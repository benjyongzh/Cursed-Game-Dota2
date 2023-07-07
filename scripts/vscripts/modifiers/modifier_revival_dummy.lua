modifier_revival_dummy = class({})

function modifier_revival_dummy:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,

        --[MODIFIER_STATE_NO_HEALTH_BAR] = true,

        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,

        --[MODIFIER_STATE_INVULNERABLE] = true,

        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,

        --[MODIFIER_STATE_BLIND] = true
    }

    return state
end

function modifier_revival_dummy:DestroyOnExpire()
    return true
end

function modifier_revival_dummy:IsHidden()
    return true
end

function modifier_revival_dummy:IsPurgable()
    return false
end

function modifier_revival_dummy:OnCreated()
    if IsServer() then
        local unit = self:GetParent()

        self.countdown = _G.HERO_REVIVE_TIME

        -- sfx
        self.fx = ParticleManager:CreateParticle( "particles/items_fx/aegis_lvl_1000_ambient_ti6_rays.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControlEnt(self.fx, 0, unit, PATTACH_ABSORIGIN_FOLLOW, nil, unit:GetAbsOrigin(), true)

        self:StartIntervalThink(0.1)
        self:OnIntervalThink()

        -- playernames for villager
        local teamID = unit:GetTeam()
        local color = ColorForTeam(teamID)
        local playername = PlayerResource:GetPlayerName(unit:GetPlayerOwnerID())
        unit:SetCustomHealthLabel( playername, color[1], color[2], color[3] )
    end
end

function modifier_revival_dummy:OnIntervalThink()
    if not self:GetParent():HasModifier("modifier_player_being_revived") then
        self.countdown = self.countdown - 0.1
        self:GetParent():SetHealth(100 * (self.countdown/_G.HERO_REVIVE_TIME))
    end

    if (self.countdown < 0.1) or (self:GetParent():GetHealth() < 1) then
        -- no longer can revive
        Game_Events:TurnTombstoneIntoGhost(self:GetParent(), self:GetParent():GetPlayerOwnerID())
        self:Destroy()
    end
end

function modifier_revival_dummy:OnDestroy()
    if IsServer() then
        --delete the damn summon
        if self.fx then
            ParticleManager:DestroyParticle( self.fx, true )
        end
        self:GetParent():ForceKill(false)
        UTIL_Remove(self:GetParent())
    end
end

function modifier_revival_dummy:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_revival_dummy:GetModifierConstantHealthRegen()
    return 0
end
