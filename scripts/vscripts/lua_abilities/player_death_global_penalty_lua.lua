player_death_global_penalty_lua = class({})
LinkLuaModifier( "modifier_player_death_global_penalty_dummy_lua", "modifiers/modifier_player_death_global_penalty_dummy_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_player_death_global_penalty_lua", "modifiers/modifier_player_death_global_penalty_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function player_death_global_penalty_lua:GetIntrinsicModifierName()
	return "modifier_player_death_global_penalty_dummy_lua"
end