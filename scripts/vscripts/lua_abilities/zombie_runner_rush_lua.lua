zombie_runner_rush_lua = class({})
LinkLuaModifier( "modifier_zombie_runner_rush_lua", "modifiers/modifier_zombie_runner_rush_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_runner_rush_lua_ms_buff", "modifiers/modifier_zombie_runner_rush_lua_ms_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function zombie_runner_rush_lua:GetIntrinsicModifierName()
	return "modifier_zombie_runner_rush_lua"
end