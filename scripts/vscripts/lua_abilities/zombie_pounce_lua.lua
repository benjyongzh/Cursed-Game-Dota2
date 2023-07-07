zombie_pounce_lua = class({})
zombie_pounce_leap_lua = class({})

LinkLuaModifier( "modifier_zombie_pounce_lua_charging", "modifiers/modifier_zombie_pounce_lua_charging", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_pounce_lua_movement", "modifiers/modifier_zombie_pounce_lua_movement", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_zombie_pounce_lua_knockback", "modifiers/modifier_zombie_pounce_lua_knockback", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------------------

function zombie_pounce_lua:OnUpgrade()
    -- listen to panorama event
    --==================================== when player press button =======================================================================
    CustomGameEventManager:RegisterListener("zombie_pounce_button_pressed", Dynamic_Wrap(zombie_pounce_lua, "OnButtonPress"))
    --==================================== when player release button =======================================================================
    CustomGameEventManager:RegisterListener("zombie_pounce_button_released", Dynamic_Wrap(zombie_pounce_lua, "OnButtonRelease"))

    -- set javascript for button

    -- world panel
    if self.worldpanel == nil then
        self.worldpanel = WorldPanels:CreateWorldPanel(
            self:GetCaster():GetPlayerOwnerID(),
            {layout = "file://{resources}/layout/custom_game/worldpanels/zombie_pounce_charging.xml",
            entity = self:GetCaster():entindex(),
            entityHeight = 200,
        })
        -- event for initializing worldpanel ui
        CustomGameEventManager:Send_ServerToPlayer(self:GetCaster():GetPlayerOwner(), "zombie_pounce_initialize", {})
    end

    -- add leap abil
    local abil = self:GetCaster():FindAbilityByName("zombie_pounce_leap_lua")
    if not abil then
        self:GetCaster():AddAbility("zombie_pounce_leap_lua")
        abil = self:GetCaster():FindAbilityByName("zombie_pounce_leap_lua")
    end
    abil:SetLevel(self:GetLevel())
end

-- Ability Start
function zombie_pounce_lua:OnSpellStart()
    -- set cd to 0
    self:StartCooldown(0.5)
    zombie_pounce_lua.max_distance = self:GetSpecialValueFor("max_distance")

    -- add modifier for charging up. link it with worldpanel bar
    local modifier = self:GetCaster():FindModifierByName("modifier_zombie_pounce_lua_charging")
    if modifier then
        modifier:Destroy()
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zombie_pounce_lua_charging", {})

    -- event for worldpanel ui
    CustomGameEventManager:Send_ServerToPlayer(self:GetCaster():GetPlayerOwner(), "zombie_pounce_start_charging", {ent_index = self:GetCaster():entindex()})
end

function zombie_pounce_lua:OnButtonPress(args)
    local playerid = args.playerid
    local caster = EntIndexToHScript(args.ent_index)

    local abil = caster:FindAbilityByName("zombie_pounce_lua")
    if abil then
        caster:CastAbilityNoTarget(abil, playerid)
    end
end

function zombie_pounce_lua:OnButtonRelease(args)
    local playerid = args.playerid
    local caster = EntIndexToHScript(args.ent_index)

    local modifier = caster:FindModifierByName("modifier_zombie_pounce_lua_charging")
    local pct = 0
    if modifier then
        pct = modifier:GetStackCount()/100
        if pct > 1.0 then
            pct = 1
        end

        -- cast leap at specific distance based on charged time
        local direction = caster:GetForwardVector():Normalized()
        local distance = pct * zombie_pounce_lua.max_distance
        local targetpt = caster:GetAbsOrigin() + (distance * direction)
        local abil = caster:FindAbilityByName("zombie_pounce_leap_lua")
        caster:CastAbilityOnPosition(targetpt, abil, playerid)
        
        modifier:Destroy()
    end

    -- event for worldpanel ui
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "zombie_pounce_stop_charging", {ent_index = caster:entindex()})
end







function zombie_pounce_leap_lua:IsHiddenAbilityCastable()
    return true
end

function zombie_pounce_leap_lua:OnSpellStart()
    -- set pounce abil to cd 1.5
    local caster = self:GetCaster()
    local abil = caster:FindAbilityByName("zombie_pounce_lua")
    if abil then
        abil:StartCooldown(abil:GetCooldown(abil:GetLevel()))
    end

    local startpt = caster:GetAbsOrigin()
    local endpt = self:GetCursorPosition()
    
    local vector = Vector(endpt.x-startpt.x, endpt.y-startpt.y, endpt.z-startpt.z)
    vector = vector:Normalized()
    local distance = GetDistance(startpt, endpt)
    local pct = distance/self:GetSpecialValueFor("max_distance")

    -- addnewmodifier for leaping movement
    caster:AddNewModifier(caster, self, "modifier_zombie_pounce_lua_movement", {
        fraction = pct,
        distance = distance,
        direction_x = vector.x,
        direction_y = vector.y,
        direction_z = vector.z
    })
end