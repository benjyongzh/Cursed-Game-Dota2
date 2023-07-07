if hero_class_selection == nil then
    hero_class_selection = class({})
end

function hero_class_selection:Init()
--=========================== global booleans for hero_selection ================================

    --number of heroes in game--
    --_G.NUM_HEROES_IN_GAME = 0
end

-------------------------------- spawning a hero ------------------------------------------
function hero_chosen(event)
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetAbilityName()
    local hPlayer = caster:GetPlayerOwner()
    local player_ID = caster:GetPlayerOwnerID()
    local team_number = PlayerResource:GetTeam(player_ID)
    local hero_name = nil
    local hero_CNT_name = nil
    --finding farmer_unit
    local farmer_unit = GetFarmer(player_ID)

    -------------------------- different classes and disabling choice of existing heroes ------------------------------------------
    --defender
    if ability_name == "choose_defender_class_lua" then
        if CustomNetTables:GetTableValue("heroes_chosen_in_game", "defender") == nil then
            hero_name = "npc_dota_hero_dragon_knight"
            CustomNetTables:SetTableValue("heroes_chosen_in_game", "defender", {value = true})
            hero_CNT_name = "defender"
        else
            SendErrorMessage(player_ID, "Defender already chosen")
            return false
        end
    --scout
    elseif ability_name == "choose_scout_class_lua" then
        if CustomNetTables:GetTableValue("heroes_chosen_in_game", "scout") == nil then
            hero_name = "npc_dota_hero_bounty_hunter"
            CustomNetTables:SetTableValue("heroes_chosen_in_game", "scout", {value = true})
            hero_CNT_name = "scout"
        else
            SendErrorMessage(player_ID, "Scout already chosen")
            return false
        end
    --barbarian
    elseif ability_name == "choose_barbarian_class_lua" then
        if CustomNetTables:GetTableValue("heroes_chosen_in_game", "barbarian") == nil then
            hero_name = "npc_dota_hero_beastmaster"
            CustomNetTables:SetTableValue("heroes_chosen_in_game", "barbarian", {value = true})
            hero_CNT_name = "barbarian"
        else
            SendErrorMessage(player_ID, "Barbarian already chosen")
            return false
        end
    --ranger
    elseif ability_name == "choose_ranger_class_lua" then
        if CustomNetTables:GetTableValue("heroes_chosen_in_game", "ranger") == nil then
            hero_name = "npc_dota_hero_windrunner"
            CustomNetTables:SetTableValue("heroes_chosen_in_game", "ranger", {value = true})
            hero_CNT_name = "ranger"
        else
            SendErrorMessage(player_ID, "Ranger already chosen")
            return false
        end
    --illusionist
    elseif ability_name == "choose_illusionist_class_lua" then
        if CustomNetTables:GetTableValue("heroes_chosen_in_game", "illusionist") == nil then
            hero_name = "npc_dota_hero_rubick"
            CustomNetTables:SetTableValue("heroes_chosen_in_game", "illusionist", {value = true})
            hero_CNT_name = "illusionist"
        else
            SendErrorMessage(player_ID, "Illusionist already chosen")
            return false
        end
    --guardian
    elseif ability_name == "choose_guardian_class_lua" then
        if CustomNetTables:GetTableValue("heroes_chosen_in_game", "guardian") == nil then
            hero_name = "npc_dota_hero_skywrath_mage"
            CustomNetTables:SetTableValue("heroes_chosen_in_game", "guardian", {value = true})
            hero_CNT_name = "guardian"
        else
            SendErrorMessage(player_ID, "guardian already chosen")
            return false
        end
    --boomer
    elseif ability_name == "choose_boomer_class_lua" then
        if CustomNetTables:GetTableValue("heroes_chosen_in_game", "boomer") == nil then
            hero_name = "npc_dota_hero_snapfire"
            CustomNetTables:SetTableValue("heroes_chosen_in_game", "boomer", {value = true})
            hero_CNT_name = "boomer"
        else
            SendErrorMessage(player_ID, "boomer already chosen")
            return false
        end
    --samurai
    elseif ability_name == "choose_samurai_class_lua" then
        if CustomNetTables:GetTableValue("heroes_chosen_in_game", "samurai") == nil then
            hero_name = "npc_dota_hero_juggernaut"
            CustomNetTables:SetTableValue("heroes_chosen_in_game", "samurai", {value = true})
            hero_CNT_name = "samurai"
        else
            SendErrorMessage(player_ID, "Samurai already chosen")
            return false
        end
    --druid
    elseif ability_name == "choose_druid_class_lua" then
        if CustomNetTables:GetTableValue("heroes_chosen_in_game", "druid") == nil then
            hero_name = "npc_dota_hero_lone_druid"
            CustomNetTables:SetTableValue("heroes_chosen_in_game", "druid", {value = true})
            hero_CNT_name = "druid"
        else
            SendErrorMessage(player_ID, "Druid already chosen")
            return false
        end
    --assassin
    elseif ability_name == "choose_assassin_class_lua" then
        if CustomNetTables:GetTableValue("heroes_chosen_in_game", "assassin") == nil then
            hero_name = "npc_dota_hero_templar_assassin"
            CustomNetTables:SetTableValue("heroes_chosen_in_game", "assassin", {value = true})
            hero_CNT_name = "assassin"
        else
            SendErrorMessage(player_ID, "Assassin already chosen")
            return false
        end
    --timebender
    --[[
    elseif ability_name == "choose_timebender_class_lua" then
        if CustomNetTables:GetTableValue("heroes_chosen_in_game", "timebender") == nil then
            hero_name = "npc_dota_hero_arc_warden"
            CustomNetTables:SetTableValue("heroes_chosen_in_game", "timebender", {value = true})
            hero_CNT_name = "timebender"
        else
            SendErrorMessage(player_ID, "Timebender already chosen")
            return false
        end
    ]]
    end
    

    ---------------------------action to take--------------------------------------------
    --spawn respective hero
    local hero = CreateUnitByName(hero_name, caster:GetAbsOrigin()+(caster:GetForwardVector():Normalized()*100), true, farmer_unit, hPlayer, caster:GetTeamNumber())
    hero:SetOwner(farmer_unit)
    hero:SetControllableByPlayer(player_ID, true)
    PlayerResource:NewSelection(player_ID, hero)
    hPlayer.class_hero = hero
    hPlayer:SetAssignedHeroEntity(hero)
    hero:Hold()
    -- CNT to ensure this player can never create a barrack with the hero selections for the rest of the game
    CustomNetTables:SetTableValue("player_hero", tostring(player_ID), {chosen = true, hero = hero_CNT_name, needrespawn = false})

    -- add hero into table of units
    table.insert(hPlayer.Units, hero)
    
    --sfx
    EmitSoundOn("HeroPicker.Selected",hero)
    local particle_cast = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_cast_lightning.vpcf"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, hero )
    ParticleManager:SetParticleControlEnt(effect_cast, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetOrigin(), true)
    ParticleManager:ReleaseParticleIndex(effect_cast)
    particle_cast = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_end_v2.vpcf"
    effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, hero )
    ParticleManager:SetParticleControl(effect_cast, 0, hero:GetOrigin())
    ParticleManager:ReleaseParticleIndex(effect_cast)

    --disabling the hero selection ability for existing and completely-built barracks in game when a hero has been chosen in that instant
    for i=0,15 do
        if PlayerResource:IsValidPlayer(i) then
            local mytable = CustomNetTables:GetTableValue("building_count", tostring(i))
            if mytable.barrack > 0 then
                if GetBarrack(i) ~= nil then
                    local someones_barrack = GetBarrack(i)
                    local abil = someones_barrack:FindAbilityByName(ability_name)
                    if abil then
                        abil:SetActivated(false)
                    end
                end
            end
        end
    end

    --renew respective player's barrack abilities
    local player_barrack = GetBarrack(player_ID)
    if player_barrack ~= caster then
        hPlayer.barrack_unit = caster
    end
    for i=0, 20 do
        local abil = caster:GetAbilityByIndex(i)
        if abil ~= nil then
            local abil_name = abil:GetAbilityName()
            caster:RemoveAbility(abil_name)
            --print("removing ability " .. abil_name .. " from barracks owned by player " .. player_ID)
        end
    end
    --here, give unit the barracks skills with unit upgrades and training etc
    caster:AddAbility("upgrade_str")
    caster:AddAbility("upgrade_agi")
    caster:AddAbility("upgrade_int")
    InitAbilities(caster)

    --[[
    --increase the global variable for number of heroes by 1. used for unlocking tiers
    _G.NUM_HEROES_IN_GAME = _G.NUM_HEROES_IN_GAME + 1
    if _G.NUM_HEROES_IN_GAME == _G.TIER2_HERO_COUNT_UNLOCK_CRITERIA then
        if _G.TIER2_UNLOCKED == nil then
            _G.TIER2_UNLOCKED = true
            --enabling the tier 2 units for existing barracks
            local existing_buildings = FindUnitsInRadius(
                                team_number,
                                Vector(0, 0, 0),
                                nil,
                                FIND_UNITS_EVERYWHERE,
                                DOTA_UNIT_TARGET_TEAM_BOTH,
                                DOTA_UNIT_TARGET_ALL,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_ANY_ORDER,
                                false)
            --check for barracks
            for _,unit in pairs(existing_buildings) do
                if unit:GetUnitName() == "barracks" then            
                    unit:FindAbilityByName("choose_illusionist_class_lua"):SetActivated(true)
                    unit:FindAbilityByName("choose_boomer_class_lua"):SetActivated(true)
                    unit:FindAbilityByName("choose_samurai_class_lua"):SetActivated(true)
                    unit:FindAbilityByName("choose_druid_class_lua"):SetActivated(true)
                end
            end
            print("tier 2 has just been unlocked.")
        end
    end
    if _G.NUM_HEROES_IN_GAME == _G.TIER3_HERO_COUNT_UNLOCK_CRITERIA then
        if _G.TIER3_UNLOCKED == nil then
            _G.TIER3_UNLOCKED = true
            --enabling the tier 3 units for existing barracks
            local existing_buildings = FindUnitsInRadius(
                                team_number,
                                Vector(0, 0, 0),
                                nil,
                                FIND_UNITS_EVERYWHERE,
                                DOTA_UNIT_TARGET_TEAM_BOTH,
                                DOTA_UNIT_TARGET_ALL,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_ANY_ORDER,
                                false)
            --check for barracks
            for _,unit in pairs(existing_buildings) do
                if unit:GetUnitName() == "barracks" then            
                    unit:FindAbilityByName("choose_assassin_class_lua"):SetActivated(true)
                    unit:FindAbilityByName("choose_timebender_class_lua"):SetActivated(true)
                end
            end
            print("tier 3 has just been unlocked.")
        end
    end
    ]]

    --msg for chosen hero
    Notifications:Top(player_ID, {ability = ability_name, duration=7})
    Notifications:Top(player_ID, {text="You have chosen the " .. hero_CNT_name .. " class", duration=7})

    -- activate HUD button for hero
    CustomGameEventManager:Send_ServerToPlayer(hPlayer, "activate_hero_shortcut", {ent_index = hero:entindex(), hero_name = hero_CNT_name})
end