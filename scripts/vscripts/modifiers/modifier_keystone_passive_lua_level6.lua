modifier_keystone_passive_lua_level6 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_keystone_passive_lua_level6:IsHidden()
	return true
end

function modifier_keystone_passive_lua_level6:IsDebuff()
	return false
end

function modifier_keystone_passive_lua_level6:IsStunDebuff()
	return false
end

function modifier_keystone_passive_lua_level6:IsPurgable()
	return false
end

function modifier_keystone_passive_lua_level6:RemoveOnDeath()
	return true
end

function modifier_keystone_passive_lua_level6:CheckState()
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

function modifier_keystone_passive_lua_level6:DeclareFunctions()
	return MODIFIER_PROPERTY_VISUAL_Z_DELTA
end

function modifier_keystone_passive_lua_level6:GetVisualZDelta()
    if IsServer() then
        return GetGroundPosition(self:GetParent():GetAbsOrigin(), nil).z
    end
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_keystone_passive_lua_level6:OnCreated()
    
    if IsServer() then
        local unit = self:GetParent()
        --[[
        self.fx = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/astral_step_portal_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControl(self.fx,1,unit:GetAbsOrigin() + Vector(0,0,250))
        ParticleManager:SetParticleControlForward(self.fx, 1, self:GetParent():GetForwardVector())
        ]]
        
        self.fx = ParticleManager:CreateParticle("particles/radiant_fx/good_barracks_ranged001_modeled_wavestopsmokey.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControlEnt( self.fx, 4, unit, PATTACH_ABSORIGIN_FOLLOW, nil, unit:GetOrigin(), true )
        
        self:StartIntervalThink(3)
        self:OnIntervalThink()
    end
end


function modifier_keystone_passive_lua_level6:OnIntervalThink()
    self:GetParent():StartGesture(ACT_DOTA_CAPTURE)
end

function modifier_keystone_passive_lua_level6:OnDestroy()
    if IsServer() then
      -- sfx
        self:GetParent():RemoveGesture(ACT_DOTA_CAPTURE)
        if self.fx then
            ParticleManager:DestroyParticle(self.fx, true)
        end
    end
end

function modifier_keystone_passive_lua_level6:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_keystone_passive_lua_level6:GetActivityTranslationModifiers()
    return "level6"
end