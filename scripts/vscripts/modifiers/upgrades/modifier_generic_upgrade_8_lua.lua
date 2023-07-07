modifier_generic_upgrade_8_lua = class({})
--------------------------------------------------------------------------------

function modifier_generic_upgrade_8_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_8_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_8_lua:DestroyOnExpire()
	return false
end

function modifier_generic_upgrade_8_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_8_lua:OnCreated( kv )
    if IsServer() then
        self:SetStackCount(0)
    end
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_8_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT_UNIQUE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_8_lua:GetModifierMoveSpeedBonus_Constant_Unique()
	if self:GetParent():HasModifier("modifier_werewolf_day") or self:GetParent():HasModifier("modifier_werewolf_night") then
		return 0
	end
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor( "ms_per_stack" )
end