function ColorIt( sStr, sColor )
	if sStr == nil or sColor == nil then
		return
	end

	--Default is cyan.
	local color = "00FFFF"

	if sColor == "green" then
		color = "ADFF2F"
	elseif sColor == "purple" then
		color = "EE82EE"
	elseif sColor == "blue" then
		color = "00BFFF"
	elseif sColor == "orange" then
		color = "FFA500"
	elseif sColor == "pink" then
		color = "DDA0DD"
	elseif sColor == "red" then
		color = "FF6347"
	elseif sColor == "cyan" then
		color = "00FFFF"
	elseif sColor == "yellow" then
		color = "FFFF00"
	elseif sColor == "brown" then
		color = "A52A2A"
	elseif sColor == "magenta" then
		color = "FF00FF"
	elseif sColor == "teal" then
		color = "008080"
	end
	return "<font color='#" .. color .. "'>" .. sStr .. "</font>"
end

function ColorStringRGB( sStr, red, green, blue )
	if sStr == nil or red == nil or green == nil or blue == nil then
		return
	end
	return "<font style='color: rgb(" .. red .. "," .. green .. "," .. blue ..")'>" .. sStr .. "</font>"
end

function ColorForTeam( teamID )
    local color = GameRules.TeamColors[ teamID ]
    if color == nil then
        color = { 255, 255, 255 } -- default to white
    end
    return color
end

function FirstLetterToUppercase(str)
    return (str:gsub("^%l", string.upper))
end

function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end

function InitAbilities( unit )
	for i=0, 30 do
		local abil = unit:GetAbilityByIndex(i)
		if abil ~= nil then
			local name = abil:GetAbilityName()
			--if name == "ranger_swap_arrow_teleport_lua" or name == "guardian_resurrect_lua" or name == "illusionist_invisible_wall_lua" then
			--else
				if unit:IsHero() and unit:GetAbilityPoints() > 0 then
					unit:UpgradeAbility(abil)
				else
					abil:SetLevel(1)
				end
			--end
		end
	end
end

function DeactivateAbilities( unit )
	for i=0, 20 do
		local abil = unit:GetAbilityByIndex(i)
		if abil ~= nil then
			abil:SetActivated(false)
		end
	end
end

function IncreaseMaxHealth(unit, bonus) -- hp % stays constant
	local newHP = unit:GetMaxHealth() + bonus
	local relativeHP = unit:GetHealthPercent() * 0.01
	if relativeHP == 0 then return end
	unit:SetMaxHealth(newHP)
	unit:SetBaseMaxHealth(newHP)
	unit:SetHealth(newHP * relativeHP)
end

function GetDistance(pointA, pointB)
	if not pointA or not pointB then return end
	local vector = Vector(pointA.x-pointB.x, pointA.y-pointB.y, pointA.z-pointB.z)
	local distance = math.sqrt(vector.x * vector.x + vector.y * vector.y)
	return distance
end

function IsTree(unit) return unit.IsStanding ~= nil end

function IsInCursedForm(unit)
	if unit:HasModifier("modifier_werewolf_night") or unit:HasModifier("modifier_werewolf_day") or unit:HasModifier("modifier_vampire_night") or unit:HasModifier("modifier_vampire_day") or unit:HasModifier("modifier_zombie_main_passive_lua") then
		return true
	end
	return false
end

function IsBuildingOrSpire(unit)
	--if not unit then return false end
	if unit:IsBuilding() or unit:HasModifier("modifier_building") or unit:HasModifier("modifier_spire") then
		return true
	end
	return false
end

function IsDummyUnit(unit)
	--if not unit then return false end
	if unit:GetUnitName() == "dummy_unit" or unit:GetUnitName() == "fly_unit" or unit:GetUnitName() == "trap_unit" or unit:GetUnitName() == "ghost_sfx_dummy_unit" or unit:GetUnitName() == "tombstone_unit" then
		return true
	end
	return false
end

function IsZombie(unit)
	if unit:GetUnitName() == "zombie_unit_basic" or unit:GetUnitName() == "zombie_unit_runner" or unit:GetUnitName() == "zombie_unit_carrier" or unit:GetUnitName() == "zombie_unit_tank" then
		return true
	end
	return false
end

function IsInAir(unit)
	if unit:HasModifier("modifier_druid_shapeshift_bird_lua") or unit:HasModifier("modifier_ghost_passive_lua") or unit:HasModifier("modifier_illusionist_fly_lua") or unit:HasModifier("modifier_illusionist_invisible_wall_lua_dummy") or unit:HasModifier("modifier_mirana_leap_movement") or unit:HasModifier("modifier_barbarian_charge_knockback_lua") then
		return true
	end
end

function RotateVector2D(v,theta)
    local xp = v.x*math.cos(theta)-v.y*math.sin(theta)
    local yp = v.x*math.sin(theta)+v.y*math.cos(theta)
    return Vector(xp,yp,v.z):Normalized()
end

function ToRadians(degrees)
	return degrees * math.pi / 180
end

function CountPlayersInGame()
	local count = 0
	for i=0,20 do
		if PlayerResource:GetPlayer(i) ~= nil and PlayerResource:IsValidPlayer(i) and PlayerResource:IsValidPlayerID(i) then
			count = count + 1
		end
	end
	return count
end

function GetFakeHero(playerID)
	local hPlayer = PlayerResource:GetPlayer(playerID)
	if hPlayer.fake_omniknight_hero ~= nil then
		return hPlayer.fake_omniknight_hero
	else
		local mytable = CustomNetTables:GetTableValue("player_important_units", tostring(playerID))
		if mytable.fake_hero_index ~= nil then
			local unit = EntIndexToHScript(mytable.fake_hero_index)
			hPlayer.fake_omniknight_hero = unit
			return hPlayer.fake_omniknight_hero
		end
	end
	return nil
end

function GetMainUnit(playerID)
	local hPlayer = PlayerResource:GetPlayer(playerID)
	if hPlayer.Main_Unit ~= nil then
		return hPlayer.Main_Unit
	else
		local mytable = CustomNetTables:GetTableValue("player_important_units", tostring(playerID))
		if mytable.main_unit_index ~= nil then
			local unit = EntIndexToHScript(mytable.main_unit_index)
			hPlayer.Main_Unit = unit
			return hPlayer.Main_Unit
		end
	end
	return nil
end

function GetFarmer(playerID)
	local hPlayer = PlayerResource:GetPlayer(playerID)
	if hPlayer.farmer_unit ~= nil then
		return hPlayer.farmer_unit
	else
		local team = PlayerResource:GetTeam(playerID)
		local all_units = FindUnitsInRadius( -- selecting all units in the map.
					team,
					Vector(0,0,0),
					nil,
					FIND_UNITS_EVERYWHERE,
					DOTA_UNIT_TARGET_TEAM_FRIENDLY,
					DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
					FIND_ANY_ORDER,
					false
					)
					-- counting only farmer starting units

		for _,unit in pairs(all_units) do
			if unit:GetUnitName() == STARTING_UNIT_NAME and unit:IsAlive() and not unit:HasModifier("modifier_building") and unit:GetPlayerOwnerID() == playerID then
				hPlayer.farmer_unit = unit
				return hPlayer.farmer_unit
			end
		end
	end
	return nil	
end

function GetAllFarmers()
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
	local mytable = {}
	for _,unit in pairs(all_units) do
		if unit:GetUnitName() == STARTING_UNIT_NAME and unit:IsAlive() and not unit:HasModifier("modifier_building") then
			table.insert(mytable,unit)
		end
	end
	return mytable
end

function CountFarmersInGame()
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
	local count = 0
	for _,unit in pairs(all_units) do
		if unit:GetUnitName() == STARTING_UNIT_NAME and unit:IsAlive() and not unit:HasModifier("modifier_building") then
			count = count + 1
		end
	end
	return count
end

function GetLoserUnit(playerID)
	local hPlayer = PlayerResource:GetPlayer(playerID)
	if hPlayer.loser_unit ~= nil then
		return hPlayer.loser_unit
	else
		local mytable = CustomNetTables:GetTableValue("player_important_units", tostring(playerID))
		if mytable.loser_unit_index ~= nil then
			local unit = EntIndexToHScript(mytable.loser_unit_index)
			hPlayer.loser_unit = unit
			return hPlayer.loser_unit
		end
	end
	return nil
end

function GetZombiesInRadius(location, radius)
	local all_units = FindUnitsInRadius( -- selecting all units in the map.
		DOTA_TEAM_NEUTRALS,
		location,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
		FIND_ANY_ORDER,
		false
	)
	local zombies = {}
	for _,unit in pairs(all_units) do
		if IsZombie(unit) then
			table.insert(zombies, unit)
		end
	end

	return zombies
end

--============================= counting alive players, xelnaga and keystone activation/sabotages==================================

function CountNonCursedPlayersInGame()
	local count = 0
	for i=0,20 do
		if PlayerResource:GetPlayer(i) ~= nil and PlayerResource:IsValidPlayer(i) and PlayerResource:IsValidPlayerID(i) then
			if _G.CURSED_UNIT:GetPlayerOwnerID() ~= i then
				count = count + 1
			end
		end
	end
	return count
end

function CountNonCursedPlayersAlive()
	local alive_players = 0
	for i=0, 15, 1 do
		if PlayerResource:IsValidPlayerID(i) then
			local unit = GetMainUnit(i)
			if unit:IsAlive() and IsValidEntity(unit) and unit ~= _G.CURSED_UNIT then
				alive_players = alive_players + 1
			end
		end
	end
	return alive_players
end

function CountKeystonesActivated()
    local keystones_activated_good = 0
    for i=1, #_G.KEYSTONE_UNIT do
        local keystone = _G.KEYSTONE_UNIT[i]
        local modifier2 = keystone:FindModifierByName("modifier_keystone_activatedgood_lua")
        if modifier2 then
            keystones_activated_good = keystones_activated_good + 1
        end
	end
	return keystones_activated_good
end

function CountKeystonesSabotaged()
    local keystones_activated_bad = 0
    for i=1, #_G.KEYSTONE_UNIT do
        local keystone = _G.KEYSTONE_UNIT[i]
        local modifier1 = keystone:FindModifierByName("modifier_keystone_sabotaged_lua")
        if modifier1 then
            keystones_activated_bad = keystones_activated_bad + 1
        end
    end
	return keystones_activated_bad
end

function CountXelNagaActivated()
    local xelnaga_activated = 0
    for i=1, #_G.XELNAGA_TOWER_UNIT do
        local tower = _G.XELNAGA_TOWER_UNIT[i]
        local modifier1 = tower:FindModifierByName("modifier_xelnaga_tower_activated_vision_lua")
        if modifier1 then
            xelnaga_activated = xelnaga_activated + 1
        end
    end
	return xelnaga_activated
end

function GetHut(playerID)
	local hPlayer = PlayerResource:GetPlayer(playerID)
	if hPlayer.hut_unit ~= nil then
		return hPlayer.hut_unit
	else
		local team = PlayerResource:GetTeam(playerID)
		local all_units = FindUnitsInRadius( -- selecting all units in the map.
					team,
					Vector(0,0,0),
					nil,
					FIND_UNITS_EVERYWHERE,
					DOTA_UNIT_TARGET_TEAM_FRIENDLY,
					DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
					FIND_ANY_ORDER,
					false
					)
					-- counting only hut units

		for _,unit in pairs(all_units) do
			if unit:GetUnitName() == "hut" and unit:IsAlive() and unit:HasModifier("modifier_building") and unit:GetPlayerOwnerID() == playerID then
				hPlayer.hut_unit = unit
				return hPlayer.hut_unit
			end
		end
	end
	return nil	
end

function GetBarrack(playerID)
	local hPlayer = PlayerResource:GetPlayer(playerID)
	if hPlayer.barrack_unit ~= nil then
		return hPlayer.barrack_unit
	else
		local team = PlayerResource:GetTeam(playerID)
		local all_units = FindUnitsInRadius( -- selecting all units in the map.
					team,
					Vector(0,0,0),
					nil,
					FIND_UNITS_EVERYWHERE,
					DOTA_UNIT_TARGET_TEAM_FRIENDLY,
					DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
					FIND_ANY_ORDER,
					false
					)
					-- counting only barrack units
		for _,unit in pairs(all_units) do
			if unit:GetUnitName() == "barracks" and unit:IsAlive() and unit:HasModifier("modifier_building") and unit:GetPlayerOwnerID() == playerID then
				hPlayer.barrack_unit = unit
				return hPlayer.barrack_unit
			end
		end
	end
	return nil
end

function GetGoldMinesAroundRadius(location, radius)
	local all_units = FindUnitsInRadius(
		DOTA_TEAM_NEUTRALS,
		location,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_ALL,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
		FIND_ANY_ORDER,
		false
		)
	local nearby_goldmines = {}
	for _,unit in pairs(all_units) do
		if unit:GetUnitName() == "goldmine" then
			table.insert(nearby_goldmines, unit)
		end
	end
	return nearby_goldmines
end

function GetXelNagasAroundRadius(location, radius)
	local all_units = FindUnitsInRadius(
		DOTA_TEAM_NEUTRALS,
		location,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_BUILDING,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
		FIND_ANY_ORDER,
		false
		)
	local nearby_xelnaga = {}
	for _,unit in pairs(all_units) do
		if unit:GetUnitName() == "xelnaga_tower" then
			table.insert(nearby_xelnaga, unit)
		end
	end
	return nearby_xelnaga
end

function GetKeystonesAroundRadius(location, radius)
	local all_units = FindUnitsInRadius(
		DOTA_TEAM_NEUTRALS,
		location,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_BUILDING,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
		FIND_ANY_ORDER,
		false
		)
	local nearby_keystone = {}
	for _,unit in pairs(all_units) do
		if unit:GetUnitName() == "keystone" then
			table.insert(nearby_keystone, unit)
		end
	end
	return nearby_keystone
end

function GetKeyspawnersAroundRadius(location, radius)
	local all_units = FindUnitsInRadius(
		DOTA_TEAM_NEUTRALS,
		location,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_BUILDING,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
		FIND_ANY_ORDER,
		false
		)
	local nearby_keyspawners = {}
	for _,unit in pairs(all_units) do
		if unit:GetUnitName() == "key_spawner" then
			table.insert(nearby_keyspawners, unit)
		end
	end
	return nearby_keyspawners
end

function GetPlayerTrainingCentres(playerID)
	local hPlayer = PlayerResource:GetPlayer(playerID)
	local team = PlayerResource:GetTeam(playerID)
	local all_units = FindUnitsInRadius( -- selecting all units in the map.
				team,
				Vector(0,0,0),
				nil,
				FIND_UNITS_EVERYWHERE,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
				FIND_ANY_ORDER,
				false
				)
				-- counting only training centre units
	local trainingcentres = {}
	for _,unit in pairs(all_units) do
		if unit:GetUnitName() == "training_centre" and unit:IsAlive() and unit:HasModifier("modifier_building") and unit:GetPlayerOwnerID() == playerID then
			table.insert(trainingcentres,unit)
		end
	end
	return trainingcentres
end

--=========================== functions used for hPlayer.Structures and hPlayer.Units ========================================
function GetAllStructures(playerID)
	local hPlayer = PlayerResource:GetPlayer(playerID)
	return hPlayer.Structures
end

function GetAllUnits(playerID)
	local hPlayer = PlayerResource:GetPlayer(playerID)
	return hPlayer.Units
end

function FixStructureUnitTable(list)
    local newList = {}
    for _,v in pairs(list) do
        if IsValidEntity(v) and v:IsAlive() then
            table.insert(newList, v)
        end
    end
    return newList
end

function RemoveStructureFromPlayerTable( playerID, unit )
    -- Remove the handle from the player structures
    local playerStructures = GetAllStructures( playerID )
    local structure_index = getIndexTable(playerStructures, unit)
    if structure_index then 
        table.remove(playerStructures, structure_index)
    end
end

function RemoveUnitFromPlayerTable( playerID, unit )
    -- Attempt to remove from player units
    local playerUnits = GetAllUnits(playerID)
    local unit_index = getIndexTable(playerUnits, unit)
    if unit_index then
        table.remove(playerUnits, unit_index)
    end
end

function getIndexTable(list, element)
    if list == nil then return false end
    for k,v in pairs(list) do
        if v == element then
            return k
        end
    end
    return nil
end

function IsItemInTable(list, element)
    if list == nil then return false end
    for k,v in pairs(list) do
        if v == element then
            return true
        end
    end
    return false
end

function UpdateNetTable(mytable, key, keyvalue)
	local newtable = {}
	for k,v in pairs(mytable) do
		if k == key then
			newtable[k] = keyvalue
		else
			newtable[k] = v
		end
	end
	if not newtable[key] then
		newtable[key] = keyvalue
	end
	return newtable
end

function Shuffle(table)
    local t = table
    local tbl = {}
    for i = 1, #t do
        tbl[i] = t[i]
    end
    for i = #tbl, 2, -1 do
		local j = RandomInt(1,i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    for i = 1, #tbl do
        print(tbl[i])
	end
	return tbl
end

function AsymptotePointValue(startvalue, maxvalue, factor, point_in_time)
	local a = startvalue
	local b = maxvalue
	local y = b - ( (b - a) * ( factor ^ point_in_time ) ) -- factor 0.5 means halflife. bigger factor -> slower approach to maxvalue
	return y
end

--============================ function for swapping items. use with datadriven items ========================================
function swap_to_item(keys, ItemName)
	for i=0, 5, 1 do  --Fill all empty slots in the player's inventory with "dummy" items.
		local current_item = keys.caster:GetItemInSlot(i)
		if current_item == nil then
			keys.caster:AddItem(CreateItem("item_dummy_datadriven", keys.caster, keys.caster))
		end
	end
	
	UTIL_Remove(keys.ability)
	--keys.caster:RemoveItem(keys.ability)
	keys.caster:AddItem(CreateItem(ItemName, keys.caster, keys.caster))  --This should be put into the same slot that the removed item was in.
	
	for i=0, 5, 1 do  --Remove all dummy items from the player's inventory.
		local current_item = keys.caster:GetItemInSlot(i)
		if current_item ~= nil then
			if current_item:GetName() == "item_dummy_datadriven" then
				UTIL_Remove(current_item)
				--keys.caster:RemoveItem(current_item)
			end
		end
	end
end

LinkLuaModifier( "modifier_building", "libraries/modifiers/modifier_building", LUA_MODIFIER_MOTION_NONE )
--================================ function for placing neutral buildings on map =============================================
function PlaceNeutralBuilding(name, location, angle)

	location = GetGroundPosition(location, nil)
	local construction_size = BuildingHelper:GetConstructionSize(name)
	local pathing_size = BuildingHelper:GetBlockPathingSize(name)
	BuildingHelper:SnapToGrid(construction_size, location)

	-- Spawn point obstructions before placing the building
	local gridNavBlockers = BuildingHelper:BlockGridSquares(construction_size, pathing_size, location)

	-- Adjust the model position z
	local model_offset = GetUnitKV(name, "ModelOffset") or 0
	local model_location = Vector(location.x, location.y, location.z + model_offset)

	-- Spawn the building
	local building = CreateUnitByName(name, model_location, true, nil, nil, DOTA_TEAM_NEUTRALS)
	building:SetNeverMoveToClearSpace(true)
	building:SetAbsOrigin(model_location)
	building.construction_size = construction_size
	building.blockers = gridNavBlockers

	-- Building Settings
	BuildingHelper:AddModifierBuilding(building)

	-- Create pedestal
	local pedestal = GetUnitKV(name, "PedestalModel")
    if pedestal then
        BuildingHelper:CreatePedestalForBuilding(building, name, GetGroundPosition(location, nil), pedestal)
    end

	if angle then
		building:SetAngles(0,-angle,0)
	end

	building:AddNewModifier(nil,nil,"modifier_building", {})

	-- Return the created building
	return building
end

--================================ function for checking abandonments in the game ============================================
function StartTeamAbandonmentListener(team)
	local checkEvery = 5.0
	local teamTotal = PlayerResource:GetPlayerCountForTeam(team)
	if teamTotal ~= 0 then
		Timers:CreateTimer(function()
			--GetConnectedPlayerCountOnTeam is the next function in this lua file
			local teamConnected = GetConnectedPlayerCountOnTeam(team)
		
			--  (intentional!) 0/0 can happen in single-player so there's no auto-quit
			if teamConnected == 0 then
				--print("T"..team.." players all DISCONNECTED.")
				-- this is also a function in utils.lua
				DecrementDisconnectTimeRemaining(checkEvery, team)
			else
				--print("Team "..team.." players connected: "..teamConnected.."/"..teamTotal)
			end
			return checkEvery
		end)
	else
		--print("Team " .. team .. " has no one in it. it will no longer be part of the StartTeamAbandonmentListener.")
	end
end

function GetConnectedPlayerCountOnTeam(team)
	local teamTotal = PlayerResource:GetPlayerCountForTeam(team)
	local teamConnected = 0
	for i = 1, teamTotal do
		local playerID = PlayerResource:GetNthPlayerIDOnTeam(team, i)
		local state = PlayerResource:GetConnectionState(playerID)
		local botstate = 1
		local playerstate = 2
		local dcstate = 3
		if state == botstate or state == playerstate then
			teamConnected = teamConnected + 1
		end
		--print("T"..team.." " .. PlayerResource:GetPlayerName(playerID) .. " ID: " .. playerID .. ", ConnState: " .. state)
	end
	return teamConnected
end


function DecrementDisconnectTimeRemaining(seconds, losingTeam)
	local mode = GameRules:GetGameModeEntity()
	mode.DisconnectTimeRemaining = mode.DisconnectTimeRemaining - seconds
	if mode.DisconnectTimeRemaining <= 0.0 then
		--self:DeclareWinner(GetOppositeTeam(losingTeam))
		local teamTotal = PlayerResource:GetPlayerCountForTeam(losingTeam)
		local teamConnected = 0
		for i = 1, teamTotal do
			local playerID = PlayerResource:GetNthPlayerIDOnTeam(losingTeam, i)
			if GetFarmer(playerID) == _G.CURSED_UNIT then
				-- the cursed player is the one who DC. how?
				local msg = "The Cursed Player has been disconnected for too long. Game Over."
				Notifications:TopToAll({text=msg, duration=10.0})
				EndGameActions()
				break
			end
		end
	else
		--print(mode.DisconnectTimeRemaining .. " seconds remaining on the DC clock.")
		local msg = "Enemy team disconnected. Your team will be victorious in " .. mode.DisconnectTimeRemaining .. " seconds."
		GameRules:SendCustomMessage(msg, 0, 0)
	end
end

-- this function is deployed for endgame scenarios
LinkLuaModifier( "modifier_endgame_pause", "modifiers/modifier_endgame_pause", LUA_MODIFIER_MOTION_NONE )
function EndGameActions()
	--pause all units. use modifier. stop them in their tracks
	local all_units = FindUnitsInRadius( -- selecting all units in the map.
	DOTA_TEAM_NOTEAM,
	Vector(0,0,0),
	nil,
	FIND_UNITS_EVERYWHERE,
	DOTA_UNIT_TARGET_TEAM_BOTH,
	DOTA_UNIT_TARGET_ALL,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
	FIND_ANY_ORDER,
	false
	)
	for _,unit in pairs(all_units) do
		unit:Interrupt()
		unit:Hold()
		DeactivateAbilities(unit)
		unit:AddNewModifier(unit,nil,"modifier_endgame_pause", {} )
	end
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled(true)
	cvar_setf("dota_time_of_day_rate",(1/(2*999999)))
	GameRules:GetGameModeEntity():SetPauseEnabled(false)
	GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)

	_G.GAME_HAS_ENDED = true
	GameRules:SetSafeToLeave( true )
	--ending scoretable. panorama

	-- removing objectives in HUD
	CustomGameEventManager:Send_ServerToAllClients("objectives_hide", {})
	
	-- remove pano for endgame portal timer
	CustomGameEventManager:Send_ServerToAllClients("remove_endgame_portal_timer", {})
end

function PlaySoundOnAllClients(string)
	CustomGameEventManager:Send_ServerToAllClients("play_sound_on_client", {string = string})
end

function PlaySoundOnClient(string, playerid)
	local player = PlayerResource:GetPlayer(playerid)
	CustomGameEventManager:Send_ServerToPlayer(player, "play_sound_on_client", {string = string})
end

function RNMNegativeSound()
	local table = {}
	for i=1,9 do
		table[i] = ("announcer_dlc_rick_and_morty_negative_followup_0" .. i)
	end
	for i=10,20 do
		table[i] = ("announcer_dlc_rick_and_morty_negative_followup_" .. i)
	end

	local rndm_num = RandomInt(1,20)
	local string = table[rndm_num]
	return string
end

function MoveCameraToTarget(unit, playerid, time)
	if not unit or not playerid then return end
	local player = PlayerResource:GetPlayer(playerid)
	CustomGameEventManager:Send_ServerToPlayer(player, "move_camera_to_target", {target_index = unit:entindex(), pan_time = time})
end

function PingLocationOnClient(location, playerid)
	if not location or not playerid then return end
	local player = PlayerResource:GetPlayer(playerid)
	CustomGameEventManager:Send_ServerToPlayer(player, "ping_location", {target_location = location})
end