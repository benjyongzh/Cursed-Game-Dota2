assassin_flashbang_lua = class({})
LinkLuaModifier( "modifier_assassin_flashbang_debuff_lua", "modifiers/modifier_assassin_flashbang_debuff_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dummy_unit", "modifiers/modifier_dummy_unit", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function assassin_flashbang_lua:GetAOERadius()
	-- check for upgrade 1
	--[[
    local abil = self:GetParent():FindAbilityByName("assassin_upgrade_1")
	if abil then
		if abil:GetLevel() > 0 then
			return self:GetSpecialValueFor( "flash_radius" ) + self:GetSpecialValueFor("upgrade_aoe_increase")
		end
	end
	]]
	return self:GetSpecialValueFor( "flash_radius" )
end

-- Ability Start
function assassin_flashbang_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local point = self:GetCursorPosition()
	
	-- load data
	local projectile_speed = self:GetSpecialValueFor("grenade_speed")
	local projectile_distance = self:GetSpecialValueFor("range")
	local projectile_start_radius = self:GetSpecialValueFor("grenade_width")
	local projectile_end_radius = self:GetSpecialValueFor("grenade_width")
    local projectile_vision = self:GetSpecialValueFor("grenade_vision")

	local projectile_direction = (Vector( point.x-origin.x, point.y-origin.y, 0 )):Normalized()


	--net animation
	local particle_name = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_proj.vpcf"

	--create target
	
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
        --iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
    }
    ProjectileManager:CreateTrackingProjectile( info )

	-- Effects
	local sound_cast = "Hero_Tiny.PreAttack"
	EmitSoundOn( sound_cast, caster )

end

--------------------------------------------------------------------------------
-- Projectile
function assassin_flashbang_lua:OnProjectileHit( hTarget, vLocation)
	if hTarget==nil or hTarget == self.dummy then

		-- load data
		local spell_duration = self:GetSpecialValueFor( "duration" )
		local dummy_origin = self.dummy:GetOrigin()
		
		--find enemies
		local caster = self:GetCaster()
		local enemies = FindUnitsInRadius(
			caster:GetTeam(),
			vLocation,
			nil,
			self:GetAOERadius(),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
			)
	
		for _,enemy in pairs(enemies) do
			if not enemy:HasModifier("modifier_spire") then
				enemy:Interrupt()
				enemy:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_assassin_flashbang_debuff_lua", -- modifier name
				{ duration = spell_duration } -- kv
				)
			end
		end

		AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation, self:GetSpecialValueFor( "grenade_vision" ), 2, false )

		-- effects
		local sound_cast = "Hero_Sniper.ShrapnelShoot"
        --EmitSoundOn( sound_cast, self.dummy )
        sound_cast = "Hero_Centaur.HoofStomp"
		EmitSoundOn( sound_cast, self.dummy )
		sound_cast = "Hero_PhantomAssassin.Arcana_Layer"
		EmitSoundOn( sound_cast, self.dummy )
        
        --particles/items_fx/abyssal_blink_start.vpcf
        local particle_precast = "particles/econ/items/centaur/centaur_ti6_gold/centaur_ti6_warstomp_gold.vpcf"
		local effect = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, self.dummy )
		ParticleManager:SetParticleControlEnt(effect, 0, self.dummy, PATTACH_ABSORIGIN_FOLLOW, nil, self.dummy:GetOrigin(), true)
		ParticleManager:ReleaseParticleIndex( effect )
		particle_precast = "particles/units/heroes/hero_zuus/zuus_thundergods_wrath_modglow.vpcf"
		effect = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, self.dummy )
		ParticleManager:SetParticleControlEnt(effect, 0, self.dummy, PATTACH_ABSORIGIN_FOLLOW, nil, self.dummy:GetOrigin(), true)
		ParticleManager:ReleaseParticleIndex( effect )
		
		--kill that shit dummy
		self.dummy:ForceKill(false)

		return true
	end
end