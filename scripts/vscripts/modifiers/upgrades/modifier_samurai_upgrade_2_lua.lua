modifier_samurai_upgrade_2_lua = class({})
--------------------------------------------------------------------------------

function modifier_samurai_upgrade_2_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_samurai_upgrade_2_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_samurai_upgrade_2_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_samurai_upgrade_2_lua:DestroyOnExpire()
	return false
end

function modifier_samurai_upgrade_2_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_samurai_upgrade_2_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_samurai_upgrade_2_lua:GetModifierOverrideAbilitySpecial( params )
    if self:GetParent() == nil or params.ability == nil then
		return 0
    end
    
    if params.ability:GetAbilityName()  == "samurai_flash_step_lua" then
        return 1
    end
    return 0
end

function modifier_samurai_upgrade_2_lua:GetModifierCooldownReduction_Constant( params )
    return self:GetAbility():GetSpecialValueFor("upgrade_cd_decrease")
end