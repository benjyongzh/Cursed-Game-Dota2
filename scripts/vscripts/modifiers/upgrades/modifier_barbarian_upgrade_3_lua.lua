modifier_barbarian_upgrade_3_lua = class({})
--------------------------------------------------------------------------------

function modifier_barbarian_upgrade_3_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_barbarian_upgrade_3_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_barbarian_upgrade_3_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_barbarian_upgrade_3_lua:DestroyOnExpire()
	return false
end

function modifier_barbarian_upgrade_3_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_barbarian_upgrade_3_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_MANACOST_REDUCTION_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_barbarian_upgrade_3_lua:GetModifierOverrideAbilitySpecial( params )
    if self:GetParent() == nil or params.ability == nil then
		return 0
    end
    
    if params.ability:GetAbilityName()  == "barbarian_axe_throw_lua" then
        return 1
	end
	return 0
end

function modifier_barbarian_upgrade_3_lua:GetModifierManacostReduction_Constant( params )
	return self:GetAbility():GetSpecialValueFor("upgrade_mp_cost_decrease")
end