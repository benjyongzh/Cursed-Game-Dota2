warrior_brandish_lua = class({})
LinkLuaModifier( "modifier_warrior_brandish_lua", "modifiers/modifier_warrior_brandish_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_warrior_brandish_slow_lua", "modifiers/modifier_warrior_brandish_slow_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function warrior_brandish_lua:GetIntrinsicModifierName()
	return "modifier_warrior_brandish_lua"
end