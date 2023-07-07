druid_shapeshift_from_bear_lua = class({})
LinkLuaModifier( "modifier_druid_shapeshift_bear_lua", "modifiers/modifier_druid_shapeshift_bear_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function druid_shapeshift_from_bear_lua:OnAbilityPhaseStart()
    
	-- play effects 
	local sound_cast = "Hero_LoneDruid.BattleCry"
	EmitSoundOn( sound_cast, self:GetCaster() )
	local particle_precast = "particles/world_outpost/world_outpost_channel.vpcf"
    self.effect_precast = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
    ParticleManager:SetParticleControlEnt(self.effect_precast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true)


	return true -- if success
end

function druid_shapeshift_from_bear_lua:OnAbilityPhaseInterrupted()
	-- stop effects 
	local sound_cast = "Hero_LoneDruid.BattleCry"
	StopSoundOn( sound_cast, self:GetCaster() )
    ParticleManager:DestroyParticle( self.effect_precast, true )
end

--------------------------------------------------------------------------------

-- Ability Start
function druid_shapeshift_from_bear_lua:OnSpellStart()
    local caster = self:GetCaster()
    local modifier = caster:FindModifierByName( "modifier_druid_shapeshift_bear_lua" )
    if modifier then        
        --real action
        modifier:Destroy()
    end
    ParticleManager:DestroyParticle( self.effect_precast, true )
end

function druid_shapeshift_from_bear_lua:ProcsMagicStick()
	return false
end