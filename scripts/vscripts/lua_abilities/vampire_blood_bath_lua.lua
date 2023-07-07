vampire_blood_bath_lua = class({})
LinkLuaModifier( "modifier_vampire_blood_bath_lua_thinker", "modifiers/modifier_vampire_blood_bath_lua_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function vampire_blood_bath_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function vampire_blood_bath_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data

	-- create thinker
	CreateModifierThinker(
		caster,
		self,
		"modifier_vampire_blood_bath_lua_thinker",
		{},
		point,
		caster:GetTeamNumber(),
		false
	)

	-- effects
	local sound_cast = "Hero_Bloodseeker.BloodRite.Cast"
	EmitSoundOn( sound_cast, caster )
end