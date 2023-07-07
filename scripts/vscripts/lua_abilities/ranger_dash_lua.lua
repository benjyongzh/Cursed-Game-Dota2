ranger_dash_lua = class({})
LinkLuaModifier( "modifier_ranger_dash_lua_movement", "modifiers/modifier_ranger_dash_lua_movement", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------------------
-- Ability Start
function ranger_dash_lua:OnSpellStart()
	-- unit identifier
    local caster = self:GetCaster()
    --this is the modifier for the dashing movement
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_ranger_dash_lua_movement", -- modifier name
		{} -- kv
    )
    -- disable dash skill until destination reached based on modifier
    

	-- effects
	local sound_cast = "Hero_EmberSpirit.PreAttack.Flame"
	EmitSoundOn( sound_cast, caster )
end