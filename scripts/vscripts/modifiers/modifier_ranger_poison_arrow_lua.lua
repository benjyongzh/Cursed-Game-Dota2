modifier_ranger_poison_arrow_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ranger_poison_arrow_lua:IsHidden()
	return false
end

function modifier_ranger_poison_arrow_lua:IsDebuff()
	return true
end

function modifier_ranger_poison_arrow_lua:IsStunDebuff()
	return false
end

function modifier_ranger_poison_arrow_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ranger_poison_arrow_lua:OnCreated( kv )
	-- references
	self.duration = kv.duration
	self.ms_slow = -kv.slow
	local damage = kv.dps/10

	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	-- Start interval
	self:StartIntervalThink( 0.1 )
	self:OnIntervalThink()
end

function modifier_ranger_poison_arrow_lua:OnRefresh( kv )
	-- references
	self.duration = kv.duration
	self.ms_slow = -kv.slow
	local damage = kv.dps/10
	
	if not IsServer() then return end
	-- update damage
	self.damageTable.damage = damage

	-- restart interval tick
	self:StartIntervalThink( 0.1 )
	self:OnIntervalThink()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ranger_poison_arrow_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_ranger_poison_arrow_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ranger_poison_arrow_lua:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ranger_poison_arrow_lua:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_viper_strike_debuff.vpcf"
end

function modifier_ranger_poison_arrow_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ranger_poison_arrow_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_poison_viper.vpcf"
end

function modifier_ranger_poison_arrow_lua:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_ranger_poison_arrow_lua:GetTexture()
	return "windrunner_powershot"
end