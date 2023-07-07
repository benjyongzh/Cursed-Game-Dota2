generic_upgrade_8_lua = class({})
LinkLuaModifier( "modifier_generic_upgrade_8_lua", "modifiers/upgrades/modifier_generic_upgrade_8_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function generic_upgrade_8_lua:GetIntrinsicModifierName()
	return "modifier_generic_upgrade_8_lua"
end

function generic_upgrade_8_lua:IsHiddenAbilityCastable()
    return true
end