wolf_passive_lua = class({})
LinkLuaModifier( "modifier_wolf_passive_lua", "modifiers/modifier_wolf_passive_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function wolf_passive_lua:GetIntrinsicModifierName()
	return "modifier_wolf_passive_lua"
end