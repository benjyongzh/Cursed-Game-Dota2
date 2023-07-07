ursa_enrage_lua = class({})
LinkLuaModifier( "modifier_ursa_enrage_lua", "modifiers/modifier_ursa_enrage_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_werewolf_howl_knockback_lua", "modifiers/modifier_werewolf_howl_knockback_lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_werewolf_howl_disarm_lua", "modifiers/modifier_werewolf_howl_disarm_lua", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------------------

function ursa_enrage_lua:GetAOERadius()
	if self:GetLevel() > 2 then
		return self:GetSpecialValueFor( "radius" )
	end
end

function ursa_enrage_lua:OnSpellStart()
	-- get references

	-- Purge
	self:GetCaster():Purge(false, true, false, true, false)

	-- Add buff modifier
	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_ursa_enrage_lua",
		{ duration = self:GetSpecialValueFor("duration") }
	)

	-- level 2 night time effect
	if self:GetLevel() > 1 then
		-- increase cd if day
		if GameRules:IsDaytime() then
			self:StartCooldown(self:GetSpecialValueFor("day_cd"))
		end

		-- start cursed night
		GameRules:BeginNightstalkerNight(self:GetSpecialValueFor("night_duration"))
	end

	-- level 3 disarm effect
	if self:GetLevel() > 2 then
		local caster = self:GetCaster()
		local centre = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius(
			caster:GetTeam(),
			centre,
			nil,
			self:GetSpecialValueFor("radius"),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		-- Make the found units move to (0, 0, 0)
		for _,unit in pairs(enemies) do
			if not IsBuildingOrSpire(unit) then
				if self:GetLevel() > 2 then
					unit:AddNewModifier(caster, self, "modifier_werewolf_howl_disarm_lua", {duration = self:GetSpecialValueFor("disarm_duration")})
				end
			end
		end

		-- sfx
		local particle = "particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest_gold_shockwave.vpcf"
		local effect = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControlEnt( effect, 0, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( effect )
		
		EmitSoundOn( "Hero_Winter_Wyvern.SplinterBlast.Cast", self:GetCaster() )
		
	end

	-- play effects
	self:PlayEffects()
end

function ursa_enrage_lua:PlayEffects()
	-- get resources
	local sound_cast = "Hero_Lycan.Howl"

	-- play sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end