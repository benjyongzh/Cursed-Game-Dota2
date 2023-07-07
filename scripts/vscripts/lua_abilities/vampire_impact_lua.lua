vampire_impact_lua = class({})
LinkLuaModifier( "modifier_vampire_impact_lua_movement", "modifiers/modifier_vampire_impact_lua_movement", LUA_MODIFIER_MOTION_BOTH )
--------------------------------------------------------------------------------

function vampire_impact_lua:GetBehavior()
	if self:GetLevel() > 1 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end
	return self.BaseClass.GetBehavior( self )
end

function vampire_impact_lua:GetAOERadius()
	if self:GetLevel() > 2 then
		return self:GetSpecialValueFor( "impact_radius" )
	end
end

function vampire_impact_lua:GetCastRange( point, target )
	local caster = self:GetCaster()
	if self:GetLevel() > 2 then
		return self:GetSpecialValueFor( "leap_distance" )
	end

	return self.BaseClass.GetCastRange( self )
end

function vampire_impact_lua:GetCastPoint()
	if not IsServer() then
		if self:GetLevel() > 2 then
			return self:GetSpecialValueFor( "l2_cast" )
		end
		return self.BaseClass.GetCastPoint( self )
	end

	local caster = self:GetCaster()

	if self:GetLevel() > 2 then
		return self:GetSpecialValueFor( "l2_cast" )
	end

	return self.BaseClass.GetCastPoint( self )
end
----------------------------------------------------------------------------------

function vampire_impact_lua:OnAbilityPhaseStart()

	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3_END, (24/30)/self:GetCastPoint())
    
	--play effects 
	EmitSoundOn( "n_creep_Wings.Heavy", self:GetCaster() )
	--local particle_precast = "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_swarm.vpcf"
    --self.effect_precast = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    --ParticleManager:SetParticleControlEnt(self.effect_precast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true)

    if self:GetLevel() > 2 then
        local modifier = self:GetCaster():FindModifierByName( "modifier_vampire_flying_lua" )
        if modifier then
            modifier:Destroy()
        end
    end

	return true -- if success
end

function vampire_impact_lua:OnAbilityPhaseInterrupted()
	-- stop effects 
	self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_3_END)
	StopSoundOn( "n_creep_Wings.Heavy", self:GetCaster() )
    --ParticleManager:DestroyParticle( self.effect_precast, true )
end

--------------------------------------------------------------------------------

-- Ability Start
function vampire_impact_lua:OnSpellStart()
    local caster = self:GetCaster()

    --sfx before transform
    local particle_precast = "particles/econ/courier/courier_hermit_crab/hermit_crab_skady_ambient_end_flakes.vpcf"
    local effect = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt(effect, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true)
    ParticleManager:ReleaseParticleIndex( effect )

    --sfx after transform
	caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_3_END)
    EmitSoundOn("n_creep_Wings.Heavy", caster )
    --ParticleManager:DestroyParticle( self.effect_precast, true )

	local modifier = caster:FindModifierByName( "modifier_vampire_flying_lua" )
	if modifier then
		modifier:Destroy()
	end    
	
    if self:GetLevel() > 2 then
        --fly
		local startpt = caster:GetAbsOrigin()
		local point = self:GetCursorPosition()
		local vector = Vector(point.x-startpt.x, point.y-startpt.y, point.z-startpt.z)
		local distance_from_source = math.sqrt(vector.x * vector.x + vector.y * vector.y)
		if distance_from_source > self:GetSpecialValueFor("leap_distance") then
			distance_from_source = self:GetSpecialValueFor("leap_distance")
		end
		vector = vector:Normalized()
        caster:AddNewModifier(
            caster, -- player source
            self, -- ability source
            "modifier_vampire_impact_lua_movement", -- modifier name
            {distance = distance_from_source, direction_x = vector.x, direction_y = vector.y, direction_z = vector.z } -- kv
        )
	end
	
	caster:SwapAbilities("vampire_impact_lua", "vampire_ascend_lua", false, true)
	-- start cooldown for ascend
	local fly_abil = caster:FindAbilityByName("vampire_ascend_lua")
	fly_abil:StartCooldown(fly_abil:GetCooldown(fly_abil:GetLevel()))
end

function vampire_impact_lua:ProcsMagicStick()
	return false
end