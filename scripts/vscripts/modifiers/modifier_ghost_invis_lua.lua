modifier_ghost_invis_lua = class({})

-- link modifier movement
LinkLuaModifier( "modifier_ghost_invis_lua_movement", "modifiers/modifier_ghost_invis_lua_movement", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Classifications
function modifier_ghost_invis_lua:IsHidden()
	return false
end

function modifier_ghost_invis_lua:IsDebuff()
	return false
end

function modifier_ghost_invis_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ghost_invis_lua:OnCreated( kv )
    -- references
	self.delay = kv.delay
	self.attack_reveal = true
    self.ability_reveal = true

	self.hidden = false

    if IsServer() then
		-- sfx
		--EmitSoundOn( "Hero_Bane.Nightmare", self:GetParent() )
		EmitSoundOn( "Hero_Bane.Nightmare.End", self:GetParent() )
		self:GetParent():EmitSoundParams("Conquest.hallow_scream", 0, 3, 0)
		local particle_cast = "particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetOrigin())
		ParticleManager:ReleaseParticleIndex( effect_cast )

		-- Start interval
		self:StartIntervalThink( self.delay )

		-- add modifier movement
		local invis_speed = self:GetAbility():GetSpecialValueFor("invis_speed")
		local turnrate = self:GetAbility():GetSpecialValueFor("turn_rate_pct")
		self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_ghost_invis_lua_movement", {speed = invis_speed, turn_rate = turnrate})
	end
end

function modifier_ghost_invis_lua:OnRefresh( kv )
    -- references
	self.delay = self:GetAbility():GetSpecialValueFor("fade_time")
	self.attack_reveal = true
	self.ability_reveal = true

	self.hidden = false

    if IsServer() then
        -- sfx
		--EmitSoundOn( "Hero_Bane.Nightmare", self:GetParent() )
		EmitSoundOn( "Hero_Bane.Nightmare.End", self:GetParent() )
		self:GetParent():EmitSoundParams("Conquest.hallow_scream", 0, 3, 0)
		local particle_cast = "particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetOrigin())
		ParticleManager:ReleaseParticleIndex( effect_cast )
        
		-- Start interval
		self:StartIntervalThink( self.delay )

		-- refresh modifier movement
		local invis_speed = self:GetAbility():GetSpecialValueFor("invis_speed")
		local turnrate = self:GetAbility():GetSpecialValueFor("turn_rate_pct")
		self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_ghost_invis_lua_movement", {speed = invis_speed, turn_rate = turnrate})
	end
end

function modifier_ghost_invis_lua:OnDestroy( kv )
	if IsServer() then
		local ability = self:GetAbility()
		--start cooldown before next possible invis
		ability:StartCooldown(ability:GetSpecialValueFor("cooldown_after_vis"))
        -- sfx
        EmitSoundOn( "Hero_Bane.Nightmare.End", self:GetParent() )
		self:GetParent():EmitSoundParams("Conquest.hallow_scream", 0, 3, 0)
		--local particle_cast = "particles/units/heroes/hero_death_prophet/death_prophet_spawn_gasburst.vpcf"
		local particle_cast = "particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetOrigin())
		ParticleManager:ReleaseParticleIndex( effect_cast )

		-- remove modifier movement
		local modifier = self:GetParent():FindModifierByName("modifier_ghost_invis_lua_movement")
		if modifier then
			modifier:Destroy()
		end
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ghost_invis_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_ATTACK,
	}

	return funcs
end

function modifier_ghost_invis_lua:GetModifierInvisibilityLevel()
	return 0.5
end

--------------------------------------------------------------------------------

function modifier_ghost_invis_lua:OnAbilityExecuted( params )
	if IsServer() then
		if not self.ability_reveal then return end
        if params.unit~=self:GetParent() then return end
        if params.ability==self:GetAbility() then return end

		self:ForceRefresh()
	end
end

--------------------------------------------------------------------------------

function modifier_ghost_invis_lua:OnAttack( params )
	if IsServer() then
		if not self.attack_reveal then return end
		if params.attacker~=self:GetParent() then return end

		self:ForceRefresh()
	end
end

--------------------------------------------------------------------------------

-- Status Effects
function modifier_ghost_invis_lua:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = self.hidden,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true
	}

	return state
end

--------------------------------------------------------------------------------

-- Interval Effects
function modifier_ghost_invis_lua:OnIntervalThink()
	self.hidden = true
end