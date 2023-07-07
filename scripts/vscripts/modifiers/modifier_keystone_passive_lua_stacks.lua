modifier_keystone_passive_lua_stacks = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_keystone_passive_lua_stacks:IsHidden()
	return false
end

function modifier_keystone_passive_lua_stacks:IsDebuff()
	return false
end

function modifier_keystone_passive_lua_stacks:IsStunDebuff()
	return false
end

function modifier_keystone_passive_lua_stacks:IsPurgable()
	return false
end

function modifier_keystone_passive_lua_stacks:RemoveOnDeath()
	return true
end

function modifier_keystone_passive_lua_stacks:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
    }
    return state
end

--[[
function modifier_keystone_passive_lua_stacks:DeclareFunctions()
	return MODIFIER_PROPERTY_VISUAL_Z_DELTA
end

function modifier_keystone_passive_lua_stacks:GetVisualZDelta()
    if IsServer() then
        return GetGroundPosition(self:GetParent():GetAbsOrigin(), nil).z
    end
end
]]

--------------------------------------------------------------------------------
-- Initializations
function modifier_keystone_passive_lua_stacks:OnCreated()
    
    if IsServer() then
        local unit = self:GetParent()

        self:SetStackCount(0)
        
        self.fx = ParticleManager:CreateParticle("particles/radiant_fx/good_barracks_ranged001_modeled_wavestopsmokey.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControlEnt( self.fx, 4, unit, PATTACH_ABSORIGIN_FOLLOW, nil, unit:GetOrigin(), true )
        
        self:StartIntervalThink(3)
        self:OnIntervalThink()

        self:GetParent():EmitSound("Hero_DeathProphet.IdleLoop")
    end
end

function modifier_keystone_passive_lua_stacks:OnRefresh()
    if IsServer() then
        self:StartIntervalThink(3)
        self:OnIntervalThink()
    end
end

function modifier_keystone_passive_lua_stacks:OnIntervalThink()
    self:GetParent():StartGesture(ACT_DOTA_CAPTURE)
end

function modifier_keystone_passive_lua_stacks:OnDestroy()
    if IsServer() then
      -- sfx
        self:GetParent():StopSound("Hero_DeathProphet.IdleLoop")
  
        self:GetParent():RemoveGesture(ACT_DOTA_CAPTURE)
        if self.fx then
            ParticleManager:DestroyParticle(self.fx, true)
        end
    end
end

function modifier_keystone_passive_lua_stacks:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_keystone_passive_lua_stacks:GetActivityTranslationModifiers()
    return "level2"-- .. (self:GetStackCount() + 2)
end