modifier_druid_upgrade_3_lua = class({})
--------------------------------------------------------------------------------

function modifier_druid_upgrade_3_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_druid_upgrade_3_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_druid_upgrade_3_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_druid_upgrade_3_lua:DestroyOnExpire()
	return false
end

function modifier_druid_upgrade_3_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_druid_upgrade_3_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_druid_upgrade_3_lua:GetModifierOverrideAbilitySpecial( params )
    if self:GetParent() == nil or params.ability == nil then
		return 0
    end
    
    if params.ability_special_value == "mp_pct_per_second" then
        if params.ability:GetAbilityName()  == "druid_shapeshift_to_bear_lua" or params.ability:GetAbilityName()  == "druid_shapeshift_to_bird_lua" then
            return 1
        end
    end
    return 0
end

function modifier_druid_upgrade_3_lua:GetModifierOverrideAbilitySpecialValue( params )
    if params.ability:GetAbilityName() == "druid_shapeshift_to_bear_lua" then
        return self:GetAbility():GetSpecialValueFor("bear_original") * self:GetAbility():GetSpecialValueFor("mp_cost_pct")
    elseif params.ability:GetAbilityName()  == "druid_shapeshift_to_bird_lua" then
        return self:GetAbility():GetSpecialValueFor("bird_original") * self:GetAbility():GetSpecialValueFor("mp_cost_pct")
    end
end