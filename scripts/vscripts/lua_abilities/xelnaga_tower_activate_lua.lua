xelnaga_tower_activate_lua = class({})
LinkLuaModifier( "modifier_xelnaga_tower_being_activated_lua_stacks", "modifiers/modifier_xelnaga_tower_being_activated_lua_stacks", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_xelnaga_tower_activated_vision_lua", "modifiers/modifier_xelnaga_tower_activated_vision_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function xelnaga_tower_activate_lua:OnUpgrade()
    self.time = 120
    self.table = {}
    self.table[1] = 120
    self.table[2] = 20
    self.table[3] = 12
end

function xelnaga_tower_activate_lua:IsHiddenAbilityCastable()
    return true
end

function xelnaga_tower_activate_lua:GetChannelTime()
    return self.time
end

function xelnaga_tower_activate_lua:OnAbilityPhaseStart()
    local playerid = self:GetCaster():GetPlayerOwnerID()
    local target = self:GetCursorTarget()
    local modifier = target:FindModifierByName("modifier_xelnaga_tower_activated_vision_lua")
    if modifier then
        SendErrorMessage(playerid, "Outpost Tower already activated")
        return false
    end
    return true
end

function xelnaga_tower_activate_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    
    local modifier = target:FindModifierByName("modifier_xelnaga_tower_being_activated_lua_stacks")
    if not modifier then
        target:AddNewModifier(target, self, "modifier_xelnaga_tower_being_activated_lua_stacks", {})
        modifier = target:FindModifierByName("modifier_xelnaga_tower_being_activated_lua_stacks")
    else
        modifier:IncrementStackCount()
    end

    StartAnimation(target, {duration = self.table[1], activity=ACT_DOTA_CHANNEL_ABILITY_1, rate=modifier:GetStackCount()})

    -- Play effects
    caster:EmitSound("Outpost.Channel")

    -- record target
    self.target = target
    
end

function xelnaga_tower_activate_lua:OnChannelFinish( bInterrupted )
	local caster = self:GetCaster()
    local target = self.target
    local modifier = target:FindModifierByName("modifier_xelnaga_tower_being_activated_lua_stacks")

    --EndAnimation(caster)
    caster:StopSound("Outpost.Channel")

    if not modifier then
        -- remove this ability
        --caster:RemoveAbility(self:GetAbilityName())
        self.target = nil
        return
    end

    modifier:DecrementStackCount()

    -- cancel if fail
    if bInterrupted then
        if modifier:GetStackCount() < 1 then
            modifier:Destroy()
            EndAnimation(target)
        else
            StartAnimation(target, {duration = self.table[1], activity=ACT_DOTA_CHANNEL_ABILITY_1, rate=modifier:GetStackCount()})
        end
		return
    end

    -- remove this ability
    --caster:RemoveAbility(self:GetAbilityName())
    self.target = nil
end

function xelnaga_tower_activate_lua:OnChannelThink()
    local target = self:GetCursorTarget()
    local modifier = target:FindModifierByName("modifier_xelnaga_tower_being_activated_lua_stacks")
    if modifier then
        self.time = self.table[1]
    else
        self:GetCaster():Stop()
    end
    self:GetChannelTime()
end
