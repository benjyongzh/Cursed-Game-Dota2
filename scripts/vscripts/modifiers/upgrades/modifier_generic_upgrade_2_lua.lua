modifier_generic_upgrade_2_lua = class({})
--------------------------------------------------------------------------------

function modifier_generic_upgrade_2_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_2_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_2_lua:DestroyOnExpire()
	return false
end

function modifier_generic_upgrade_2_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_2_lua:OnCreated( kv )
    self.bonus = self:GetAbility():GetSpecialValueFor( "hp_regen_per_stack" )
    if IsServer() then
        self:SetStackCount(0)
    end
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_2_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_2_lua:GetModifierConstantHealthRegen( params )
	if self:GetParent():HasModifier("modifier_werewolf_day") or self:GetParent():HasModifier("modifier_werewolf_night") then
		return 0
	end
	return self:GetStackCount() * self.bonus
end