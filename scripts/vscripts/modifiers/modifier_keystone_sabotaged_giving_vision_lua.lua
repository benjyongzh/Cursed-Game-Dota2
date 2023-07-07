modifier_keystone_sabotaged_giving_vision_lua = class({})

--------------------------------------------------------------------------------

function modifier_keystone_sabotaged_giving_vision_lua:IsDebuff()
	return true
end

function modifier_keystone_sabotaged_giving_vision_lua:IsHidden()
	return true
end

function modifier_keystone_sabotaged_giving_vision_lua:IsPurgable()
	return false
end

function modifier_keystone_sabotaged_giving_vision_lua:OnCreated()
    if IsServer() then
        self:GetParent():EmitSound("Hero_Pugna.LifeDrain.Loop")
        EmitSoundOn("Hero_Phoenix.SuperNova.Death", self:GetParent())
        EmitSoundOn("Hero_Phoenix.SunRay.Stop", self:GetParent())
        self.fx = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_give.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(self.fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.fx, 1, SPIRE_UNIT, PATTACH_POINT_FOLLOW, "attach_hitloc", SPIRE_UNIT:GetAbsOrigin(), true)

        self:StartIntervalThink(0.2)
    end
end


function modifier_keystone_sabotaged_giving_vision_lua:OnRefresh()
end


function modifier_keystone_sabotaged_giving_vision_lua:OnDestroy()
    if IsServer() then
        if self.fx then
            ParticleManager:DestroyParticle(self.fx, true)
        end
        self:GetParent():StopSound("Hero_Pugna.LifeDrain.Loop")
    end
end

function modifier_keystone_sabotaged_giving_vision_lua:OnIntervalThink()
    -- check keystones
    local keystones_activated_bad = 0
    for i=1, #_G.KEYSTONE_UNIT do
        local keystone = _G.KEYSTONE_UNIT[i]
        local modifier1 = keystone:FindModifierByName("modifier_keystone_sabotaged_lua")
        if modifier1 then
            keystones_activated_bad = keystones_activated_bad + 1
        end
    end
    if keystones_activated_bad < _G.KEYSTONES_TO_CURSED_WIN then
        -- not enough bad keystones (will be impt when alien is in game. who can disable keystones)
        self:Destroy()
    end
end