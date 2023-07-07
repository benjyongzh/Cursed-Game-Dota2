modifier_goldmine_passive_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_goldmine_passive_lua:IsHidden()
	return true
end

function modifier_goldmine_passive_lua:IsDebuff()
	return false
end

function modifier_goldmine_passive_lua:IsStunDebuff()
	return false
end

function modifier_goldmine_passive_lua:IsPurgable()
	return false
end

function modifier_goldmine_passive_lua:RemoveOnDeath()
	return true
end

function modifier_goldmine_passive_lua:CheckState()
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

--------------------------------------------------------------------------------
-- Initializations
function modifier_goldmine_passive_lua:OnCreated()
    if IsServer() then
        if TOOLS_MODE then
            AddFOWViewer(2, self:GetParent():GetAbsOrigin(), 300, 500, false)
        end
    end
end

function modifier_goldmine_passive_lua:OnRefresh()
end