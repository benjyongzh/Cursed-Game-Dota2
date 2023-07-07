modifier_key_spawner_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_key_spawner_lua:IsHidden()
	return true
end

function modifier_key_spawner_lua:IsDebuff()
	return false
end

function modifier_key_spawner_lua:IsStunDebuff()
	return false
end

function modifier_key_spawner_lua:IsPurgable()
	return false
end

function modifier_key_spawner_lua:RemoveOnDeath()
	return true
end

function modifier_key_spawner_lua:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
    }
    return state
end

function modifier_key_spawner_lua:DeclareFunctions()
	return MODIFIER_PROPERTY_VISUAL_Z_DELTA
end

function modifier_key_spawner_lua:GetVisualZDelta()
	return 0
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_key_spawner_lua:OnCreated()
end

function modifier_key_spawner_lua:OnRefresh()
end

function modifier_key_spawner_lua:OnDestroy()
end