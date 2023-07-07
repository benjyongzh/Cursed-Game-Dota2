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
illusionist_conjure_image_lua = class({})
LinkLuaModifier( "modifier_illusionist_conjure_image_lua", "modifiers/modifier_illusionist_conjure_image_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_illusionist_conjure_image_illusion_lua", "modifiers/modifier_illusionist_conjure_image_illusion_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_illusion_lua", "modifiers/modifier_generic_illusion_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Unit Filter Check

function illusionist_conjure_image_lua:CastFilterResultTarget( hTarget )
	if hTarget:IsBuilding() or hTarget:GetUnitName() == "spire" then
		return UF_FAIL_BUILDING
	end
	if hTarget:HasModifier("modifier_werewolf_day_lua") or hTarget:HasModifier("modifier_werewolf_night_lua") or hTarget:GetUnitName() == "zombie_main_unit" then
		return UF_FAIL_OTHER
	end
	return UF_SUCCESS
end

function illusionist_conjure_image_lua:GetCustomCastErrorTarget( hTarget )
	if hTarget:IsBuilding() or hTarget:GetUnitName() == "spire" then
		return "#dota_hud_error_cant_cast_on_building"
	elseif hTarget:HasModifier("modifier_werewolf_day_lua") or hTarget:HasModifier("modifier_werewolf_night_lua") or hTarget:GetUnitName() == "zombie_main_unit" then
		return "Cannot cast on Cursed Form"
	end
	return ""
end


-- Ability Start
function illusionist_conjure_image_lua:OnSpellStart()
	-- get references
	local inv_duration = self:GetSpecialValueFor("invuln_duration")
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- Add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_illusionist_conjure_image_lua", -- modifier name
		{ duration = inv_duration,
	} -- kv
	)
end

--------------------------------------------------------------------------------
-- Ability Considerations
function illusionist_conjure_image_lua:AbilityConsiderations()

	-- Illusion Copy
	local bIllusion = target:IsIllusion()
end

--------------------------------------------------------------------------------
-- Helpers. use this for the metamorphosis change for this spell
--illusionist_conjure_image_lua.illusions = {}

--------------------------------------------------------------------------------
function illusionist_conjure_image_lua:PlayEffects()

	-- Create Sound
	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end