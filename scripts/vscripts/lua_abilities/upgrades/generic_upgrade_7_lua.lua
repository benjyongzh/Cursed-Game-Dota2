generic_upgrade_7_lua = class({})
LinkLuaModifier( "modifier_generic_upgrade_7_lua", "modifiers/upgrades/modifier_generic_upgrade_7_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function generic_upgrade_7_lua:GetIntrinsicModifierName()
	return "modifier_generic_upgrade_7_lua"
end

function generic_upgrade_7_lua:IsHiddenAbilityCastable()
    return true
end