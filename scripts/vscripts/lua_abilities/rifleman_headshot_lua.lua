rifleman_headshot_lua = class({})
LinkLuaModifier( "modifier_rifleman_headshot_lua", "modifiers/modifier_rifleman_headshot_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function rifleman_headshot_lua:GetIntrinsicModifierName()
	return "modifier_rifleman_headshot_lua"
end