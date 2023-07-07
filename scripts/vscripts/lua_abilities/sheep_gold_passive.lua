sheep_gold_passive = class({})
LinkLuaModifier( "modifier_sheep_passive_lua", "modifiers/modifier_sheep_passive_lua", LUA_MODIFIER_MOTION_NONE )
-------------------------------------------------------------------------

function sheep_gold_passive:GetIntrinsicModifierName()
	return "modifier_sheep_passive_lua"
end
