tombstone_revive_lua = class({})
LinkLuaModifier( "modifier_player_being_revived", "modifiers/modifier_player_being_revived", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tombstone_revive_lua_stacks", "modifiers/modifier_tombstone_revive_lua_stacks", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function tombstone_revive_lua:GetIntrinsicModifierName()
	return "modifier_tombstone_revive_lua_stacks"
end

--[[
function tombstone_revive_lua:IsHiddenAbilityCastable()
    return true
end

function tombstone_revive_lua:OnAbilityPhaseStart()
    local playerid = self:GetCaster():GetPlayerOwnerID()
    local target = self:GetCursorTarget()
    local modifier = target:FindModifierByName("modifier_player_being_revived")
    if modifier then
        SendErrorMessage(playerid, "Already being revived")
        self:GetCaster():RemoveAbility(self:GetAbilityName())
        return false
    end

    local mytable = CustomNetTables:GetTableValue("player_hero", tostring(target:GetPlayerOwnerID()))
    if mytable.needrespawn > 0 then
        return true
    else
        return false
    end
end

function tombstone_revive_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    
    target:AddNewModifier(nil, self, "modifier_player_being_revived", {})

    -- Play effects
    --caster:EmitSound("Outpost.Channel")
    
end

function tombstone_revive_lua:OnChannelFinish( bInterrupted )
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local modifier = target:FindModifierByName("modifier_player_being_revived")

    --EndAnimation(caster)
    --caster:StopSound("Outpost.Channel")

    modifier:Destroy()
    self:GetCaster():RemoveAbility(self:GetAbilityName())

    -- cancel if fail
    if bInterrupted then
		return
    end
    
    -- if channel full
    local targetplayer = target:GetPlayerOwner()
    local targethero = targetplayer.Main_Unit
    if not targethero:IsAlive() then
        -- respawn
        targethero:RespawnUnit()
        local respawn_location = target:GetAbsOrigin()
        FindClearSpaceForUnit(targethero, respawn_location, true)

        -- remove tombstone
        target:ForceKill(false)
        
        -- update playerboard
        CustomGameEventManager:Send_ServerToAllClients("player_revived", {playerid = targethero:GetPlayerOwnerID()})
        
        -- sfx
        EmitSoundOn("Hero_Chen.TeleportIn", targethero)
        EmitSoundOn("Hero_Chen.HandOfGodHealHero", targethero)
        
        local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf", PATTACH_ABSORIGIN_FOLLOW, targethero)
        ParticleManager:SetParticleControlEnt(effect_cast, 1, targethero, PATTACH_ABSORIGIN_FOLLOW, nil, targethero:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(effect_cast)

        effect_cast = ParticleManager:CreateParticle( "particles/items_fx/aegis_resspawn_body.vpcf", PATTACH_ABSORIGIN_FOLLOW, targethero )
        ParticleManager:SetParticleControlEnt(effect_cast, 0, targethero, PATTACH_ABSORIGIN_FOLLOW, nil, targethero:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(effect_cast)
    else
        SendErrorMessage(caster:GetPlayerOwnerID(), "Hero already revived")
    end

    --EndAnimation(target)
end
]]

function tombstone_revive_lua:OnAbilityPhaseStart()
    local playerid = self:GetCaster():GetPlayerOwnerID()
    local target = self:GetCursorTarget()
    local modifier = target:FindModifierByName("modifier_player_being_revived")
    if modifier then
        SendErrorMessage(playerid, "Already being revived")
        self:GetCaster():RemoveAbility(self:GetAbilityName())
        return false
    end

    local mytable = CustomNetTables:GetTableValue("player_hero", tostring(target:GetPlayerOwnerID()))
    if mytable.needrespawn > 0 then
        target:AddNewModifier(nil, self, "modifier_player_being_revived", {})
        self.target = target
        return true
    else
        return false
    end
end

function tombstone_revive_lua:OnAbilityPhaseInterrupted()
    local modifier = self.target:FindModifierByName("modifier_player_being_revived")
    modifier:Destroy()
    self.target = nil
end

function tombstone_revive_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local modifier = target:FindModifierByName("modifier_player_being_revived")
    modifier:Destroy()

    local targetplayer = target:GetPlayerOwner()
    local targethero = targetplayer.Main_Unit
    if not targethero:IsAlive() then
        -- respawn
        targethero:RespawnUnit()
        local respawn_location = target:GetAbsOrigin()
        FindClearSpaceForUnit(targethero, respawn_location, true)

        -- remove tombstone
        target:ForceKill(false)
        
        -- update playerboard
        CustomGameEventManager:Send_ServerToAllClients("player_revived", {playerid = targethero:GetPlayerOwnerID()})
        
        -- sfx
        EmitSoundOn("Hero_Chen.TeleportIn", targethero)
        EmitSoundOn("Hero_Chen.HandOfGodHealHero", targethero)
        
        local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf", PATTACH_ABSORIGIN_FOLLOW, targethero)
        ParticleManager:SetParticleControlEnt(effect_cast, 1, targethero, PATTACH_ABSORIGIN_FOLLOW, nil, targethero:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(effect_cast)

        effect_cast = ParticleManager:CreateParticle( "particles/items_fx/aegis_resspawn_body.vpcf", PATTACH_ABSORIGIN_FOLLOW, targethero )
        ParticleManager:SetParticleControlEnt(effect_cast, 0, targethero, PATTACH_ABSORIGIN_FOLLOW, nil, targethero:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(effect_cast)
    else
        SendErrorMessage(caster:GetPlayerOwnerID(), "Hero already revived")
    end
    self.target = nil
end