zombie_tank_passive_lua = class({})
LinkLuaModifier( "modifier_zombie_tank_passive_lua", "modifiers/modifier_zombie_tank_passive_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_tank_passive_lua_knockback", "modifiers/modifier_zombie_tank_passive_lua_knockback", LUA_MODIFIER_MOTION_BOTH )
--LinkLuaModifier( "modifier_zombie_tank_passive_lua_knockback", "modifiers/modifier_zombie_tank_passive_lua_knockback", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function zombie_tank_passive_lua:GetIntrinsicModifierName()
	return "modifier_zombie_tank_passive_lua"
end