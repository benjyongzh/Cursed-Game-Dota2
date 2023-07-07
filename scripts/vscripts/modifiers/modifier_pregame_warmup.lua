modifier_pregame_warmup = class({})

function modifier_pregame_warmup:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_NIGHTMARED] = true,
    }

    return state
end

function modifier_pregame_warmup:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

function modifier_pregame_warmup:IsPurgable()
    return false
end

function modifier_pregame_warmup:IsHidden()
    return true
end

function modifier_pregame_warmup:GetEffectName()
    return "particles/generic_gameplay/generic_sleep.vpcf"
end

function modifier_pregame_warmup:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_pregame_warmup:GetOverrideAnimation()
    return ACT_DOTA_IDLE_SLEEPING
end

function modifier_pregame_warmup:OnDestroy()
    if IsServer() then
        local unit = self:GetParent()
        unit:StartGesture(ACT_DOTA_SLEEPING_END)
    end
end