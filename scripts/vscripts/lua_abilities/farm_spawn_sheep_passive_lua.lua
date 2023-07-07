farm_spawn_sheep_passive_lua = class({})
LinkLuaModifier( "modifier_spawn_sheep_lua", "modifiers/modifier_spawn_sheep_lua", LUA_MODIFIER_MOTION_NONE )
-------------------------------------------------------------------------

function farm_spawn_sheep_passive_lua:GetIntrinsicModifierName()
	return "modifier_spawn_sheep_lua"
end
