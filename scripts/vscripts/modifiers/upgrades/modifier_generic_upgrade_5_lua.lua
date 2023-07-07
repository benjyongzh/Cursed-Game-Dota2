modifier_generic_upgrade_5_lua = class({})
--------------------------------------------------------------------------------

function modifier_generic_upgrade_5_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_5_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_5_lua:DestroyOnExpire()
	return false
end

function modifier_generic_upgrade_5_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_5_lua:OnCreated( kv )
    if IsServer() then
        self:SetStackCount(0)
    end
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_5_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_5_lua:GetModifierPreAttack_BonusDamage( params )
	if self:GetParent():HasModifier("modifier_werewolf_day") or self:GetParent():HasModifier("modifier_werewolf_night") then
		return 0
	end
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor( "atk_dmg_per_stack" )
end