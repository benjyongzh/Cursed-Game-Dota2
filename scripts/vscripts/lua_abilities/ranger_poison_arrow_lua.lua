ranger_poison_arrow_lua = class({})
LinkLuaModifier( "modifier_ranger_poison_arrow_lua", "modifiers/modifier_ranger_poison_arrow_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function ranger_poison_arrow_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- Play effects
	local sound_cast = "Ability.PowershotPull"
	EmitSoundOnLocationForAllies( caster:GetOrigin(), sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Ability Channeling
function ranger_poison_arrow_lua:OnChannelFinish( bInterrupted )
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()

	-- load data
	local damage = self:GetSpecialValueFor( "powershot_damage" )
	local reduction = 1-self:GetSpecialValueFor( "damage_reduction" )
	local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	
	local projectile_name = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf"
	--local projectile_name = "particles/econ/items/viper/viper_ti7_immortal/viper_poison_attack_ti7.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "arrow_speed" )
	local projectile_distance = self:GetSpecialValueFor( "arrow_range" )
	local projectile_radius = self:GetSpecialValueFor( "arrow_width" )
	local projectile_min_poison_dmg = self:GetSpecialValueFor( "min_poison_duration" )
	local projectile_max_poison_dmg = self:GetSpecialValueFor( "max_poison_duration" )
	local projectile_min_poison_slow = self:GetSpecialValueFor( "min_poison_slow_percent" )
	local projectile_max_poison_slow = self:GetSpecialValueFor( "max_poison_slow_percent" )
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius = projectile_radius,
		vVelocity = projectile_direction * projectile_speed,
    
        bDeleteOnHit = true,
		bProvidesVision = true,
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber(),
		--iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2 only for trackingprojectile
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)

	-- register projectile data
	self.projectiles[projectile] = {}
    self.projectiles[projectile].damage = damage*channel_pct
    self.projectiles[projectile].poison_duration = projectile_min_poison_dmg+((projectile_max_poison_dmg-projectile_min_poison_dmg)*channel_pct)
    self.projectiles[projectile].poison_slow = projectile_min_poison_slow+((projectile_max_poison_slow-projectile_min_poison_slow)*channel_pct)
	--self.projectiles[projectile].reduction = reduction

	-- Play effects
	local sound_cast = "Ability.Powershot"
	EmitSoundOn( sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Projectile
-- projectile data table
ranger_poison_arrow_lua.projectiles = {}

function ranger_poison_arrow_lua:OnProjectileHitHandle( target, location, handle )
    local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	local vision_duration = self:GetSpecialValueFor( "vision_duration" )
	if not target then --max range of arrow
		-- create Vision
        AddFOWViewer( self:GetCaster():GetTeamNumber(), location, vision_radius, vision_duration, false )
        --destroy arrow
		return true
	end

	-- get data
	local data = self.projectiles[handle]
	local damage = data.damage
	local poison_duration = data.poison_duration
    local poison_slow = data.poison_slow
    
	-- impact damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
    --apply poison modifier
    target:AddNewModifier(self:GetCaster(), self, "modifier_ranger_poison_arrow_lua", {
        duration = poison_duration,
        slow = poison_slow,
        dps = self:GetSpecialValueFor( "poison_dps" )
	})
	-- create Vision
	AddFOWViewer( self:GetCaster():GetTeamNumber(), location, vision_radius, vision_duration, false )
	-- Play effects
	local sound_cast = "hero_viper.projectileImpact"
    EmitSoundOn( sound_cast, target )
    sound_cast = "Hero_Venomancer.VenomousGaleImpact"
    EmitSoundOn( sound_cast, target )
    return true
end