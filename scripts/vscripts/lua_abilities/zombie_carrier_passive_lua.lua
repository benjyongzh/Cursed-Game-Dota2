zombie_carrier_passive_lua = class({})
LinkLuaModifier( "modifier_zombie_carrier_passive_lua", "modifiers/modifier_zombie_carrier_passive_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function zombie_carrier_passive_lua:GetIntrinsicModifierName()
	return "modifier_zombie_carrier_passive_lua"
end