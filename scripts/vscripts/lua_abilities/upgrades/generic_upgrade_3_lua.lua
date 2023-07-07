generic_upgrade_3_lua = class({})
LinkLuaModifier( "modifier_generic_upgrade_3_lua", "modifiers/upgrades/modifier_generic_upgrade_3_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function generic_upgrade_3_lua:GetIntrinsicModifierName()
	return "modifier_generic_upgrade_3_lua"
end

function generic_upgrade_3_lua:IsHiddenAbilityCastable()
    return true
end