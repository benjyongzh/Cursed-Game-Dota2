tracker_snare_lua = class({})
LinkLuaModifier( "modifier_tracker_snare_debuff_lua", "modifiers/modifier_tracker_snare_debuff_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dummy_unit", "modifiers/modifier_dummy_unit", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function tracker_snare_lua:GetAOERadius()
	return self:GetSpecialValueFor( "net_radius" )
end

function tracker_snare_lua:GetCooldown(level)
    local reduction = 0

    local abil = self:GetCaster():FindAbilityByName("scout_upgrade_2")
	if abil then
		if abil:GetLevel() > 0 then
			reduction = self:GetSpecialValueFor( "upgrade_cd_decrease" )
		end
	end

    local cooldown = 10 - reduction
    return cooldown
end

-- Ability Start
function tracker_snare_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local point = self:GetCursorPosition()
	
	-- load data
	local projectile_speed = self:GetSpecialValueFor("net_speed")
	local projectile_distance = self:GetSpecialValueFor("net_range")
	local projectile_start_radius = self:GetSpecialValueFor("net_width")
	local projectile_end_radius = self:GetSpecialValueFor("net_width")
    local projectile_vision = self:GetSpecialValueFor("net_vision")

	local projectile_direction = (Vector( point.x-origin.x, point.y-origin.y, 0 )):Normalized()


	--net animation
	local particle_name = "particles/units/heroes/hero_meepo/meepo_earthbind_projectile_fx.vpcf"

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
        iVisionRadius = 0,
        iVisionTeamNumber = caster:GetTeamNumber(),
        --iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
    }
    ProjectileManager:CreateTrackingProjectile( info )

	-- Effects
	local sound_cast = "Hero_NagaSiren.Ensnare.Cast"
	EmitSoundOn( sound_cast, caster )

end

--------------------------------------------------------------------------------
-- Projectile
function tracker_snare_lua:OnProjectileHit( hTarget, vLocation)
	if hTarget==nil or hTarget == self.dummy then

		-- load data
		local spell_duration = self:GetSpecialValueFor( "duration" )
		local dummy_origin = self.dummy:GetOrigin()
		
		--find enemies
		local caster = self:GetCaster()
		local enemies = FindUnitsInRadius(
			caster:GetTeam(),
			--dummy_origin,
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
			if not IsBuildingOrSpire(enemy) then
				enemy:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_tracker_snare_debuff_lua", -- modifier name
				{ duration = spell_duration } -- kv
				)
			end
		end

		AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation, 500, 3, true )

		-- effects
		local sound_cast = "Hero_NagaSiren.Ensnare.Target"
		EmitSoundOn( sound_cast, hTarget )
		
		--kill that shit dummy
		self.dummy:ForceKill(false)

		return true
	end
end