guardian_patience_lua = class({})
LinkLuaModifier( "modifier_guardian_patience_lua_thinker", "modifiers/modifier_guardian_patience_lua_thinker", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function guardian_patience_lua:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

-- Ability Start
function guardian_patience_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- get values
	local delay = self:GetSpecialValueFor("delay")
	local vision_distance = self:GetSpecialValueFor("vision_distance")
	local vision_duration = self:GetSpecialValueFor("vision_duration")

	--check for upgrade 3
	--[[
	local abil = self:GetCaster():FindAbilityByName("guardian_upgrade_3")
	if abil then
		if abil:GetLevel() > 0 then
			guardian_patience_lua.aoe = self:GetSpecialValueFor( "area_of_effect" ) + self:GetSpecialValueFor("upgrade_aoe_increase")
		else
			guardian_patience_lua.aoe = self:GetSpecialValueFor( "area_of_effect" )
		end
	end
	]]

	-- create modifier thinker
	CreateModifierThinker(
		caster,
		self,
		"modifier_guardian_patience_lua_thinker",
		{ duration = delay },
		point,
		caster:GetTeamNumber(),
		false
	)

	-- create vision
	AddFOWViewer( caster:GetTeamNumber(), point, vision_distance, vision_duration, false )
end