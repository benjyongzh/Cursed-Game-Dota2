werewolf_crit_strike_lua = class({})
LinkLuaModifier( "modifier_werewolf_crit_strike_lua", "modifiers/modifier_werewolf_crit_strike_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function werewolf_crit_strike_lua:GetIntrinsicModifierName()
	return "modifier_werewolf_crit_strike_lua"
end