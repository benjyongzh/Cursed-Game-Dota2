modifier_dummy_unit = class({})

function modifier_dummy_unit:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_BLIND] = true
    }

    return state
end

function modifier_dummy_unit:DestroyOnExpire()
  return true
end

function modifier_dummy_unit:IsPurgable()
  return false
end

function modifier_dummy_unit:OnDestroy()
  if IsServer() then
          --delete the damn summon
    self:GetParent():ForceKill(false)
  end
end