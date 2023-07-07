function hire_units(event)
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetAbilityName()
    local hPlayer = caster:GetPlayerOwner()
    local player_ID = caster:GetPlayerOwnerID()
    local team_number = PlayerResource:GetTeam(player_ID)
    local hero = hPlayer.fake_omniknight_hero
    --local hero = PlayerResource:GetSelectedHeroEntity(player_ID)
    local unit_name = nil

    --------------------------different classes------------------------------------------
    if ability_name == "hire_worker" then
        unit_name = "worker_unit"

    elseif ability_name == "hire_sellsword" then
        unit_name = "sellsword_unit"
    elseif ability_name == "hire_zealot" then
        unit_name = "zealot_unit"
    elseif ability_name == "hire_warrior" then
        unit_name = "warrior_unit"

    elseif ability_name == "hire_bowman" then
        unit_name = "bowman_unit"
    elseif ability_name == "hire_hunter" then
        unit_name = "hunter_unit"
    elseif ability_name == "hire_rifleman" then
        unit_name = "rifleman_unit"
    end
    ---------------------------action to take--------------------------------------------
    
    -- check for sufficient food. currently all units cost 1 food. currently, hiring units cost 0 lumber
    if Resources:HasEnoughFood( player_ID, 1 ) then
        local unit = CreateUnitByName(unit_name, caster:GetAbsOrigin()+(caster:GetForwardVector():Normalized()*150), true, hero, hPlayer, team_number)
        unit:SetOwner(hero)
        unit:SetControllableByPlayer(player_ID, true)
        Resources:ModifyFoodUsed( player_ID, 1 )

        -- to allow building
        if unit_name == "worker_unit" then
            BuildingHelper:InitializeBuilder(unit)
        end

        -- add unit into table of units
        table.insert(hPlayer.Units, unit)

        -- sfx
        EmitSoundOn("Hero_Terrorblade.Reflection" , unit)
        local particle = "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7_gold_impact_sparks.vpcf"
        local effect = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControl( effect, PATTACH_ABSORIGIN_FOLLOW, unit:GetOrigin() )
        ParticleManager:ReleaseParticleIndex(effect)
    else
        SendErrorMessage(player_ID, "Not enough Food!")
        ability:EndCooldown()
        local gold = ability:GetGoldCost(ability:GetLevel())
        Resources:ModifyGold( player_ID, gold )
    end
end

function UpgradeUnitFromBasic(event)
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetAbilityName()
    local hPlayer = caster:GetPlayerOwner()
    local player_ID = caster:GetPlayerOwnerID()
    local CNT_unit_name = nil
    local unit_actual_name = nil
    local old_abil_name = nil
    local new_abil_name = nil
    local unitupgrade_items = {}
    local lumber_cost = ability:GetSpecialValueFor("lumber_cost")
    local newtable = {}
    local unit_old_name = nil

    -- check for lumber
    if Resources:HasEnoughLumber( player_ID, lumber_cost ) then
        Resources:ModifyLumber( player_ID, -lumber_cost )
        
        -- CNT
        local mytable = CustomNetTables:GetTableValue("unit_upgrades", tostring(player_ID))

        -- different upgrades
        if ability_name == "item_upgrade_sellsword_zealot" then
            CNT_unit_name = "zealot"
            unit_actual_name = "Zealot"
            old_abil_name = "hire_sellsword"
            new_abil_name = "hire_zealot"
            unitupgrade_items = {"item_upgrade_sellsword_zealot","item_upgrade_sellsword_warrior"}
            unit_old_name = "sellsword_unit"
            --CNT edit
            newtable = UpdateNetTable(mytable, "melee", CNT_unit_name)

        elseif ability_name == "item_upgrade_sellsword_warrior" then
            CNT_unit_name = "warrior"
            unit_actual_name = "Warrior"
            old_abil_name = "hire_sellsword"
            new_abil_name = "hire_warrior"
            unitupgrade_items = {"item_upgrade_sellsword_zealot","item_upgrade_sellsword_warrior"}
            unit_old_name = "sellsword_unit"
            --CNT edit
            newtable = UpdateNetTable(mytable, "melee", CNT_unit_name)

        elseif ability_name == "item_upgrade_bowman_hunter" then
            CNT_unit_name = "hunter"
            unit_actual_name = "Huntsman"
            old_abil_name = "hire_bowman"
            new_abil_name = "hire_hunter"
            unitupgrade_items = {"item_upgrade_bowman_hunter","item_upgrade_bowman_rifleman"}
            unit_old_name = "bowman_unit"
            --CNT edit
            newtable = UpdateNetTable(mytable, "ranged", CNT_unit_name)

        elseif ability_name == "item_upgrade_bowman_rifleman" then
            CNT_unit_name = "rifleman"
            unit_actual_name = "Rifleman"
            old_abil_name = "hire_bowman"
            new_abil_name = "hire_rifleman"
            unitupgrade_items = {"item_upgrade_bowman_hunter","item_upgrade_bowman_rifleman"}
            unit_old_name = "bowman_unit"
            --CNT edit
            newtable = UpdateNetTable(mytable, "ranged", CNT_unit_name)
        end
        CustomNetTables:SetTableValue("unit_upgrades", tostring(player_ID), newtable)

        -- updating all the player's training centres to get in sync with the upgrade
        local trainingcentres = GetPlayerTrainingCentres(player_ID)
        for _,unit in pairs(trainingcentres) do
            -- swap old and new training abil
            unit:AddAbility(new_abil_name)
            unit:SwapAbilities(old_abil_name, new_abil_name, false, true)

            -- delete old abil
            local hAbil = unit:FindAbilityByName(old_abil_name)
            if hAbil then
                unit:RemoveAbility(old_abil_name)
            end

            -- new training abil set to level 1
            hAbil = unit:FindAbilityByName(new_abil_name)
            if hAbil then
                hAbil:SetLevel(1)
            end

            -- removing relevant upgrade skills
            for _,item in pairs(unitupgrade_items) do
                local checkitem = unit:FindItemInInventory(item)
                if checkitem then
                    UTIL_Remove(checkitem)
                end
            end

            -- sfx at each Tcentre
            local particle = "particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_moonfall.vpcf"
            local effect_cast = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, unit )
            ParticleManager:SetParticleControl( effect_cast, PATTACH_ABSORIGIN_FOLLOW, unit:GetOrigin() )
            ParticleManager:ReleaseParticleIndex(effect_cast)
        end

        -- give player's existing relevant units the upgrade item
        local old_units = FindUnitsInRadius( -- selecting all units in the map.
            caster:GetTeam(),
            Vector(0,0,0),
            nil,
            FIND_UNITS_EVERYWHERE,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
            FIND_ANY_ORDER,
            false
        )
        -- counting only relevant old units
        for _,unit2 in pairs(old_units) do
            if unit2:GetUnitName() == unit_old_name and unit2:GetPlayerOwnerID() == player_ID then
                unit2:AddItem(CreateItem("item_unit_upgrade_lua", unit2, unit2))
            end
        end

        -- sfx and notif
        EmitSoundOnClient("ui.trophy_levelup", hPlayer)

        -- notifications
        Notifications:Bottom(player_ID, {ability = new_abil_name, duration=7})
        Notifications:Bottom(player_ID, {text= " " .. unit_actual_name .. " ", duration=7, style={color="orange"}})
        Notifications:Bottom(player_ID, {text="Class Upgrade chosen", continue=true})

    else
        -- not enough lumber, refund gold
        ability:EndCooldown()
        local gold = ability:GetGoldCost(ability:GetLevel())
        Resources:ModifyGold( player_ID, gold )
    end
end