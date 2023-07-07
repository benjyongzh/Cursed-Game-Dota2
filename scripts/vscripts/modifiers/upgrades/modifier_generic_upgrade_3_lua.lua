modifier_generic_upgrade_3_lua = class({})
--------------------------------------------------------------------------------

function modifier_generic_upgrade_3_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_3_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_3_lua:DestroyOnExpire()
	return false
end

function modifier_generic_upgrade_3_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_3_lua:OnCreated( kv )
	if IsServer() then
		if kv.stacks then
			self:SetStackCount(kv.stacks)
		else
			self:SetStackCount(0)
		end
    end
end

function modifier_generic_upgrade_3_lua:OnRefresh(kv)
	if IsServer() then
		if kv.stacks then
			self:SetStackCount(kv.stacks)
		end
	end
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_3_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_generic_upgrade_3_lua:GetModifierExtraManaBonus()
	if self:GetParent():HasModifier("modifier_werewolf_day") or self:GetParent():HasModifier("modifier_werewolf_night") then
		return 0
	end
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor( "mp_per_stack" )
end