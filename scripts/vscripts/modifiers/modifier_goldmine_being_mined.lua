modifier_goldmine_being_mined = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_goldmine_being_mined:IsHidden()
	return false
end

function modifier_goldmine_being_mined:IsDebuff()
	return false
end

function modifier_goldmine_being_mined:IsPurgable()
	return false
end

function modifier_goldmine_being_mined:DestroyOnExpire()
	return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_goldmine_being_mined:OnCreated( kv )
	if IsServer() then
        self:SetStackCount( 1 )
        -- sfx
        self.fx1 = ParticleManager:CreateParticle( "particles/econ/courier/courier_eye_glow_defense_01/courier_eye_glow_defense_01.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(self.fx1, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "eye_right", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.fx1, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "eye_right", self:GetParent():GetAbsOrigin(), true)
        
        self.fx2 = ParticleManager:CreateParticle( "particles/econ/courier/courier_eye_glow_defense_01/courier_eye_glow_defense_01.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(self.fx2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "eye_left", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.fx2, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "eye_left", self:GetParent():GetAbsOrigin(), true)

        self.fx3 = ParticleManager:CreateParticle( "particles/econ/items/slardar/slardar_ti10_head/slardar_ti10_gold_amp_damage_cloud.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(self.fx3, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)

        self.fx4 = ParticleManager:CreateParticle( "particles/econ/items/nightstalker/nightstalker_ti10_silence/nightstalker_ti10_gold_ring_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(self.fx4, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)

        self:GetParent():EmitSound("Hero_Lich.ChainFrostLoop")
	end
end

function modifier_goldmine_being_mined:OnRefresh( kv )
	if IsServer() then
	end
end

function modifier_goldmine_being_mined:OnDestroy( kv )
    if IsServer() then
        -- sfx
        if self.fx1 then
            ParticleManager:DestroyParticle(self.fx1, true)
        end
        if self.fx2 then
            ParticleManager:DestroyParticle(self.fx2, true)
        end
        if self.fx3 then
            ParticleManager:DestroyParticle(self.fx3, true)
        end
        if self.fx4 then
            ParticleManager:DestroyParticle(self.fx4, false)
            ParticleManager:ReleaseParticleIndex(self.fx4)

        end

        self:GetParent():StopSound("Hero_Lich.ChainFrostLoop")
	end
end