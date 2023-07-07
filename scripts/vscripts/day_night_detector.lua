if Day_Night_Detector == nil then
	Day_Night_Detector = class({})
end

function Day_Night_Detector:Init()
	--start the thinker function for checking. with 0.1 second delay for first tick
	TIMER_INTERVAL = 0.1
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, TIMER_INTERVAL )
	GameRules:GetGameModeEntity().HalfCycleTimeRemaining = DAY_DURATION -- a global variable for the amount of time remaining for the current day/night
	DAY_OR_NIGHT = 1 -- used to check for transition between day and night. 1 is day, 0 is night. we start with day.
	TIMER_VISIBLE = false -- used to check if the timer is out(visible) or not
	_G.DAY_COUNTER = 1 -- to be used by the modifiers of some curseds like werewolf
	--CustomNetTables:SetTableValue("cycle", "TimeRemaining", { value = DAY_DURATION }) -- setting a starting value for the "timeremaining" key in the "cycle" table
	--CustomNetTables:SetTableValue("cycle", "IsDaytime", { value = true }) -- setting a starting value for the "IsDaytime" key in the "cycle" table
	print('day_night_detector initiated.') -- checking
	CustomGameEventManager:Send_ServerToAllClients("update_day_night_counter", {cycle = "D A Y", counter = _G.DAY_COUNTER} ) -- display for players the day/night and number
    --=============================================== when timer fades out ===================================================
    CustomGameEventManager:RegisterListener("custom_timer_faded_out", Dynamic_Wrap(Day_Night_Detector, "OnTimerFadedOut"))
end

function Day_Night_Detector:OnTimerFadedOut(args)
	TIMER_VISIBLE = false
	print('timer visible false.')
end

function Day_Night_Detector:OnThink()
	if _G.GAME_HAS_ENDED ~= true then
		local mode = GameRules:GetGameModeEntity()
		if GameRules:IsGamePaused() == false then -- only runs if the game is running (not paused)
			mode.HalfCycleTimeRemaining = mode.HalfCycleTimeRemaining - TIMER_INTERVAL
			CustomGameEventManager:Send_ServerToAllClients("pause_timer", {pause=false} )

			-- show timer
			if mode.HalfCycleTimeRemaining <= _G.TRANSITION_WARNING_TIME then
				if TIMER_VISIBLE == false and not GameRules:IsNightstalkerNight() then
					TIMER_VISIBLE = true
					CustomGameEventManager:Send_ServerToAllClients("display_timer", {msg="Remaining", duration=mode.HalfCycleTimeRemaining, mode=0, endfade=false, position=0, warning=5, paused=false, sound=true} )
					print('timer visible true.')
				end
			end

			-- turn off timer if nightstalker night is up
			if GameRules:IsNightstalkerNight() and TIMER_VISIBLE == true then
				CustomGameEventManager:Send_ServerToAllClients("fade_timer", {} )
				TIMER_VISIBLE = false
				print('timer visible false.')
			end

			-- check for end of real day/night
			if mode.HalfCycleTimeRemaining <= 0 then
				if DAY_OR_NIGHT == 0 then
					-- turning from night to day
					DAY_OR_NIGHT = 1
					_G.DAY_COUNTER = _G.DAY_COUNTER + 1

					-- daily gold
					if _G.DAY_COUNTER > 1 then
						for i = 0,15,1 do
							if PlayerResource:IsValidPlayerID(i) then
								if GetMainUnit(i):IsAlive() and IsValidEntity(GetMainUnit(i)) then
									if GetMainUnit(i) ~= _G.CURSED_UNIT or _G.CURSED_CREATURE ~= "zombie" then
										local gold = 0
										if _G.DAY_COUNTER > 8 then
											gold = _G.DAILY_GOLD[8]
										else
											gold = _G.DAILY_GOLD[_G.DAY_COUNTER]
										end
										Resources:ModifyGold( i, gold )
										SendOverheadEventMessage(PlayerResource:GetPlayer(i), OVERHEAD_ALERT_GOLD, GetMainUnit(i), gold, PlayerResource:GetPlayer(i))
									end
								end
							end
						end
					end

					-- panorama indicator
					CustomGameEventManager:Send_ServerToAllClients("update_day_night_counter", {cycle = "D A Y", counter = _G.DAY_COUNTER} )
					
					-- panorama cursed upgrade level update
					CustomGameEventManager:Send_ServerToPlayer(_G.CURSED_UNIT:GetPlayerOwner(), "update_cursed_upgrade_level",{daycounter = _G.DAY_COUNTER, creature = _G.CURSED_CREATURE, ent_index = _G.CURSED_UNIT:entindex()})
				else
					-- turning day to night
					DAY_OR_NIGHT = 0

					-- unlock the next xelnaga tower
					if _G.DAY_COUNTER <= #_G.XELNAGA_UNLOCK_PATTERN then
						Game_Events:UnlockNextXelNaga()
					end
					
					-- panorama indicator
					CustomGameEventManager:Send_ServerToAllClients("update_day_night_counter", {cycle = "N I G H T", counter = _G.DAY_COUNTER} )
				end
				
				-- cursed creature modifier refresh to set stack count correctly
				if _G.CURSED_CREATURE == "werewolf" then
					if CURSED_UNIT:HasModifier("modifier_werewolf_day") then
						CURSED_UNIT:FindModifierByName("modifier_werewolf_day"):ForceRefresh()
					elseif CURSED_UNIT:HasModifier("modifier_werewolf_night") then
						CURSED_UNIT:FindModifierByName("modifier_werewolf_night"):ForceRefresh()
					end
				elseif _G.CURSED_CREATURE == "vampire" then
					if CURSED_UNIT:HasModifier("modifier_vampire_day") then
						CURSED_UNIT:FindModifierByName("modifier_vampire_day"):ForceRefresh()
					elseif CURSED_UNIT:HasModifier("modifier_vampire_night") then
						CURSED_UNIT:FindModifierByName("modifier_vampire_night"):ForceRefresh()
					end
				end

				-- restart global timer checker
				mode.HalfCycleTimeRemaining = DAY_DURATION
			end
		else
			CustomGameEventManager:Send_ServerToAllClients("pause_timer", {pause=true} ) -- if the game is paused, makes sure any visible timer is on pause too
		end
		return TIMER_INTERVAL --check every 0.1 seconds
	end
end