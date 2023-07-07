LinkLuaModifier("modifier_keystone_markedbycursed_lua", "modifiers/modifier_keystone_markedbycursed_lua", LUA_MODIFIER_MOTION_NONE)

function OnAbilityPhaseStart(event)
    local caster = event.caster
    local playerid = caster:GetPlayerOwnerID()
    local target = event.target
    local index = getIndexTable(_G.KEYSTONE_UNIT, target)
    local mytable = CustomNetTables:GetTableValue("keystone_status", tostring(index))
    if (mytable.keys >= _G.KEYS_TO_ACTIVATE_KEYSTONE[CountPlayersInGame()]) or (mytable.activated > 1) then
        SendErrorMessage(playerid, "Keystone already activated")
        return false
    end
    if _G.SPIRE_UNIT:HasModifier("modifier_endgame_portal_lua") then
        --endgame portal
        SendErrorMessage(playerid, "Escape Portal already opened!")
        PingLocationOnClient(_G.SPIRE_UNIT:GetAbsOrigin(), playerid)
        return false
    end
    return true
end

function OnSpellStart(event)
    -- unit identifier
    local caster = event.caster
    local playerid = caster:GetPlayerOwnerID()
    local target = event.target
    local index = getIndexTable(_G.KEYSTONE_UNIT, target)
    local mytable = CustomNetTables:GetTableValue("keystone_status", tostring(index))
    local current_keys = mytable.keys

    -- modifier add stack for anim
    local modifier = target:FindModifierByName("modifier_keystone_passive_lua_stacks")
    if modifier then
        modifier:IncrementStackCount()
        modifier:ForceRefresh()
    end

    if not target.activators then
        target.activators = {}
    end
    if not PlayerResource:IsValidPlayerID(playerid) then
        table.insert(target.activators, 0)
    else
        table.insert(target.activators, playerid)
    end

    -- add key to this keystone
    CustomNetTables:SetTableValue("keystone_status", tostring(index), {activated = false, keys = modifier:GetStackCount()})
    Game_Events:KeystoneUpdate(playerid, index, target.activators)

    -- add marking by cursed
    if playerid == _G.CURSED_UNIT:GetPlayerOwnerID() then
        target:AddNewModifier(target, nil, "modifier_keystone_markedbycursed_lua", {})
        print("markedby cursed activated")
    end

    -- sfx
    EmitSoundOn( "DOTA_Item.EtherealBlade.Activate", target)
    local particle = ParticleManager:CreateParticle("particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_reincarn_dust_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControl(particle,0,target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)

    if target.activator_fx == nil then
        target.activator_fx = {}
    end

    local effect = ParticleManager:CreateParticle("particles/econ/items/razor/razor_punctured_crest/razor_static_link_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(effect, 0, target, PATTACH_POINT_FOLLOW, "attach_attack1", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(effect, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    caster:EmitSound("Hero_ShadowShaman.Shackles")
    target.activator_fx[caster:entindex()] = effect

    -- recording target
    event.ability.target = target:entindex()
end

function OnChannelEnd(event)
    -- unit identifier
    --for k,v in pairs(event) do
    --    print(k,v)
    --end
    local caster = event.caster
    local playerid = caster:GetPlayerOwnerID()
    --local target = event.ability:GetCursorTarget()
    local target = EntIndexToHScript(event.ability.target)
    local index = getIndexTable(_G.KEYSTONE_UNIT, target)

    -- modifier add stack for anim
    local modifier = target:FindModifierByName("modifier_keystone_passive_lua_stacks")
    if modifier then
        modifier:DecrementStackCount()

        -- remove player id from list of keystone's activators
        local playerid_index = getIndexTable(target.activators, playerid)
        if playerid_index then
            table.remove(target.activators, playerid_index)
        end


        -- add key to this keystone
        CustomNetTables:SetTableValue("keystone_status", tostring(index), {activated = false, keys = modifier:GetStackCount()})
        Game_Events:KeystoneUpdate(playerid, index, target.activators)

        -- remove marking by cursed
        if playerid == _G.CURSED_UNIT:GetPlayerOwnerID() then
            if target:HasModifier("modifier_keystone_markedbycursed_lua") then
                target:FindModifierByName("modifier_keystone_markedbycursed_lua"):Destroy()
            end
        end
    end

    -- sfx
    if target.activator_fx[caster:entindex()] then
        ParticleManager:DestroyParticle(target.activator_fx[caster:entindex()], true)
    end
    caster:StopSound("Hero_ShadowShaman.Shackles")

    event.ability.target = nil
end


--[[
function OnAbilityPhaseStart(event)
    local caster = event.caster
    local playerid = caster:GetPlayerOwnerID()
    local target = event.target
    local index = getIndexTable(_G.KEYSTONE_UNIT, target)
    local mytable = CustomNetTables:GetTableValue("keystone_status", tostring(index))
    if (mytable.keys >= _G.KEYS_TO_ACTIVATE_KEYSTONE[CountPlayersInGame()]) or (mytable.activated > 1) then
        SendErrorMessage(playerid, "Keystone already activated")
        return false
    end
    if _G.SPIRE_UNIT:HasModifier("modifier_endgame_portal_lua") then
        --endgame portal
        SendErrorMessage(playerid, "Escape Portal already opened!")
        PingLocationOnClient(_G.SPIRE_UNIT:GetAbsOrigin(), playerid)
        return false
    end
    return true
end

function OnSpellStart(event)
    -- unit identifier
    local caster = event.caster
    local playerid = caster:GetPlayerOwnerID()
    local target = event.target
    local index = getIndexTable(_G.KEYSTONE_UNIT, target)
    local mytable = CustomNetTables:GetTableValue("keystone_status", tostring(index))
    local current_keys = mytable.keys

    -- add key to this keystone
    CustomNetTables:SetTableValue("keystone_status", tostring(index), {activated = false, keys = current_keys + 1})
    Game_Events:KeystoneUpdate(playerid, index)

    -- modifier add stack for anim
    local modifier = target:FindModifierByName("modifier_keystone_passive_lua_level4")
    if modifier then
        modifier:Destroy()
        target:AddNewModifier(nil, nil, "modifier_keystone_passive_lua_level5", {})
    end
    modifier = target:FindModifierByName("modifier_keystone_passive_lua_level2")
    if modifier then
        modifier:Destroy()
        target:AddNewModifier(nil, nil, "modifier_keystone_passive_lua_level4", {})
    end
    modifier = target:FindModifierByName("modifier_keystone_passive_lua_level1")
    if modifier then
        modifier:Destroy()
        target:AddNewModifier(nil, nil, "modifier_keystone_passive_lua_level2", {})
    end

    -- sfx
    EmitSoundOn( "ui.crafting_mech", target)
    EmitSoundOn( "DOTA_Item.EtherealBlade.Activate", target)
    local particle = ParticleManager:CreateParticle("particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_reincarn_dust_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControl(particle,0,target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)

    -- marking by cursed
    if playerid == _G.CURSED_UNIT:GetPlayerOwnerID() then
        target:AddNewModifier(nil, nil, "modifier_keystone_markedbycursed_lua", {})
    end
    
end
]]