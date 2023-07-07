zealot_zealot_rush_lua = class({})
LinkLuaModifier( "modifier_zealot_zealot_rush_lua", "modifiers/modifier_zealot_zealot_rush_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zealot_zealot_rush_lua_ms_buff", "modifiers/modifier_zealot_zealot_rush_lua_ms_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function zealot_zealot_rush_lua:GetIntrinsicModifierName()
	return "modifier_zealot_zealot_rush_lua"
end