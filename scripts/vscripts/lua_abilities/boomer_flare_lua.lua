boomer_flare_lua = class({})

------------------------------------------------------------------------------------------------------------------------
function boomer_flare_lua:GetAOERadius()
	return self:GetSpecialValueFor( "area_of_effect" )
end

function boomer_flare_lua:OnSpellStart()

    -- unit identifier
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local point = self:GetCursorPosition()

	-- load data
	local particle_name = "particles/econ/items/clockwerk/clockwerk_paraflare/clockwerk_para_rocket_flare.vpcf"
	local projectile_speed = self:GetSpecialValueFor("rocket_speed")
	local projectile_distance = self:GetSpecialValueFor("rocket_range")
	local projectile_vision = self:GetSpecialValueFor("rocket_vision")

    local projectile_direction = caster:GetForwardVector():Normalized()
	
	self.dummy = CreateUnitByName(
		"dummy_unit",
		self:GetCursorPosition(),
		true,
		caster,
		caster:GetOwner(),
		caster:GetTeamNumber()
	)

	self.dummy:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_dummy_unit", -- modifier name
		{} -- kv
	)

    local info = {
		
		
		Target = self.dummy,
        Source = caster,
		Ability = self,
		
		bDeleteOnHit = true,

        EffectName = particle_name,
        bDodgeable = false,
        bProvidesVision = true,
        iMoveSpeed = projectile_speed,
        iVisionRadius = projectile_vision,
        iVisionTeamNumber = caster:GetTeamNumber(),
        --iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
    }
    ProjectileManager:CreateTrackingProjectile( info )
    local sound_cast = "Hero_Rattletrap.Rocket_Flare.Fire"
    EmitSoundOn( sound_cast, caster )
    
end

function boomer_flare_lua:OnProjectileHit( hTarget, vLocation )

    if hTarget==nil or hTarget == self.dummy then

		-- load data
		local spell_duration = self:GetSpecialValueFor( "vision_duration" )
		local spell_radius = self:GetSpecialValueFor( "area_of_effect" )
		local dummy_origin = self.dummy:GetOrigin()

		-- check for upgrade 1
		local abil = self:GetCaster():FindAbilityByName("boomer_upgrade_1")
		if abil then
			if abil:GetLevel() > 0 then
				spell_duration = spell_duration + self:GetSpecialValueFor("upgrade_duration_increase")
			end
		end

		AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation, spell_radius, spell_duration, false )
		
		self:PlayEffects( hTarget )
		
		--kill that shit dummy
		self.dummy:ForceKill(false)

		return true
	end
end

function boomer_flare_lua:PlayEffects( hTarget )
	-- Get Resources
	local particle_cast = "particles/econ/items/clockwerk/clockwerk_paraflare/clockwerk_para_rocket_flare_parachute.vpcf"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, hTarget )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end