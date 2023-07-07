assassin_backstab_lua = class({})
LinkLuaModifier( "modifier_assassin_backstab_lua", "modifiers/modifier_assassin_backstab_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function assassin_backstab_lua:GetIntrinsicModifierName()
	return "modifier_assassin_backstab_lua"
end