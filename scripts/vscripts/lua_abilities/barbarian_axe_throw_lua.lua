barbarian_axe_throw_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function barbarian_axe_throw_lua:GetManaCost(level)
    local reduction = 0
	local abil = self:GetCaster():FindAbilityByName("barbarian_upgrade_3")
	if abil then
		if abil:GetLevel() > 0 then
			reduction = self:GetSpecialValueFor( "upgrade_mp_cost_decrease" )
		end
	end

	return 70 - reduction
end

-- Ability Start
function barbarian_axe_throw_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local point = self:GetCursorPosition()

	-- load data
	local projectile_name = "particles/units/heroes/hero_troll_warlord/troll_warlord_whirling_axe_ranged.vpcf"
	local projectile_speed = self:GetSpecialValueFor("arrow_speed")
	local projectile_distance = self:GetSpecialValueFor("arrow_range")
	local projectile_radius = self:GetSpecialValueFor("arrow_width")
	local projectile_vision = self:GetSpecialValueFor("arrow_vision")

	local arrow_damage = self:GetAbilityDamage()
	local min_stun = self:GetSpecialValueFor( "arrow_stun" )

    --local projectile_direction = (Vector( point.x-origin.x, point.y-origin.y, 0 )):Normalized()
    local projectile_direction = caster:GetForwardVector():Normalized()

	-- logic
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetOrigin(),
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius = projectile_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}
    --local projectile = ProjectileManager:CreateLinearProjectile(info)
    ProjectileManager:CreateLinearProjectile(info)
    --self.projectiles[projectile] = {}
    
	-- Effects
	local sound_cast = "Hero_Beastmaster.Wild_Axes"
	EmitSoundOn( sound_cast, caster )
end

--barbarian_axe_throw_lua.projectiles = {}
--------------------------------------------------------------------------------
-- Projectile
function barbarian_axe_throw_lua:OnProjectileHit( hTarget, vLocation )

    local vision_radius = self:GetSpecialValueFor("arrow_vision")
    local vision_duration = self:GetSpecialValueFor( "vision_duration" )

    if hTarget==nil then
        --if target == 0 upon projectile hit, that means it has reached max distance. so destroy it.
		-- create Vision
        AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation, vision_radius, vision_duration, true )
        --destroy projectile
        return true
    end

    if not hTarget:IsAncient() and not hTarget:IsMagicImmune() and not IsBuildingOrSpire(hTarget) then
        local damageTable = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = self:GetAbilityDamage(),
            damage_type = self:GetAbilityDamageType(),
            ability = self, --Optional.
            --damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, --Optional.
        }
        ApplyDamage(damageTable)

        --apply stun
        local stun_duration = self:GetSpecialValueFor( "arrow_stun" )
        hTarget:AddNewModifier(
            self:GetCaster(), -- player source
            self, -- ability source
            "modifier_generic_stunned_lua", -- modifier name
            { duration = stun_duration } -- kv
        )

        --ProjectileManager:DestroyLinearProjectile(handle) --destroying arrow
        AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation, vision_radius, vision_duration, true ) --vision for caster

        --sfx effects
        local sound_cast = "Hero_Lion.ImpaleHitTarget"
        EmitSoundOn( sound_cast, hTarget )
        local particle_cast = "particles/econ/items/lifestealer/ls_ti9_immortal_gold/ls_ti9_open_wounds_gold_blood_bulk.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, hTarget )
        ParticleManager:SetParticleControlEnt(effect_cast, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true)
        ParticleManager:ReleaseParticleIndex(effect_cast)
        
        --destroy projectile
        return true
    end
    return false
end