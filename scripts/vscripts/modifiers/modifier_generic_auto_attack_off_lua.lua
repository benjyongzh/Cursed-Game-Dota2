modifier_generic_auto_attack_off_lua = class({})

function modifier_generic_auto_attack_off_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_generic_auto_attack_off_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_generic_auto_attack_off_lua:CanParentBeAutoAttacked()
	return false
end

--------------------------------------------------------------------------------

--[[
function modifier_generic_auto_attack_off_lua:GetDisableAutoAttack()
	-- return true doesnt work but return 1 works
	return 1
end

--------------------------------------------------------------------------------

function modifier_generic_auto_attack_off_lua:DeclareFunctions() 
    return { MODIFIER_PROPERTY_DISABLE_AUTOATTACK }
end
]]
  
function modifier_generic_auto_attack_off_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

