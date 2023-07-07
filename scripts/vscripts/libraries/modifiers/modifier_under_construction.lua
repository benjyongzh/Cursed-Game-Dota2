modifier_under_construction = class({})

-- SFX for buildings under construction
function modifier_under_construction:OnCreated(event)
    if IsServer() then
        local particle_cast = "particles/units/heroes/heroes_underlord/underlord_dark_rift_ring.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        
        ParticleManager:SetParticleControlEnt(
            effect_cast,
            20,
            self:GetParent(),
            PATTACH_CENTER_FOLLOW,
            "attach_hitloc",
            self:GetParent():GetOrigin(), -- unknown
            true -- unknown, true
        )
        
        self:AddParticle(
            effect_cast,
            false,
            false,
            -1,
            false,
            false
        )
        
        particle_cast = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_start.vpcf"
        effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:ReleaseParticleIndex(effect_cast)

        --looping sound
        EmitSoundOn("Hero_VoidSpirit.AetherRemnant.Spawn_lp",self:GetParent())
    end
end



function modifier_under_construction:OnRemoved(event)
    if IsServer() and self:GetParent():IsAlive() then
        local particle_cast = "particles/econ/events/ti8/hero_levelup_ti8_flash_hit_magic.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
        ParticleManager:ReleaseParticleIndex(effect_cast)
        --looping sound
        self:GetParent():StopSound("Hero_VoidSpirit.AetherRemnant.Spawn_lp")
    
        --------------------if the building is a barrack, control hero_selection and abilities etc-------------------------------
        local building = self:GetParent()
        local hPlayer = building:GetPlayerOwner()
        --print("has hero chosen? " .. tostring(hPlayer.has_hero_class_chosen))
        --print("barbarian in game? " .. tostring(_G.BARBARIAN_IN_GAME))
        if building:GetUnitName() == "barracks" then
            if CustomNetTables:GetTableValue("player_hero", tostring(building:GetPlayerOwnerID())).chosen > 0 then
            --if CustomNetTables:GetTableValue("player_chosen_hero", tostring(building:GetPlayerOwnerID())).value > 0 then
                --player has a hero chosen, so barracks will have abilities on upgrading hero unit--
                --here, give unit the barracks skills with unit upgrades and training etc
                building:AddAbility("upgrade_str")
                building:AddAbility("upgrade_agi")
                building:AddAbility("upgrade_int")
            else
                --player has not chosen any hero, so the barracks will have abilities for choosing--
                -----------------------------------basic tier------------------------------------------
                building:AddAbility("choose_defender_class_lua")
                if CustomNetTables:GetTableValue("heroes_chosen_in_game", "defender") ~= nil then
                    building:FindAbilityByName("choose_defender_class_lua"):SetActivated(false)
                end

                building:AddAbility("choose_scout_class_lua")
                if CustomNetTables:GetTableValue("heroes_chosen_in_game", "scout") ~= nil then
                    building:FindAbilityByName("choose_scout_class_lua"):SetActivated(false)
                end

                building:AddAbility("choose_barbarian_class_lua")
                if CustomNetTables:GetTableValue("heroes_chosen_in_game", "barbarian") ~= nil then
                    building:FindAbilityByName("choose_barbarian_class_lua"):SetActivated(false)
                end

                building:AddAbility("choose_ranger_class_lua")
                if CustomNetTables:GetTableValue("heroes_chosen_in_game", "ranger") ~= nil then
                    building:FindAbilityByName("choose_ranger_class_lua"):SetActivated(false)
                end

                ---------------------------------intermediate tier-------------------------------------
                building:AddAbility("choose_illusionist_class_lua")
                --if _G.ILLUSIONIST_IN_GAME == true or _G.NUM_HEROES_IN_GAME < _G.TIER2_HERO_COUNT_UNLOCK_CRITERIA then
                if CustomNetTables:GetTableValue("heroes_chosen_in_game", "illusionist") ~= nil then
                    building:FindAbilityByName("choose_illusionist_class_lua"):SetActivated(false)
                end
                
                building:AddAbility("choose_guardian_class_lua")
                --if _G.GUARDIAN_IN_GAME == true or _G.NUM_HEROES_IN_GAME < _G.TIER2_HERO_COUNT_UNLOCK_CRITERIA then
                if CustomNetTables:GetTableValue("heroes_chosen_in_game", "guardian") ~= nil then
                    building:FindAbilityByName("choose_guardian_class_lua"):SetActivated(false)
                end

                building:AddAbility("choose_boomer_class_lua")
                --if _G.BOOMER_IN_GAME == true or _G.NUM_HEROES_IN_GAME < _G.TIER2_HERO_COUNT_UNLOCK_CRITERIA then
                if CustomNetTables:GetTableValue("heroes_chosen_in_game", "boomer") ~= nil then
                    building:FindAbilityByName("choose_boomer_class_lua"):SetActivated(false)
                end

                building:AddAbility("choose_samurai_class_lua")
                --if _G.SAMURAI_IN_GAME == true or _G.NUM_HEROES_IN_GAME < _G.TIER2_HERO_COUNT_UNLOCK_CRITERIA then
                if CustomNetTables:GetTableValue("heroes_chosen_in_game", "samurai") ~= nil then
                    building:FindAbilityByName("choose_samurai_class_lua"):SetActivated(false)
                end

                building:AddAbility("choose_druid_class_lua")
                --if _G.DRUID_IN_GAME == true or _G.NUM_HEROES_IN_GAME < _G.TIER2_HERO_COUNT_UNLOCK_CRITERIA then
                if CustomNetTables:GetTableValue("heroes_chosen_in_game", "druid") ~= nil then
                    building:FindAbilityByName("choose_druid_class_lua"):SetActivated(false)
                end
                
                -------------------------------advanced tier------------------------------------------
                building:AddAbility("choose_assassin_class_lua")
                --if _G.ASSASSIN_IN_GAME == true or _G.NUM_HEROES_IN_GAME < _G.TIER3_HERO_COUNT_UNLOCK_CRITERIA then
                if CustomNetTables:GetTableValue("heroes_chosen_in_game", "assassin") ~= nil then
                    building:FindAbilityByName("choose_assassin_class_lua"):SetActivated(false)
                end
                --building:AddAbility("choose_timebender_class_lua")
                --if _G.TIMEBENDER_IN_GAME == true or _G.NUM_HEROES_IN_GAME < _G.TIER3_HERO_COUNT_UNLOCK_CRITERIA then
                --    building:FindAbilityByName("choose_timebender_class_lua"):SetActivated(false)
                --end
            end
            ---------------------------set ability levels to 1------------------------------------
            InitAbilities(building) 
                
            -- other building types
        elseif building:GetUnitName() == "hut" then
            -- add unit creation abilities
            building:AddAbility("hire_worker")
            InitAbilities(building)

            -- start hut building cooldown
            local playerid = building:GetPlayerOwnerID()
            local farmer = GetFarmer(playerid)
            if farmer ~= nil then
                local abil = farmer:FindAbilityByName("build_hut")
                local cooldown = abil:GetSpecialValueFor("cooldown_after_built")
                abil:StartCooldown(cooldown)
            end

        elseif building:GetUnitName() == "campfire" then
            building:AddAbility("campfire_passive_lua")
            InitAbilities(building)
        elseif building:GetUnitName() == "watch_tower" then
            building:AddAbility("watch_tower_passive_lua")
            InitAbilities(building)
        elseif building:GetUnitName() == "sheep_farm" then
            building:AddAbility("farm_spawn_sheep_passive_lua")
            InitAbilities(building)
        elseif building:GetUnitName() == "training_centre" then
            local mytable = CustomNetTables:GetTableValue("unit_upgrades", tostring(building:GetPlayerOwnerID()))
            -- melee units
            if mytable.melee == "basic" then
                building:AddAbility("hire_sellsword")
                local item = CreateItem("item_upgrade_sellsword_zealot", building, building)
                if item then 
                    building:AddItem(item)
                end
                item = CreateItem("item_upgrade_sellsword_warrior", building, building)
                if item then 
                    building:AddItem(item)
                end
            elseif mytable.melee == "zealot" then
                building:AddAbility("hire_zealot")
            elseif mytable.melee == "warrior" then
                building:AddAbility("hire_warrior")
            end
            --ranged units
            if mytable.ranged == "basic" then
                -- standard ranged unit and further upgrade choices
                building:AddAbility("hire_bowman")
                local item = CreateItem("item_upgrade_bowman_hunter", building, building)
                if item then 
                    building:AddItem(item)
                end
                item = CreateItem("item_upgrade_bowman_rifleman", building, building)
                if item then 
                    building:AddItem(item)
                end
            elseif mytable.ranged == "hunter" then
                building:AddAbility("hire_hunter")
            elseif mytable.ranged == "rifleman" then
                building:AddAbility("hire_rifleman")
            end
            InitAbilities(building)
        end


        -- item for self-destruct
        for i=0, 4, 1 do  --Fill all empty slots in the player's inventory with "dummy" items.
            local current_item = building:GetItemInSlot(i)
            if current_item == nil then
                building:AddItem(CreateItem("item_dummy_datadriven", building, building))
            end
        end
        building:AddItem(CreateItem("item_building_selfdestruct_lua", building, building))
        for i=0, 4, 1 do  --Remove all dummy items from the player's inventory.
            local current_item = building:GetItemInSlot(i)
            if current_item ~= nil then
                if current_item:GetName() == "item_dummy_datadriven" then
                    UTIL_Remove(current_item)
                end
            end
        end

        -- destroying trees
        local actual_size = building:GetKeyValue("BlockPathingSize")
        local position = building:GetAbsOrigin() + Vector(((actual_size*64)/2) + 32, 0, 0) -- start point
        
        local side_size = actual_size + 2
        local side_counter = nil
        if actual_size % 2 == 0 then
            -- even number
            position = position + Vector(0, -32, 0)
            side_counter = (side_size/2) + 1
        else
            -- odd number
            side_counter = (side_size-1)/2
        end
        
        -- go clockwise
        local direction = Vector(0,-64,0)

        local total_perimeter = (side_size*side_size) - (actual_size*actual_size)
        for i=0,total_perimeter,1 do
            
            -- check for trees
            local treeBlocked = GridNav:IsNearbyTree(position, 30, true)
            if treeBlocked then
                local trees = GridNav:GetAllTreesAroundPoint(position, 30, true)
                for _,tree in pairs(trees) do
                    if tree:IsStanding() then
                        tree:CutDown(building:GetTeam())
                    end
                end
            end

            if side_counter < side_size then
                side_counter = side_counter + 1
            else
                side_counter = 1
                --change direction
                if direction == Vector(0,-64,0) then
                    direction = Vector(-64,0,0)
                elseif direction == Vector(-64, 0, 0) then
                    direction = Vector(0,64,0)
                elseif direction == Vector(0,64,0) then
                    direction = Vector(64,0,0)
                else
                    direction = Vector(0,-64,0)
                end
            end

            position = position + direction
        end

    end
end

function modifier_under_construction:IsHidden()
    return true
end

function modifier_under_construction:IsPurgable()
    return false
end