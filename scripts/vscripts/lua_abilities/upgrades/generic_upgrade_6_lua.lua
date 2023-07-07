generic_upgrade_6_lua = class({})
LinkLuaModifier( "modifier_generic_upgrade_6_lua", "modifiers/upgrades/modifier_generic_upgrade_6_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function generic_upgrade_6_lua:GetIntrinsicModifierName()
	return "modifier_generic_upgrade_6_lua"
end

function generic_upgrade_6_lua:IsHiddenAbilityCastable()
    return true
end