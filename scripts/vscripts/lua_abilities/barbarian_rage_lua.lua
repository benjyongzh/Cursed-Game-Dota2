barbarian_rage_lua = class({})
LinkLuaModifier( "modifier_barbarian_rage_lua", "modifiers/modifier_barbarian_rage_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function barbarian_rage_lua:GetIntrinsicModifierName()
	return "modifier_barbarian_rage_lua"
end