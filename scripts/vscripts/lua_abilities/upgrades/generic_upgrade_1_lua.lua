generic_upgrade_1_lua = class({})
LinkLuaModifier( "modifier_generic_upgrade_1_lua", "modifiers/upgrades/modifier_generic_upgrade_1_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function generic_upgrade_1_lua:GetIntrinsicModifierName()
	return "modifier_generic_upgrade_1_lua"
end

function generic_upgrade_1_lua:IsHiddenAbilityCastable()
    return true
end