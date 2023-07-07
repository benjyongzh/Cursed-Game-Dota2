modifier_vampire_blood_bath_lua_thinker = class({})
LinkLuaModifier( "modifier_vampire_bloodrage_lua", "modifiers/modifier_vampire_bloodrage_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Classifications
function modifier_vampire_blood_bath_lua_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_vampire_blood_bath_lua_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		local delay = self:GetAbility():GetSpecialValueFor("delay")
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.duration = self:GetAbility():GetSpecialValueFor("duration")

		-- Start interval
		self:StartIntervalThink( delay )

		-- Create fow viewer
		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self.radius, delay, true)

		-- effects
		self:PlayEffects1()
	end
end

function modifier_vampire_blood_bath_lua_thinker:OnDestroy( kv )
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_vampire_blood_bath_lua_thinker:OnIntervalThink()
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- effects
		self:PlayEffects3( enemy )
	end

    local stack = #enemies
	local ability = self:GetCaster():FindAbilityByName("vampire_blood_bath_lua") 
	-- level 1 ability(within circle)
	if ability:GetLevel() == 1 then
		if stack >= 1 then
			local distance = GetDistance(self:GetCaster():GetAbsOrigin(), self:GetParent():GetAbsOrigin())
			if distance <= self.radius then
				self:GetCaster():AddNewModifier(
					self:GetCaster(), -- player source
					self:GetAbility(), -- ability source
					"modifier_vampire_bloodrage_lua", -- modifier name
					{ duration = self.duration, stack = stack }
				)
			end
			--[[
			local vampire = FindUnitsInRadius(
				self:GetCaster():GetTeamNumber(),	-- int, your team number
				self:GetParent():GetOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				0,	-- int, flag filter
				0,	-- int, order filter
				false	-- bool, can grow cache
			)

			if #vampire >= 1 then
				for _,friendly in pairs(vampire) do
					friendly:AddNewModifier(
						self:GetCaster(), -- player source
						self:GetAbility(), -- ability source
						"modifier_vampire_bloodrage_lua", -- modifier name
						{ duration = self.duration, stack = stack }
					)
				end
			end	
			]]
		end

	-- level 2 ability(outside and inside circle)
	elseif ability:GetLevel() > 1 then	
		if stack >= 1 then
			self:GetCaster():AddNewModifier(
				self:GetCaster(), -- player source
				self:GetAbility(), -- ability source
				"modifier_vampire_bloodrage_lua", -- modifier name
				{ duration = self.duration, stack = stack }
			)
			--[[
			local vampire = FindUnitsInRadius(
				self:GetCaster():GetTeamNumber(),	-- int, your team number
				self:GetParent():GetOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				0,	-- int, flag filter
				0,	-- int, order filter
				false	-- bool, can grow cache
			)
	
			if #vampire >= 1 then
				for _,friendly in pairs(vampire) do
					friendly:AddNewModifier(
						self:GetCaster(), -- player source
						self:GetAbility(), -- ability source
						"modifier_vampire_bloodrage_lua", -- modifier name
						{ duration = 10, stack = stack }
					)
				end
			end
			]]
			
		end
	end

	self:PlayEffects2()
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_vampire_blood_bath_lua_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring.vpcf"
	local sound_cast = "Hero_Bloodseeker.BloodRite"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	--assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_color"))(self,self.effect_cast)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_vampire_blood_bath_lua_thinker:PlayEffects2()
	-- Get Resources
	-- local sound_cast = 

	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Create Sound
	-- EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_vampire_blood_bath_lua_thinker:PlayEffects3( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf"
	local sound_cast = "hero_bloodseeker.bloodRite.silence"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	--assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_color"))(self,effect_cast)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end