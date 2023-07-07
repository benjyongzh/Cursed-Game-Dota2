modifier_generic_upgrade_4_lua = class({})
--------------------------------------------------------------------------------

function modifier_generic_upgrade_4_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_4_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_4_lua:DestroyOnExpire()
	return false
end

function modifier_generic_upgrade_4_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_4_lua:OnCreated( kv )
    self.bonus = self:GetAbility():GetSpecialValueFor( "mp_regen_per_stack" )
    if IsServer() then
        self:SetStackCount(0)
    end
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_4_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_4_lua:GetModifierConstantManaRegen( params )
	if self:GetParent():HasModifier("modifier_werewolf_day") or self:GetParent():HasModifier("modifier_werewolf_night") then
		return 0
	end
	return self:GetStackCount() * self.bonus
end