barbarian_charge_lua = class({})
LinkLuaModifier( "modifier_barbarian_charge_lua_movement", "modifiers/modifier_barbarian_charge_lua_movement", LUA_MODIFIER_MOTION_HORIZONTAL )
--------------------------------------------------------------------------------

function barbarian_charge_lua:GetCastPoint()
	local reduction = 0
	local abil = self:GetCaster():FindAbilityByName("barbarian_upgrade_2")
	if abil then
		if abil:GetLevel() > 0 then
			reduction = self:GetSpecialValueFor( "upgrade_cast_point" )
		end
	end

	return 1.2 - reduction
end

function barbarian_charge_lua:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local particle = "particles/econ/items/monkey_king/arcana/fire/mk_arcana_fire_spring_channel_rings.vpcf"
	local effect = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, caster )
	--ParticleManager:SetParticleControlEnt( effect, 0, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( effect )
	
	effect = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/arcana/base/monkey_king_arcana_spring_cast_streaks.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:ReleaseParticleIndex( effect )

	StartAnimation(caster, {duration = self:GetCastPoint(), activity=ACT_DOTA_CAST_ABILITY_4, rate=0.75})
	
	self.sfx_counter = 0
	self.abil_casting = true
	self:SetContextThink( "OnThinkSFX", Dynamic_Wrap(self, "OnThinkSFX"), 0.1 )
	return true
end

function barbarian_charge_lua:OnThinkSFX()
	if self.sfx_counter <= 10 and self.abil_casting then
		local caster = self:GetCaster()
		local particle = "particles/econ/items/monkey_king/arcana/fire/mk_arcana_fire_spring_channel_rings.vpcf"
		local effect = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:ReleaseParticleIndex( effect )
		self.sfx_counter = self.sfx_counter + 1
		return 0.1
	end
end

function barbarian_charge_lua:OnAbilityPhaseInterrupted()
	self.abil_casting = false
	EndAnimation(self:GetCaster())
end

-- Ability Start
function barbarian_charge_lua:OnSpellStart()
	
	-- unit identifier
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()

	-- stuff for point target abil
	local startpt = caster:GetAbsOrigin()
	local point = self:GetCursorPosition()
	local vector = Vector(point.x-startpt.x, point.y-startpt.y, point.z-startpt.z)
	local distance_from_source = math.sqrt(vector.x * vector.x + vector.y * vector.y)
	if distance_from_source > self:GetSpecialValueFor("leap_distance") then
		distance_from_source = self:GetSpecialValueFor("leap_distance")
	end
	vector = vector:Normalized()

    --this is the modifier for the leaping movement. dont touch.
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_barbarian_charge_lua_movement", -- modifier name
		{duration = 3 , distance = distance_from_source, direction_x = vector.x, direction_y = vector.y, direction_z = vector.z } -- kv
	)

	-- effects
	local sound_cast = "Hero_Beastmaster.Primal_Roar.ti7"
	EmitSoundOn( sound_cast, caster )

	StartAnimation(caster, {duration = 2, activity=ACT_DOTA_RUN, rate=2.8, translate="haste"})
end