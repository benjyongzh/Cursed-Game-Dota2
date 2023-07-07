mirana_leap_lua = class({})
LinkLuaModifier( "modifier_mirana_leap_lua", "modifiers/modifier_mirana_leap_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mirana_leap_lua_movement", "modifiers/modifier_mirana_leap_lua_movement", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------
function mirana_leap_lua:GetAOERadius()
	return self:GetSpecialValueFor( "leap_damage_radius" )
end

-- Ability Start
function mirana_leap_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- stuff for point target abil
	local startpt = caster:GetAbsOrigin()
	local point = self:GetCursorPosition()
	local vector = Vector(point.x-startpt.x, point.y-startpt.y, point.z-startpt.z)
	local distance_from_source = math.sqrt(vector.x * vector.x + vector.y * vector.y)
	if distance_from_source > self:GetSpecialValueFor("leap_distance") then
		distance_from_source = self:GetSpecialValueFor("leap_distance")
	end
	vector = vector:Normalized()

    --this is the modifier for the leaping movement. dont touch.
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_mirana_leap_lua_movement", -- modifier name
		{distance = distance_from_source, direction_x = vector.x, direction_y = vector.y, direction_z = vector.z } -- kv
	)

	-- effects
	local sound_cast = "Ability.Leap"
	EmitSoundOn( sound_cast, caster )
end