modifier_samurai_upgrade_1_lua = class({})
--------------------------------------------------------------------------------

function modifier_samurai_upgrade_1_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_samurai_upgrade_1_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_samurai_upgrade_1_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_samurai_upgrade_1_lua:DestroyOnExpire()
	return false
end

function modifier_samurai_upgrade_1_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_samurai_upgrade_1_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_samurai_upgrade_1_lua:GetModifierOverrideAbilitySpecial( params )
    if self:GetParent() == nil or params.ability == nil then
		return 0
    end
    
    if params.ability_special_value == "max_travel_distance" and params.ability:GetAbilityName()  == "samurai_flash_step_lua" then
        return 1
    end
end

function modifier_samurai_upgrade_1_lua:GetModifierOverrideAbilitySpecialValue( params )
    return self:GetAbility():GetSpecialValueFor("upgrade_aoe_increase")
end