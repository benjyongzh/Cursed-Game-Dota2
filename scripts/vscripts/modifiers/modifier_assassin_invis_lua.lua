modifier_assassin_invis_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_assassin_invis_lua:IsHidden()
	return false
end

function modifier_assassin_invis_lua:IsDebuff()
	return false
end

function modifier_assassin_invis_lua:IsPurgable()
	return false
end

function modifier_assassin_invis_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_assassin_invis_lua:DestroyOnExpire()
	return true
end

function modifier_assassin_invis_lua:RemoveOnDeath()
	return true
end

function modifier_assassin_invis_lua:GetTexture()
	return "templar_assassin_meld"
end

--------------------------------------------------------------------------------

-- Initializations
function modifier_assassin_invis_lua:OnCreated( kv )
    -- references
    if IsServer() then
		--sfx
		local particle_cast = "particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetOrigin())
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end

	self.manacost = self:GetAbility():GetSpecialValueFor("mp_pct_per_second")
    self:StartIntervalThink( 0.1 )
	self:OnIntervalThink()
	

end

function modifier_assassin_invis_lua:OnRefresh( kv )
	-- references
	self.manacost = self:GetAbility():GetSpecialValueFor("mp_pct_per_second")
    self:StartIntervalThink( 0.1 )
	self:OnIntervalThink()
end

function modifier_assassin_invis_lua:OnDestroy( kv )
	if IsServer() then
		local ability = self:GetAbility()
		--start cooldown before next possible invis
		local cd = ability:GetSpecialValueFor("cooldown_after_vis")

		-- check for upgrade 3
		local abil = self:GetParent():FindAbilityByName("assassin_upgrade_3")
		if abil then
			if abil:GetLevel() > 0 then
				cd = cd - ability:GetSpecialValueFor("upgrade_cd_decrease")
			end
		end

		ability:StartCooldown(cd)

		--sfx
		local sound_cast = "Hero_TemplarAssassin.Meld.Move"
		EmitSoundOn( sound_cast, self:GetParent() )
		local particle_cast = "particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetOrigin())
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_assassin_invis_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_START,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_assassin_invis_lua:GetModifierInvisibilityLevel()
	return 2
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_assassin_invis_lua:CheckState()
	local state = {
	[MODIFIER_STATE_INVISIBLE] = true,
	--[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_assassin_invis_lua:OnIntervalThink()
	if IsServer() then
		local unit = self:GetParent()
		if unit:GetMana() <= 1.0 then
			unit:FindAbilityByName(self:GetAbility():GetAbilityName()):ToggleAbility()
		else
			unit:ReduceMana(0.1*(unit:GetManaRegen() + (0.01 * self.manacost) * unit:GetMaxMana()))
		end		
    end
end



function modifier_assassin_invis_lua:OnAttackLanded(keys)
	--for k,v in pairs(keys) do
    --    print(k,v)
    --end
	
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target
		local backstab_abil = "assassin_backstab_lua"
		if attacker == self:GetParent() then
			if attacker:HasAbility(backstab_abil) and attacker:FindAbilityByName(backstab_abil):IsActivated() then
				if not target:IsBuilding() and target:GetTeamNumber() ~= attacker:GetTeamNumber() and not IsBuildingOrSpire(target) then

					-- backstab angle and damage from backstab passive
					local backstab_angle =  attacker:FindAbilityByName(backstab_abil):GetSpecialValueFor("backstab_angle")
					local backstab_damage = 0
					if GameRules:IsDaytime() then
						backstab_damage = attacker:FindAbilityByName(backstab_abil):GetSpecialValueFor("backstab_damage_hp_pct_invis_day")
					else
						backstab_damage = attacker:FindAbilityByName(backstab_abil):GetSpecialValueFor("backstab_damage_hp_pct_invis_night")
					end
					backstab_damage = (backstab_damage/100) * (target:GetMaxHealth())

					-- The y value of the angles vector contains the angle we actually want: where units are directionally facing in the world.
					local victim_angle = target:GetAnglesAsVector().y
					local origin_difference = target:GetAbsOrigin() - attacker:GetAbsOrigin()

					-- Get the radian of the origin difference between the attacker and Riki. We use this to figure out at what angle the victim is at relative to Riki.
					local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
					
					-- Convert the radian to degrees.
					origin_difference_radian = origin_difference_radian * 180
					local attacker_angle = origin_difference_radian / math.pi
					-- Makes angle "0 to 360 degrees" as opposed to "-180 to 180 degrees" aka standard dota angles.
					attacker_angle = attacker_angle + 180.0
					
					-- Finally, get the angle at which the victim is facing Riki.
					local result_angle = attacker_angle - victim_angle
					result_angle = math.abs(result_angle)
					
					-- Check for the backstab angle.
					if result_angle >= (180 - backstab_angle) and result_angle <= (180 + backstab_angle) then 
						
						-- Apply extra backstab damage
						ApplyDamage({
							victim = target,
							attacker = attacker,
							damage = backstab_damage,
							damage_type = self:GetAbility():GetAbilityDamageType()})

						-- Play the sound on the victim.
						EmitSoundOn("Hero_Spectre.DaggerImpact", target)
						EmitSoundOn( "Hero_PhantomAssassin.Spatter", target )

						-- Create the back particle effect.
						local particle_cast = "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_stab.vpcf"
						local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target) 
						-- Set Control Point 1 for the backstab particle; this controls where it's positioned in the world. In this case, it should be positioned on the victim.
						ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true) 

						particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
						effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
						ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
						ParticleManager:ReleaseParticleIndex( effect_cast )
					end
				end
			end
			--auto toggle invis upon landing any attack on an enemy
			self:Destroy()
			attacker:FindAbilityByName(self:GetAbility():GetAbilityName()):ToggleAbility()

		end
	end
end

--auto toggle invis upon starting to cast a spell
function modifier_assassin_invis_lua:OnAbilityStart(keys)
	--for k,v in pairs(keys) do
    --    print(k,v)
    --end
	local caster = keys.unit
	local hAbility = keys.ability
	if caster == self:GetParent() then
		if hAbility ~= nil and (not hAbility:IsItem()) and (not hAbility:IsToggle()) then
			self:Destroy()
			caster:FindAbilityByName(self:GetAbility():GetAbilityName()):ToggleAbility()
		end
	end
end

--auto toggle invis upon taking dmg
function modifier_assassin_invis_lua:OnTakeDamage(keys)
	if IsServer() then
		local damage_taken = keys.damage
		local unit = keys.unit
		local min_dmg = self:GetAbility():GetSpecialValueFor("min_dmg_taken_invis_cancel")
		if unit == self:GetParent() and unit:IsAlive() and damage_taken >= min_dmg then
			self:Destroy()
			unit:FindAbilityByName(self:GetAbility():GetAbilityName()):ToggleAbility()
		end
	end
end

function modifier_assassin_invis_lua:OnDeath(kv)
	if IsServer() then
		if self:GetParent() == kv.unit then
			local abil = self:GetAbility()
			self:Destroy()
			unit:FindAbilityByName(abil:GetAbilityName()):ToggleAbility()
		end
	end
end