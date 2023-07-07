boomer_sugar_rush_lua = class({})
LinkLuaModifier( "modifier_boomer_sugar_rush_lua", "modifiers/modifier_boomer_sugar_rush_lua", LUA_MODIFIER_MOTION_NONE)


--------------------------------------------------------------------------------
-- Custom KV
function boomer_sugar_rush_lua:GetCastPoint()
	if IsServer() and self:GetCursorTarget()==self:GetCaster() then
		return self:GetSpecialValueFor( "self_cast_delay" )
	end
	return 0.2
end

--------------------------------------------------------------------------------
-- Ability cast on building
function boomer_sugar_rush_lua:CastFilterResultTarget( hTarget )
	if IsBuildingOrSpire(hTarget) then
		return UF_FAIL_BUILDING
	end
	return UF_SUCCESS
end

function boomer_sugar_rush_lua:GetCustomCastErrorTarget( hTarget )
	if IsBuildingOrSpire(hTarget) then
		return "#dota_hud_error_cant_cast_on_building"
	end
	return ""
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function boomer_sugar_rush_lua:OnAbilityPhaseInterrupted()

end

function boomer_sugar_rush_lua:OnAbilityPhaseStart()
	if self:GetCursorTarget()==self:GetCaster() then
		self:PlayEffects1()
	end

	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function boomer_sugar_rush_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local projectile_name = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)

	-- Play sound
	local sound_cast = "Hero_Snapfire.FeedCookie.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
end
--------------------------------------------------------------------------------
-- Projectile
function boomer_sugar_rush_lua:OnProjectileHit( target, location )
	if not target then return end

	if target:IsOutOfGame() then return end
	print(hit)
    --load data
	local duration = self:GetSpecialValueFor("duration")
	
	-- check for upgrade 3
	local abil = self:GetCaster():FindAbilityByName("boomer_upgrade_3")
	if abil then
		if abil:GetLevel() > 0 then
			duration = self:GetCooldown(self:GetLevel())
		end
	end
    
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_boomer_sugar_rush_lua", -- modifier name
		{ duration = duration } -- kv
	)
	
	-- play effects2
    --local effect_cast = self:PlayEffects2( target )
	
	return true
end

--------------------------------------------------------------------------------
function boomer_sugar_rush_lua:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_selfcast.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

--[[function boomer_sugar_rush_lua:PlayEffects2( target )
	-- Get Resources
	--local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_buff.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_receive.vpcf"
	local sound_target = "Hero_Snapfire.FeedCookie.Consume"

	-- Create Particle
	--local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	-- Create Sound
	EmitSoundOn( sound_target, target )

	return effect_cast
end]]

--[[function boomer_sugar_rush_lua:PlayEffects3( target, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf"
	local sound_location = "Hero_Snapfire.FeedCookie.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_location, target )
end]]