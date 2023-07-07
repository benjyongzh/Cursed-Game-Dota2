vampire_delirium_lua = class({})
LinkLuaModifier( "modifier_vampire_delirium_debuff_lua", "modifiers/modifier_vampire_delirium_debuff_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_vampire_illusion_lua", "modifiers/modifier_vampire_illusion_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_vampire_illusion_buff_lua", "modifiers/modifier_vampire_illusion_buff_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_vampire_day", "modifiers/modifier_vampire_day", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vampire_night", "modifiers/modifier_vampire_night", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function vampire_delirium_lua:OnAbilityPhaseStart()
	-- play effects 
	local sound_cast = "Hero_ShadowDemon.Disruption.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
	
	local particle_precast = "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm_smoke.vpcf"
	self.effect_precast = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(self.effect_precast, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true)

	return true -- if success
end

function vampire_delirium_lua:OnAbilityPhaseInterrupted()
	-- stop effects 
	local sound_cast = "Hero_ShadowDemon.Disruption.Cast"
	StopSoundOn( sound_cast, self:GetCaster() )
	ParticleManager:DestroyParticle( self.effect_precast, true )
end
----------------------------------------------------------------------------------------
function vampire_delirium_lua:OnSpellStart()
	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()

	self.wave_speed = self:GetSpecialValueFor( "wave_speed" )
	self.wave_width = self:GetSpecialValueFor( "wave_width" )
	self.vision_aoe = self:GetSpecialValueFor( "vision_aoe" )
	self.vision_duration = self:GetSpecialValueFor( "vision_duration" )
	self.illusion_duration = self:GetSpecialValueFor( "illusion_duration" )
	self.wave_damage = self:GetSpecialValueFor( "wave_damage" )

	local info = {
		EffectName = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.wave_width,
		fEndRadius = self.wave_width,
		vVelocity = vDirection * self.wave_speed,
		fDistance = self:GetCastRange( self:GetCaster():GetOrigin(), self:GetCaster() ),
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = true,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		iVisionRadius = self.vision_aoe,
	}

	self.flVisionTimer = self.wave_width / self.wave_speed
	self.flLastThinkTime = GameRules:GetGameTime()
	self.nProjID = ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_Nightstalker.Void.Nihility" , self:GetCaster() )

	ParticleManager:DestroyParticle( self.effect_precast, true )
end

--------------------------------------------------------------------------------

function vampire_delirium_lua:OnProjectileThink( vLocation )
	self.flVisionTimer = self.flVisionTimer - ( GameRules:GetGameTime() - self.flLastThinkTime )

	if self.flVisionTimer <= 0.0 then
		local vVelocity = ProjectileManager:GetLinearProjectileVelocity( self.nProjID )
		AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation + vVelocity * ( self.wave_width / self.wave_speed ), self.vision_aoe, self.vision_duration, false )
		self.flVisionTimer = self.wave_width / self.wave_speed
	end
end


--------------------------------------------------------------------------------

function vampire_delirium_lua:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.wave_damage,
			damage_type = self:GetAbilityDamageType(),
			ability = this,
		}

		ApplyDamage( damage )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_vampire_delirium_debuff_lua", { duration = self.vision_duration } )
		
		local caster = self:GetCaster()
		
		--level 2 of spell
		if self:GetLevel() > 1 then
			local rndm = randomFloat(0, 100)
			if rndm <= self:GetSpecialValueFor( "illusion_chance") then
				local caster = self:GetCaster()
				local unit = caster:GetUnitName()
				local distance = self:GetSpecialValueFor( "illusion_spawn_distance")
				local origin = hTarget:GetAbsOrigin() + RandomVector(distance)
				local trees = GridNav:GetAllTreesAroundPoint(origin, 40, true)
				local counter = 0
				while (counter < 500) and ((not GridNav:IsTraversable(origin)) or #trees > 0) do
					origin = hTarget:GetAbsOrigin() + RandomVector(distance)
					trees = GridNav:GetAllTreesAroundPoint(origin, 40, true)
				end

				local duration = self:GetSpecialValueFor("illusion_duration")
				local outgoing_damage = self:GetSpecialValueFor( "illusion_outgoing_damage")
				local incoming_damage = self:GetSpecialValueFor( "illusion_incoming_damage")
				local speed = self:GetSpecialValueFor( "illusion_speed")

				----player
				local player = caster:GetPlayerOwnerID()

				--create illusion of vamp
				local illusion = CreateUnitByName(unit, origin, true, caster, nil, caster:GetTeamNumber())
				--illusion:SetPlayerID(caster:GetPlayerID())
				illusion:SetOwner(caster)
				illusion:SetControllableByPlayer(player, true)

				-- name label
				illusion:SetCustomHealthLabel( "Vampire", 200, 50, 50 )

				if GameRules:IsDaytime() then
					illusion:AddNewModifier(caster, self, "modifier_vampire_day", {})
				else
					illusion:AddNewModifier(caster, self, "modifier_vampire_night", {})
				end

				-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
				illusion:MakeIllusion()

				illusion:SetForwardVector(hTarget:GetAbsOrigin() - illusion:GetAbsOrigin())

				-- Set the unit as an illusion
				illusion:AddNewModifier(caster, self, "modifier_illusion", { duration = duration, outgoing_damage = outgoing_damage, incoming_damage = incoming_damage })
				
				-- Bonus as an illusion. Flying attack and 400 movespeed
				illusion:AddNewModifier(self:GetCaster(), self, "modifier_vampire_illusion_buff_lua", {duration = duration, speed = speed})

				-- first attack order
				Timers:CreateTimer(0.1,function()
					illusion:MoveToTargetToAttack(hTarget)
				end)
				
			end
		end
	end

	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------