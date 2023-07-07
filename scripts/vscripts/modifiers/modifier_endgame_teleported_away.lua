modifier_endgame_teleported_away = class({})

function modifier_endgame_teleported_away:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_BLIND] = true
    }

    return state
end

function modifier_endgame_teleported_away:OnCreated()
    if IsServer() then
        self:GetParent():SetModelScale(0.01)
    end
end