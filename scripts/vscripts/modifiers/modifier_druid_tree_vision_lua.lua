modifier_druid_tree_vision_lua = class({})
--------------------------------------------------------------------------------

function modifier_druid_tree_vision_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_druid_tree_vision_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_druid_tree_vision_lua:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_druid_tree_vision_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
            
function modifier_druid_tree_vision_lua:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
        [MODIFIER_STATE_NO_TEAM_SELECT] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true
    }
    return state
end

function modifier_druid_tree_vision_lua:GetVisualZDelta()
	return 350
end

--------------------------------------------------------------------------------

function modifier_druid_tree_vision_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_druid_tree_vision_lua:OnCreated()
    if IsServer() then
        -- Create Particle
        local particle_cast = "particles/units/heroes/hero_wisp/wisp_guardian.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(
            effect_cast,
            0,
            self:GetParent(),
            PATTACH_CENTER_FOLLOW,
            "attach_hitloc",
            self:GetParent():GetOrigin(), -- unknown
            true -- unknown, true
        )
        self:AddParticle(
            effect_cast,
            false,
            false,
            -1,
            false,
            false
        )
        particle_cast = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta_start.vpcf"
        effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl(effect_cast, 1, self:GetParent():GetOrigin())
        ParticleManager:ReleaseParticleIndex(effect_cast)
    end
end

--------------------------------------------------------------------------------

function modifier_druid_tree_vision_lua:OnDestroy()
	if IsServer() then
        --sfx
        EmitSoundOn("Hero_Wisp.Spirits.Target", self:GetParent())
        local particle_cast = "particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end_sparks.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl(effect_cast, 1, self:GetParent():GetOrigin())
        ParticleManager:ReleaseParticleIndex(effect_cast)

        --delete the damn summon
		self:GetParent():ForceKill(false)
	end
end

--------------------------------------------------------------------------------

