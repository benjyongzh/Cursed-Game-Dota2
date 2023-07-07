modifier_keystone_activation_delay_lua = class({})

LinkLuaModifier("modifier_keystone_passive_lua_level6", "modifiers/modifier_keystone_passive_lua_level6", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Classifications
function modifier_keystone_activation_delay_lua:IsHidden()
	return true
end

function modifier_keystone_activation_delay_lua:IsDebuff()
	return false
end

function modifier_keystone_activation_delay_lua:IsStunDebuff()
	return false
end

function modifier_keystone_activation_delay_lua:IsPurgable()
	return false
end

function modifier_keystone_activation_delay_lua:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_keystone_activation_delay_lua:OnCreated()
    if IsServer() then
        -- sfx
        if IsServer() then
            local unit = self:GetParent()
            local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
            ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(particle, 3, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
            ParticleManager:ReleaseParticleIndex(particle)

            --self.fx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_all_electric.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
            --ParticleManager:SetParticleControlEnt(self.fx1, 3, unit, PATTACH_POINT_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)

            self.fx1 = ParticleManager:CreateParticle("particles/econ/items/tinker/boots_of_travel/teleport_end_bots.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
            ParticleManager:SetParticleControlEnt(self.fx1, 0, unit, PATTACH_ABSORIGIN_FOLLOW, nil, unit:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(self.fx1, 1, unit, PATTACH_ABSORIGIN_FOLLOW, nil, unit:GetAbsOrigin(), true)


            --self:GetParent():EmitSound("Hero_StormSpirit.BallLightning.Loop")
            self:GetParent():EmitSound("Portal.Loop_Appear")
            
        end
    end
end

function modifier_keystone_activation_delay_lua:OnRefresh()
end

function modifier_keystone_activation_delay_lua:OnDestroy()
    -- update javascript and pano for all
    if IsServer() then
        -- sfx
        --self:GetParent():StopSound("Hero_StormSpirit.BallLightning.Loop")
        self:GetParent():StopSound("Portal.Loop_Appear")
        EmitSoundOn("Hero_AbyssalUnderlord.DarkRift.Complete", self:GetParent())
        if self.fx1 then
            ParticleManager:DestroyParticle(self.fx1, true)
        end

        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_death_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(particle)

        local modifier = self:GetParent():FindModifierByName("modifier_keystone_passive_lua_level2")
        if modifier then
            modifier:Destroy()
        end
        modifier = self:GetParent():FindModifierByName("modifier_keystone_passive_lua_level4")
        if modifier then
            modifier:Destroy()
        end
        modifier = self:GetParent():FindModifierByName("modifier_keystone_passive_lua_level5")
        if modifier then
            modifier:Destroy()
        end

        self:GetParent():AddNewModifier(nil, nil, "modifier_keystone_passive_lua_level6", {})

        Game_Events:KeystoneActivated(self:GetParent())

    end
end

function modifier_keystone_activation_delay_lua:GetEffectName()
    return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner_status.vpcf"
end

function modifier_keystone_activation_delay_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
	--return PATTACH_OVERHEAD_FOLLOW
end