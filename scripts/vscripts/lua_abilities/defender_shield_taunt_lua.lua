-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
defender_shield_taunt_lua = class({})
LinkLuaModifier( "modifier_defender_shield_taunt_lua", "modifiers/modifier_defender_shield_taunt_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_defender_shield_taunt_debuff_lua", "modifiers/modifier_defender_shield_taunt_debuff_lua", LUA_MODIFIER_MOTION_NONE )


-- Ability cast on building
function defender_shield_taunt_lua:CastFilterResultTarget( hTarget )
	if hTarget and IsBuildingOrSpire(hTarget) then
		return UF_FAIL_BUILDING
	end
	return UF_SUCCESS
end

function defender_shield_taunt_lua:GetCustomCastErrorTarget( hTarget )
	if hTarget and IsBuildingOrSpire(hTarget) then
		return "#dota_hud_error_cant_cast_on_building"
	end
	return ""
end

function defender_shield_taunt_lua:GetCastRange(vLocation, hTarget)
	local add = 0
	local abil = self:GetCaster():FindAbilityByName("defender_upgrade_1")
	if abil then
		if abil:GetLevel() > 0 then
			add = self:GetSpecialValueFor( "upgrade_cast_range" )
		end
	end

	return 500 + add
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function defender_shield_taunt_lua:OnAbilityPhaseInterrupted()
	-- stop effects 
	local sound_cast = "Hero_Axe.BerserkersCall.Start"
	StopSoundOn( sound_cast, self:GetCaster() )
end
function defender_shield_taunt_lua:OnAbilityPhaseStart()
	-- play effects 
	local sound_cast = "Hero_Axe.BerserkersCall.Start"
	EmitSoundOn( sound_cast, self:GetCaster() )

	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function defender_shield_taunt_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = caster:GetOrigin()
	local target = self:GetCursorTarget()
	
	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	--[[ find units caught
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		target,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)]]

	-- call
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_defender_shield_taunt_debuff_lua", -- modifier name
		{ duration = duration } -- kv
	)
	

	-- self buff
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_defender_shield_taunt_lua", -- modifier name
		{ duration = duration } -- kv
	)

	--[[play effects
	if #enemies>0 then
		local sound_cast = "Hero_Axe.Berserkers_Call"
		EmitSoundOn( sound_cast, self:GetCaster() )
	end
	self:PlayEffects()]]
end

--------------------------------------------------------------------------------
function defender_shield_taunt_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end