samurai_flash_step_lua = class({})

LinkLuaModifier( "modifier_samurai_flash_step_charges_lua", "modifiers/modifier_samurai_flash_step_charges_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_samurai_counter_lua", "modifiers/modifier_samurai_counter_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function samurai_flash_step_lua:GetIntrinsicModifierName()
	return "modifier_samurai_flash_step_charges_lua"
end

--check for upgrade 2
function samurai_flash_step_lua:GetCooldown(level)
    local reduction = 0

    local abil = self:GetCaster():FindAbilityByName("samurai_upgrade_2")
	if abil then
		if abil:GetLevel() > 0 then
			reduction = self:GetSpecialValueFor( "upgrade_cd_decrease" )
		end
	end

    local cooldown = 4 - reduction
    return cooldown
end

--------------------------------------------------------------------------------
-- Ability Start
function samurai_flash_step_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()

	-- load data
	local min_dist = self:GetSpecialValueFor( "min_travel_distance" )
	local max_dist = self:GetSpecialValueFor( "max_travel_distance" )
	local radius = self:GetSpecialValueFor( "radius" )
	
	-- check for upgrade 1
	local abil = self:GetCaster():FindAbilityByName("samurai_upgrade_1")
	if abil then
		if abil:GetLevel() > 0 then
			max_dist = max_dist + self:GetSpecialValueFor( "upgrade_max_range_increase" )
		end
	end

	-- find destination
	local direction = (point-origin)
	local dist = math.max( math.min( max_dist, direction:Length2D() ), min_dist )
	direction.z = 0
	direction = direction:Normalized()

	local target = GetGroundPosition( origin + direction*dist, nil )

	-- teleport
	FindClearSpaceForUnit( caster, target, true )

	-- find units in line
	local enemies = FindUnitsInLine(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		origin,	-- point, start point
		target,	-- point, end point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	-- int, flag filter
	)

	for _,enemy in pairs(enemies) do
		-- perform attack
		--caster:PerformAttack( enemy, true, true, true, false, true, false, true )
		if not IsBuildingOrSpire(enemy) then
			local damageTable = {
				victim = enemy,
				attacker = caster,
				damage = self:GetAbilityDamage(),
				damage_type = self:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = self, --Optional.
			}
			
			ApplyDamage(damageTable)

			-- play effects
			self:PlayEffects2( enemy )
		end
	end

	-- play effects
	self:PlayEffects1( origin, target )

	-- check for upgrade 3
	local abil = self:GetCaster():FindAbilityByName("samurai_upgrade_3")
	if abil then
		if abil:GetLevel() > 0 then
			local counter_abil = caster:FindAbilityByName("samurai_counter_lua")
			if counter_abil then

				-- remove existing counter modifier if any
				local counter_modifier = caster:FindModifierByName("modifier_samurai_counter_lua")
				if counter_modifier then
					counter_modifier:Destroy()
				end

				-- apply counter modifier
				local max_range = counter_abil:GetSpecialValueFor("max_range")
				local spell_duration = counter_abil:GetSpecialValueFor("duration")
				local distance = counter_abil:GetSpecialValueFor("distance_away")
				caster:AddNewModifier(caster, self, "modifier_samurai_counter_lua", {duration = spell_duration, range = max_range, blink_distance = distance})
			end
		end
	end

end

--------------------------------------------------------------------------------
function samurai_flash_step_lua:PlayEffects1( origin, target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf"
	local sound_start = "Hero_Wisp.Return.Arc"
	local sound_end = "Hero_Riki.Blink_Strike"
	--local sound_end = "Hero_VengefulSpirit.NetherSwap"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end

function samurai_flash_step_lua:PlayEffects2( target )
    -- Create Particle
    local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControlEnt(effect_cast, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
    ParticleManager:ReleaseParticleIndex( effect_cast )
    -- Create Sound
    local sound_cast = "Hero_Juggernaut.Attack"
    EmitSoundOn( sound_cast, target )

    --[[ extra sfx
    -- Create Particle
    particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
    effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
    ParticleManager:ReleaseParticleIndex( effect_cast )
    -- Create Sound
    sound_cast = "Hero_PhantomAssassin.Spatter"
	EmitSoundOn( sound_cast, target )
	]]
end