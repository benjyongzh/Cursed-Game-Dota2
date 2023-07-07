zombie_lesser_passive_lua = class({})
LinkLuaModifier( "modifier_zombie_lesser_passive_lua", "modifiers/modifier_zombie_lesser_passive_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_lesser_passive_lua_ms_slow", "modifiers/modifier_zombie_lesser_passive_lua_ms_slow", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function zombie_lesser_passive_lua:GetIntrinsicModifierName()
	return "modifier_zombie_lesser_passive_lua"
end