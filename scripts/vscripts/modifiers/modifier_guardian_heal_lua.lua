modifier_guardian_heal_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_guardian_heal_lua:IsHidden()
	return false
end

function modifier_guardian_heal_lua:IsDebuff()
	return true
end

function modifier_guardian_heal_lua:IsPurgable()
	return false
end

---------------------------------------------------------------------------------
-- Initializations
function modifier_guardian_heal_lua:OnCreated( kv )
	self.start_time = GameRules:GetGameTime()
	self.duration = kv.duration

	if not IsServer() then return end
	-- references
	local damage = self:GetAbility():GetSpecialValueFor("damage")
	local caster = self:GetAbility():GetCaster()
	local abil = caster:FindAbilityByName("guardian_upgrade_1")
	if abil then
		if abil:GetLevel() > 0 then
			damage = damage - self:GetAbility():GetSpecialValueFor("upgrade_damage_decrease")
		end
	end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( 1 )
    self:OnIntervalThink()
    
    local sound_cast = "Hero_Oracle.PurifyingFlames"
    -- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_guardian_heal_lua:OnRefresh( kv )

	self.start_time = GameRules:GetGameTime()
	self.duration = kv.duration
	
	if not IsServer() then return end
	-- references
	local damage = self:GetAbility():GetSpecialValueFor("damage")
	local caster = self:GetAbility():GetCaster()
	local abil = caster:FindAbilityByName("guardian_upgrade_1")
	if abil then
		if abil:GetLevel() > 0 then
			damage = damage - self:GetAbility():GetSpecialValueFor("upgrade_damage_decrease")
		end
	end
	-- update damage
	self.damageTable.damage = damage

	-- restart interval tick
	self:StartIntervalThink( 1 )
	self:OnIntervalThink()

	local sound_cast = "Hero_Oracle.PurifyingFlames"
    -- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_guardian_heal_lua:OnDestroy( kv )

end

--[[function modifier_guardian_heal_lua:OnStackCountChanged( old )
	if IsServer() then
		if self:GetStackCount()<1 then
			self:Destroy()
		end
	end
end]]

--------------------------------------------------------------------------------
function modifier_guardian_heal_lua:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--Graphics & Animations
function modifier_guardian_heal_lua:GetEffectName()
	return "particles/units/heroes/hero_oracle/oracle_fortune_purge.vpcf"
end

function modifier_guardian_heal_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

