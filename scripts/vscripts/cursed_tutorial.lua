if cursed_tutorial == nil then
	cursed_tutorial = class({})
end

TUTORIAL_DELAY = 2.5
TUTORIAL_MSGS = 9
--VILLAGER_COLOR_HEX = "#FCAF3D" -- day

-- Print messages to the player at the start of the match
function cursed_tutorial:Start(playerID)
	local tutorialString = "#Tutorial_GG_MSG_"
	--local colorHex = "VILLAGER_COLOR_HEX"
	--[[if PlayerResource:GetTeam(playerID) == DOTA_TEAM_GOODGUYS then
		tutorialString = "#Tutorial_GG_MSG_"
		colorHex = SNIPERS_COLOR_HEX
	else
		tutorialString = "#Tutorial_BG_MSG_"
		colorHex = NS_COLOR_HEX
	end]]

	local i = 1 -- Lua arrays start at 1
	Timers:CreateTimer(0.3, function()
		Notifications:Top(playerID, {text=tutorialString..i, duration=TUTORIAL_DELAY, style={color=red}})
		i = i + 1
		if i <= TUTORIAL_MSGS then
			return TUTORIAL_DELAY
		else
			return nil
		end
	end)
end

--[[function HVHTutorial:WakeUpHeroes()
  local heroList = HeroList:GetAllHeroes()
  for _,hero in pairs(heroList) do
    if hero:IsAlive() and hero:HasModifier("modifier_tutorial_sleep") then
      hero:RemoveModifierByName("modifier_tutorial_sleep")
    end
  end
end]]