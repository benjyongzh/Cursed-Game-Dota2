modifier_warrior_brandish_slow_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_warrior_brandish_slow_lua:IsHidden()
	return false
end

function modifier_warrior_brandish_slow_lua:IsDebuff()
	return true
end

function modifier_warrior_brandish_slow_lua:IsStunDebuff()
	return false
end

function modifier_warrior_brandish_slow_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_warrior_brandish_slow_lua:OnCreated( kv )
	-- references
	self.ms_slow = -kv.ms_slow_pct
end

function modifier_warrior_brandish_slow_lua:OnRefresh( kv )
	-- references
	self.ms_slow = -kv.ms_slow_pct
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_warrior_brandish_slow_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_warrior_brandish_slow_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations

function modifier_warrior_brandish_slow_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_phantoml_slowlance.vpcf"
end