ranger_powershot_lua = class({})
LinkLuaModifier( "modifier_ranger_powershot_lua", "modifiers/modifier_ranger_powershot_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function ranger_powershot_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- Play effects
	local sound_cast = "Ability.PowershotPull"
	EmitSoundOn( sound_cast, caster )
	local hanzo_sound_cast = "Ability.hanzo.powershot_edited"
	EmitSoundOn( hanzo_sound_cast, caster )
	local particle_cast = "particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_channel_ti6.vpcf"
	self.effect_1 = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(self.effect_1, 0, caster, PATTACH_POINT_FOLLOW, "bow_mid1", caster:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.effect_1, 1, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetOrigin() + Vector(0,0,60) + caster:GetForwardVector()*60, true)
end

--------------------------------------------------------------------------------
-- Ability Channeling
function ranger_powershot_lua:OnChannelFinish( bInterrupted )
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()

	-- load data
	local damage = self:GetSpecialValueFor( "powershot_damage" )
	local reduction = 1-self:GetSpecialValueFor( "damage_reduction" )
	local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	
	local projectile_name = "particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf"
	
	local projectile_speed = self:GetSpecialValueFor( "arrow_speed" )
	local projectile_distance = self:GetSpecialValueFor( "arrow_range" )
	local projectile_radius = self:GetSpecialValueFor( "arrow_width" )
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
    
        --bDeleteOnHit = true,
		bProvidesVision = true,
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber(),
		--iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)

	-- register projectile data
	self.projectiles[projectile] = {}
	self.projectiles[projectile].damage = damage*channel_pct

	-- Play effects
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
	EmitSoundOn( "Hero_Windrunner.Powershot.FalconBow", caster )
	
	if channel_pct < 0.99 then
		local hanzo_sound_cast = "Ability.hanzo.powershot_edited"
		StopSoundOn( hanzo_sound_cast, caster )
	else
		EmitSoundOn( "Hero_DragonKnight.DragonTail.Cast.Kindred", caster )
		EmitSoundOn( "Hero_DragonKnight.ElderDragonForm", caster )
	end

	if self.effect_1 then
		ParticleManager:DestroyParticle(self.effect_1, true)
	end
	local particle_cast = "particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_channel_ti6_shock_ring.vpcf"
	local effect = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(effect, 1, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
end

--------------------------------------------------------------------------------
-- Projectile
-- projectile data table
ranger_powershot_lua.projectiles = {}

function ranger_powershot_lua:OnProjectileHitHandle( target, location, handle )
    local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	local vision_duration = self:GetSpecialValueFor( "vision_duration" )
	if not target then --max range of arrow
		-- create Vision
        AddFOWViewer( self:GetCaster():GetTeamNumber(), location, vision_radius, vision_duration, true )
        --destroy arrow
		return true
	end

	-- get data
	local data = self.projectiles[handle]
	local damage = data.damage

	-- damage
	if not target:IsMagicImmune() and not IsBuildingOrSpire(target) then

		--if unit hp is below arrow dmg then insta kill
		if target:GetHealth() < damage then
			local damageTable = {
				victim = target,
				attacker = self:GetCaster(),
				damage = target:GetHealth() + 1,
				damage_type = DAMAGE_TYPE_PURE,
				ability = self, --Optional.
			}
			ApplyDamage(damageTable)
			--sfx
			local sound_cast = "Hero_Shredder.TimberChain.Impact"
			EmitSoundOn( sound_cast, target )
			sound_cast = "Hero_PhantomAssassin.Spatter"
			EmitSoundOn( sound_cast, target )
			local particle_cast = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta_blood.vpcf"
			local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
			ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
			ParticleManager:ReleaseParticleIndex(effect_cast)
			--make the projectile carry on travelling
			return false

		--if unit hp is high enough then deal dmg to it. and destroy arrow
		else
			local damageTable = {
				victim = target,
				attacker = self:GetCaster(),
				damage = damage,
				damage_type = self:GetAbilityDamageType(),
				ability = self, --Optional.
			}
			ApplyDamage(damageTable)

			-- Play effects
			local sound_cast = "Hero_Sniper.AssassinateDamage"
			EmitSoundOn( sound_cast, target )
			local particle_cast = "particles/units/heroes/hero_sniper/sniper_assassinate_impact_blood.vpcf"
			local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
			ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
			ParticleManager:ReleaseParticleIndex(effect_cast)

			-- create Vision
			AddFOWViewer( self:GetCaster():GetTeamNumber(), location, vision_radius, vision_duration, true )
			return true
		end
		return false
	end
end

-- check for upgrade 3 to destroy trees
function ranger_powershot_lua:OnProjectileThink( location )
	local abil = self:GetCaster():FindAbilityByName("ranger_upgrade_3")
	if abil then
		if abil:GetLevel() > 0 then
			-- destroy trees
			local tree_width = self:GetSpecialValueFor( "arrow_width" )
			GridNav:DestroyTreesAroundPoint(location, tree_width, false)	
		end
	end
end