vampire_ascend_lua = class({})
LinkLuaModifier( "modifier_vampire_flying_lua", "modifiers/modifier_vampire_flying_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function vampire_ascend_lua:OnAbilityPhaseStart()
	--animation
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 0.66)	
	local particle_precast = "particles/units/heroes/hero_night_stalker/nightstalker_void_bat_swarm.vpcf"
	self.effect_precast = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(self.effect_precast, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true)
    
	return true -- if success
end

function vampire_ascend_lua:OnAbilityPhaseInterrupted()
	--animation
	self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
	-- stop effects 
	ParticleManager:DestroyParticle( self.effect_precast, true )
end
--------------------------------------------------------------------------------

-- Ability Effect Start
function vampire_ascend_lua:OnSpellStart()
    local caster = self:GetCaster()
    local modifier = caster:FindModifierByName( "modifier_vampire_flying_lua" )
	if not modifier then
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_vampire_flying_lua", -- modifier name
			{} -- kv
		)
		caster:SwapAbilities("vampire_ascend_lua", "vampire_impact_lua", false, true)
		
		--sfx when cast finish
		ParticleManager:DestroyParticle( self.effect_precast, true )
	end
end

function vampire_ascend_lua:OnUpgrade()
	local caster = self:GetCaster()
	local abil = caster:FindAbilityByName("vampire_impact_lua")
	if abil then
		abil:SetLevel(self:GetLevel())
	end
end