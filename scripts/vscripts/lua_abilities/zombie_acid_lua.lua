zombie_acid_lua = class({})
LinkLuaModifier( "modifier_zombie_acid_dummy_lua", "modifiers/modifier_zombie_acid_dummy_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_acid_debuff_lua", "modifiers/modifier_zombie_acid_debuff_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dummy_unit", "modifiers/modifier_dummy_unit", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function zombie_acid_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function zombie_acid_lua:OnAbilityPhaseStart()
	--animation
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_LIFESTEALER_EJECT, (10/(0.7*30)))

	-- play effects 
	local sound_cast = "hero_viper.preAttack"
	EmitSoundOn( sound_cast, self:GetCaster() )
	
	--local particle_precast = "particles/econ/events/fall_major_2016/teleport_start_fm06_leaves_b.vpcf"
	--local particle_precast = "particles/econ/items/wisp/wisp_relocate_channel_ti7.vpcf"
	--self.effect_precast = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	--ParticleManager:SetParticleControlEnt(self.effect_precast, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true)

	return true -- if success
end

function zombie_acid_lua:OnAbilityPhaseInterrupted()
	--animation
	self:GetCaster():RemoveGesture(ACT_DOTA_LIFESTEALER_EJECT)

	-- stop effects 
	local sound_cast = "hero_viper.preAttack"
	StopSoundOn( sound_cast, self:GetCaster() )
	--ParticleManager:DestroyParticle( self.effect_precast, true )
end


-- Ability Start
function zombie_acid_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local point = self:GetCursorPosition()

	--caster:RemoveGesture(ACT_DOTA_LIFESTEALER_EJECT)
	
	-- load data
	local projectile_speed = self:GetSpecialValueFor("proj_speed")
	local projectile_distance = self:GetSpecialValueFor("range")
	local projectile_start_radius = self:GetSpecialValueFor("proj_width")
	local projectile_end_radius = self:GetSpecialValueFor("proj_width")
    local projectile_vision = self:GetSpecialValueFor("proj_vision")

	local projectile_direction = (Vector( point.x-origin.x, point.y-origin.y, 0 )):Normalized()

	--net animation
	local particle_name = "particles/econ/items/viper/viper_ti7_immortal/viper_poison_attack_ti7.vpcf"

	--create target
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
		{ duration = 3.0 } -- kv
	)
	
	-- Create the projectile
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
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
    }
    ProjectileManager:CreateTrackingProjectile( info )

	-- Effects
	EmitSoundOn( "hero_viper.poisonAttack.Cast.ti7", caster )
	EmitSoundOn( "Hero_Bristleback.ViscousGoo.Cast", caster )

end

--------------------------------------------------------------------------------
-- Projectile
function zombie_acid_lua:OnProjectileHit( hTarget, vLocation)
	if hTarget==nil or hTarget == self.dummy then

		-- load data
		local caster = self:GetCaster()
		local spell_duration = self:GetSpecialValueFor( "duration" )
		local dummy_origin = self.dummy:GetOrigin()
		
		-- create new dummy unit and add dummy modifier to it
		local dummy = CreateUnitByName(
			"dummy_unit",
			dummy_origin,
			true,
			caster,
			caster:GetOwner(),
			caster:GetTeamNumber()
		)

		dummy:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_zombie_acid_dummy_lua", -- modifier name
			{ duration = spell_duration } -- kv
		)

		AddFOWViewer( self:GetCaster():GetTeamNumber(), dummy_origin, self:GetSpecialValueFor( "radius" ), spell_duration, false )
		
		--kill that shit dummy
		self.dummy:ForceKill(false)

		return true
	end
end