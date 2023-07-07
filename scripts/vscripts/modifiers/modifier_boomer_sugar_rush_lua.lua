modifier_boomer_sugar_rush_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_boomer_sugar_rush_lua:IsHidden()
	return false
end

function modifier_boomer_sugar_rush_lua:IsDebuff()
	return false
end

function modifier_boomer_sugar_rush_lua:IsPurgable()
	return false
end

---------------------------------------------------------------------------------
-- Initializations
function modifier_boomer_sugar_rush_lua:OnCreated( kv )
	-- references
	self.bonus = self:GetAbility():GetSpecialValueFor( "speed_bonus" )
end

function modifier_boomer_sugar_rush_lua:OnRefresh( kv )
	-- references
	self.bonus = self:GetAbility():GetSpecialValueFor( "speed_bonus" )
end

function modifier_boomer_sugar_rush_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_boomer_sugar_rush_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_boomer_sugar_rush_lua:GetModifierMoveSpeedBonus_Constant()
	return self.bonus
end

-- Graphics & Animations
function modifier_boomer_sugar_rush_lua:GetEffectName()
	return "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_receive.vpcf"
end

function modifier_boomer_sugar_rush_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end