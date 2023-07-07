modifier_guardian_resurrect_ghost_lua = class({})

function modifier_guardian_resurrect_ghost_lua:IsPurgable()
    return false
end

function modifier_guardian_resurrect_ghost_lua:IsHidden()
    return true
end

function modifier_guardian_resurrect_ghost_lua:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

function modifier_guardian_resurrect_ghost_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_guardian_resurrect_ghost_lua:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

function modifier_guardian_resurrect_ghost_lua:OnCreated()
end

function modifier_guardian_resurrect_ghost_lua:OnDestroy()
end
