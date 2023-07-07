generic_upgrade_2_lua = class({})
LinkLuaModifier( "modifier_generic_upgrade_2_lua", "modifiers/upgrades/modifier_generic_upgrade_2_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function generic_upgrade_2_lua:GetIntrinsicModifierName()
	return "modifier_generic_upgrade_2_lua"
end

function generic_upgrade_2_lua:IsHiddenAbilityCastable()
    return true
end