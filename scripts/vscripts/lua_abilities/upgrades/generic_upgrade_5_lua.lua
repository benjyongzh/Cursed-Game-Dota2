generic_upgrade_5_lua = class({})
LinkLuaModifier( "modifier_generic_upgrade_5_lua", "modifiers/upgrades/modifier_generic_upgrade_5_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function generic_upgrade_5_lua:GetIntrinsicModifierName()
	return "modifier_generic_upgrade_5_lua"
end

function generic_upgrade_5_lua:IsHiddenAbilityCastable()
    return true
end