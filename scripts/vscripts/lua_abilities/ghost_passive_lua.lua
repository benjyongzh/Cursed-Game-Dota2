ghost_passive_lua = class({})
LinkLuaModifier( "modifier_ghost_passive_lua", "modifiers/modifier_ghost_passive_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_ghost_passive_lua_haunt", "modifiers/modifier_ghost_passive_lua_haunt", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function ghost_passive_lua:GetIntrinsicModifierName()
	return "modifier_ghost_passive_lua"
end