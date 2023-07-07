druid_shapeshift_to_bear_lua = class({})
LinkLuaModifier( "modifier_druid_shapeshift_bear_lua", "modifiers/modifier_druid_shapeshift_bear_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function druid_shapeshift_to_bear_lua:GetManaCost(level)
    local mp = 70
	local abil = self:GetCaster():FindAbilityByName("druid_upgrade_2")
	if abil then
		if abil:GetLevel() > 0 then
			mp = 0
		end
	end

	return mp
end

function druid_shapeshift_to_bear_lua:OnAbilityPhaseStart()
	--animation
	--self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_SPAWN, 0.66)

	-- play effects 
	local sound_cast = "Hero_LoneDruid.TrueForm.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
	
	--local particle_precast = "particles/econ/events/fall_major_2016/teleport_start_fm06_leaves_b.vpcf"
	local particle_precast = "particles/econ/items/wisp/wisp_relocate_channel_ti7.vpcf"
	self.effect_precast = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(self.effect_precast, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true)

	return true -- if success
end

function druid_shapeshift_to_bear_lua:OnAbilityPhaseInterrupted()
	--animation
	--self:GetCaster():RemoveGesture(ACT_DOTA_SPAWN)
	-- stop effects 
	local sound_cast = "Hero_LoneDruid.TrueForm.Cast"
	StopSoundOn( sound_cast, self:GetCaster() )
	ParticleManager:DestroyParticle( self.effect_precast, true )
end

--------------------------------------------------------------------------------

-- Ability Effect Start
function druid_shapeshift_to_bear_lua:OnSpellStart()
    local caster = self:GetCaster()
    local modifier = caster:FindModifierByName( "modifier_druid_shapeshift_bear_lua" )
	if not modifier then
		--real action
		caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_druid_shapeshift_bear_lua", -- modifier name
			{} -- kv
		)
	end
	ParticleManager:DestroyParticle( self.effect_precast, true )
end

function druid_shapeshift_to_bear_lua:ProcsMagicStick()
	return false
end