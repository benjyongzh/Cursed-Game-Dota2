modifier_assassin_backstab_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_assassin_backstab_lua:IsHidden()
	return true
end

function modifier_assassin_backstab_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_assassin_backstab_lua:OnCreated( kv )
	
	local damage = self:GetAbility():GetSpecialValueFor("backstab_damage_normal") -- special value

	if IsServer() then

		-- check for upgrade 2
		local abil = self:GetParent():FindAbilityByName("assassin_upgrade_2")
		if abil then
			if abil:GetLevel() > 0 then
				damage = damage + self:GetAbility():GetSpecialValueFor("upgrade_damage_increase")
			end
		end

		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = self:GetParent(),
			damage = damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
		}
	end
end

function modifier_assassin_backstab_lua:OnRefresh( kv )
	
	local damage = self:GetAbility():GetSpecialValueFor("backstab_damage_normal") -- special value

	if IsServer() then
		-- check for upgrade 2
		local abil = self:GetParent():FindAbilityByName("assassin_upgrade_2")
		if abil then
			if abil:GetLevel() > 0 then
				damage = damage + self:GetAbility():GetSpecialValueFor("upgrade_damage_increase")
			end
		end

		self.damageTable.damage = damage
	end
end

function modifier_assassin_backstab_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_assassin_backstab_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}

	return funcs
end

function modifier_assassin_backstab_lua:OnAttackLanded( kv )
	
	local attacker = kv.attacker
	local target = kv.target
	if IsServer() then
		if attacker == self:GetParent() then
			if self:GetAbility():IsActivated() then
				if not target:IsBuilding() and target:GetTeamNumber() ~= attacker:GetTeamNumber() and not IsBuildingOrSpire(target) then

					-- backstab angle and damage from backstab passive
					local backstab_angle =  self:GetAbility():GetSpecialValueFor("backstab_angle")

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
						-- Apply backstab damage
						self.damageTable.victim = target
						ApplyDamage(self.damageTable)

						-- Effects
						
						EmitSoundOn( "Hero_Spectre.Attack", target )
						
						local particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_attack_blur_crit.vpcf"
						local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target) 
						-- Set Control Point 1 for the backstab particle; this controls where it's positioned in the world. In this case, it should be positioned on the victim.
						ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true) 
					end
				end
			end
		end
	end
end

function modifier_assassin_backstab_lua:GetAttackSound()
	return "Hero_Antimage.Attack"
end