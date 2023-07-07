modifier_guardian_resurrect_lua = class({})

function modifier_guardian_resurrect_lua:IsPurgable()
    return false
end

function modifier_guardian_resurrect_lua:IsHidden()
    return true
end

function modifier_guardian_resurrect_lua:OnCreated()
    if IsServer() then
        self.effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(self.effect, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    end
end

function modifier_guardian_resurrect_lua:OnDestroy()
    if IsServer() then
        if self.effect then
            ParticleManager:DestroyParticle( self.effect, true )
        end
    end
end

function modifier_guardian_resurrect_lua:GetEffectName()
    return "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf"
    --local particle_cast = "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf"
    --local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.target)
    --ParticleManager:SetParticleControlEnt(effect_cast, 1, self.target, PATTACH_ABSORIGIN_FOLLOW, nil, self.target:GetOrigin(), true)
    --ParticleManager:ReleaseParticleIndex(effect_cast)
end
