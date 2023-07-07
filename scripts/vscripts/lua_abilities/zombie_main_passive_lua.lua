zombie_main_passive_lua = class({})
LinkLuaModifier( "modifier_zombie_main_passive_lua", "modifiers/modifier_zombie_main_passive_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_main_passive_lua_aura", "modifiers/modifier_zombie_main_passive_lua_aura", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function zombie_main_passive_lua:GetIntrinsicModifierName()
	return "modifier_zombie_main_passive_lua"
end