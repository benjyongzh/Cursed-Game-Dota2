modifier_player_death_global_penalty_dummy_lua = class({})

function modifier_player_death_global_penalty_dummy_lua:CheckState()
    local state = {
        --[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        --[MODIFIER_STATE_BLIND] = true
    }

    return state
end

--------------------------------------------------------------------------------

function modifier_player_death_global_penalty_dummy_lua:IsDebuff()
	return true
end

function modifier_player_death_global_penalty_dummy_lua:IsHidden()
	return false
end

function modifier_player_death_global_penalty_dummy_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_player_death_global_penalty_dummy_lua:IsAura()
    return true
end

function modifier_player_death_global_penalty_dummy_lua:GetModifierAura()
	return "modifier_player_death_global_penalty_lua"
end

function modifier_player_death_global_penalty_dummy_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_player_death_global_penalty_dummy_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_player_death_global_penalty_dummy_lua:GetAuraRadius()
    return FIND_UNITS_EVERYWHERE
end

function modifier_player_death_global_penalty_dummy_lua:GetAuraEntityReject( hEntity )
	if IsServer() then
		if IsBuildingOrSpire(hEntity) or IsDummyUnit(hEntity) or IsInCursedForm(hEntity) then
			return true
		else
			return false
		end
	end
end

--------------------------------------------------------------------------------

function modifier_player_death_global_penalty_dummy_lua:GetTexture()
	return "nevermore_dark_lord"
end