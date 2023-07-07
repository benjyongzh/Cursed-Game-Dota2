boomer_boomershot_lua = class({})
LinkLuaModifier( "modifier_boomer_boomershot_knockback_lua", "modifiers/modifier_boomer_boomershot_knockback_lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_generic_custom_indicator_lua", "modifiers/modifier_generic_custom_indicator_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom Indicator
function boomer_boomershot_lua:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator_lua"
end

function boomer_boomershot_lua:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			-- register cursor position
			self.custom_indicator:Register( vLoc )
		end
	end

	return UF_SUCCESS
end

function boomer_boomershot_lua:CreateCustomIndicator()
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_range_finder_aoe.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end

function boomer_boomershot_lua:UpdateCustomIndicator( loc )
	-- get data
	local origin = self:GetCaster():GetAbsOrigin()
	local point_blank = self:GetSpecialValueFor( "point_blank_range" )

	-- get direction
	local direction = loc - origin
	direction.z = 0
	direction = direction:Normalized()

	ParticleManager:SetParticleControl( self.effect_cast, 0, origin )
	ParticleManager:SetParticleControl( self.effect_cast, 1, origin + direction*(self:GetCastRange( loc, nil )+200) )
	ParticleManager:SetParticleControl( self.effect_cast, 6, origin + direction*point_blank )
end

function boomer_boomershot_lua:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end

--check for upgrade 2
function boomer_boomershot_lua:GetCooldown(level)
    local reduction = 0

    local abil = self:GetCaster():FindAbilityByName("boomer_upgrade_2")
	if abil then
		if abil:GetLevel() > 0 then
			reduction = self:GetSpecialValueFor( "upgrade_cd_decrease" )
		end
	end

    local cooldown = 25 - reduction
    return cooldown
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function boomer_boomershot_lua:OnAbilityPhaseStart()
	-- play sound
	local sound_cast = "Hero_Snapfire.Shotgun.Load"
	EmitSoundOn( sound_cast, self:GetCaster() )

	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function boomer_boomershot_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()

	-- load data
	local projectile_name = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun.vpcf"
	local projectile_distance = self:GetCastRange( point, nil )
	local projectile_start_radius = self:GetSpecialValueFor( "blast_width_initial" )/2
	local projectile_end_radius = self:GetSpecialValueFor( "blast_width_end" )/2
	local projectile_speed = self:GetSpecialValueFor( "blast_speed" )
	local projectile_direction = point-origin
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()	

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = self:GetAbilityTargetTeam(),
	    iUnitTargetFlags = self:GetAbilityTargetFlags(),
	    iUnitTargetType = self:GetAbilityTargetType(),
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bProvidesVision = false,
		ExtraData = {
			pos_x = origin.x,
			pos_y = origin.y,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- play sound
	local sound_cast = "Hero_Snapfire.Shotgun.Fire"
	EmitSoundOn( sound_cast, caster )
end
--------------------------------------------------------------------------------
-- Projectile
function boomer_boomershot_lua:OnProjectileHit_ExtraData( target, location, extraData )
	if not target then return end

	if IsBuildingOrSpire(target) or target:HasModifier("modifier_ghost_passive_lua") then return end

	-- load data
	local caster = self:GetCaster()
	local location = target:GetOrigin()
	local point_blank_range = self:GetSpecialValueFor( "point_blank_range" )
	local point_blank_mult = self:GetSpecialValueFor( "point_blank_dmg_bonus_pct" )/100
	local damage = self:GetSpecialValueFor( "damage" )    

    local centre = caster:GetAbsOrigin()
	local vector = Vector(location.x-centre.x, location.y-centre.y, location.z-centre.z)
	local distance_from_source = math.sqrt(vector.x * vector.x + vector.y * vector.y)
	local distance_to_travel = self:GetSpecialValueFor("blast_width_end") - distance_from_source
	vector = vector:Normalized()

	-- check position
	local origin = Vector( extraData.pos_x, extraData.pos_y, 0 )
	local length = (location-origin):Length2D()

	-- manual check due to projectile's circle shape
	-- if length>self:GetCastRange( location, nil )+150 then return end

	local point_blank = (length<=point_blank_range)
	if point_blank then damage = damage + point_blank_mult*damage end

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- debuff
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_boomer_boomershot_knockback_lua", -- modifier name
		{
            direction_x = vector.x,
            direction_y = vector.y,
            distance = distance_to_travel,
            speed = self:GetSpecialValueFor("knockback_speed")
        } -- kv
	)

	-- effect
	self:PlayEffects( target, point_blank )
end

--------------------------------------------------------------------------------
function boomer_boomershot_lua:PlayEffects( target, point_blank )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_impact.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_shells_impact.vpcf"
	local particle_cast3 = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_pointblank_impact_sparks.vpcf"
	local sound_target = "Hero_Snapfire.Shotgun.Target"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if point_blank then
		local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_POINT_FOLLOW, target )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			3,
			target,
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:ReleaseParticleIndex( effect_cast )

		local effect_cast = ParticleManager:CreateParticle( particle_cast3, PATTACH_POINT_FOLLOW, target )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			4,
			target,
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end

	-- Create Sound
	EmitSoundOn( sound_target, target )
end