modifier_endgame_pause = class({})

function modifier_endgame_pause:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

function modifier_endgame_pause:IsPurgable()
    return false
end

function modifier_endgame_pause:IsHidden()
    return true
end
