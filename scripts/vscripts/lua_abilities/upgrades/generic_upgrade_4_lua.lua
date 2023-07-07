generic_upgrade_4_lua = class({})
LinkLuaModifier( "modifier_generic_upgrade_4_lua", "modifiers/upgrades/modifier_generic_upgrade_4_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function generic_upgrade_4_lua:GetIntrinsicModifierName()
	return "modifier_generic_upgrade_4_lua"
end

function generic_upgrade_4_lua:IsHiddenAbilityCastable()
    return true
end