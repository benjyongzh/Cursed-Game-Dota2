modifier_generic_upgrade_1_lua = class({})
--------------------------------------------------------------------------------

function modifier_generic_upgrade_1_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_1_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_1_lua:DestroyOnExpire()
	return false
end

function modifier_generic_upgrade_1_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_1_lua:OnCreated( kv )
	if IsServer() then
		if kv.stacks then
			self:SetStackCount(kv.stacks)
		else
			self:SetStackCount(0)
		end
    end
end

function modifier_generic_upgrade_1_lua:OnRefresh( kv )
	if IsServer() then
		if kv.stacks then
			self:SetStackCount(kv.stacks)
		end
	end
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_1_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_1_lua:GetModifierExtraHealthBonus()
	if self:GetParent():HasModifier("modifier_werewolf_day") or self:GetParent():HasModifier("modifier_werewolf_night") then
		return 0
	end
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor( "hp_per_stack" )
end