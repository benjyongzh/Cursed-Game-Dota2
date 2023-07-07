illusionist_glimmer_lua = class({})
LinkLuaModifier( "modifier_illusionist_glimmer_lua", "modifiers/modifier_illusionist_glimmer_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function illusionist_glimmer_lua:CastFilterResultTarget( hTarget )
	if hTarget:HasModifier("modifier_spire") then
		return UF_FAIL_BUILDING
	end
	return UF_SUCCESS
end

function illusionist_glimmer_lua:GetCustomCastErrorTarget( hTarget )
	if hTarget:HasModifier("modifier_spire") then
		return "#dota_hud_error_cant_cast_on_building"
	end
	return ""
end

function illusionist_glimmer_lua:GetCooldown(level)
    local reduction = 0

    local abil = self:GetCaster():FindAbilityByName("illusionist_upgrade_3")
	if abil then
		if abil:GetLevel() > 0 then
			reduction = self:GetSpecialValueFor( "upgrade_cd_decrease" )
		end
	end

    local cooldown = 21 - reduction
    return cooldown
end

-- Ability Start
function illusionist_glimmer_lua:OnSpellStart(keys)
    

    -- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
    
    local particle_cast = "particles/items3_fx/glimmer_cape_initial_flash.vpcf"
	local sound_cast = "Hero_Riki.Invisibility"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
    
    ParticleManager:ReleaseParticleIndex( effect_cast )
    EmitSoundOn( sound_cast, target )

	-- load data
	local duration = self:GetSpecialValueFor("duration")
	local fade = self:GetSpecialValueFor("glimmer_fade")
	local abil = self:GetCaster():FindAbilityByName("illusionist_upgrade_3")
	if abil then
		if abil:GetLevel() > 0 then
			fade = 0.03
		end
	end

    
	-- Add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_illusionist_glimmer_lua", -- modifier name
		{ duration = duration, delay= fade } -- kv
	)

	--[[Play Effects
	self:PlayEffects()]]
end
