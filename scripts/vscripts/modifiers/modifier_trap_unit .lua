modifier_trap_unit = class({})

function modifier_trap_unit:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = false,
        [MODIFIER_STATE_NO_HEALTH_BAR] = false,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = false,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_BLIND] = true
    }

    return state
end

function modifier_trap_unit:DestroyOnExpire()
    return true
  end
  function modifier_trap_unit:IsPurgable()
    return false
  end
  function modifier_trap_unit:OnDestroy()
    if IsServer() then
            --delete the damn summon
        self:GetParent():ForceKill(false)
    end
end