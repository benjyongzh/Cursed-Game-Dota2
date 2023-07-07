Game_Events = class({})
LinkLuaModifier ( "modifier_werewolf_day", "modifiers/modifier_werewolf_day", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_werewolf_night", "modifiers/modifier_werewolf_night", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_vampire_day", "modifiers/modifier_vampire_day", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_vampire_night", "modifiers/modifier_vampire_night", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_dummy_unit", "modifiers/modifier_dummy_unit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_sheep_basket_expire_lua", "modifiers/items/modifier_sheep_basket_expire_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_item_key_dummy_unit_lua", "modifiers/items/modifier_item_key_dummy_unit_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_xelnaga_cursed_track_lua", "modifiers/modifier_xelnaga_cursed_track_lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier ( "modifier_keystone_passive_lua_stacks", "modifiers/modifier_keystone_passive_lua_stacks", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_keystone_full_keys_delay_lua", "modifiers/modifier_keystone_full_keys_delay_lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier ( "modifier_keystone_activation_delay_lua", "modifiers/modifier_keystone_activation_delay_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_keystone_sabotaged_lua", "modifiers/modifier_keystone_sabotaged_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_keystone_sabotaged_giving_vision_lua", "modifiers/modifier_keystone_sabotaged_giving_vision_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_keystone_activatedgood_lua", "modifiers/modifier_keystone_activatedgood_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_walking_anim_fix_lua", "modifiers/modifier_walking_anim_fix_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_revival_dummy", "modifiers/modifier_revival_dummy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_player_death_global_penalty_dummy_lua", "modifiers/modifier_player_death_global_penalty_dummy_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_endgame_portal_lua", "modifiers/modifier_endgame_portal_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_endgame_teleported_away", "modifiers/modifier_endgame_teleported_away", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_spire_giving_vision_lua", "modifiers/modifier_spire_giving_vision_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_generic_upgrade_1_lua", "modifiers/upgrades/modifier_generic_upgrade_1_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_generic_upgrade_2_lua", "modifiers/upgrades/modifier_generic_upgrade_2_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_generic_upgrade_3_lua", "modifiers/upgrades/modifier_generic_upgrade_3_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_generic_upgrade_4_lua", "modifiers/upgrades/modifier_generic_upgrade_4_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_generic_upgrade_5_lua", "modifiers/upgrades/modifier_generic_upgrade_5_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_generic_upgrade_6_lua", "modifiers/upgrades/modifier_generic_upgrade_6_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_generic_upgrade_7_lua", "modifiers/upgrades/modifier_generic_upgrade_7_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ( "modifier_generic_upgrade_8_lua", "modifiers/upgrades/modifier_generic_upgrade_8_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_zombie_ai", "modifiers/modifier_zombie_ai", LUA_MODIFIER_MOTION_NONE )

function Game_Events:Init()
    --======================================================= xelnaga
    _G.XELNAGA_UNLOCK_SEQUENCE = {}
    for i=1, #_G.XELNAGA_LOCATIONS do
        CustomNetTables:SetTableValue("xelnaga_status", tostring(i), {activated = false, offline = true})
        table.insert(_G.XELNAGA_UNLOCK_SEQUENCE, i)
    end
    -- xelnaga unlocking randomised sequence
    _G.XELNAGA_UNLOCK_SEQUENCE = Shuffle(_G.XELNAGA_UNLOCK_SEQUENCE)
    _G.XELNAGA_UNLOCKED = 0
    -- global variable to check if cursed is being revealed
    _G.XELNAGA_REVEALED = false
    
    --======================================================= keystones
    for i=1, #_G.KEYSTONE_LOCATIONS do
        CustomNetTables:SetTableValue("keystone_status", tostring(i), {activated = false, keys = 0})
    end

    --======================================================= heroes
    _G.CHOSEN_HEROES = {}
    _G.ZOMBIE_UNIT_COUNT = 0

    --==================================== when player UI requests info =======================================================================
    CustomGameEventManager:RegisterListener("request_ui_info", Dynamic_Wrap(Game_Events, "OnRequestUIInfo"))

    --==================================== when player rightclicks xelnaga tower ============================================================================
    CustomGameEventManager:RegisterListener("xelnaga_rightclicked", Dynamic_Wrap(Game_Events, "OnXelNagaRightClicked"))

    --==================================== when cursed player choose decision on sabotaging =================================================================
    CustomGameEventManager:RegisterListener("keystone_sabotage_decision", Dynamic_Wrap(Game_Events, "OnKeystoneSabotageChoiceMade"))

    --==================================== when cursed player choose decision on sabotaging =================================================================
    CustomGameEventManager:RegisterListener("hero_selected", Dynamic_Wrap(Game_Events, "OnHeroSelected"))
    
    --==================================== when player rightclicks a dummy unit =============================================================================
    CustomGameEventManager:RegisterListener("tombstone_rightclicked", Dynamic_Wrap(Game_Events, "OnTombstoneRightClicked"))

    --==================================== when player rightclicks a goldmine ===============================================================================
    CustomGameEventManager:RegisterListener("goldmine_rightclicked", Dynamic_Wrap(Game_Events, "OnGoldmineRightClicked"))

    --==================================== when player clicks playerboard main button (used for toggling opacity of objectives) =============================
    CustomGameEventManager:RegisterListener("player_board_clicked", Dynamic_Wrap(Game_Events, "OnPlayerBoardClicked"))
    
    --==================================== when player confirms a hero upgrade choice =======================================================================
    CustomGameEventManager:RegisterListener("hero_upgrade_choice_selected", Dynamic_Wrap(Game_Events, "OnHeroUpgradeSelected"))

    print("game_events initialized")
end

function Game_Events:InitPlayerHUD(player_id) -- used for start of game. addon_game_mode_lua line 774
    if PlayerResource:IsValidPlayerID(player_id) then
        local hPlayer = PlayerResource:GetPlayer(player_id)

        -- configure_hud to remove some of the default dota hud stuff
        CustomGameEventManager:Send_ServerToPlayer(hPlayer, "configure_hud", {})
        
        -- playerboard
		CustomGameEventManager:Send_ServerToPlayer(hPlayer, "initialize_player_board", {})
		if TOOLS_MODE then
			for i = 0, 9 do
				local name_data = "player " .. i
				local status_data = "Alive"
				CustomGameEventManager:Send_ServerToPlayer(hPlayer, "add_player_to_board", {playername = name_data, playerid = i, status = status_data})
			end
			CustomGameEventManager:Send_ServerToPlayer(hPlayer, "player_dead", {playerid = 4})
		else
			for i = 0, 15, 1 do
				if PlayerResource:IsValidPlayer(i) then
					local name_data = PlayerResource:GetPlayerName(i)
					local team = PlayerResource:GetTeam(i)
                    local color = ColorForTeam(team)
					CustomGameEventManager:Send_ServerToPlayer(
						hPlayer, 
						"add_player_to_board",
						{
							playername = name_data,
							playerid = i,
							status = "Alive",
							color1 = color[1],
							color2 = color[2],
							color3 = color[3]
						}
                    )
                    
                    -- check real status
                    local mainunit = GetMainUnit(i)
                    if not mainunit:IsAlive() or not IsValidEntity(mainunit) then
                        local loserunit = GetLoserUnit(i)
                        if loserunit then
                            -- this player is dead
                            CustomGameEventManager:Send_ServerToPlayer(hPlayer, "player_dead", {playerid = i})
                        end
                    end

				end
			end
        end
        
		-- xelnaga
        CustomGameEventManager:Send_ServerToPlayer(hPlayer, "xelnaga_initialize", {count = #_G.XELNAGA_LOCATIONS})
		for i=1, #_G.XELNAGA_LOCATIONS do
            local mytable = CustomNetTables:GetTableValue("xelnaga_status", tostring(i))
            CustomGameEventManager:Send_ServerToPlayer(hPlayer, "xelnaga_update", {index = i, activated = mytable.activated, ent_index = _G.XELNAGA_TOWER_UNIT[i]:entindex(), offline = mytable.offline})
            -- worldpanel for tooltips
            WorldPanels:CreateWorldPanel(
				player_id,
				{
					layout = "file://{resources}/layout/custom_game/worldpanels/building_tooltip.xml",
					entity = _G.XELNAGA_TOWER_UNIT[i],
					entityHeight = 0,
					data = {name = "Outpost Tower", number = i}
				}
			)
		end
		
		-- keystones
		CustomGameEventManager:Send_ServerToPlayer(hPlayer, "keystone_hud_initialize", {count = #_G.KEYSTONE_LOCATIONS})
		for i=1, #_G.KEYSTONE_LOCATIONS do
            local mytable = CustomNetTables:GetTableValue("keystone_status", tostring(i))
            if mytable.activated < 1 then
                -- turn on world panels for unactivated keystones
                WorldPanels:CreateWorldPanel(
                    player_id,
                    {
                        layout = "file://{resources}/layout/custom_game/worldpanels/keystone.xml",
                        entity = _G.KEYSTONE_UNIT[i],
                        entityHeight = 380,
                        data = {keys = _G.KEYS_TO_ACTIVATE_KEYSTONE[CountPlayersInGame()]}
                    }
                )
            end

            -- worldpanel for tooltips
            WorldPanels:CreateWorldPanel(
				player_id,
				{
					layout = "file://{resources}/layout/custom_game/worldpanels/building_tooltip.xml",
					entity = _G.KEYSTONE_UNIT[i],
					entityHeight = 0,
					data = {name = "Keystone", number = i}
				}
			)
			
			-- init hud panel
			CustomGameEventManager:Send_ServerToPlayer(hPlayer, "keystone_hud_update", {index = i, activated = mytable.activated, keys = mytable.keys, max_keys = _G.KEYS_TO_ACTIVATE_KEYSTONE[CountPlayersInGame()], ent_index = _G.KEYSTONE_UNIT[i]:entindex()})
        end
        CustomGameEventManager:Send_ServerToPlayer(hPlayer, "keystone_initialize", {})
        
        -- goldmines
        for i=1, #_G.GOLDMINE_UNIT do
            -- worldpanel for tooltips
            WorldPanels:CreateWorldPanel(
                player_id,
                {
                    layout = "file://{resources}/layout/custom_game/worldpanels/building_tooltip.xml",
                    entity = _G.GOLDMINE_UNIT[i],
                    entityHeight = 0,
                    data = {name = "Goldmine", number = i}
                }
            )
        end

	    -- send message to client to make sure client does not request for ui info again
        --CustomGameEventManager:Send_ServerToPlayer(hPlayer, "player_hud_already_updated",{})
    end

end

function Game_Events:InitHeroSelectionUI(player_id) -- used for addon_game_mode_lua line 805
    if PlayerResource:IsValidPlayerID(player_id) then
        local hPlayer = PlayerResource:GetPlayer(player_id)
        CustomGameEventManager:Send_ServerToPlayer(hPlayer, "hero_selection_initialize", {})
    end
end

function Game_Events:ForceUpdatePlayerHUD(player_id) -- used for player reconnection. temporarily out of game for now
    if PlayerResource:IsValidPlayerID(player_id) then
        local hPlayer = PlayerResource:GetPlayer(player_id)

        -- configure_hud to remove some of the default dota hud stuff
        CustomGameEventManager:Send_ServerToPlayer(hPlayer, "configure_hud", {})
        
        -- playerboard
		CustomGameEventManager:Send_ServerToPlayer(hPlayer, "initialize_player_board", {})
		if TOOLS_MODE then
			for i = 0, 9 do
				local name_data = "player " .. i
				local status_data = "Alive"
				CustomGameEventManager:Send_ServerToPlayer(hPlayer, "add_player_to_board", {playername = name_data, playerid = i, status = status_data})
			end
			CustomGameEventManager:Send_ServerToPlayer(hPlayer, "player_dead", {playerid = 4})
		else
			for i = 0, 15, 1 do
				if PlayerResource:IsValidPlayer(i) then
					local name_data = PlayerResource:GetPlayerName(i)
					local team = PlayerResource:GetTeam(i)
                    local color = ColorForTeam(team)
					CustomGameEventManager:Send_ServerToPlayer(
						hPlayer, 
						"add_player_to_board",
						{
							playername = name_data,
							playerid = i,
							status = "Alive",
							color1 = color[1],
							color2 = color[2],
							color3 = color[3]
						}
                    )
                    
                    -- check real status
                    local mainunit = GetMainUnit(i)
                    if not mainunit:IsAlive() or not IsValidEntity(mainunit) then
                        local loserunit = GetLoserUnit(i)
                        if loserunit then
                            -- this player is dead
                            CustomGameEventManager:Send_ServerToPlayer(hPlayer, "player_dead", {playerid = i})
                        end
                    end

				end
			end
        end
        
		-- xelnaga
        CustomGameEventManager:Send_ServerToPlayer(hPlayer, "xelnaga_initialize", {count = #_G.XELNAGA_LOCATIONS})
		for i=1, #_G.XELNAGA_LOCATIONS do
            local mytable = CustomNetTables:GetTableValue("xelnaga_status", tostring(i))
            CustomGameEventManager:Send_ServerToPlayer(hPlayer, "xelnaga_update", {index = i, activated = mytable.activated, ent_index = _G.XELNAGA_TOWER_UNIT[i]:entindex(), offline = mytable.offline})
            -- worldpanel for tooltips
            WorldPanels:CreateWorldPanel(
				player_id,
				{
					layout = "file://{resources}/layout/custom_game/worldpanels/building_tooltip.xml",
					entity = _G.XELNAGA_TOWER_UNIT[i],
					entityHeight = 0,
					data = {name = "Outpost Tower", number = i}
				}
			)
		end
		
		-- keystones
		CustomGameEventManager:Send_ServerToPlayer(hPlayer, "keystone_hud_initialize", {count = #_G.KEYSTONE_LOCATIONS})
		for i=1, #_G.KEYSTONE_LOCATIONS do
            local mytable = CustomNetTables:GetTableValue("keystone_status", tostring(i))
            if mytable.activated < 1 then
                -- turn on world panels for unactivated keystones
                WorldPanels:CreateWorldPanel(
                    player_id,
                    {
                        layout = "file://{resources}/layout/custom_game/worldpanels/keystone.xml",
                        entity = _G.KEYSTONE_UNIT[i],
                        entityHeight = 380,
                        data = {keys = _G.KEYS_TO_ACTIVATE_KEYSTONE[CountPlayersInGame()]}
                    }
                )
            end

            -- worldpanel for tooltips
            WorldPanels:CreateWorldPanel(
				player_id,
				{
					layout = "file://{resources}/layout/custom_game/worldpanels/building_tooltip.xml",
					entity = _G.KEYSTONE_UNIT[i],
					entityHeight = 0,
					data = {name = "Keystone", number = i}
				}
			)
			
			-- init hud panel
			CustomGameEventManager:Send_ServerToPlayer(hPlayer, "keystone_hud_update", {index = i, activated = mytable.activated, keys = mytable.keys, max_keys = _G.KEYS_TO_ACTIVATE_KEYSTONE[CountPlayersInGame()], ent_index = _G.KEYSTONE_UNIT[i]:entindex()})
        end
        CustomGameEventManager:Send_ServerToPlayer(hPlayer, "keystone_initialize", {})
        
        -- goldmines
        for i=1, #_G.GOLDMINE_UNIT do
            -- worldpanel for tooltips
            WorldPanels:CreateWorldPanel(
                player_id,
                {
                    layout = "file://{resources}/layout/custom_game/worldpanels/building_tooltip.xml",
                    entity = _G.GOLDMINE_UNIT[i],
                    entityHeight = 0,
                    data = {name = "Goldmine", number = i}
                }
            )
        end
	
        -- hero selection or upgrades
        local mainunit = GetMainUnit(player_id)
        local unitname = mainunit:GetUnitName()
        if unitname == "farmer" then
            CustomGameEventManager:Send_ServerToPlayer(hPlayer, "hero_selection_initialize", {})
            CustomGameEventManager:Send_ServerToPlayer(hPlayer, "hero_panel_update", _G.CHOSEN_HEROES)
        else
            CustomGameEventManager:Send_ServerToPlayer(hPlayer, "initialize_hero_upgrades", {hero = unitname, num_players = CountPlayersInGame()})
            local mytable = CustomNetTables:GetTableValue("player_hero", tostring(player_id)).upgrade_choices
            CustomGameEventManager:Send_ServerToPlayer(hPlayer, "update_hero_upgrade_progress", mytable)
        end

        -- extras for cursed player
        if mainunit == _G.CURSED_UNIT then
            if _G.CURSED_EXTRAS_UI_SHOWN and _G.CURSED_EXTRAS_UI_SHOWN == true then
                CustomGameEventManager:Send_ServerToPlayer(hPlayer, "display_cursed_upgrades",{creature = _G.CURSED_CREATURE})
                CustomGameEventManager:Send_ServerToPlayer(hPlayer, "update_cursed_upgrade_level",{daycounter = _G.DAY_COUNTER, creature = _G.CURSED_CREATURE})
                CustomGameEventManager:Send_ServerToPlayer(hPlayer, "display_cursed_transform",{creature = _G.CURSED_CREATURE, ent_index = mainunit:entindex(), cooldown = _G.CURSED_TRANSFORM_COOLDOWN})
                -- update panorama for cursed player, from Game_events:OnHeroSelected
                CustomGameEventManager:Send_ServerToPlayer(hPlayer, "update_cursed_unit_entity_index",{ent_index = mainunit:entindex()})
            end
        end

        -- objectives
        if _G.OBJECTIVES_UI_SHOWN and _G.OBJECTIVES_UI_SHOWN == true then
            Game_Events:InitObjectives(player_id)
            Game_Events:ObjectivesUpdate(player_id)
        end

        -- send message to client to make sure client does not request for ui info again
        CustomGameEventManager:Send_ServerToPlayer(hPlayer, "player_hud_already_updated",{})
    end

end

function Game_Events:OnRequestUIInfo(args)
    local playerid = args.playerid
    Game_Events:ForceUpdatePlayerHUD(playerid)
    print("UI info request received and executed from server side")
end

--=============================================================== objectives ===============================================================
function Game_Events:InitObjectives(playerid)
    if PlayerResource:IsValidPlayerID(playerid) then
        local hPlayer = PlayerResource:GetPlayer(playerid)
        local data = {
            keystone_humans_win = _G.KEYSTONES_TO_HUMANS_WIN,
            keystone_cursed_win = _G.KEYSTONES_TO_CURSED_WIN,
            max_keystones = #_G.KEYSTONE_LOCATIONS,
            max_xelnaga = #_G.XELNAGA_LOCATIONS,
            max_noncursed_players = CountNonCursedPlayersInGame(),
        }
        local unit = GetMainUnit(playerid)
        if unit:IsAlive() and IsValidEntity(unit) then
            if unit == _G.CURSED_UNIT then
                CustomGameEventManager:Send_ServerToPlayer(hPlayer, "cursed_objectives_initialize", data)
            else
                CustomGameEventManager:Send_ServerToPlayer(hPlayer, "human_objectives_initialize", data)
            end
        end
    end
end

function Game_Events:ObjectivesUpdate(playerid)
    if PlayerResource:IsValidPlayerID(playerid) then
        local hPlayer = PlayerResource:GetPlayer(playerid)
        local data = {
            keystone_humans_win = _G.KEYSTONES_TO_HUMANS_WIN,
            keystone_cursed_win = _G.KEYSTONES_TO_CURSED_WIN,
            keystones_activated = CountKeystonesActivated(),
            keystones_sabotaged = CountKeystonesSabotaged(),
            max_keystones = #_G.KEYSTONE_LOCATIONS,
            xelnaga_activated = CountXelNagaActivated(),
            max_xelnaga = #_G.XELNAGA_LOCATIONS,
            players_remaining = CountNonCursedPlayersAlive(),
            max_noncursed_players = CountNonCursedPlayersInGame(),
        }
        if playerid == _G.CURSED_UNIT:GetPlayerOwnerID() then
            CustomGameEventManager:Send_ServerToPlayer(hPlayer, "cursed_objectives_update", data)
        else
            CustomGameEventManager:Send_ServerToPlayer(hPlayer, "human_objectives_update", data)
        end
    end

end

function Game_Events:OnPlayerBoardClicked(args)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(args.playerid), "toggle_objectives_opacity", {})
end

function Game_Events:ChooseCursed()
    local all_units = FindUnitsInRadius( -- selecting all units in the map.
        DOTA_TEAM_NOTEAM,
        Vector(0,0,0),
        nil,
        FIND_UNITS_EVERYWHERE,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
        FIND_ANY_ORDER,
        false
    )
    -- counting only farmer starting units
    local farmers = {}
    for i,unit in pairs(all_units) do
        if unit:GetUnitName() == STARTING_UNIT_NAME and unit:IsAlive() then
            farmers[i] = unit
        end
    end
    local rndm_number = math.random(1,#farmers) -- random number among te number of units
    return farmers[rndm_number] -- choosing cursed unit
end

--=============================================================== goldmine =================================================================
function Game_Events:OnGoldmineRightClicked(args)
    local unit = EntIndexToHScript(args.entindex)
    local target = EntIndexToHScript(args.targetindex)
    local playerid = unit:GetPlayerOwnerID()
    if not PlayerResource:IsValidPlayerID(playerid) then return end
    if not IsValidEntity(unit) or not IsValidEntity(target) then return end

    -- doing mining
    if target:HasModifier("modifier_goldmine_passive_lua") then
        if unit == GetMainUnit(playerid) then
            -- check cursed
            if IsInCursedForm(unit) then
                SendErrorMessage(playerid, "Cannot mine in Cursed Form")
                unit:MoveToPosition(target:GetAbsOrigin())
            -- add mining abil and cast it on dummy
            else
                local abil = unit:FindAbilityByName("mine_goldmine_lua")
                if not abil then
                    unit:AddAbility("mine_goldmine_lua")
                    abil = unit:FindAbilityByName("mine_goldmine_lua")
                end
                abil:SetLevel(1)
                unit:CastAbilityOnTarget(target, abil, playerid)
            end
        else
            SendErrorMessage(playerid, "Only Heroes can mine")
            unit:MoveToPosition(target:GetAbsOrigin())
        end
    else
        SendErrorMessage(playerid, "Not a valid Goldmine")
        unit:MoveToPosition(target:GetAbsOrigin())
    end


end

--========================================================= keystones and xelnagas =========================================================

function Game_Events:KeySpawning()
    math.randomseed(RandomInt(1,CountPlayersInGame()))
    Timers:CreateTimer(RandomInt(_G.KEY_SPAWNING_TIME_MIN[CountPlayersInGame()], _G.KEY_SPAWNING_TIME_MAX[CountPlayersInGame()]), function()
        --action
        local max_num = #_G.KEY_SPAWN_LOCATIONS
        local rand_int = RandomInt(1, max_num)
        local key_spawner = _G.KEY_SPAWNER_UNIT[rand_int]
        local key_dummy_around = true
        local key_spawner_index = 0
        for i= 1,max_num do
            if key_dummy_around == true then
                if key_spawner.dummy ~= nil and key_spawner.dummy:HasModifier("modifier_item_key_dummy_unit_lua") then
                    key_dummy_around = true
                    if rand_int + i > max_num then
                        key_spawner = _G.KEY_SPAWNER_UNIT[(rand_int + i) - max_num]
                        key_spawner_index = (rand_int + i) - max_num
                    else
                        key_spawner = _G.KEY_SPAWNER_UNIT[rand_int + i]
                        key_spawner_index = rand_int + i
                    end
                else
                    key_dummy_around = false
                    break
                end
            end
        end

        if key_dummy_around == false then
            -- craete key item
            local key = CreateItem("item_keystone_key", nil, nil)
            local rndm_distance = RandomInt(100, _G.KEY_SPAWN_RADIUS)
            --local container = CreateItemOnPositionSync(key_spawner:GetAbsOrigin() + RandomVector(rndm_distance), key)
            local container = CreateItemOnPositionSync(key_spawner:GetAbsOrigin() + Vector(0,(-1 * rndm_distance),0), key)
            container:SetAngles(0, RandomFloat(0, 360), 0)

            -- create key_dummy_unit
            local location = container:GetAbsOrigin()
            key_spawner.dummy = CreateUnitByName("dummy_unit", location, true, nil, nil, DOTA_TEAM_NEUTRALS)
            key_spawner.dummy:AddNewModifier(key_spawner.dummy,nil,"modifier_item_key_dummy_unit_lua", {})

            -- sfx
            local particle = "particles/econ/events/ti9/shovel/shovel_baby_roshan_spawn_burst.vpcf"
            local effect = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN, container )
            ParticleManager:SetParticleControl( effect, 0, location )
            ParticleManager:ReleaseParticleIndex( effect )
        end
        
        --repeat itself
        return RandomInt(_G.KEY_SPAWNING_TIME_MIN[CountPlayersInGame()], _G.KEY_SPAWNING_TIME_MAX[CountPlayersInGame()])
    end)
end

function Game_Events:OnItemPickedUp(table)
    -- pick up a keystone key
    if table.itemname == "item_keystone_key" then
        local all_units = FindUnitsInRadius( -- selecting all units in the map.
            DOTA_TEAM_NEUTRALS,
            EntIndexToHScript(table.ItemEntityIndex):GetAbsOrigin(),
            nil,
            _G.KEY_SPAWN_RADIUS + 160,
            DOTA_UNIT_TARGET_TEAM_BOTH,
            DOTA_UNIT_TARGET_BUILDING,
            DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
            FIND_ANY_ORDER,
            false
        )
        for _,unit in pairs(all_units) do
            if unit:GetUnitName() == "key_spawner" then
                if unit.dummy ~= nil and unit.dummy:HasModifier("modifier_item_key_dummy_unit_lua") then
                    unit.dummy:ForceKill(false)
                    unit.dummy = nil
                end
            end
        end
    end

end

--[[
function Game_Events:SheepBasketDespawning()
    Timers:CreateTimer(0.2, function()
        if _G.SHEEPBASKETS_TO_EXPIRE ~= {} then
            for index,container in pairs(_G.SHEEPBASKETS_TO_EXPIRE) do
                if IsValidEntity(container) then
                    local createdtime = container:GetCreationTime()
                    if GameRules:GetGameTime() >= (createdtime +_G.SHEEP_BUCKET_LIFESPAN) then
                        -- sfx
                        local sfx_dummy = CreateUnitByName( "dummy_unit", container:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NOTEAM )
                        sfx_dummy:AddNewModifier(sfx_dummy, nil, "modifier_sheep_basket_expire_lua", {duration = 0.1})

                        table.remove(_G.SHEEPBASKETS_TO_EXPIRE, index)
                        UTIL_Remove(container)
                    end
                else
                    table.remove(_G.SHEEPBASKETS_TO_EXPIRE, index)
                    UTIL_Remove(container)
                end
            end
        end
        return 0.2
    end)
end
]]

function Game_Events:UnlockNextXelNaga()
    local quantity = _G.XELNAGA_UNLOCK_PATTERN[_G.DAY_COUNTER]
    local quantitytable = {}

    -- creating a table based on the quantity itself. eg quantity = 4, then table = {1,2,3,4}
    for i=1,quantity,1 do
        table.insert(quantitytable, i)
    end

    -- recalling the indexes executed upon in the previous night
    local previous_sum = 0
    if _G.DAY_COUNTER > 1 then
        for i=1,_G.DAY_COUNTER-1 do
            previous_sum = previous_sum + _G.XELNAGA_UNLOCK_PATTERN[i]
        end
    end

    -- executing unlocking based on previous_sum and quantitytable
    for i=1,#quantitytable do
        local index = _G.XELNAGA_UNLOCK_SEQUENCE[previous_sum + quantitytable[i]]
        local tower = _G.XELNAGA_TOWER_UNIT[index]
        local modifier = tower:FindModifierByName("modifier_xelnaga_tower_locked_lua")
        if modifier then
            modifier:Destroy()

            -- sfx
            PlaySoundOnAllClients("General.PingDefense")

            -- notifications
            Notifications:BottomToAll({text="Outpost Tower " .. index .. " is now online", duration = 8})

            -- update xelnaga hud wording
            CustomGameEventManager:Send_ServerToAllClients("xelnaga_update", {index = index, activated = false, ent_index = tower:entindex(), offline = false})

            -- update CNT
            CustomNetTables:SetTableValue("xelnaga_status", tostring(index), {activated = false, offline = false})

            -- add to global variable
            _G.XELNAGA_UNLOCKED = _G.XELNAGA_UNLOCKED + 1
        end
    end
end

function Game_Events:OnXelNagaRightClicked(args)
    local unit = EntIndexToHScript(args.entindex)
    local target = EntIndexToHScript(args.targetindex)
    local playerid = unit:GetPlayerOwnerID()
    if not PlayerResource:IsValidPlayerID(playerid) then return end
    if not IsValidEntity(unit) or not IsValidEntity(target) then return end

    if unit == GetMainUnit(playerid) then
        if IsInCursedForm(unit) then
            -- check if zombie
            if unit:HasModifier("modifier_zombie_main_passive_lua") then
                -- is zombie. cannot deactivate
                SendErrorMessage(playerid, "Zombies cannot interact with Outpost Towers")
                unit:MoveToPosition(target:GetAbsOrigin())
            else
                -- not zombie. can deactivate
                if target:HasModifier("modifier_xelnaga_tower_activated_vision_lua") then
                    --deactivate tower
                    local deactivation_abil = unit:FindAbilityByName("xelnaga_tower_deactivate_lua")
                    if not deactivation_abil then
                        unit:AddAbility("xelnaga_tower_deactivate_lua")
                        deactivation_abil = unit:FindAbilityByName("xelnaga_tower_deactivate_lua")
                        deactivation_abil:SetLevel(1)
                    end
                    unit:CastAbilityOnTarget(target, deactivation_abil, playerid)
                else
                    SendErrorMessage(playerid, "Cannot activate Outpost Tower in Cursed Form")
                    unit:MoveToPosition(target:GetAbsOrigin())
                end
            end
        
        else
            if target:HasModifier("modifier_xelnaga_tower_activated_vision_lua") then
                unit:MoveToPosition(target:GetAbsOrigin())
            else
                -- activate tower
                if target:HasModifier("modifier_xelnaga_tower_locked_lua") then
                    SendErrorMessage(playerid, "Outpost Tower is offline. Cannot be activated yet")
                    unit:MoveToPosition(target:GetAbsOrigin())
                else
                    local activation_abil = unit:FindAbilityByName("xelnaga_tower_activate_lua")
                    if not activation_abil then
                        unit:AddAbility("xelnaga_tower_activate_lua")
                        activation_abil = unit:FindAbilityByName("xelnaga_tower_activate_lua")
                        activation_abil:SetLevel(1)
                    end
                    unit:CastAbilityOnTarget(target, activation_abil, playerid)
                end
            end
        end
    end
end

function Game_Events:XelNagaUpdate()
    local n = 0
    for i=1,#_G.XELNAGA_LOCATIONS do
        local mytable = CustomNetTables:GetTableValue("xelnaga_status", tostring(i))
        if mytable ~= nil and mytable.activated > 0 then
            n = n + 1
        end
        CustomGameEventManager:Send_ServerToAllClients("xelnaga_update", {index = i, activated = mytable.activated, ent_index = _G.XELNAGA_TOWER_UNIT[i]:entindex(), offline = mytable.offline})
    end
    if n >= _G.XELNAGA_REVEAL_REQUIREMENT then
        if not _G.XELNAGA_REVEALED then
            -- start revealing
            _G.CURSED_UNIT:AddNewModifier(_G.CURSED_UNIT,nil,"modifier_xelnaga_cursed_track_lua", {})
            _G.XELNAGA_REVEALED = true

            -- notifications
            Notifications:BottomToAll({text="The Cursed has been revealed by the Outpost Towers!", duration = 8})

            -- sfx
            PlaySoundOnAllClients(RNMNegativeSound())
        end
    else
        if _G.XELNAGA_REVEALED then
            -- stop revealing
            local modifier = _G.CURSED_UNIT:FindModifierByName("modifier_xelnaga_cursed_track_lua")
            if modifier then
                modifier:Destroy()
            end
            _G.XELNAGA_REVEALED = false
        end
    end
    for i =0,15,1 do
        if PlayerResource:IsValidPlayerID(i) then
            Game_Events:ObjectivesUpdate(i)
        end
    end
end

function Game_Events:KeystoneUpdate(playerid, ks_index, activators_table) -- called by item_keystone_key_lua
    local mytable = CustomNetTables:GetTableValue("keystone_status", tostring(ks_index))
    local keystone = _G.KEYSTONE_UNIT[ks_index]
    local playername = PlayerResource:GetPlayerName(playerid)

    CustomGameEventManager:Send_ServerToAllClients("keystone_hud_update", {index = ks_index, activated = false, keys = mytable.keys, max_keys = _G.KEYS_TO_ACTIVATE_KEYSTONE[CountPlayersInGame()], ent_index = keystone, activators = activators_table})

    -- checking if keystone has been completed
    if mytable.keys >= _G.KEYS_TO_ACTIVATE_KEYSTONE[CountPlayersInGame()] then
        -- full keys
        local modifier2 = keystone:FindModifierByName("modifier_keystone_full_keys_delay_lua")
        if not modifier2 then
            keystone:AddNewModifier(keystone, nil, "modifier_keystone_full_keys_delay_lua",{})
        end
    else
        -- not completed
        local modifier2 = keystone:FindModifierByName("modifier_keystone_full_keys_delay_lua")
        if modifier2 then
            modifier2:Destroy()
        end
    end

    -- javascript update for worldpanel key indication
    CustomGameEventManager:Send_ServerToAllClients("keystone_worldpanel_update", {ent_index = keystone:entindex(), keys_activated = mytable.keys})
end

function Game_Events:OnKeystoneSabotageChoiceMade(args)
    local keystone = EntIndexToHScript(args.entindex)
    keystone.sabotage_decision = args.choice
end

function Game_Events:KeystoneActivated(keystone) -- called by modifier_keystone_activation_delay_lua
    if keystone.sabotage_decision == nil then
        keystone.sabotage_decision = 0
    end
    local index = getIndexTable(_G.KEYSTONE_UNIT, keystone)
    Notifications:BottomToAll({text="Keystone " .. index .. " has been ", duration = 8})

    if keystone.sabotage_decision > 0 then
        -- actions
        -- add modifier sabotaged
        keystone:AddNewModifier(keystone, nil, "modifier_keystone_sabotaged_lua", {})

        -- notification
        Notifications:BottomToAll({text="sabotaged", style={color="red"}, continue=true})

        -- sfx
        PlaySoundOnAllClients("Keystone_activated_bad")
    else
        -- actions
        -- add modifier clear
        keystone:AddNewModifier(keystone, nil, "modifier_keystone_activatedgood_lua", {})

        -- notification
        Notifications:BottomToAll({text="successfully activated", style={color="limegreen"}, continue=true})

        -- sfx
        PlaySoundOnAllClients("Keystone_activated_good")
    end

    -- turning off the keystone indicator
    CustomGameEventManager:Send_ServerToAllClients("keystone_make_hidden", {ent_index = keystone:entindex()})
    -- update the keystone hud indicator
    CustomGameEventManager:Send_ServerToAllClients("keystone_hud_activate", {ent_index = keystone:entindex(), sabotaged = keystone.sabotage_decision})
    -- turn off sabotage prompt for cursed player
    CustomGameEventManager:Send_ServerToPlayer(_G.CURSED_UNIT:GetPlayerOwner(), "keystone_sabotage_prompt_force_close",{})

    -- check winning game condition for keystones
    Game_Events:KeystoneWinConditionCheck()

    -- updating objectives on HUD
    for i =0,15,1 do
        if PlayerResource:IsValidPlayerID(i) then
            Game_Events:ObjectivesUpdate(i)
        end
    end
end

-- check for portal modifier duration
function Game_Events:KeystoneWinConditionCheck()
    local keystones_activated_good = 0
    local keystones_activated_bad = 0
    for i=1, #_G.KEYSTONE_UNIT do
        local keystone = _G.KEYSTONE_UNIT[i]
        local modifier1 = keystone:FindModifierByName("modifier_keystone_sabotaged_lua")
        local modifier2 = keystone:FindModifierByName("modifier_keystone_activatedgood_lua")
        if modifier1 then
            keystones_activated_bad = keystones_activated_bad + 1
        elseif modifier2 then
            keystones_activated_good = keystones_activated_good + 1
        end
    end
    if keystones_activated_bad >= _G.KEYSTONES_TO_CURSED_WIN then
        -- notifications
        --Notifications:ClearTopFromAll()
        --Notifications:ClearBottomFromAll()
        Notifications:BottomToAll({text= "Too many Keystones have been sabotaged!", duration=10})
        Notifications:BottomToAll({text= "The Cursed now has vision of the remaining players!", style={color="red"}, duration = 10})

        --sfx modifiers
        for i=1, #_G.KEYSTONE_UNIT do
            local keystone = _G.KEYSTONE_UNIT[i]
            local modifier1 = keystone:FindModifierByName("modifier_keystone_sabotaged_lua")
            if modifier1 then
                keystone:AddNewModifier(keystone, nil, "modifier_keystone_sabotaged_giving_vision_lua", {})
            end
        end

        -- modifier for giving vision to others
        SPIRE_UNIT:AddNewModifier(SPIRE_UNIT, nil, "modifier_spire_giving_vision_lua", {})

        CustomGameEventManager:Send_ServerToAllClients("stop_keystone_activation_sound", {})
        PlaySoundOnAllClients("Keystone_Reveal_Location")

    elseif keystones_activated_good >= _G.KEYSTONES_TO_HUMANS_WIN then
        -- humans get all keystones required
        if not _G.SPIRE_UNIT:HasModifier("modifier_endgame_portal_lua") then
            _G.SPIRE_UNIT:AddNewModifier(_G.SPIRE_UNIT, nil, "modifier_endgame_portal_lua", {}) --duration = _G.ENDGAME_PORTAL_DURATION

            -- notifications
            for i=0,15,1 do
                if PlayerResource:IsValidPlayerID(i) then
                    Notifications:ClearBottom(i)
                    Notifications:Bottom(i, {text="The Escape Portal has been opened!", duration = 10})
                    PingLocationOnClient(_G.SPIRE_UNIT:GetAbsOrigin(), i)
                    if _G.CURSED_UNIT:GetPlayerOwnerID() == i then
                        Notifications:Bottom(i, {text="Eliminate remaining players before they escape!", duration = 10})
                    else
                        Notifications:Bottom(i, {text="Gather there to evacuate and win the game!", duration = 10})
                    end
                end
            end

            CustomGameEventManager:Send_ServerToAllClients("stop_keystone_activation_sound", {})
            PlaySoundOnAllClients("Endgame_portal_Created")
        end
            
    end
end

function Game_Events:EndgamePortalSuccessSequence()
    self.endgameportalmainunitfx = {}
    for i=0,15,1 do
        if PlayerResource:IsValidPlayerID(i) then
            -- camera to spire unit
            MoveCameraToTarget(_G.SPIRE_UNIT, i, 0.5)

            --sfx for winning main units
            local main_unit = GetMainUnit(i)
            if main_unit:IsAlive() and (IsValidEntity(main_unit)) and (main_unit ~= _G.CURSED_UNIT) then
                if GetDistance(main_unit:GetAbsOrigin(), _G.SPIRE_UNIT:GetAbsOrigin()) <= _G.ENDGAME_PORTAL_DISTANCE + 10 then
                    local fx = ParticleManager:CreateParticle("particles/econ/events/ti10/teleport/teleport_end_ti10.vpcf", PATTACH_ABSORIGIN_FOLLOW, main_unit)
                    ParticleManager:SetParticleControlEnt(fx, 0, main_unit, PATTACH_ABSORIGIN_FOLLOW, nil, main_unit:GetAbsOrigin(), true)
                    ParticleManager:SetParticleControlEnt(fx, 1, main_unit, PATTACH_ABSORIGIN_FOLLOW, nil, main_unit:GetAbsOrigin(), true)
                    table.insert(self.endgameportalmainunitfx, fx)
                end
            end
        end
    end

    EmitSoundOn("Hero_Wisp.Relocate", SPIRE_UNIT)

    -- anims
    _G.SPIRE_UNIT:StartGestureWithPlaybackRate(ACT_DOTA_IDLE, 0.05)
    --StartAnimation(_G.SPIRE_UNIT, {duration=99, activity=ACT_DOTA_IDLE, rate=0.05})

    -- notifications
    Notifications:ClearTopFromAll()
    Notifications:ClearBottomFromAll()
    Notifications:BottomToAll({text= "Survivors have escaped!", duration=30.0})

    -- in utils.lua
    EndGameActions()

    -- action sequence
    Timers:CreateTimer(2.5,function()
        -- sfx
        StopSoundOn("Hero_Wisp.Relocate", SPIRE_UNIT)

        -- ending sfx for each winning main unit
        for i=1,10,1 do
            if self.endgameportalmainunitfx[i] then
                ParticleManager:DestroyParticle( self.endgameportalmainunitfx[i], false )
                ParticleManager:ReleaseParticleIndex(self.endgameportalmainunitfx[i])
            end
        end

        -- extra sfx for each winning main unit
        for i = 0, 15, 1 do
            if PlayerResource:IsValidPlayerID(i) then
                local main_unit = GetMainUnit(i)
                if main_unit:IsAlive() and (IsValidEntity(main_unit)) and (main_unit ~= _G.CURSED_UNIT) then
                    if GetDistance(main_unit:GetAbsOrigin(), _G.SPIRE_UNIT:GetAbsOrigin()) <= _G.ENDGAME_PORTAL_DISTANCE + 10 then
                        --modifier for hidden
                        main_unit:AddNewModifier(nil,nil,"modifier_endgame_teleported_away", {})
                        --sfx
                        EmitSoundOn("Portal.Hero_Disappear", main_unit)
                        local effect = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_start_l_ti5.vpcf", PATTACH_ABSORIGIN_FOLLOW, main_unit)
                        ParticleManager:SetParticleControlEnt(effect, 0, main_unit, PATTACH_ABSORIGIN_FOLLOW, nil, main_unit:GetAbsOrigin(), true)
                        ParticleManager:ReleaseParticleIndex(effect)
                    end
                end
            end
        end

        -- deleting spire unit modifier effect
        local modifier = _G.SPIRE_UNIT:FindModifierByName("modifier_endgame_portal_lua")
        if modifier then
            modifier:Destroy()
        end

        -- anims
        _G.SPIRE_UNIT:RemoveGesture(ACT_DOTA_IDLE)
        _G.SPIRE_UNIT:StartGestureWithPlaybackRate(ACT_DOTA_DIE, 0.4)
    end)

    Timers:CreateTimer(4.2,function()
        -- camera to cursed unit
        for i=0,15,1 do
            if PlayerResource:IsValidPlayerID(i) then
                MoveCameraToTarget(_G.CURSED_UNIT, i, 0.5)
            end
        end

        --anim
        _G.SPIRE_UNIT:StopAnimation()

        -- colouring playername
        local playername = PlayerResource:GetPlayerName(_G.CURSED_UNIT:GetPlayerOwnerID())
        local teamID = PlayerResource:GetTeam(_G.CURSED_UNIT:GetPlayerOwnerID())
        local color = ColorForTeam(teamID)
        Notifications:BottomToAll({text= playername .. " ", duration=30.0, style = {color="rgb(" .. color[1] .. "," .. color[2] .. "," .. color[3] .. ")"}})
        Notifications:BottomToAll({text="was the Cursed!",  continue=true})

        --human win announcer
        local announcer_sounds = {}
        --for humans
        announcer_sounds[1] = "announcer_dlc_stanleyparable_announcer_victory_01"
        announcer_sounds[2] = "announcer_dlc_stanleyparable_announcer_victory_02"
        announcer_sounds[3] = "announcer_dlc_stanleyparable_announcer_victory_03"
        announcer_sounds[4] = "announcer_dlc_stanleyparable_announcer_victory_04"
        announcer_sounds[5] = "announcer_dlc_stanleyparable_announcer_victory_05"
        announcer_sounds[6] = "announcer_dlc_stanleyparable_announcer_victory_06"
        announcer_sounds[7] = "announcer_dlc_stanleyparable_announcer_victory_07"
        announcer_sounds[8] = "announcer_dlc_stanleyparable_announcer_victory_08"
        announcer_sounds[9] = "announcer_dlc_stanleyparable_announcer_victory_09"
        --for werewolf
        announcer_sounds[10] = "announcer_dlc_stanleyparable_announcer_defeat_01"
        announcer_sounds[11] = "announcer_dlc_stanleyparable_announcer_defeat_03"
        announcer_sounds[12] = "announcer_dlc_stanleyparable_announcer_defeat_04"
        announcer_sounds[13] = "announcer_dlc_stanleyparable_announcer_defeat_06"
        for i=0,10 do
            if i == victim_player_id then
                local rndm_number = RandomInt(10,13)
                EmitAnnouncerSoundForPlayer(announcer_sounds[rndm_number], i)
            else
                local rndm_number = RandomInt(1,9)
                EmitAnnouncerSoundForPlayer(announcer_sounds[rndm_number], i)
            end
        end
    end)
end

--====================================================== hero selection =============================================================

function Game_Events:OnHeroSelected(args)
    local playerid = args.playerid
    local herostring = args.herochoice
    local goldcost = args.gold * (-1)
    if PlayerResource:IsValidPlayerID(playerid) and GetMainUnit(playerid):IsAlive() and IsValidEntity(GetMainUnit(playerid)) then
        local farmer = GetMainUnit(playerid)
        if farmer == _G.CURSED_UNIT and IsInCursedForm(farmer) then
            SendErrorMessage(playerid, "Cannot choose class in Cursed Form")
            return
        end
        local hPlayer = PlayerResource:GetPlayer(playerid)
        local fake_hero = GetFakeHero(playerid)
        local unit = CreateUnitByName(herostring, farmer:GetAbsOrigin(), true, fake_hero, fake_hero, PlayerResource:GetTeam(playerid))
        unit:SetOwner(fake_hero)
        unit:SetControllableByPlayer(playerid, true)
        PlayerResource:NewSelection(playerid, unit)
        hPlayer:SetAssignedHeroEntity(unit)
        unit:Hold()

        -- selection overrides
        fake_hero:SetSelectionOverride(unit)
        farmer:SetSelectionOverride(unit)

        -- CNT
        CustomNetTables:SetTableValue("player_hero", tostring(playerid), {chosen = true, hero = herostring, needrespawn = false, upgrade_number = 0, upgrade_choices = {}})

        local newtable = UpdateNetTable(CustomNetTables:GetTableValue("player_important_units", tostring(playerid)), "main_unit_index", unit:entindex())
        CustomNetTables:SetTableValue("player_important_units", tostring(playerid), newtable)

        -- adding abilities for generic upgrades
        for i=1,8,1 do
            unit:AddAbility("generic_upgrade_"..i.."_lua")
        end
        -- level up abilities
        InitAbilities(unit)

        -- make sure ranger's displace is not leveled
        local abil = unit:FindAbilityByName("ranger_swap_arrow_teleport_lua")
        if abil then
            abil:SetLevel(0)
        end
        -- make sure guardian's resurrect is not leveled
        abil = unit:FindAbilityByName("guardian_resurrect_lua")
        if abil then
            abil:SetLevel(0)
        end
        -- make sure illusionist invisible wall is not leveled
        abil = unit:FindAbilityByName("illusionist_invisible_wall_lua")
        if abil then
            abil:SetLevel(0)
        end

        -- adding abilities for hero-specific upgrades
        for i=1,3,1 do
            unit:AddAbility(herostring .. "_upgrade_" .. i)
        end

        --transfer items
        for i=0,8,1 do
            local item = farmer:GetItemInSlot(i)
            if item ~= nil then
                unit:AddItem(item)
            end
        end

        -- renewing cursed xelnaga tracking modifier, if any
        if farmer:HasModifier("modifier_xelnaga_cursed_track_lua") then
            unit:AddNewModifier(unit,nil,"modifier_xelnaga_cursed_track_lua", {})
        end

        --sfx
        EmitSoundOn("HeroPicker.Selected",unit)
        local particle_cast = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_cast_lightning.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControlEnt(effect_cast, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true)
        ParticleManager:ReleaseParticleIndex(effect_cast)
        particle_cast = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_end_v2.vpcf"
        effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, unit )
        ParticleManager:SetParticleControl(effect_cast, 0, unit:GetOrigin())
        ParticleManager:ReleaseParticleIndex(effect_cast)

        if farmer == _G.CURSED_UNIT then
            if _G.CURSED_CREATURE == "werewolf" then                
                -- pass cursed abilities and upgrades
                unit:AddAbility("wolf_sniff")
                abil = unit:FindAbilityByName("wolf_sniff")
                abil:SetLevel(farmer:FindAbilityByName("wolf_sniff"):GetLevel())
                
                unit:AddAbility("mirana_leap_lua")
                abil = unit:FindAbilityByName("mirana_leap_lua")
                abil:SetLevel(farmer:FindAbilityByName("mirana_leap_lua"):GetLevel())

                unit:AddAbility("werewolf_instinct_lua")
                abil = unit:FindAbilityByName("werewolf_instinct_lua")
                abil:SetLevel(farmer:FindAbilityByName("werewolf_instinct_lua"):GetLevel())

                unit:AddAbility("werewolf_crit_strike_lua")
                abil = unit:FindAbilityByName("werewolf_crit_strike_lua")
                abil:SetLevel(farmer:FindAbilityByName("werewolf_crit_strike_lua"):GetLevel())

                unit:AddAbility("ursa_enrage_lua")
				abil = unit:FindAbilityByName("ursa_enrage_lua")
				abil:SetLevel(farmer:FindAbilityByName("ursa_enrage_lua"):GetLevel())
            elseif _G.CURSED_CREATURE == "vampire" then
                -- pass cursed abilities and upgrades
                unit:AddAbility("vampire_ascend_lua")
                
                unit:AddAbility("vampire_blood_bath_lua")
                local abil = unit:FindAbilityByName("vampire_blood_bath_lua")
                abil:SetLevel(farmer:FindAbilityByName("vampire_blood_bath_lua"):GetLevel())

                unit:AddAbility("vampire_delirium_lua")
                abil = unit:FindAbilityByName("vampire_delirium_lua")
                abil:SetLevel(farmer:FindAbilityByName("vampire_delirium_lua"):GetLevel())

                unit:AddAbility("vampire_sol_skin_lua")
                abil = unit:FindAbilityByName("vampire_sol_skin_lua")
                abil:SetLevel(farmer:FindAbilityByName("vampire_sol_skin_lua"):GetLevel())

                unit:AddAbility("vampire_shadow_ward_lua")
				abil = unit:FindAbilityByName("vampire_shadow_ward_lua")
                abil:SetLevel(farmer:FindAbilityByName("vampire_shadow_ward_lua"):GetLevel())
                
                unit:AddAbility("vampire_impact_lua")
                abil = unit:FindAbilityByName("vampire_ascend_lua")
                abil:SetLevel(farmer:FindAbilityByName("vampire_ascend_lua"):GetLevel())
            end
            -- adding xelnaga disable ability
            unit:AddAbility("xelnaga_tower_deactivate_lua")
            local abil = unit:FindAbilityByName("xelnaga_tower_deactivate_lua")
            abil:SetLevel(1)

            -- update panorama for cursed player
            CustomGameEventManager:Send_ServerToPlayer(hPlayer, "update_cursed_unit_entity_index",{ent_index = unit:entindex()})

            -- update global definition of cursed unit
            _G.CURSED_UNIT = unit
        end

        -- update definition of main unit for the player
        hPlayer.Main_Unit = unit
        
        -- kill farmer from game
        farmer:SetUnitCanRespawn(false)
        farmer:ForceKill(false)

        -- msg for chosen hero
        local ability_name = nil
        if herostring == "defender" then
            ability_name = "choose_defender_class_lua"
        elseif herostring == "scout" then
            ability_name = "choose_scout_class_lua"
        elseif herostring == "barbarian" then
            ability_name = "choose_barbarian_class_lua"
        elseif herostring == "ranger" then
            ability_name = "choose_ranger_class_lua"
        elseif herostring == "illusionist" then
            ability_name = "choose_illusionist_class_lua"
        elseif herostring == "guardian" then
            ability_name = "choose_guardian_class_lua"
        elseif herostring == "boomer" then
            ability_name = "choose_boomer_class_lua"
        elseif herostring == "samurai" then
            ability_name = "choose_samurai_class_lua"
        elseif herostring == "druid" then
            ability_name = "choose_druid_class_lua"
        elseif herostring == "assassin" then
            ability_name = "choose_assassin_class_lua"
        end
        --Notifications:Top(playerid, {ability = ability_name, duration=7})
        Notifications:Bottom(playerid, {text="You have chosen the " .. herostring .. " class", duration=8})

        -- updating hero panel for the rest of the players
        if _G.CHOSEN_HEROES == nil then
            _G.CHOSEN_HEROES = {}
        end
        table.insert(_G.CHOSEN_HEROES, herostring)
        CustomGameEventManager:Send_ServerToAllClients("hero_panel_update", _G.CHOSEN_HEROES)

        -- set can respawn
        unit:SetUnitCanRespawn(true)

        -- animations for jug and snapfire
        if unit:GetUnitName() == "samurai" or unit:GetUnitName() == "boomer" then
            unit:AddNewModifier(nil, nil, "modifier_walking_anim_fix_lua", {})
        end

        -- set custom label
        -- playernames for villager
        local teamID = unit:GetTeam()
        local color = ColorForTeam(teamID)
        local playername = PlayerResource:GetPlayerName(playerid)
        unit:SetCustomHealthLabel( playername, color[1], color[2], color[3] )

        -- camera
        MoveCameraToTarget(unit, playerid, 0.3)

        -- modify player gold
        Resources:ModifyGold( playerid, goldcost )

        -- initiate hero upgrades button
        CustomGameEventManager:Send_ServerToPlayer(hPlayer, "initialize_hero_upgrades", {hero = herostring, num_players = CountPlayersInGame()})

    end
end

--============================================== werewolf transformation sequences ==================================================

function Game_Events:TransformIntoCursed()
    if _G.CURSED_CREATURE == "werewolf" then
        --adding real werewolf effect modifier
        if GameRules:IsDaytime() then
            _G.CURSED_UNIT:AddNewModifier( _G.CURSED_UNIT, nil, "modifier_werewolf_day", {} )
        else
            _G.CURSED_UNIT:AddNewModifier( _G.CURSED_UNIT, nil, "modifier_werewolf_night", {} )
        end

        -- remove playername health label
        _G.CURSED_UNIT:SetCustomHealthLabel( "Werewolf", 200, 50, 50 )
        
        -- sfx
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf", PATTACH_ABSORIGIN, _G.CURSED_UNIT )
        ParticleManager:SetParticleControlEnt( nFXIndex, 1, _G.CURSED_UNIT, PATTACH_ABSORIGIN_FOLLOW, nil, _G.CURSED_UNIT:GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        EmitSoundOnEntityForPlayer("Hero_Invoker.DeafeningBlast.Immortal", _G.CURSED_UNIT, _G.CURSED_UNIT:GetPlayerOwnerID())

    elseif _G.CURSED_CREATURE == "vampire" then
        --adding real werewolf effect modifier
        if GameRules:IsDaytime() then
            _G.CURSED_UNIT:AddNewModifier( _G.CURSED_UNIT, nil, "modifier_vampire_day", {} )
        else
            _G.CURSED_UNIT:AddNewModifier( _G.CURSED_UNIT, nil, "modifier_vampire_night", {} )
        end

        -- remove playername health label
        _G.CURSED_UNIT:SetCustomHealthLabel( "Vampire", 200, 50, 50 )
        
        -- sfx
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf", PATTACH_ABSORIGIN, _G.CURSED_UNIT )
        --ParticleManager:SetParticleControlEnt( nFXIndex, 1, _G.CURSED_UNIT, PATTACH_ABSORIGIN_FOLLOW, nil, _G.CURSED_UNIT:GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_end.vpcf", PATTACH_ABSORIGIN, _G.CURSED_UNIT )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        EmitSoundOnEntityForPlayer("Hero_Nightstalker.Darkness", _G.CURSED_UNIT, _G.CURSED_UNIT:GetPlayerOwnerID())
    end    

    -- purge off both good and bad buffs
    _G.CURSED_UNIT:Purge(true, true, false, false, false)

    -- ability swaps
    Game_Events:AbilitySwapToCursed()
    _G.CURSED_UNIT:Interrupt()
    
    -- cooldown for pano
    CustomGameEventManager:Send_ServerToPlayer(_G.CURSED_UNIT:GetPlayerOwner(), "start_cursed_transform_cooldown", {})

	if _G.CURSED_UNIT:GetUnitName() ~= "farmer" then
        -- force close upgrades, if any
		CustomGameEventManager:Send_ServerToPlayer(_G.CURSED_UNIT:GetPlayerOwner(), "force_close_hero_upgrades", {})
        -- lock upgrades, if any
		CustomGameEventManager:Send_ServerToPlayer(_G.CURSED_UNIT:GetPlayerOwner(), "lock_hero_upgrades", {})
	end
end

function Game_Events:TransformFromCursed()
    if _G.CURSED_CREATURE == "werewolf" then
        -- remove modifier
        local modifier = _G.CURSED_UNIT:FindModifierByName("modifier_werewolf_day")
        if modifier then
            modifier:Destroy()
        else
            modifier = _G.CURSED_UNIT:FindModifierByName("modifier_werewolf_night")
            if modifier then
                modifier:Destroy()
            end
        end

        -- sfx
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", PATTACH_ABSORIGIN, _G.CURSED_UNIT )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj_burst.vpcf", PATTACH_ABSORIGIN, _G.CURSED_UNIT )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        
        EmitSoundOnEntityForPlayer("Hero_Nightstalker.Void.Nihility", _G.CURSED_UNIT, _G.CURSED_UNIT:GetPlayerOwnerID())
    elseif _G.CURSED_CREATURE == "vampire" then
        -- remove modifier
        local modifier = _G.CURSED_UNIT:FindModifierByName("modifier_vampire_day")
        if modifier then
            modifier:Destroy()
        else
            modifier = _G.CURSED_UNIT:FindModifierByName("modifier_vampire_night")
            if modifier then
                modifier:Destroy()
            end
        end

        modifier = _G.CURSED_UNIT:FindModifierByName("modifier_vampire_flying_lua")
        if modifier then
            modifier:Destroy()
        end

        -- sfx
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_hit.vpcf", PATTACH_ABSORIGIN, _G.CURSED_UNIT )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_death_prophet/death_prophet_death.vpcf", PATTACH_ABSORIGIN, _G.CURSED_UNIT )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        
        EmitSoundOnEntityForPlayer("Hero_Nightstalker.Trickling_Fear", _G.CURSED_UNIT, _G.CURSED_UNIT:GetPlayerOwnerID())
    end

    -- playernames for villager
	local teamID = _G.CURSED_UNIT:GetTeam()
	local color = ColorForTeam(teamID)
	local playername = PlayerResource:GetPlayerName(_G.CURSED_UNIT:GetPlayerOwnerID())
    _G.CURSED_UNIT:SetCustomHealthLabel( playername, color[1], color[2], color[3] )

    -- ability swaps
    Game_Events:AbilitySwapFromCursed()
    _G.CURSED_UNIT:Interrupt()
    
    -- cooldown for pano
    CustomGameEventManager:Send_ServerToPlayer(_G.CURSED_UNIT:GetPlayerOwner(), "start_cursed_transform_cooldown", {})

    -- unlock upgrades, if any
	if _G.CURSED_UNIT:GetUnitName() ~= "farmer" then
		CustomGameEventManager:Send_ServerToPlayer(_G.CURSED_UNIT:GetPlayerOwner(), "unlock_hero_upgrades", {})
    end
    
    -- if it is defender
    local shield_abil = _G.CURSED_UNIT:FindAbilityByName("defender_energy_shield_lua")
    if shield_abil then
        if shield_abil:IsCooldownReady() then
            shield_abil:OnUpgrade()
        end
    end
end

function Game_Events:AbilitySwapToCursed()
    if _G.CURSED_UNIT.Is_In_Build_Menu == true then
        _G.CURSED_UNIT:CastAbilityImmediately(_G.CURSED_UNIT:FindAbilityByName("build_menu_cancel_lua"), _G.CURSED_UNIT:GetPlayerOwnerID())
    end

    local unit_name = _G.CURSED_UNIT:GetUnitName()

    local abil = nil

    local cursedabilnum = #_G.CURSED_ABILITY_TABLE[_G.CURSED_CREATURE]

    for i=0,5,1 do
        abil = _G.CURSED_UNIT:GetAbilityByIndex(i)
        if not IsItemInTable(_G.CURSED_ABILITY_TABLE[_G.CURSED_CREATURE], abil:GetAbilityName()) then
            if i < 5 then
                -- basic abils
                if i <= (cursedabilnum - 2) then
                    _G.CURSED_UNIT:SwapAbilities(abil:GetAbilityName(), _G.CURSED_ABILITY_TABLE[_G.CURSED_CREATURE][i+1], false, true)
                else
                    abil:SetActivated(false)
                    abil:SetHidden(true)
                end
            else
                --ult abil for last abil index
                _G.CURSED_UNIT:SwapAbilities(abil:GetAbilityName(), _G.CURSED_ABILITY_TABLE[_G.CURSED_CREATURE][cursedabilnum], false, true)
            end
        else
            abil:SetActivated(true)
            abil:SetHidden(false)
        end

    end

end

function Game_Events:AbilitySwapFromCursed()
    local unit_name = _G.CURSED_UNIT:GetUnitName()

    local abil = nil

    local abilcount = #_G.MAIN_UNIT_ABILITY_TABLE[unit_name]

    for i = 0,5,1 do
        abil = _G.CURSED_UNIT:GetAbilityByIndex(i)
        if not IsItemInTable(_G.MAIN_UNIT_ABILITY_TABLE[unit_name], abil:GetAbilityName()) then
            if i <= (abilcount - 2) then
                _G.CURSED_UNIT:SwapAbilities(abil:GetAbilityName(), _G.MAIN_UNIT_ABILITY_TABLE[unit_name][i+1], false, true)
            else
                if i ~= 5 then
                    abil:SetActivated(false)
                    abil:SetHidden(true)
                else
                    -- convert ulti
                    _G.CURSED_UNIT:SwapAbilities(abil:GetAbilityName(), _G.MAIN_UNIT_ABILITY_TABLE[unit_name][abilcount], false, true)
                end
            end
        else
            abil:SetActivated(true)
            abil:SetHidden(false)
        end
    end

end

--============================================== alpha zombie intitiation ==================================================

function Game_Events:InitializeAlphaZombie(playerid)
    if PlayerResource:IsValidPlayerID(playerid) and GetMainUnit(playerid):IsAlive() and IsValidEntity(GetMainUnit(playerid)) then
        local farmer = GetMainUnit(playerid)
        local hPlayer = PlayerResource:GetPlayer(playerid)
        local fake_hero = GetFakeHero(playerid)
        local unit = CreateUnitByName("zombie_main_unit", farmer:GetAbsOrigin(), true, fake_hero, fake_hero, PlayerResource:GetTeam(playerid))
        unit:SetOwner(fake_hero)
        unit:SetControllableByPlayer(playerid, true)
        PlayerResource:NewSelection(playerid, unit)
        hPlayer:SetAssignedHeroEntity(unit)
        unit:Hold()

        -- selection overrides
        fake_hero:SetSelectionOverride(unit)
        farmer:SetSelectionOverride(unit)

        -- CNT
        local newtable = UpdateNetTable(CustomNetTables:GetTableValue("player_important_units", tostring(playerid)), "main_unit_index", unit:entindex())
        CustomNetTables:SetTableValue("player_important_units", tostring(playerid), newtable)
        
        -- level up abilities
        InitAbilities(unit)

        -- make sure acid is not leveled
        local abil = unit:FindAbilityByName("zombie_acid_lua")
        if abil then
            abil:SetLevel(0)
        end

        -- make sure ult starts with a cooldown
        abil = unit:FindAbilityByName("zombie_summon_wave_lua")
        if abil then
            abil:StartCooldown(25)
        end

        -- renewing cursed xelnaga tracking modifier, if any
        if farmer:HasModifier("modifier_xelnaga_cursed_track_lua") then
            unit:AddNewModifier(unit,nil,"modifier_xelnaga_cursed_track_lua", {})
        end

        --sfx
        local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/undying/undying_pale_augur/undying_pale_augur_decay.vpcf", PATTACH_ABSORIGIN, unit )
        ParticleManager:SetParticleControl(effect_cast, 0, unit:GetOrigin())
        ParticleManager:ReleaseParticleIndex(effect_cast)

        effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_tower_destruction_lv.vpcf", PATTACH_ABSORIGIN, unit )
        ParticleManager:SetParticleControl(effect_cast, 0, unit:GetOrigin())
        ParticleManager:ReleaseParticleIndex(effect_cast)

        effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green_mid.vpcf", PATTACH_ABSORIGIN, unit )
        ParticleManager:SetParticleControl(effect_cast, 0, unit:GetOrigin())
        ParticleManager:ReleaseParticleIndex(effect_cast)

        EmitSoundOn("Hero_Undying.SoulRip.Cast",unit)

        -- update definition of main unit for the player
        _G.CURSED_UNIT = unit
        hPlayer.Main_Unit = unit
        
        -- kill farmer from game
        farmer:SetUnitCanRespawn(false)
        farmer:ForceKill(false)

        -- set custom label
        _G.CURSED_UNIT:SetCustomHealthLabel( "Zombie", 200, 50, 50 )

        -- camera
        MoveCameraToTarget(unit, playerid, 0.3)

        -- modify player gold
        Resources:SetGold( playerid, 0 )

        -- force close hero selection if any
        CustomGameEventManager:Send_ServerToPlayer(hPlayer, "turn_off_display_hero_selection",{})

        -- initialize zombie unit count
        _G.ZOMBIE_UNIT_COUNT = 0
    end
end

--============================================ Game Events for deaths and revives ==================================================

function Game_Events:OnCursedKilled(victim,victim_player_id,attacker,attacker_player_id)
    Notifications:ClearBottomFromAll()

    --actions to take for each player
    for i=0,10 do
        if i == victim_player_id then
            --for werewolf player
            Notifications:Bottom(i, {text="You have failed to kill all the Villagers... The Villagers have won.", duration=15, style={color="red"}})
        elseif i == attacker_player_id then
            --for killer player
            Notifications:Bottom(i, {text="You have eliminated the Cursed! Villagers win!", duration=15})
            --GameRules:SetGameWinner(PlayerResource:GetTeam(attacker_player_id))
        elseif PlayerResource:GetPlayer(i) ~= nil then
            --for all other players
            Notifications:Bottom(i, {text="The Cursed has been neutralised! Villagers win!", duration=15})
        end
        -- camera pan to cursed unit
        MoveCameraToTarget(victim, i, 0.5)
    end
    
    -- notification for all
    local playername = PlayerResource:GetPlayerName(victim_player_id)
    local teamID = victim:GetTeam()
    local color = ColorForTeam(teamID)
    Notifications:BottomToAll({text= playername .. " ", duration=15.0, style = {color="rgb(" .. color[1] .. "," .. color[2] .. "," .. color[3] .. ")"}})
    Notifications:BottomToAll({text="was the Cursed!",  continue=true})
    
    --human win announcer
    local announcer_sounds = {}
    --for humans
    announcer_sounds[1] = "announcer_dlc_stanleyparable_announcer_victory_01"
    announcer_sounds[2] = "announcer_dlc_stanleyparable_announcer_victory_02"
    announcer_sounds[3] = "announcer_dlc_stanleyparable_announcer_victory_03"
    announcer_sounds[4] = "announcer_dlc_stanleyparable_announcer_victory_04"
    announcer_sounds[5] = "announcer_dlc_stanleyparable_announcer_victory_05"
    announcer_sounds[6] = "announcer_dlc_stanleyparable_announcer_victory_06"
    announcer_sounds[7] = "announcer_dlc_stanleyparable_announcer_victory_07"
    announcer_sounds[8] = "announcer_dlc_stanleyparable_announcer_victory_08"
    announcer_sounds[9] = "announcer_dlc_stanleyparable_announcer_victory_09"
    --for werewolf
    announcer_sounds[10] = "announcer_dlc_stanleyparable_announcer_defeat_01"
    announcer_sounds[11] = "announcer_dlc_stanleyparable_announcer_defeat_03"
    announcer_sounds[12] = "announcer_dlc_stanleyparable_announcer_defeat_04"
    announcer_sounds[13] = "announcer_dlc_stanleyparable_announcer_defeat_06"
    for i=0,10 do
        if i == victim_player_id then
            local rndm_number = RandomInt(10,13)
            EmitAnnouncerSoundForPlayer(announcer_sounds[rndm_number], i)
        else
            local rndm_number = RandomInt(1,9)
            EmitAnnouncerSoundForPlayer(announcer_sounds[rndm_number], i)
        end
    end

    -- this is in utils.lua
    EndGameActions()
end

-- check for test mode. scenario for last non-cursed dying
function Game_Events:OnHeroNeedsRevive(victim,victim_player_id)
    local location = victim:GetAbsOrigin()
    local victim_player = PlayerResource:GetPlayer(victim_player_id)

    -- check if it was the last player
    if CountNonCursedPlayersAlive() < 1 then
        --if TOOLS_MODE == false then
            -- end game with cursed as winner
            -- camera
            for i=0,15,1 do
                if PlayerResource:IsValidPlayerID(i) then
                    MoveCameraToTarget(_G.CURSED_UNIT, i, 0.5)
                end
            end
            
            -- notifications
            Notifications:ClearBottomFromAll()
            Notifications:BottomToAll({text= "All players have been eliminated! Cursed wins!", duration=15.0})

            -- colouring playername
            local playername = PlayerResource:GetPlayerName(_G.CURSED_UNIT:GetPlayerOwnerID())
            local teamID = PlayerResource:GetTeam(_G.CURSED_UNIT:GetPlayerOwnerID())
            local color = ColorForTeam(teamID)
            Notifications:BottomToAll({text= playername .. " ", duration=15.0, style = {color="rgb(" .. color[1] .. "," .. color[2] .. "," .. color[3] .. ")"}})
            Notifications:BottomToAll({text="was the Cursed!",  continue=true})

            EmitGlobalSound("Conquest.Stinger.HulkCreep")
            print("Game ended. Cursed won.")
            --GameRules:SetGameWinner(PlayerResource:GetTeam(_G.CURSED_UNIT:GetPlayerOwnerID()))
            
            -- this is in utils.lua
            EndGameActions()
            return
        --end
    end

    -- tombstone to revive
    local dummy = CreateUnitByName("tombstone_unit", location, true, nil, nil, PlayerResource:GetTeam(victim_player_id))
    dummy:SetOwner(GetFakeHero(victim_player_id))
    dummy:SetForwardVector(Vector(0,-1,0))
    dummy:AddNewModifier(dummy, nil, "modifier_revival_dummy", {})

    -- camera
    MoveCameraToTarget(dummy, victim_player_id, 1.0)

    -- countdown for victim player
    -- currently using hp of tombstone

    -- close hero selection
    CustomGameEventManager:Send_ServerToPlayer(victim_player, "turn_off_display_hero_selection",{})

    -- global penalty modifier
    if _G.PENALTY_DUMMY_UNIT == nil then
        _G.PENALTY_DUMMY_UNIT = CreateUnitByName("dummy_unit", Vector(0,0,0), true, nil, nil, DOTA_TEAM_NEUTRALS)
        _G.PENALTY_DUMMY_UNIT:AddAbility("player_death_global_penalty_lua")
        local abil = _G.PENALTY_DUMMY_UNIT:FindAbilityByName("player_death_global_penalty_lua")
        InitAbilities(_G.PENALTY_DUMMY_UNIT)
    else
        local abil = _G.PENALTY_DUMMY_UNIT:FindAbilityByName("player_death_global_penalty_lua")
        if abil then
            if abil:GetLevel() < abil:GetMaxLevel() then
                abil:SetLevel(1 + abil:GetLevel())
            end
        else
            _G.PENALTY_DUMMY_UNIT:AddAbility("player_death_global_penalty_lua")
            InitAbilities(_G.PENALTY_DUMMY_UNIT)
        end
    end
    
    -- notifs
    local playername = PlayerResource:GetPlayerName(victim_player_id)
    local teamID = victim:GetTeam()
    local color = ColorForTeam(teamID)
    Notifications:BottomToAll({text= playername .. " ", duration=10, style = {color="rgb(" .. color[1] .. "," .. color[2] .. "," .. color[3] .. ")"} })
    Notifications:BottomToAll({text="has just been killed. Revive him/her!",  continue=true})

    -- sfx
    PlaySoundOnAllClients("Announcer.Hero_Death")
    
    -- update playerboard
    CustomGameEventManager:Send_ServerToAllClients("player_need_revive", {playerid = victim_player_id})

    -- update objectives HUD
    for i =0,15,1 do
        if PlayerResource:IsValidPlayerID(i) then
            Game_Events:ObjectivesUpdate(i)
        end
    end
end

function Game_Events:OnTombstoneRightClicked(args)
    local unit = EntIndexToHScript(args.entindex)
    local target = EntIndexToHScript(args.targetindex)
    local playerid = unit:GetPlayerOwnerID()

    -- doing revivals
    if target:HasModifier("modifier_revival_dummy") then
        if unit == GetMainUnit(playerid) and unit:GetUnitName() == "guardian" then
            -- revival
            if IsInCursedForm(unit) then
                SendErrorMessage(playerid, "Cannot revive in Cursed Form")
                unit:MoveToPosition(target:GetAbsOrigin())
            -- add revive abil and cast it on dummy
            else
                if target:HasModifier("modifier_player_being_revived") then
                    SendErrorMessage(playerid, "Only 1 Hero can revive at a time")
                    unit:MoveToPosition(target:GetAbsOrigin())
                else
                    --local abil = unit:FindAbilityByName("tombstone_revive_lua")
                    --if not abil then
                    --    unit:AddAbility("tombstone_revive_lua")
                    --    abil = unit:FindAbilityByName("tombstone_revive_lua")
                    --end
                    --abil:SetLevel(1)
                    local abil = unit:FindAbilityByName("tombstone_revive_lua")
                    unit:CastAbilityOnTarget(target, abil, playerid)
                end
            end
        else
            SendErrorMessage(playerid, "Only Guardian can revive")
            unit:MoveToPosition(target:GetAbsOrigin())
        end
    end


end

function Game_Events:TurnTombstoneIntoGhost(tombstone, victim_player_id)

    -- notifs
    local playername = PlayerResource:GetPlayerName(victim_player_id)
    local teamID = tombstone:GetTeam()
    local color = ColorForTeam(teamID)
    Notifications:BottomToAll({text= playername .. " ", duration=8, style = {color="rgb(" .. color[1] .. "," .. color[2] .. "," .. color[3] .. ")"} })
    Notifications:BottomToAll({text="has passed away for good",  continue=true})

    Notifications:Top(victim_player_id, {text="You will now play as a Ghost", duration=_G.WOLF_GHOST_SPAWN_TIME})
    local location = tombstone:GetAbsOrigin()

    -- ghost team establishing
    if _G.GHOST_TEAM == nil then
        _G.GHOST_TEAM = PlayerResource:GetTeam(victim_player_id)
    end

    -- respawn timer notification
    local respawn_timer = _G.WOLF_GHOST_SPAWN_TIME
    local respawn_timer_interval = 1
    Timers:CreateTimer(0, function()
        if respawn_timer > 0 then
            Notifications:Top(victim_player_id, {text = respawn_timer, duration = respawn_timer_interval, style = {color="red"}})
            respawn_timer = respawn_timer - respawn_timer_interval
            return respawn_timer_interval
        end
    end)

    -- sfx for death
    local sfx_dummy = CreateUnitByName("dummy_unit", location, true, nil, nil, PlayerResource:GetTeam(victim_player_id))
    sfx_dummy:AddNewModifier(sfx_dummy, nil, "modifier_dummy_unit", {duration = _G.WOLF_GHOST_SPAWN_TIME})
    local particle_cast = "particles/units/heroes/hero_rubick/rubick_doom.vpcf"
    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, sfx_dummy )
    ParticleManager:SetParticleControl(self.effect_cast, 0, sfx_dummy:GetOrigin())
    EmitGlobalSound("versus_screen.dire")

    -- camera
    MoveCameraToTarget( sfx_dummy, victim_player_id, 0.2)
    
    -- update playerboard
    CustomGameEventManager:Send_ServerToAllClients("player_dead", {playerid = victim_player_id})

    -- every ghost player will be transferred to this global ghost team
    _G.CUSTOM_TEAM_PLAYER_COUNT[_G.GHOST_TEAM] = _G.CUSTOM_TEAM_PLAYER_COUNT[_G.GHOST_TEAM] + 1
    GameRules:SetCustomGameTeamMaxPlayers(_G.GHOST_TEAM, _G.CUSTOM_TEAM_PLAYER_COUNT[_G.GHOST_TEAM])
    PlayerResource:SetCustomTeamAssignment(victim_player_id, _G.GHOST_TEAM)

    Timers:CreateTimer(_G.WOLF_GHOST_SPAWN_TIME,function()
        local hPlayer = PlayerResource:GetPlayer(victim_player_id)
        local fake_hero = GetFakeHero(victim_player_id)
        local unit_name = "ghost_loser_main_unit"

        if GetLoserUnit(victim_player_id) ~= nil and GetLoserUnit(victim_player_id):GetUnitName() == unit_name then
            -- respawning action if player already has a ghost unit (he died before)
            GetLoserUnit(victim_player_id):RespawnUnit()
            FindClearSpaceForUnit(GetLoserUnit(victim_player_id), location, true)
        else
            -- create ghost unit
            local unit = CreateUnitByName(unit_name, location, true, fake_hero, fake_hero, PlayerResource:GetTeam(victim_player_id))
            unit:SetOwner(fake_hero)
            unit:SetControllableByPlayer(victim_player_id, true)
            InitAbilities(unit)
            unit:SetUnitCanRespawn(true)
            hPlayer.loser_unit = unit

            -- CNT
            local newtable = UpdateNetTable(CustomNetTables:GetTableValue("player_important_units", tostring(victim_player_id)), "loser_unit_index", unit:entindex())
            CustomNetTables:SetTableValue("player_important_units", tostring(victim_player_id), newtable)
        end


        -- selection
        fake_hero:SetSelectionOverride(hPlayer.loser_unit)
        PlayerResource:SetDefaultSelectionEntity(victim_player_id, hPlayer.loser_unit)
        PlayerResource:NewSelection(victim_player_id, hPlayer.loser_unit)

        -- sfx or spawning
        if self.effect_cast ~= nil then
            ParticleManager:DestroyParticle(self.effect_cast, true)
        end
        particle_cast = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green_mid.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControl(effect_cast, 0, unit:GetOrigin())
        ParticleManager:ReleaseParticleIndex(effect_cast)
    end)
end

-- for testing reasons, these wont be implemented until other cursed types are in game. by right, werewolf turns ppl into wolfs without revival chance. wolfs die and become ghosts immediately.
--[[
function Game_Events:Turn_Farmer_Into_Wolf(farmerplayer_id, farmer_unit, attacker)
    Notifications:Bottom(farmerplayer_id, {text="You will now play as a Wolf alongside the Cursed One", duration=_G.WOLF_GHOST_SPAWN_TIME})
    local location = farmer_unit:GetAbsOrigin()

    -- respawn timer notification
    local respawn_timer = _G.WOLF_GHOST_SPAWN_TIME
    local respawn_timer_interval = 1
    Timers:CreateTimer(0, function()
        if respawn_timer > 0 then
            Notifications:Bottom(farmerplayer_id, {text = respawn_timer, duration = respawn_timer_interval, style = {color="red"}})
            respawn_timer = respawn_timer - respawn_timer_interval
            return respawn_timer_interval
        end
    end)

    -- sfx for death
    local sfx_dummy = CreateUnitByName("dummy_unit", location, true, nil, nil, PlayerResource:GetTeam(farmerplayer_id))
    sfx_dummy:AddNewModifier(sfx_dummy, nil, "modifier_dummy_unit", {duration = _G.WOLF_GHOST_SPAWN_TIME})
    local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf"
    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, sfx_dummy )
    ParticleManager:SetParticleControl(self.effect_cast, 0, sfx_dummy:GetOrigin())

    -- camera
    PlayerResource:SetCameraTarget(farmerplayer_id, sfx_dummy)
    Timers:CreateTimer({EndTime = 1, callback = function()
        PlayerResource:SetCameraTarget(farmerplayer_id, nil)
    end})

    Timers:CreateTimer(_G.WOLF_GHOST_SPAWN_TIME,function()
        local hPlayer = PlayerResource:GetPlayer(farmerplayer_id)
        local fake_hero = hPlayer.fake_omniknight_hero
        local unit_name = "wolf_loser_main_unit"

        -- set team
        local wolf_team = attacker:GetTeam()
        _G.CUSTOM_TEAM_PLAYER_COUNT[wolf_team] = _G.CUSTOM_TEAM_PLAYER_COUNT[wolf_team] + 1
        GameRules:SetCustomGameTeamMaxPlayers(wolf_team, _G.CUSTOM_TEAM_PLAYER_COUNT[wolf_team])
        PlayerResource:SetCustomTeamAssignment(farmerplayer_id, wolf_team)

        -- create unit
        local unit = CreateUnitByName(unit_name, location, true, fake_hero, fake_hero, PlayerResource:GetTeam(farmerplayer_id))
        unit:SetOwner(fake_hero)
        unit:SetControllableByPlayer(farmerplayer_id, true)
        fake_hero:SetSelectionOverride(unit)
        PlayerResource:SetDefaultSelectionEntity(farmerplayer_id, unit)
        InitAbilities(unit)

        -- selection
        PlayerResource:NewSelection(farmerplayer_id, unit)
        hPlayer.loser_unit = unit

        -- sfx for spawning
        if self.effect_cast ~= nil then
            ParticleManager:DestroyParticle(self.effect_cast, true)
        end
        particle_cast = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControl(effect_cast, 0, unit:GetOrigin())
        ParticleManager:ReleaseParticleIndex(effect_cast)
    end)
end

function Game_Events:Turn_Farmer_Into_Ghost(farmerplayer_id, farmer_unit)
    Notifications:Top(farmerplayer_id, {text="You will now play as a Ghost", duration=_G.WOLF_GHOST_SPAWN_TIME})
    local location = farmer_unit:GetAbsOrigin()

    -- respawn timer notification
    local respawn_timer = _G.WOLF_GHOST_SPAWN_TIME
    local respawn_timer_interval = 1
    Timers:CreateTimer(0, function()
        if respawn_timer > 0 then
            Notifications:Top(farmerplayer_id, {text = respawn_timer, duration = respawn_timer_interval, style = {color="red"}})
            respawn_timer = respawn_timer - respawn_timer_interval
            return respawn_timer_interval
        end
    end)

    -- sfx for death
    local sfx_dummy = CreateUnitByName("dummy_unit", location, true, nil, nil, PlayerResource:GetTeam(farmerplayer_id))
    sfx_dummy:AddNewModifier(sfx_dummy, nil, "modifier_dummy_unit", {duration = _G.WOLF_GHOST_SPAWN_TIME})
    local particle_cast = "particles/units/heroes/hero_rubick/rubick_doom.vpcf"
    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, sfx_dummy )
    ParticleManager:SetParticleControl(self.effect_cast, 0, sfx_dummy:GetOrigin())

    -- camera
    PlayerResource:SetCameraTarget(farmerplayer_id, sfx_dummy)
    Timers:CreateTimer({EndTime = 1, callback = function()
        PlayerResource:SetCameraTarget(farmerplayer_id, nil)
    end})

    -- every ghost player will be transferred to this global ghost team
    _G.CUSTOM_TEAM_PLAYER_COUNT[_G.GHOST_TEAM] = _G.CUSTOM_TEAM_PLAYER_COUNT[_G.GHOST_TEAM] + 1
    GameRules:SetCustomGameTeamMaxPlayers(_G.GHOST_TEAM, _G.CUSTOM_TEAM_PLAYER_COUNT[_G.GHOST_TEAM])
    PlayerResource:SetCustomTeamAssignment(farmerplayer_id, _G.GHOST_TEAM)

    Timers:CreateTimer(_G.WOLF_GHOST_SPAWN_TIME,function()
        local hPlayer = PlayerResource:GetPlayer(farmerplayer_id)
        local fake_hero = GetFakeHero(victim_player_id)
        local unit_name = "ghost_loser_main_unit"
        
        -- create ghost unit
        local unit = CreateUnitByName(unit_name, location, true, fake_hero, fake_hero, PlayerResource:GetTeam(farmerplayer_id))
        unit:SetOwner(fake_hero)
        unit:SetControllableByPlayer(farmerplayer_id, true)
        fake_hero:SetSelectionOverride(unit)
        PlayerResource:SetDefaultSelectionEntity(farmerplayer_id, unit)
        InitAbilities(unit)
        unit:SetUnitCanRespawn(true)

        -- selection
        PlayerResource:NewSelection(farmerplayer_id, unit)
        hPlayer.loser_unit = unit

        -- sfx or spawning
        if self.effect_cast ~= nil then
            ParticleManager:DestroyParticle(self.effect_cast, true)
        end
        -- particle_cast = "particles/units/heroes/hero_rubick/rubick_finger_of_death.vpcf"
        particle_cast = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green_mid.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControl(effect_cast, 0, unit:GetOrigin())
        ParticleManager:ReleaseParticleIndex(effect_cast)
    end)
end
]]

-- not implemented yet
function Game_Events:Cursed_Kill_Farmer_Reward(cursedplayer_id)
    --sfx
    --level up?
    --gold?
end

-- not implemented yet
function Game_Events:Betrayal_Penalty(betrayer_player_id)
    -- are there any? put here

end

function Game_Events:OnLoserUnitDeath(unit, player_id)
    if unit:GetUnitName() ~= "ghost_loser_main_unit" and unit:GetUnitName() ~= "wolf_loser_main_unit" then return end
    if not player_id or not unit then return end
    if unit ~= GetLoserUnit(player_id) then return end

    if unit:GetUnitName() == "ghost_loser_main_unit" then
        -- ghost respawn
        Notifications:Top(player_id, {text="Respawning in...", duration=_G.WOLF_GHOST_DEATH_RESPAWN_TIME})
        local respawn_timer = _G.WOLF_GHOST_DEATH_RESPAWN_TIME
        local respawn_timer_interval = 1
        Timers:CreateTimer(0, function()
            if respawn_timer > 0 then
                -- respawn timer notification
                Notifications:Top(player_id, {text = respawn_timer, duration = respawn_timer_interval, style = {color="red"}})
                respawn_timer = respawn_timer - respawn_timer_interval
                return respawn_timer_interval
            else
                -- respawning action
                unit:RespawnUnit()
                FindClearSpaceForUnit(unit, _G.MAP_CENTREPOINT + RandomVector(450), true)

                -- camera
                MoveCameraToTarget(unit, player_id, 0.8)

                -- sfx
                local particle_cast = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green_mid.vpcf"
                local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, unit )
                ParticleManager:SetParticleControl(effect_cast, 0, unit:GetOrigin())
                ParticleManager:ReleaseParticleIndex(effect_cast)
            end
        end)
    else
        -- of wolf die then respawn as a ghost but stay on werewolf team
        Game_Events:Turn_Farmer_Into_Ghost(player_id, unit)

        -- reducing the team max size for the werewolf player
        local wolf_team = _G.CURSED_UNIT:GetTeam()
        _G.CUSTOM_TEAM_PLAYER_COUNT[wolf_team] = _G.CUSTOM_TEAM_PLAYER_COUNT[wolf_team] - 1
        GameRules:SetCustomGameTeamMaxPlayers(wolf_team, _G.CUSTOM_TEAM_PLAYER_COUNT[wolf_team])
    end
end

--==================================== when the cursed player levels up an upgrade ======================================
function Game_Events:OnCursedUnitUpgradeSelected(table)
	local upgradeid = table.id
    local playerid = table.playerid
    print("upgraded has been selected " .. upgradeid)
    if (upgradeid > 1000) and (upgradeid < 1011) then -- werewolf upgrades
        if upgradeid == 1001 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("mirana_leap_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 1002 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("wolf_sniff")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 1003 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("ursa_enrage_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 1004 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("werewolf_instinct_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 1005 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("werewolf_instinct_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 1006 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("wolf_sniff")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 1007 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("mirana_leap_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 1008 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("ursa_enrage_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 1009 then
            _G.CURSED_UNIT:SetPhysicalArmorBaseValue(_G.CURSED_UNIT:GetPhysicalArmorBaseValue() + 4)
        elseif upgradeid == 1010 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("werewolf_crit_strike_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        end
    elseif (upgradeid > 2000) and (upgradeid < 2011) then -- vampire upgrades
        if upgradeid == 2001 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("vampire_delirium_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 2002 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("vampire_blood_bath_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 2003 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("vampire_sol_skin_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 2004 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("vampire_ascend_lua")
            abil:SetLevel(abil:GetLevel() + 1)
            abil = _G.CURSED_UNIT:FindAbilityByName("vampire_impact_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 2005 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("vampire_blood_bath_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 2006 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("vampire_shadow_ward_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 2007 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("vampire_delirium_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 2008 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("vampire_ascend_lua")
            abil:SetLevel(abil:GetLevel() + 1)
            abil = _G.CURSED_UNIT:FindAbilityByName("vampire_impact_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 2009 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("vampire_shadow_ward_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 2010 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("vampire_sol_skin_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        end
    elseif (upgradeid > 3000) and (upgradeid < 3011) then -- zombie upgrades
        if upgradeid == 3001 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("zombie_summon_wave_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 3002 then
            _G.CURSED_UNIT:SetPhysicalArmorBaseValue(_G.CURSED_UNIT:GetPhysicalArmorBaseValue() + 3)
            _G.CURSED_UNIT:SetBaseHealthRegen(_G.CURSED_UNIT:GetBaseHealthRegen() + 4)
        elseif upgradeid == 3003 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("zombie_acid_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 3004 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("zombie_pounce_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 3005 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("zombie_summon_wave_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 3006 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("zombie_tombstone_lua")
            abil:SetLevel(abil:GetLevel() + 1)
            _G.CURSED_UNIT:SetBaseManaRegen(_G.CURSED_UNIT:GetBaseManaRegen() + 3)
        elseif upgradeid == 3007 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("zombie_summon_wave_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 3008 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("zombie_pounce_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 3009 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("zombie_summon_wave_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        elseif upgradeid == 3010 then
            local abil = _G.CURSED_UNIT:FindAbilityByName("zombie_acid_lua")
            abil:SetLevel(abil:GetLevel() + 1)
        end
    end

    -- fire client event for upgrade points and windowbuttonflashing() in cursed_upgrades.js
    CustomGameEventManager:Send_ServerToPlayer(_G.CURSED_UNIT:GetPlayerOwner(), "on_upgrade_selected",{})
end

--========================================= when a player levels up a hero upgrade ======================================
function Game_Events:OnHeroUpgradeSelected(args)
	local upgradeid = args.id
    local playerid = args.playerid
    local gold_cost = args.cost * (-1)
    local mainunit = GetMainUnit(playerid)


    -- check CNT if full upgrades
    local mytable = CustomNetTables:GetTableValue("player_hero", tostring(playerid))
    if mytable.upgrade_number < 12 then

        -- increase the stacks of the generic upgrade ability
        local modifier = mainunit:FindModifierByName("modifier_" .. upgradeid .. "_lua")
        if modifier then
            modifier:IncrementStackCount()
            -- for HP and MP, reapply modifier to update real hp and mp
            if upgradeid == "generic_upgrade_1" or upgradeid == "generic_upgrade_3" then
                local abil = mainunit:FindAbilityByName(upgradeid .. "_lua")
                mainunit:AddNewModifier(mainunit, abil, "modifier_" .. upgradeid .. "_lua", {stacks = modifier:GetStackCount()})
            end
        end

        -- change CNT upgrade number to record the number of upgrades chosen so far
        local index = mytable.upgrade_number
        index = index + 1
        local newtable = UpdateNetTable(CustomNetTables:GetTableValue("player_hero", tostring(playerid)), "upgrade_number", index)
        CustomNetTables:SetTableValue("player_hero", tostring(playerid), newtable)

        -- add to CNT upgrade_choices to update upgrade progress in UI
        local temp_table = mytable.upgrade_choices
        temp_table[index] = upgradeid
        newtable = UpdateNetTable(CustomNetTables:GetTableValue("player_hero", tostring(playerid)), "upgrade_choices", temp_table)
        CustomNetTables:SetTableValue("player_hero", tostring(playerid), newtable)
        mytable = CustomNetTables:GetTableValue("player_hero", tostring(playerid)).upgrade_choices

        -- check if hero-specific upgrade should be leveled up as well
        if index == 4 then
            -- unlock 1st hero upgrade
            local string = mainunit:GetUnitName() .. "_upgrade_1"
            local abil = mainunit:FindAbilityByName(string)
            if abil then
                abil:SetLevel(1)
            end
        elseif index == 8 then
            -- unlock 2nd hero upgrade
            local string = mainunit:GetUnitName() .. "_upgrade_2"
            local abil = mainunit:FindAbilityByName(string)
            if abil then
                abil:SetLevel(1)
            end
        elseif index == 12 then
            -- unlock 3rd hero upgrade
            local string = mainunit:GetUnitName() .. "_upgrade_3"
            local abil = mainunit:FindAbilityByName(string)
            if abil then
                abil:SetLevel(1)
            end
        end

        -- send data to javascript to update upgrades progress for client
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid), "update_hero_upgrade_progress", mytable)

        -- modify player gold
        Resources:ModifyGold( playerid, gold_cost )

        -- sfx
        PlaySoundOnClient("ui.trophy_new", playerid)
    else
        SendErrorMessage(playerid, "Reached Upgrade Limit")
    end
end

--================================ function for zombies ============================================
function Game_Events:SpawnZombie(location, playerid, moving_bool)
    if PlayerResource:IsValidPlayerID(playerid) then
		local hPlayer = PlayerResource:GetPlayer(playerid)
		local mainunit = GetMainUnit(playerid)
		if mainunit:IsAlive() and IsValidEntity(mainunit) then
			local abil = mainunit:FindAbilityByName("zombie_summon_wave_lua")
			local chancetable = {}

            if abil then
                -- zombie type chance
				chancetable[1] = abil:GetSpecialValueFor("zombie_basic_chance")
				chancetable[2] = abil:GetSpecialValueFor("zombie_runner_chance")
				chancetable[3] = abil:GetSpecialValueFor("zombie_carrier_chance")
                chancetable[4] = abil:GetSpecialValueFor("zombie_tank_chance")
                local chance = math.random() * 100
                local unit_name = ""
                if chance <= chancetable[4] then
                    unit_name = _G.ZOMBIE_UNIT_TABLE[4]
                elseif chance <= (chancetable[4] + chancetable[3]) then
                    unit_name = _G.ZOMBIE_UNIT_TABLE[3]
                elseif chance <= (chancetable[4] + chancetable[3] + chancetable[2]) then
                    unit_name = _G.ZOMBIE_UNIT_TABLE[2]
                else
                    unit_name = _G.ZOMBIE_UNIT_TABLE[1]
                end

                local omniknight = GetFakeHero(playerid)
                local unit = CreateUnitByName(unit_name, location, true, omniknight, hPlayer, PlayerResource:GetTeam(playerid))
                unit:SetOwner(omniknight)
        
                -- add unit to zombie count
                _G.ZOMBIE_UNIT_COUNT = _G.ZOMBIE_UNIT_COUNT + 1
        
                -- thinking zombie
                local bool = 0
                if moving_bool == true then
                    bool = 1
                end
                unit:AddNewModifier(unit, nil, "modifier_zombie_ai", {roaming = bool})

                -- abilities
                Game_Events:InitZombieAbilities(unit, abil:GetLevel())
        
                -- sfx
                EmitSoundOn("Undying_Zombie.Spawn", unit)
                local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_zombie_spawn.vpcf", PATTACH_ABSORIGIN, unit)
                ParticleManager:ReleaseParticleIndex(effect)

                -- model
                if unit:GetUnitName() == "zombie_unit_basic" then
                    local rndm = math.random(1,2)
                    if rndm > 1 then
                        unit:SetModel("models/heroes/undying/undying_minion_torso.vmdl")
                    end
                end
                
                -- model size
                local rndm = randomFloat(0.80, 1.25)
                unit:SetModelScale(rndm)

                -- colour
                if unit:GetUnitName() == "zombie_unit_basic" then
                    local rndm1 = math.random(160,255)
                    local rndm2 = math.random(160,255)
                    unit:SetRenderColor(rndm1, 255, rndm2)
                elseif unit:GetUnitName() == "zombie_unit_runner" then
                    unit:SetRenderColor(255, 100, 100)
                end
            end
        end        
    end
end

function Game_Events:SpawnZombieBasic(location, playerid, moving_bool)
    if PlayerResource:IsValidPlayerID(playerid) then
		local hPlayer = PlayerResource:GetPlayer(playerid)

        local omniknight = GetFakeHero(playerid)
        local unit = CreateUnitByName("zombie_unit_basic", location, true, omniknight, hPlayer, PlayerResource:GetTeam(playerid))
        unit:SetOwner(omniknight)

        -- add unit to zombie count
        _G.ZOMBIE_UNIT_COUNT = _G.ZOMBIE_UNIT_COUNT + 1

        -- thinking zombie
        local bool = 0
        if moving_bool == true then
            bool = 1
        end
        unit:AddNewModifier(unit, nil, "modifier_zombie_ai", {roaming = bool})

        -- abilities
        local mainunit = GetMainUnit(playerid)
        local abil = mainunit:FindAbilityByName("zombie_summon_wave_lua")
        Game_Events:InitZombieAbilities(unit, abil:GetLevel())

        -- model
        local rndm = math.random(1,2)
        if rndm > 1 then
            unit:SetModel("models/heroes/undying/undying_minion_torso.vmdl")
        end

        -- model size
        local rndm = randomFloat(0.85, 1.15)
        unit:SetModelScale(rndm)

        -- colour
        local rndm1 = math.random(160,255)
        local rndm2 = math.random(160,255)
        unit:SetRenderColor(rndm1, 255, rndm2)
    end
end

function Game_Events:InitZombieAbilities(zombie, horde_level)
    if zombie:GetUnitName() == "zombie_unit_basic" then
        local lvl = 1
        if horde_level >= 4 then
            lvl = 3
        elseif horde_level >=2 then
            lvl = 2
        end
        for i=0, 5 do
            local abil = zombie:GetAbilityByIndex(i)
            if abil ~= nil then
                abil:SetLevel(lvl)
            end
        end
    elseif zombie:GetUnitName() == "zombie_unit_runner" then
        local lvl = 1
        if horde_level >= 3 then
            lvl = 3
        elseif horde_level >=2 then
            lvl = 2
        end
        for i=0, 5 do
            local abil = zombie:GetAbilityByIndex(i)
            if abil ~= nil then
                abil:SetLevel(lvl)
            end
        end
    elseif zombie:GetUnitName() == "zombie_unit_carrier" then
        local lvl = 1
        if horde_level >= 5 then
            lvl = 2
        end
        for i=0, 5 do
            local abil = zombie:GetAbilityByIndex(i)
            if abil ~= nil then
                abil:SetLevel(lvl)
            end
        end
    elseif zombie:GetUnitName() == "zombie_unit_tank" then
        for i=0, 5 do
            local abil = zombie:GetAbilityByIndex(i)
            if abil ~= nil then
                abil:SetLevel(1)
            end
        end
    end
end

--================================ function for illusionist ============================================
function Game_Events:MatchIllusionGenericUpgrades(illusion, target)
    for i=1,8,1 do
        local modifier = target:FindModifierByName("modifier_generic_upgrade_" .. i .. "_lua")
        if modifier then
            local modifier_name = "modifier_generic_upgrade_" .. i .. "_lua"
            local stack = modifier:GetStackCount()
            
            local abil = target:FindAbilityByName("generic_upgrade_" .. i .. "_lua")
            if i == 1 or i == 3 then
                -- for HP and MP, reapply modifier to update real hp and mp
                illusion:AddNewModifier(illusion, abil, modifier_name, {stacks = stack})
            else
                illusion:AddNewModifier(illusion, abil, modifier_name, {})
                local illu_modifier = illusion:FindModifierByName(modifier_name)
                illu_modifier:SetStackCount(stack)
            end
        end
    end
end