guardian_heal_lua = class({})
LinkLuaModifier( "modifier_guardian_heal_lua", "modifiers/modifier_guardian_heal_lua", LUA_MODIFIER_MOTION_NONE)


---------------------------------------------------------------------------------------------------------------------------------------------

-- Ability cast on building
function guardian_heal_lua:CastFilterResultTarget( hTarget )
	if IsBuildingOrSpire(hTarget) then
		return UF_FAIL_BUILDING
	end
	return UF_SUCCESS
end

function guardian_heal_lua:GetCustomCastErrorTarget( hTarget )
	if IsBuildingOrSpire(hTarget) then
		return "#dota_hud_error_cant_cast_on_building"
	end
	return ""
end

function guardian_heal_lua:GetCastPoint()
	if IsServer() and self:GetCursorTarget()==self:GetCaster() then
		return self:GetSpecialValueFor( "self_cast_delay" )
	end
	return 0.2
end

function guardian_heal_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local heal = self:GetSpecialValueFor("heal")
	local radius = self:GetSpecialValueFor("radius")
    local projectile_name = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )

    
    -- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)

	-- Play sound
	local sound_cast = "Hero_SkywrathMage.ArcaneBolt.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
	
end

function guardian_heal_lua:OnProjectileHit( target, location )
	if not target then return end

	if target:IsOutOfGame() then return end
    --load data
    local duration = self:GetSpecialValueFor("duration")
    local heal = self:GetSpecialValueFor("heal")

    --heal
    target:Heal( heal, self )
    
	self:PlayEffects1(target)
	
	local sound_cast = "Hero_Omniknight.Purification"
	EmitSoundOn( sound_cast, target )

	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_guardian_heal_lua", -- modifier name
        { duration = duration} -- kv
	)
	
	
	
	return true
end



function guardian_heal_lua:PlayEffects1(target)
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
    local effect_target = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	--local sound_target = "Hero_Omniknight.Purification"

	ParticleManager:ReleaseParticleIndex( effect_target )
	--EmitSoundOn( sound_target, target )
end