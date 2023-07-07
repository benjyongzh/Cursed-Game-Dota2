modifier_player_being_revived = class({})

function modifier_player_being_revived:DestroyOnExpire()
    return true
end

function modifier_player_being_revived:IsHidden()
    return true
end

function modifier_player_being_revived:IsPurgable()
    return false
end

function modifier_player_being_revived:OnCreated()
    if IsServer() then
        -- sfx
        local effect_precast = ParticleManager:CreateParticle( "particles/econ/events/ti6/hero_levelup_ti6_flash_hit_aegis.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(effect_precast, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(effect_precast)

        self.fx = ParticleManager:CreateParticle( "particles/econ/items/wisp/wisp_relocate_marker_ti7_sparkle.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(self.fx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)

        self:GetParent():EmitSound("Hero_Wisp.ReturnCounter")
        self:StartIntervalThink(1)
    end
end

function modifier_player_being_revived:OnIntervalThink()
    -- sfx
    local effect_precast = ParticleManager:CreateParticle( "particles/items_fx/aegis_timer_e.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt(effect_precast, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(effect_precast)
end

function modifier_player_being_revived:OnDestroy()
    if IsServer() then
        self:StartIntervalThink(-1)
        -- sfx
        self:GetParent():StopSound("Hero_Wisp.ReturnCounter")
        if self.fx then
            ParticleManager:DestroyParticle(self.fx, true)
        end
    end
end