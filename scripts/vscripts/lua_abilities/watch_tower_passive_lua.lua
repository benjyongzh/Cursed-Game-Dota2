watch_tower_passive_lua = class({})
LinkLuaModifier( "modifier_watch_tower_passive_lua", "modifiers/modifier_watch_tower_passive_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function watch_tower_passive_lua:GetIntrinsicModifierName()
	return "modifier_watch_tower_passive_lua"
end