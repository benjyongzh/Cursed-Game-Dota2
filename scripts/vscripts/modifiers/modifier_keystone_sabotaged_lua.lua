modifier_keystone_sabotaged_lua = class({})

--------------------------------------------------------------------------------

function modifier_keystone_sabotaged_lua:IsDebuff()
	return true
end

function modifier_keystone_sabotaged_lua:IsHidden()
	return true
end

function modifier_keystone_sabotaged_lua:IsPurgable()
	return false
end

function modifier_keystone_sabotaged_lua:OnCreated()
    if IsServer() then
        --self.fx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        --ParticleManager:SetParticleControlEnt( self.fx1, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true )
        self.fx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_prj_core.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( self.fx1, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true )
        self.fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( self.fx2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true )
        self.fx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( self.fx3, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( self.fx3, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex(self.fx3)
        EmitSoundOn("Hero_Oracle.FalsePromise.Cast", self:GetParent())
        self:GetParent():EmitSound("Hero_Phoenix.SunRay.Loop")
    end
end


function modifier_keystone_sabotaged_lua:OnRefresh()
end


function modifier_keystone_sabotaged_lua:OnDestroy()
    if IsServer() then
        if self.fx1 then
            ParticleManager:DestroyParticle(self.fx1, true)
        end
        if self.fx2 then
            ParticleManager:DestroyParticle(self.fx2, true)
        end
        self:GetParent():StopSound("Hero_Phoenix.SunRay.Loop")
    end

end