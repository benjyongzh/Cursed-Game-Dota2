modifier_mirana_leap_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mirana_leap_lua:IsHidden()
	return false
end

function modifier_mirana_leap_lua:IsDebuff()
	return true
end

function modifier_mirana_leap_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_mirana_leap_lua:OnCreated( kv )
	-- references
	self.ms_bonus = -self:GetAbility():GetSpecialValueFor( "leap_speed_debuff_percent" ) -- special value
end

function modifier_mirana_leap_lua:OnRefresh( kv )
	-- references
	self.ms_bonus = -self:GetAbility():GetSpecialValueFor( "leap_speed_debuff_percent" ) -- special value
end

function modifier_mirana_leap_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_mirana_leap_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_mirana_leap_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus
end