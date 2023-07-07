modifier_zombie_acid_debuff_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_acid_debuff_lua:IsHidden()
	return false
end

function modifier_zombie_acid_debuff_lua:IsDebuff()
	return true
end

function modifier_zombie_acid_debuff_lua:IsStunDebuff()
	return false
end

function modifier_zombie_acid_debuff_lua:IsPurgable()
	return true
end

function modifier_zombie_acid_debuff_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_zombie_acid_debuff_lua:OnCreated( kv )
    self.ms_slow = self:GetAbility():GetSpecialValueFor("ms_slow_pct")
end

function modifier_zombie_acid_debuff_lua:OnRefresh( kv )
    self.ms_slow = self:GetAbility():GetSpecialValueFor("ms_slow_pct")
end

function modifier_zombie_acid_debuff_lua:OnRemoved()
end

function modifier_zombie_acid_debuff_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_zombie_acid_debuff_lua:CheckState()
	local state = {
		--[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

-------------------------------------------------------------------------------
function modifier_zombie_acid_debuff_lua:GetModifierMoveSpeedBonus_Percentage()
    return -self.ms_slow
end

function modifier_zombie_acid_debuff_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------
-- Graphics & Animations


function modifier_zombie_acid_debuff_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_poison_viper.vpcf"
end