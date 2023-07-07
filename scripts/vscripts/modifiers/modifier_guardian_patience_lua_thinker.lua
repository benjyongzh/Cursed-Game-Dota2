modifier_guardian_patience_lua_thinker = class({})
LinkLuaModifier( "modifier_guardian_patience_debuff_lua", "modifiers/modifier_guardian_patience_debuff_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Classifications
function modifier_guardian_patience_lua_thinker:IsHidden()
	return true
end

function modifier_guardian_patience_lua_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_guardian_patience_lua_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		--self.damage = self:GetAbility():GetOrbSpecialValueFor("damage","e")
		self.radius = self:GetAbility():GetSpecialValueFor("area_of_effect")
		self.duration = self:GetAbility():GetSpecialValueFor("duration")
		-- Play effects
		self:PlayEffects1()
	end
end

function modifier_guardian_patience_lua_thinker:OnDestroy( kv )
	if IsServer() then
		local all_units = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		
		for _,unit in pairs(all_units) do
			if not IsBuildingOrSpire(unit) then
				if unit:GetTeam() == self:GetCaster():GetTeam() then
					-- purge
					unit:Purge(false, true, false, true, false)
				else
					unit:AddNewModifier(
						self:GetParent(), -- player source
						self, -- ability source
						"modifier_guardian_patience_debuff_lua", -- modifier name
						{ duration = self.duration} -- kv
					)
				end
			end
		end

		-- Play effects
		self:PlayEffects2()

		-- remove thinker
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_guardian_patience_lua_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_oracle/oracle_fortune_cast_tgt_symbol.vpcf"
	local sound_cast = "Hero_Invoker.SunStrike.Charge"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_guardian_patience_lua_thinker:PlayEffects2()
	StopSoundOn("Hero_Invoker.SunStrike.Charge", self:GetParent())
	
	-- Get Resources
	local particle_cast = "particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/antimage_manavoid_ti_5_gold.vpcf"
	local sound_cast = "Hero_Antimage.ManaVoid"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end