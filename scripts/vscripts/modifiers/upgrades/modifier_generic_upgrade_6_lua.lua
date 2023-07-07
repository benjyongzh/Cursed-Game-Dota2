modifier_generic_upgrade_6_lua = class({})
--------------------------------------------------------------------------------

function modifier_generic_upgrade_6_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_6_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_6_lua:DestroyOnExpire()
	return false
end

function modifier_generic_upgrade_6_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_6_lua:OnCreated()
    if IsServer() then
        self:SetStackCount(0)
    end
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_6_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_6_lua:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():HasModifier("modifier_werewolf_day") or self:GetParent():HasModifier("modifier_werewolf_night") then
		return 0
	end
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor( "atk_speed_per_stack" )
end