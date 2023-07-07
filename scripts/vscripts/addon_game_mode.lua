require('libraries/timers')
require('libraries/selection')
require('libraries/notifications')
require('libraries/buildinghelper')
require('libraries/playertables')
require('libraries/worldpanels')
require('libraries/animations')

require('day_night_detector')
require('game_constants')
require('game_events')
require('utils')
require('resources_gold_lumber_food')
require('cursed_tutorial')

LinkLuaModifier("modifier_hidden", "modifiers/modifier_hidden", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pregame_warmup", "modifiers/modifier_pregame_warmup", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spire", "modifiers/modifier_spire", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_keystone_passive_lua_stacks", "modifiers/modifier_keystone_passive_lua_stacks", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_xelnaga_tower_passive_lua", "modifiers/modifier_xelnaga_tower_passive_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_xelnaga_tower_locked_lua", "modifiers/modifier_xelnaga_tower_locked_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_key_spawner_lua", "modifiers/modifier_key_spawner_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_goldmine_passive_lua", "modifiers/modifier_goldmine_passive_lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_generic_auto_attack_off_lua", "modifiers/modifier_generic_auto_attack_off_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_take_damage_alert_lua", "modifiers/modifier_generic_take_damage_alert_lua", LUA_MODIFIER_MOTION_NONE)

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

--=====================================================precache=====================================================
function Precache( context )
	--Precache things we know we'll use.  Possible file types include (but not limited to):

	---------------------------------------------- models ----------------------------------------------------------
	--PrecacheResource( "model", "*.vmdl", context )
	PrecacheResource( "model", _G.CURSED_UNIT_WOLF_3D_MODEL, context )
	PrecacheResource( "model", DRUID_FLYING_3D_MODEL, context )
	PrecacheResource( "model", DRUID_BEAR_3D_MODEL, context )
	PrecacheResource( "model", ILLUSIONIST_WALL_3D_MODEL, context )

	-- scout wearables
	--PrecacheResource( "model", "models/heroes/bounty_hunter/bounty_hunter_bandana.vmdl", context )
	--PrecacheResource( "model", "models/heroes/bounty_hunter/bounty_hunter_backpack.vmdl", context )
	--PrecacheResource( "model", "models/items/bounty_hunter/back_jawtrap.vmdl", context )
	--PrecacheResource( "model", "models/heroes/bounty_hunter/bounty_hunter_pads.vmdl", context )

	-------------------------------------------- particles ---------------------------------------------------------
	--PrecacheResource( "particle", "*.vpcf", context )
	

	----------------------------------------- soundfiles for SFX ---------------------------------------------------
	--PrecacheResource( "soundfile", "*.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/Ability.panic.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/Ability.sniff.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/Ability.track.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/Ability.trap.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/Ability.hanzo.powershot.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/Announcer_Sounds.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/Ambient_Sounds_Edited.vsndevts", context )

	PrecacheResource( "soundfile", "soundevents/game_sounds.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/soundevents_conquest.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_creeps.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/soundevents_dota_ui.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_items.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_ui_imported.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_announcer_dlc_stanleyparable.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_announcer_dlc_rick_and_morty.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_life_stealer.vsndevts", context )
	
	
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abyssal_underlord.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_arc_warden.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bane.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bloodseeker.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bristleback.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_chen.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_willow.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_disruptor.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_furion.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_grimstroke.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_life_stealer.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lycan.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_mars.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nightstalker.vsndevts", context )
	--PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_obsidian_destroyer.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_oracle.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pangolier.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_lancer.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_puck.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pudge.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_rattletrap.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_riki.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_rubick.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_shadowshaman.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_shredder.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_snapfire.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_spectre.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_stormspirit.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_undying.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_vengefulspirit.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_viper.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_void_spirit.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_windrunner.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_winter_wyvern.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_wisp.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_witchdoctor.vsndevts", context )

	---------------------------- particle folder for buidinghelper. do not touch -------------------------------------
	--PrecacheResource( "particle_folder", "particles/folder", context )
	PrecacheResource("particle_folder", "particles/buildinghelper", context)

	----------------------------------------- others. do not touch ---------------------------------------------------
	-- PrecacheItemByNameSync( "item_tombstone", context )
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

--====================================== main init game mode ==========================================================
function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	
	--skips stuff at the start when we are editing the map and scripts etc. Also useful for testing teams at start
	if TOOLS_MODE then
		GameRules:SetCustomGameSetupAutoLaunchDelay(2)
		GameRules:SetPostGameTime(5)
	else
		GameRules:SetCustomGameSetupAutoLaunchDelay(GAME_SETUP_AUTO_LAUNCH_DELAY)
		GameRules:SetPostGameTime(POST_GAME_TIME)
	end
	
	GameRules:SetHeroSelectionTime(0)
	GameRules:SetStrategyTime(0)
	GameRules:SetPreGameTime(0)
	GameRules:SetShowcaseTime(0)

	--================================================= other game rules ===================================================

	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetHeroRespawnEnabled(false)
	GameRules:SetUseCustomHeroXPValues (true)
	GameRules:SetUseBaseGoldBountyOnHeroes(false)
	
	GameRules:SetUseUniversalShopMode(true)

	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	GameRules:SetStartingGold(_G.STARTING_GOLD)
	GameRules:SetGoldPerTick(GOLD_PER_TICK)

	GameRules:SetHeroMinimapIconScale(1)
	GameRules:SetCreepMinimapIconScale(1)

	GameRules:SetHideKillMessageHeaders(true)

	--========================================== setting individual teams ==================================================
	GameRules.TeamColors = {}
	GameRules.TeamColors[DOTA_TEAM_GOODGUYS] = _G.TeamColors[DOTA_TEAM_GOODGUYS]
	GameRules.TeamColors[DOTA_TEAM_BADGUYS]  = _G.TeamColors[DOTA_TEAM_BADGUYS]
	GameRules.TeamColors[DOTA_TEAM_CUSTOM_1] = _G.TeamColors[DOTA_TEAM_CUSTOM_1]
	GameRules.TeamColors[DOTA_TEAM_CUSTOM_2] = _G.TeamColors[DOTA_TEAM_CUSTOM_2]
	GameRules.TeamColors[DOTA_TEAM_CUSTOM_3] = _G.TeamColors[DOTA_TEAM_CUSTOM_3]
	GameRules.TeamColors[DOTA_TEAM_CUSTOM_4] = _G.TeamColors[DOTA_TEAM_CUSTOM_4]
	GameRules.TeamColors[DOTA_TEAM_CUSTOM_5] = _G.TeamColors[DOTA_TEAM_CUSTOM_5]
	GameRules.TeamColors[DOTA_TEAM_CUSTOM_6] = _G.TeamColors[DOTA_TEAM_CUSTOM_6]
	GameRules.TeamColors[DOTA_TEAM_CUSTOM_7] = _G.TeamColors[DOTA_TEAM_CUSTOM_7]
	GameRules.TeamColors[DOTA_TEAM_CUSTOM_8] = _G.TeamColors[DOTA_TEAM_CUSTOM_8]

	local count = 0
    for team,number in pairs(_G.CUSTOM_TEAM_PLAYER_COUNT) do
		if count >= _G.MAX_PLAYERS then
			GameRules:SetCustomGameTeamMaxPlayers(team, 0)
		else
			GameRules:SetCustomGameTeamMaxPlayers(team, number)
			--local color = GameRules.TeamColors[ team ]
			--if color then
			--	color[1] = 255 - ((255 - color[1]) * _G.TeamColorSaturationValue)
			--	color[2] = 255 - ((255 - color[2]) * _G.TeamColorSaturationValue)
			--	color[3] = 255 - ((255 - color[3]) * _G.TeamColorSaturationValue)
			--	SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
			--end
		end
		count = count + 1
	end
	
	--=========================================== setting the speed of day/night ============================================
	cvar_setf("dota_time_of_day_rate",(1/(2*DAY_DURATION)))

	--=========================================== setting the player name display ===========================================
	--SendToConsole("dota_hero_overhead_names 2")
	SendToConsole("dota_always_show_player_names 0")

	--==================================== when cursed player presses transform button ======================================
	CustomGameEventManager:RegisterListener( "cursed_unit_transform", CursedUnitTransform )

	--==================================== when the cursed player levels up an upgrade ======================================
	CustomGameEventManager:RegisterListener( "cursed_unit_upgrade_selected", OnCursedUnitUpgradeSelected )
	--found in game_events.lua

	--================================================= attack alert ========================================================
	CustomGameEventManager:RegisterListener( "alert_under_attack", AlertUnderAttack )
	
	--========================================== listen to all players conencting ===========================================
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(self, 'OnPlayerConnectFull'), self)

	--============================================ listen to game state changes =============================================
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(self, 'OnGameRulesStateChange'), self)

	--=========================================== listen to entity spawning =================================================
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(self, 'OnNPCSpawned'), self)

	--============================================ listen to entity deaths ==================================================
	ListenToGameEvent('entity_killed', Dynamic_Wrap(self, 'OnEntityKilled'), self)

	--========================================= listen to player reconnections ==============================================
	ListenToGameEvent('player_reconnected', Dynamic_Wrap(self, 'OnPlayerReconnected'), self)

	--======================================== listen to item pick ups for keys =============================================
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(Game_Events, 'OnItemPickedUp'), self)

	--========================================= spawning other units for testing ============================================
	if TOOLS_MODE then
		
		-- testing spawning positions. it works. mechanism transferred over to player's farmer spawning already
		local count = COUNT_TESTING_UNITS
		local distance = DISTANCE_TESTING_UNITS
		local segment = 360/count
		local position = MAP_CENTREPOINT + Vector(distance, 0, 0)
		
		for i=0,(count-1) do
			local rotation = QAngle(0, (90+ (i*segment)), 0)
			local new_position = RotatePosition(MAP_CENTREPOINT, rotation, position)
			local unit = CreateUnitByName("farmer", new_position, true, nil, nil, DOTA_TEAM_BADGUYS)
		end
	end
	
end

-- when cursed player presses transform button
function CursedUnitTransform(eventSourceIndex, args)
	local playerid = CURSED_UNIT:GetPlayerOwnerID()
	local unit = GetMainUnit(playerid)
	if unit ~= CURSED_UNIT then return end
	if (not GetMainUnit(playerid):IsAlive()) or (not IsValidEntity(GetMainUnit(playerid))) then return end

	-- check if druid
	if unit:GetUnitName() == "druid" then
		local bear = unit:FindModifierByName("modifier_druid_shapeshift_bear_lua")
		local bird = unit:FindModifierByName("modifier_druid_shapeshift_bird_lua")
		if bear then
			bear:Destroy()
		elseif bird then
			bird:Destroy()                
		end
	-- check of assassin in invis
	elseif unit:GetUnitName() == "assassin" then
		local invis = unit:FindModifierByName("modifier_assassin_invis_lua")
		if invis then
			unit:FindAbilityByName("assassin_invis_lua"):ToggleAbility()
		end
	end

	-- cursed creature transform
	if _G.CURSED_CREATURE == "werewolf" then
		if IsInCursedForm(unit) then
			local abil = unit:FindAbilityByName("transform_from_werewolf_lua")
			if not abil then
				unit:AddAbility("transform_from_werewolf_lua")
				abil = unit:FindAbilityByName("transform_from_werewolf_lua")
			end
			abil:SetLevel(1)
			unit:CastAbilityNoTarget(abil, playerid)
		else
			local abil = unit:FindAbilityByName("transform_to_werewolf_lua")
			if not abil then
				unit:AddAbility("transform_to_werewolf_lua")
				abil = unit:FindAbilityByName("transform_to_werewolf_lua")
			end
			abil:SetLevel(1)
			unit:CastAbilityNoTarget(abil, playerid)
		end
	elseif _G.CURSED_CREATURE == "vampire" then
		if IsInCursedForm(unit) then
			local abil = unit:FindAbilityByName("transform_from_vampire_lua")
			if not abil then
				unit:AddAbility("transform_from_vampire_lua")
				abil = unit:FindAbilityByName("transform_from_vampire_lua")
			end
			abil:SetLevel(1)
			unit:CastAbilityNoTarget(abil, playerid)
		else
			local abil = unit:FindAbilityByName("transform_to_vampire_lua")
			if not abil then
				unit:AddAbility("transform_to_vampire_lua")
				abil = unit:FindAbilityByName("transform_to_vampire_lua")
			end
			abil:SetLevel(1)
			unit:CastAbilityNoTarget(abil, playerid)
		end
	end

	-- force close upgrades, if any
	if unit:GetUnitName() ~= "farmer" then
		local hPlayer = PlayerResource:GetPlayer(playerid)
		CustomGameEventManager:Send_ServerToPlayer(hPlayer, "force_close_hero_upgrades", {})
	end

end

-- for when the cursed player selects an upgrade on panorama
function OnCursedUnitUpgradeSelected(eventSourceIndex, args)
	local playerid = args.playerid
	if GetMainUnit(playerid) ~= nil and GetMainUnit(playerid):IsAlive() then
		Game_Events:OnCursedUnitUpgradeSelected(args)
	end
end

-- when a unit is under attack. currently only useful for villager units
function AlertUnderAttack(eventSourceIndex, args)
	local bool = args.onscreen
    if bool < 1 then
        local unit = EntIndexToHScript(args.index)
        local location = unit:GetAbsOrigin()
        local player_id = unit:GetPlayerOwnerID()
        MinimapEvent(
            unit:GetTeam(),
            unit,
            location.x,
            location.y,
            DOTA_MINIMAP_EVENT_HINT_LOCATION,
            4
		)
		if unit == GetMainUnit(player_id) then
			Notifications:Top(player_id, {text="Your Hero is under attack!", duration=8, style = {color="red"}})
		end

		PlaySoundOnClient("Announcer_Under_Attack", player_id)

		local screen_effect = ParticleManager:CreateParticleForPlayer("particles/generic_gameplay/screen_damage_indicator.vpcf", PATTACH_EYES_FOLLOW, unit:GetPlayerOwner(), unit:GetPlayerOwner())
		ParticleManager:SetParticleControl(screen_effect, 1, Vector(1,0,0))
		Timers:CreateTimer(2.5,function()
			ParticleManager:DestroyParticle(screen_effect, true)
		end)
		
		-- start modifier cooldown
        local modifier = unit:FindModifierByName("modifier_generic_take_damage_alert_lua")
        if modifier then
            modifier.ready = false
            modifier:StartIntervalThink(4)
        end
    end
end
	
function CAddonTemplateGameMode:OnPlayerConnectFull()
	self:SetupGameMode()
end

function CAddonTemplateGameMode:OnPlayerReconnected(keys)
	--[[
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local unit = GetMainUnit(keys.PlayerID)
	Game_Events:ForceUpdatePlayerHUD(keys.PlayerID)
	if unit == _G.CURSED_UNIT then
		CustomGameEventManager:Send_ServerToPlayer(player, "display_cursed_upgrades",{creature = _G.CURSED_CREATURE})
		CustomGameEventManager:Send_ServerToPlayer(player, "update_cursed_upgrade_level",{daycounter = _G.DAY_COUNTER, creature = _G.CURSED_CREATURE})
		CustomGameEventManager:Send_ServerToPlayer(player, "display_cursed_transform",{creature = _G.CURSED_CREATURE, ent_index = unit:entindex(), cooldown = _G.CURSED_TRANSFORM_COOLDOWN})
		-- update panorama for cursed player, from Game_events:OnHeroSelected
		CustomGameEventManager:Send_ServerToPlayer(player, "update_cursed_unit_entity_index",{ent_index = unit:entindex()})
	end
	]]
end

-- ============================================== other game settings ====================================================
function CAddonTemplateGameMode:SetupGameMode()
	-- everyone always start with omniknight. it is the dummy hero for everyone
	local forceHero = "Omniknight"
	GameRules:GetGameModeEntity():SetCustomGameForceHero(forceHero)

	GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled(UNSEEN_FOW_PITCH_BLACK)
	GameRules:GetGameModeEntity():SetAlwaysShowPlayerNames(false)
	GameRules:GetGameModeEntity():SetAnnouncerDisabled(true)

	GameRules:GetGameModeEntity():SetStashPurchasingDisabled(true)
	GameRules:GetGameModeEntity():SetRecommendedItemsDisabled(true)
	GameRules:GetGameModeEntity():SetCustomBuybackCostEnabled(true)
	GameRules:GetGameModeEntity():SetCustomBuybackCooldownEnabled(true)
	GameRules:GetGameModeEntity():SetBuybackEnabled(false)
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
	
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( self, "FilterExecuteOrder" ), self )
	GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap( self, "FilterExperience" ), self )
    GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( self, "FilterGold" ), self )

	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride(true)
	GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible(false)

	GameRules:GetGameModeEntity():SetUseCustomHeroLevels (true)
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel (HERO_MAX_LEVEL)
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

	GameRules:GetGameModeEntity():SetCustomScanCooldown(3600)
	GameRules:GetGameModeEntity():SetCustomGlyphCooldown(3600)

	-- all runes disabled for this game. check game_constants
	for rune, spawn in pairs(ENABLED_RUNES) do
		GameRules:GetGameModeEntity():SetRuneEnabled(rune, spawn)
	end

	-- time allowed for disconnections. currently set to 5mins
	GameRules:GetGameModeEntity().DisconnectTimeRemaining = DC_TIME_ALLOWANCE

end

--====================================== game state changes and actions at each stage ===============================================
function CAddonTemplateGameMode:OnGameRulesStateChange()
	state = GameRules:State_Get()
	--[[
		if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
	
		elseif state == DOTA_GAMERULES_STATE_HERO_SELECTION then
			self:PostLoadPrecache()
			self:RegisterHostOptions()
			self:SetupInitialTeamSpawns()
			self:PushScoreToCustomNetTable()
			self:GlimpseFix()

	elseif state == DOTA_GAMERULES_STATE_WAIT_FOR_MAP_TO_LOAD then
	  --
	elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
	  self:DisableMinimapCheck()
	]]
	if state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-------------------------------------------- start up the abandonment listener --------------------------------
		--for i=1,10 do
			--executed in utils.lua
		--	StartTeamAbandonmentListener(TEAM_LIST[i])
		--end
		
	  	-------------------------------------------- start up the day_night_detector ----------------------------------
		Day_Night_Detector:Init()

		-------------------------------------------- creating spire in middle of map ----------------------------------
		-- PlaceNeutralBuilding is executed in utils.lua
		_G.SPIRE_UNIT = PlaceNeutralBuilding("spire", MAP_CENTREPOINT, -90)
		_G.SPIRE_UNIT:AddNewModifier(_G.SPIRE_UNIT,nil,"modifier_spire", {})

		-- rotation animation
		Timers:CreateTimer(1,function()
			_G.SPIRE_UNIT:StartGestureWithPlaybackRate(ACT_DOTA_IDLE, 0.4)
			if _G.GAME_HAS_ENDED ~= true then
				return 5
			else
				_G.SPIRE_UNIT:RemoveGesture(ACT_DOTA_IDLE)
			end
		end)

		-------------------------------------------- creating keystones in map -----------------------------------------
		if _G.KEYSTONE_UNIT == nil then
			_G.KEYSTONE_UNIT = {}
			for i=1, #_G.KEYSTONE_LOCATIONS do
				if _G.KEYSTONE_UNIT[i] == nil then
					-- PlaceNeutralBuilding is executed in utils.lua
					_G.KEYSTONE_UNIT[i] = PlaceNeutralBuilding("keystone", _G.KEYSTONE_LOCATIONS[i], -45)
					_G.KEYSTONE_UNIT[i]:AddNewModifier(_G.KEYSTONE_UNIT[i],nil,"modifier_keystone_passive_lua_stacks", {})
					local trees = GridNav:GetAllTreesAroundPoint( _G.KEYSTONE_UNIT[i]:GetAbsOrigin(), 300, true )
					for _,tree in pairs(trees) do
						if tree:IsStanding() then
							tree:CutDown(_G.KEYSTONE_UNIT[i]:GetTeam())
						end
					end
					InitAbilities(_G.KEYSTONE_UNIT[i])
				end
			end
		end

		-------------------------------------- creating xelnaga towers in map -----------------------------------------
		if _G.XELNAGA_TOWER_UNIT == nil then
			_G.XELNAGA_TOWER_UNIT = {}
			for i=1, #_G.XELNAGA_LOCATIONS do
				if _G.XELNAGA_TOWER_UNIT[i] == nil then
					-- PlaceNeutralBuilding is executed in utils.lua
					_G.XELNAGA_TOWER_UNIT[i] = PlaceNeutralBuilding("xelnaga_tower", _G.XELNAGA_LOCATIONS[i], -45)

					-- xelnaga lock modifier. to be removed 1 per day
					_G.XELNAGA_TOWER_UNIT[i]:AddNewModifier(_G.XELNAGA_TOWER_UNIT[i],nil,"modifier_xelnaga_tower_locked_lua", {})

					-- destroy trees around it
					local trees = GridNav:GetAllTreesAroundPoint( _G.XELNAGA_TOWER_UNIT[i]:GetAbsOrigin(), 300, true )
					for _,tree in pairs(trees) do
						if tree:IsStanding() then
							tree:CutDown(_G.XELNAGA_TOWER_UNIT[i]:GetTeam())
						end
					end

					-- init abil for standard xelnaga stuff
					InitAbilities(_G.XELNAGA_TOWER_UNIT[i])
				end
			end
		end

		-------------------------------------- creating key spawners in map --------------------------------------------
		if _G.KEY_SPAWNER_UNIT == nil then
			_G.KEY_SPAWNER_UNIT = {}
			for i=1, #_G.KEY_SPAWN_LOCATIONS do
				_G.KEY_SPAWNER_UNIT[i] = PlaceNeutralBuilding("key_spawner",  _G.KEY_SPAWN_LOCATIONS[i], 135)
				_G.KEY_SPAWNER_UNIT[i]:AddNewModifier(nil,nil,"modifier_key_spawner_lua", {})
				local trees = GridNav:GetAllTreesAroundPoint( _G.KEY_SPAWNER_UNIT[i]:GetAbsOrigin(), 200, true )
				for _,tree in pairs(trees) do
					if tree:IsStanding() then
						tree:CutDown(_G.KEY_SPAWNER_UNIT[i]:GetTeam())
					end
				end
			end
		end

		-------------------------------------- creating goldmines in map --------------------------------------------
		if _G.GOLDMINE_UNIT == nil then
			_G.GOLDMINE_UNIT = {}
			
			for i=1, _G.GOLDMINE_COUNT do
				local location = Vector(
					RandomFloat(
						(-6000 + _G.GOLDMINE_MAP_BORDER_OFFSET_DISTANCE),
						(6000 - _G.GOLDMINE_MAP_BORDER_OFFSET_DISTANCE)
					),
					RandomFloat(
						(-6000 + _G.GOLDMINE_MAP_BORDER_OFFSET_DISTANCE),
						(6000 - _G.GOLDMINE_MAP_BORDER_OFFSET_DISTANCE)
					),
					0
				)
				local vector = Vector(location.x-_G.MAP_CENTREPOINT.x, location.y-_G.MAP_CENTREPOINT.y, location.z-_G.MAP_CENTREPOINT.z)
				local distance_to_centre = math.sqrt(vector.x * vector.x + vector.y * vector.y)
				local nearby_goldmines = GetGoldMinesAroundRadius(location, _G.GOLDMINE_GOLDMINE_DISTANCE)
				local nearby_xelnagas = GetXelNagasAroundRadius(location, _G.GOLDMINE_XELNAGA_DISTANCE)
				local nearby_keystones = GetKeystonesAroundRadius(location, _G.GOLDMINE_KEYSTONE_DISTANCE)
				local nearby_keyspawners = GetKeyspawnersAroundRadius(location, _G.GOLDMINE_KEYSPAWNER_DISTANCE)
				local nearby_trees = GridNav:GetAllTreesAroundPoint(location, 200, false)
				local counter = 0
				local stage = 0
				--[[
				print("=================== goldmine " .. i .. ", iteration " .. counter)
				print(#nearby_goldmines)
				print(#nearby_xelnagas)
				print(#nearby_keystones)
				print(#nearby_keyspawners)
				print(#nearby_trees)
				print(location)
				]]
				while (counter < 1950) and ( (not GridNav:IsTraversable(location)) or (distance_to_centre < ( _G.GOLDMINE_CENTRE_DISTANCE)) or (#nearby_goldmines > 0) or (#nearby_xelnagas > 0) or (#nearby_keystones > 0) or (#nearby_keyspawners > 0) or (#nearby_trees > 0) ) do
					location = Vector(
						RandomFloat(
							(-6000 + _G.GOLDMINE_MAP_BORDER_OFFSET_DISTANCE),
							(6000 - _G.GOLDMINE_MAP_BORDER_OFFSET_DISTANCE)
						),
						RandomFloat(
							(-6000 + _G.GOLDMINE_MAP_BORDER_OFFSET_DISTANCE),
							(6000 - _G.GOLDMINE_MAP_BORDER_OFFSET_DISTANCE)
						),
						0
					)
					vector = Vector(location.x-_G.MAP_CENTREPOINT.x, location.y-_G.MAP_CENTREPOINT.y, location.z-_G.MAP_CENTREPOINT.z)
					distance_to_centre = math.sqrt(vector.x * vector.x + vector.y * vector.y)
					nearby_goldmines = GetGoldMinesAroundRadius(location, _G.GOLDMINE_GOLDMINE_DISTANCE-(150 * stage))
					nearby_xelnagas = GetXelNagasAroundRadius(location, _G.GOLDMINE_XELNAGA_DISTANCE-(150 * stage))
					nearby_keystones = GetKeystonesAroundRadius(location, _G.GOLDMINE_KEYSTONE_DISTANCE-(150 * stage))
					nearby_keyspawners = GetKeyspawnersAroundRadius(location, _G.GOLDMINE_KEYSPAWNER_DISTANCE-(150 * stage))
					nearby_trees = GridNav:GetAllTreesAroundPoint(location, 200, false)
					counter = counter + 1
					if math.fmod(counter,400) == 0 then
						stage = stage + 1
					end
				end
				print("goldmine " .. i .. " attempted " .. counter .. " times.")
				print(location)
				_G.GOLDMINE_UNIT[i] = PlaceNeutralBuilding("goldmine",  location, 90)
				_G.GOLDMINE_UNIT[i]:AddNewModifier(nil,nil,"modifier_goldmine_passive_lua", {})
				local trees = GridNav:GetAllTreesAroundPoint( _G.GOLDMINE_UNIT[i]:GetAbsOrigin(), 200, true )
				for _,tree in pairs(trees) do
					if tree:IsStanding() then
						tree:CutDown(_G.GOLDMINE_UNIT[i]:GetTeam())
					end
				end
			end
		end

		---------------------------------------------- spire sfx at start of game --------------------------------------
		Timers:CreateTimer(_G.STARTING_WARMUP_SPIRE_SFX_START, function()
			
			local point = Vector(0,0,650)
			-- starting sfx

			-- relocate sound
			--EmitSoundOn("Hero_Wisp.Relocate", SPIRE_UNIT)
			
			EmitSoundOn("Hero_Invoker.EMP.Charge", SPIRE_UNIT)
			
			--local particle_effect = "particles/econ/events/ti9/teleport_end_ti9_lvl2.vpcf"
			--local effect = ParticleManager:CreateParticle(particle_effect, PATTACH_ABSORIGIN_FOLLOW, SPIRE_UNIT)
			--ParticleManager:SetParticleControl(effect, PATTACH_ABSORIGIN_FOLLOW, SPIRE_UNIT:GetAbsOrigin())

			local particle_effect = "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf"
			local effect = ParticleManager:CreateParticle(particle_effect, PATTACH_ABSORIGIN_FOLLOW, SPIRE_UNIT)
    		ParticleManager:SetParticleControlEnt(effect, 0, SPIRE_UNIT, PATTACH_POINT_FOLLOW, "attach_hitloc", SPIRE_UNIT:GetOrigin(), true)
    		ParticleManager:SetParticleControlEnt(effect, 6, SPIRE_UNIT, PATTACH_POINT_FOLLOW, "attach_hitloc", SPIRE_UNIT:GetOrigin(), true)

			-- delayed sfx
			Timers:CreateTimer(_G.STARTING_WARMUP_SPIRE_SFX_DURATION,function()
				ParticleManager:DestroyParticle(effect, true)

				particle_effect = "particles/econ/items/outworld_devourer/od_ti8/od_ti8_santies_eclipse_area_shockwave.vpcf"
				effect = ParticleManager:CreateParticle(particle_effect, PATTACH_ABSORIGIN_FOLLOW, SPIRE_UNIT)
				ParticleManager:SetParticleControlEnt(effect, 0, SPIRE_UNIT, PATTACH_POINT_FOLLOW, "attach_hitloc", SPIRE_UNIT:GetOrigin(), true)
				ParticleManager:ReleaseParticleIndex(effect)

				--particle_effect = "particles/units/heroes/hero_rubick/rubick_supernova_egg_ring_start.vpcf"
				--effect = ParticleManager:CreateParticle(particle_effect, PATTACH_ABSORIGIN_FOLLOW, SPIRE_UNIT)
				--ParticleManager:SetParticleControl(effect, PATTACH_ABSORIGIN_FOLLOW, SPIRE_UNIT:GetAbsOrigin())
				--ParticleManager:ReleaseParticleIndex(effect)
				
				particle_effect = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_bolt_parent.vpcf"
				for _,unit in pairs(GetAllFarmers()) do
					EmitSoundOn("Hero_Sven.StormBoltImpact", unit)
					effect = ParticleManager:CreateParticle(particle_effect, PATTACH_ABSORIGIN_FOLLOW, unit)
					ParticleManager:SetParticleControl(effect, PATTACH_ABSORIGIN_FOLLOW, unit:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(effect)
				end

				--StopSoundOn("Hero_Wisp.Relocate", SPIRE_UNIT)
				StopSoundOn("Hero_Invoker.EMP.Charge", SPIRE_UNIT)
				EmitSoundOn("Hero_Invoker.EMP.Discharge", SPIRE_UNIT)
				-- supernova sound
				
				EmitSoundOn("Hero_Phoenix.SuperNova.Explode", SPIRE_UNIT)

			end)
			return nil
		end)

		----------------------- choose cursed after spire sfx is finished. and cursed unit stats and abils. and tutorial notifs and hud ui startup ----------------------
		Timers:CreateTimer(_G.STARTING_WARMUP_SPIRE_SFX_START + _G.STARTING_WARMUP_SPIRE_SFX_DURATION, function()
			print("There are now " .. CountFarmersInGame() .. " farmers in game")
			
			-- choose cursed player
			if TOOLS_MODE then
				if _G.ALWAYS_IS_CURSED == true then
					_G.CURSED_UNIT = GetMainUnit(0)
				else
					_G.CURSED_UNIT = Game_Events:ChooseCursed()
				end
			else
				_G.CURSED_UNIT = Game_Events:ChooseCursed()
			end

			-- randomise form of cursed
			local rndm_number = RandomInt(1,#_G.CURSED_TYPES)
			_G.CURSED_CREATURE = _G.CURSED_TYPES[rndm_number]
			print("the cursed form for this game shall be a ".. _G.CURSED_CREATURE)

			-- settings for each special cursed
			if _G.CURSED_CREATURE == "werewolf" then
				-- cursed stats based on global table in game_constants.lua. used in modifier_werewolf
				CustomNetTables:SetTableValue("cursed_stats", "0", _G.WEREWOLF_STATS_TABLE[CountPlayersInGame()])
				
				-- cooldown time for werewolf transform
				_G.CURSED_TRANSFORM_COOLDOWN = _G.WEREWOLF_TRANSFORM_COOLDOWN

				-- adding cursed abilities
				_G.CURSED_UNIT:AddAbility("wolf_sniff") -- starts at level 0
				_G.CURSED_UNIT:AddAbility("mirana_leap_lua") -- starts at level 0
				_G.CURSED_UNIT:AddAbility("werewolf_instinct_lua") -- starts at level 0
				_G.CURSED_UNIT:AddAbility("werewolf_crit_strike_lua") -- starts at level 0
				_G.CURSED_UNIT:AddAbility("ursa_enrage_lua")
				local abil = _G.CURSED_UNIT:FindAbilityByName("ursa_enrage_lua")
				abil:SetLevel(1)
				_G.CURSED_UNIT:AddAbility("xelnaga_tower_deactivate_lua")
				abil = _G.CURSED_UNIT:FindAbilityByName("xelnaga_tower_deactivate_lua")
				abil:SetLevel(1)

			elseif _G.CURSED_CREATURE == "vampire" then
				-- cursed stats based on global table in game_constants.lua. used in modifier_werewolf
				CustomNetTables:SetTableValue("cursed_stats", "0", _G.VAMPIRE_STATS_TABLE[CountPlayersInGame()])
				
				-- cooldown time for werewolf transform
				_G.CURSED_TRANSFORM_COOLDOWN = _G.VAMPIRE_TRANSFORM_COOLDOWN

				-- adding cursed abilities
				_G.CURSED_UNIT:AddAbility("vampire_ascend_lua") -- starts at level 1
				_G.CURSED_UNIT:AddAbility("vampire_blood_bath_lua") -- starts at level 0
				_G.CURSED_UNIT:AddAbility("vampire_delirium_lua") -- starts at level 0
				_G.CURSED_UNIT:AddAbility("vampire_sol_skin_lua") -- starts at level 1
				local abil = _G.CURSED_UNIT:FindAbilityByName("vampire_sol_skin_lua")
				abil:SetLevel(1)
				_G.CURSED_UNIT:AddAbility("vampire_shadow_ward_lua")
				_G.CURSED_UNIT:AddAbility("vampire_impact_lua")
				abil = _G.CURSED_UNIT:FindAbilityByName("vampire_ascend_lua")
				abil:SetLevel(1)
				_G.CURSED_UNIT:AddAbility("xelnaga_tower_deactivate_lua")
				abil = _G.CURSED_UNIT:FindAbilityByName("xelnaga_tower_deactivate_lua")
				abil:SetLevel(1)

			elseif _G.CURSED_CREATURE == "zombie" then
				-- cursed stats based on global table in game_constants.lua. used in modifier_werewolf
				--CustomNetTables:SetTableValue("cursed_stats", "0", _G.ZOMBIE_STATS_TABLE[CountPlayersInGame()])
				
				-- cooldown time for werewolf transform
				_G.CURSED_TRANSFORM_COOLDOWN = _G.ZOMBIE_TRANSFORM_COOLDOWN
			end

			-- sfx in test mode to know who
			if TOOLS_MODE then
				local particle_cast = "particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest.vpcf"
				local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW,_G.CURSED_UNIT )
				ParticleManager:SetParticleControl(effect_cast, 0, _G.CURSED_UNIT:GetOrigin())
				ParticleManager:ReleaseParticleIndex( effect_cast )
			end

			-- tutorial
			for i=0, 15 do
				if PlayerResource:GetPlayer(i) ~= nil then
					cursed_tutorial:Start(i)
				end 
			end

			-- rnm sound
			Timers:CreateTimer(10,function()
				EmitAnnouncerSound("announcer_dlc_rick_and_morty_idle_place_is_freaky")
			end)

			-- init HUDs
			for i = 0, 15, 1 do
				if PlayerResource:IsValidPlayerID(i) then
					-- hud start up
					Game_Events:InitPlayerHUD(i)
				end
			end

			return nil
		end)

		--------------------------- after TIME_AS_UNKNOWN_ROLES seconds, tell cursed player. also initialize objectives ------------------------------------
		local random_timing = RandomInt(_G.TIME_AS_UNKNOWN_ROLES_MIN, _G.TIME_AS_UNKNOWN_ROLES_MAX)
		Timers:CreateTimer(random_timing, function()
			Notifications:Bottom(_G.CURSED_UNIT:GetPlayerOwnerID(), {text="You are the Cursed ", duration=10})
			Notifications:Bottom(_G.CURSED_UNIT:GetPlayerOwnerID(), {text=FirstLetterToUppercase(_G.CURSED_CREATURE), continue = true})
			Notifications:Bottom(_G.CURSED_UNIT:GetPlayerOwnerID(), {text="! Prepare to eliminate the other players!", continue = true})
			
			if _G.CURSED_CREATURE == "zombie" then
				Notifications:Bottom(_G.CURSED_UNIT:GetPlayerOwnerID(), {text="As the zombie, you cannot choose a hero class", duration=10})
			end

			-- objectives and hero menu
			for i=0,15,1 do
				if PlayerResource:IsValidPlayerID(i) then
					Game_Events:InitObjectives(i)
					Game_Events:ObjectivesUpdate(i)

					-- activate choose hero menu
					local mainunit = GetMainUnit(i)
					if _G.CURSED_CREATURE == "zombie" and mainunit == _G.CURSED_UNIT then
						-- dont activate abil
					else
						local abil = mainunit:FindAbilityByName("choose_hero_lua")
						if abil then
							Game_Events:InitHeroSelectionUI(i)
							abil:SetActivated(true)
						end
					end
				end
			end
			_G.OBJECTIVES_UI_SHOWN = true -- used for Game_Events:ForceUpdatePlayerHUD

			--sfx
			PlaySoundOnClient("Announcer.Cursed_Player_Start", _G.CURSED_UNIT:GetPlayerOwnerID())
		end)

		---------------------------------------- 0.5 seconds before first night, give cursed player transformation and upgrades -----------------------------
		Timers:CreateTimer((_G.DAY_DURATION-0.5), function()
			Notifications:Bottom(_G.CURSED_UNIT:GetPlayerOwnerID(), {text="Your hunt as the ", duration=8})
			Notifications:Bottom(_G.CURSED_UNIT:GetPlayerOwnerID(), {text=_G.CURSED_CREATURE .. " ", style={color="red"}, continue=true})
			Notifications:Bottom(_G.CURSED_UNIT:GetPlayerOwnerID(), {text="begins!", continue=true})

			-- if zombie then immediately turn
			if _G.CURSED_CREATURE == "zombie" then
				Game_Events:InitializeAlphaZombie(_G.CURSED_UNIT:GetPlayerOwnerID())
			end

			-- hud
			CustomGameEventManager:Send_ServerToPlayer(_G.CURSED_UNIT:GetPlayerOwner(), "display_cursed_upgrades",{creature = _G.CURSED_CREATURE})
			CustomGameEventManager:Send_ServerToPlayer(_G.CURSED_UNIT:GetPlayerOwner(), "display_cursed_transform",{creature = _G.CURSED_CREATURE, ent_index = GetMainUnit(_G.CURSED_UNIT:GetPlayerOwnerID()):entindex(), cooldown = _G.CURSED_TRANSFORM_COOLDOWN})
			_G.CURSED_EXTRAS_UI_SHOWN = true -- used for Game_Events:ForceUpdatePlayerHUD

			--sfx
			PlaySoundOnClient("Cursed_begin_hunt", _G.CURSED_UNIT:GetPlayerOwnerID())
		end)

		-------------------------------- top notification for all players as a welcome message ------------------------
		Timers:CreateTimer(1,function()
			Notifications:BottomToAll({text="Welcome to... ", duration = _G.STARTING_WARMUP_SPIRE_SFX_START - 1})
		end)
		Timers:CreateTimer(2,function()
			Notifications:BottomToAll({text="Cursed!", style = {color="red"}, continue = true})
			EmitGlobalSound("Conquest.Glyph.Cast")
		end)

		----------------------------------------------- start up the game_events --------------------------------------
		Game_Events:Init()

		---------------------------------------------- start up the key spawning --------------------------------------
		Game_Events:KeySpawning()

	end
end

--================================================== for unit spawning ==============================================================
function CAddonTemplateGameMode:OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)
	if (npc:GetUnitName() == "spire") or (npc:GetUnitName() == "dummy_unit") or (npc:GetUnitName() == "fly_unit") or (npc:GetUnitName() == "trap_unit") or (npc:GetUnitName() == "ghost_sfx_dummy_unit") then return end
	
	-- bracket here applies for ALL units that arent dummy units

	-- auto attack switched off for real games. on for tools_mode so that enemies will attack u
	if (TOOLS_MODE == false) then
		if not IsZombie(npc) then
			local modifier = npc:FindModifierByName("modifier_generic_auto_attack_off_lua")
			if not modifier then
				npc:AddNewModifier(npc,nil,"modifier_generic_auto_attack_off_lua",{})
			end
		end
	end

	if npc:IsRealHero() and npc:GetUnitName() == "npc_dota_hero_omniknight" and npc.FirstSpawnRegistered == nil then
		---------------- spawned unit is the dummy unit starting hero. use it to activate the farmer unit ---------------------
		local player = npc:GetPlayerID()
		-- spawning the farmer unit for the player
		-- direction is based on playerID number
		local playercount = CountPlayersInGame()
		local distance = 180
		local segment = 360/playercount
		local position = MAP_CENTREPOINT + Vector(distance, 0, 0)
		local rotation = QAngle(0, (npc:GetPlayerID() * segment), 0)
		position = RotatePosition(MAP_CENTREPOINT, rotation, position)

		-- create farmer main unit
		local unit = CreateUnitByName(STARTING_UNIT_NAME, position, true, npc, npc, PlayerResource:GetTeam(player))
		unit.FirstSpawnRegistered = true
		unit:SetOwner(npc)
		unit:SetControllableByPlayer(player, true)
		unit:SetForwardVector(RandomVector(10))
		npc:GetPlayerOwner().Main_Unit = unit
		npc:GetPlayerOwner().fake_omniknight_hero = npc

		-- CNT
		CustomNetTables:SetTableValue("player_hero", tostring(player), {chosen = false, needrespawn = false})
		CustomNetTables:SetTableValue("player_important_units", tostring(player), {fake_hero_index = npc:entindex(), main_unit_index = unit:entindex(), loser_unit_index = nil})

		-- hiding omniknight (the dummy hero)
		npc:AddNoDraw()
		npc:AddNewModifier(npc, nil, "modifier_hidden", {})

		-- Redirects the selection of dummy hero to farmer unit
		npc:SetSelectionOverride(unit)

		-- set player's starting resources
		Resources:InitializePlayer(npc:GetPlayerID())

		-- moving omniknight to some location(?)
		FindClearSpaceForUnit(npc, MAP_CENTREPOINT, true)

		-- perma FOW at spire for all players
		AddFOWViewer(npc:GetTeam(), MAP_CENTREPOINT, 1000, 3600, false)

		-- initialize farmer for player
		CAddonTemplateGameMode:OnFarmerInGame(unit)
	
	elseif npc:IsConsideredHero() then
		if npc.FirstSpawnRegistered == nil then
			---------------------------------- spawned unit is a hero spawned for first time --------------------------------------
			npc.FirstSpawnRegistered = true
			--InitAbilities(npc) already done in game_events:OnHeroSelected()
		else
			local player_id = npc:GetPlayerOwnerID()
			npc:Hold()
			if npc == GetMainUnit(player_id) then
				------------------------------------------------ hero respawning actions --------------------------------------------------

				-- if it is defender
				if npc:FindAbilityByName("defender_energy_shield_lua") then
					if npc:FindAbilityByName("defender_energy_shield_lua"):IsCooldownReady() then
						npc:FindAbilityByName("defender_energy_shield_lua"):OnUpgrade()
					end
				end

				-- add hero into table of units
				local hPlayer = PlayerResource:GetPlayer(player_id)
				local newtable = UpdateNetTable(CustomNetTables:GetTableValue("player_hero", tostring(player_id)), "needrespawn", false)
				CustomNetTables:SetTableValue("player_hero", tostring(player_id), newtable)

				-- sfx and notification
				PlaySoundOnAllClients("Hero_death_Revive")

				-- camera
                MoveCameraToTarget(npc, player_id, 0.4)

				-- notifications
				local playername = PlayerResource:GetPlayerName(player_id)
				local teamID = npc:GetTeam()
            	local color = ColorForTeam(teamID)
				Notifications:BottomToAll({text= playername .. " ", duration=8, style = {color="rgb(" .. color[1] .. "," .. color[2] .. "," .. color[3] .. ")"} })
				Notifications:BottomToAll({text="has just been revived",  continue=true})

				-- updating objectives in HUD
				for i = 0,15,1 do
					if PlayerResource:IsValidPlayerID(i) then
						Game_Events:ObjectivesUpdate(i)
					end
				end

			elseif npc == GetLoserUnit(player_id) then
				-- ghost respawning
			end
		end

	-- in this bracket, units that spawn/respawn are not real heroes (AKA creep heroes), nor farmer units. (buildings, sheep, workers, fighters, loser units)
	--elseif npc:GetUnitName() == "hunter_unit" then
	--	npc:SetRenderColor(255, 255, 0)
	--elseif npc:GetUnitName() == "zombie_unit_runner" then
	--	npc:SetRenderColor(255, 100, 100)
	--elseif npc:GetUnitName() == "warrior_unit" then
	--	npc:SetRenderColor(255, 60, 60)
	end
end

--=============================== what happens when the farmer unit is spawned into the game ========================================
function CAddonTemplateGameMode:OnFarmerInGame(farmer)

	-- This function comes from util.lua and will go through all the hero's abilities and set
	-- their level to 1, and it spends the first given ability point in the process.
	InitAbilities(farmer)

	-- turn off hero choosing until cursed is decided
	local abil = farmer:FindAbilityByName("choose_hero_lua")
	if abil then
		abil:SetActivated(false)
	end
	
	local hPlayer = farmer:GetPlayerOwner()
	local playerid = farmer:GetPlayerOwnerID()

	-- make farmer unit the player's default selection
	PlayerResource:SetDefaultSelectionEntity(playerid, farmer)

	-- Show a popup with game instructions.
  	-- ShowGenericPopupToPlayer(farmer.player, "#samplerts_instructions_title", "#samplerts_instructions_body", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )
	
	-- weather effects for player camera
	CAddonTemplateGameMode:weather_effects_start(hPlayer)

	-- pause at start of game
	farmer:AddNewModifier(farmer, nil, "modifier_pregame_warmup", {duration = _G.STARTING_WARMUP_SPIRE_SFX_START + _G.STARTING_WARMUP_SPIRE_SFX_DURATION})

	-- move camera to spire at start of game
    MoveCameraToTarget( SPIRE_UNIT, playerid, 1.0)

	-- setting farmer unit's player color
	local teamID_1 = farmer:GetTeam()
	local color1 = ColorForTeam(teamID_1)
	PlayerResource:SetCustomPlayerColor( playerid, color1[1], color1[2], color1[3] )

	-- playernames for villagers
	local playername = PlayerResource:GetPlayerName(playerid)
	farmer:SetCustomHealthLabel( playername, color1[1], color1[2], color1[3] )

	-- hidden villager modifier for detecting taking dmg. this is for alerting player of attacks
	farmer:AddNewModifier(farmer, nil, "modifier_generic_take_damage_alert_lua", {})

	-- revivable
	farmer:SetUnitCanRespawn(true)

	-- hud start up
	--Game_Events:InitPlayerHUD(playerid)
	--Game_Events:ForceUpdatePlayerHUD(playerid)
end

function CAddonTemplateGameMode:weather_effects_start(player)
	local snow = ParticleManager:CreateParticle("particles/rain_fx/econ_rain.vpcf", PATTACH_EYES_FOLLOW, player)
	ParticleManager:SetParticleControl(snow, 1, Vector(1,0,0))
end

--==================================================== on unit death ================================================================

function CAddonTemplateGameMode:OnEntityKilled(kv)
	--for key,val in pairs(kv) do
	--	print(key, val)
	--end
	local victim = EntIndexToHScript(kv.entindex_killed)
	local attacker = EntIndexToHScript(kv.entindex_attacker)
	local victim_player_id = victim:GetPlayerOwnerID()
	local attacker_player_id = attacker:GetPlayerOwnerID()
	local victim_player = victim:GetPlayerOwner()
	if not victim then return end
	if not victim_player_id then return end
	if not victim:IsIllusion() and victim:GetUnitName() ~= "druid_tree_eye" and victim:GetUnitName() ~= "dummy_unit" and victim:GetUnitName() ~= "fly_unit" and victim:GetUnitName() ~= "trap_unit" and victim:GetUnitName() ~= "ghost_sfx_dummy_unit" then
		if victim == victim_player.Main_Unit then
			-- actual events to carry out here
			local newtable = UpdateNetTable(CustomNetTables:GetTableValue("player_hero", tostring(victim_player_id)), "needrespawn", true)
			CustomNetTables:SetTableValue("player_hero", tostring(victim_player_id), newtable)

			-- drop relevant items
			for i=0,8 do
				local carried_item = victim:GetItemInSlot(i)
				if carried_item then
					if carried_item:GetAbilityName() == "item_keystone_key" or carried_item:GetAbilityName() == "item_truth_lens" then
						victim:DropItemAtPositionImmediate(carried_item, victim:GetAbsOrigin() + RandomVector(100))
					end
				end
			end

			-- cursed is killed
			if victim == _G.CURSED_UNIT then
				-- end game
				Game_Events:OnCursedKilled(victim,victim_player_id,attacker,attacker_player_id)

			-- some other human farmer unit is killed so the game continues
			else
				-- hero revive event
				Game_Events:OnHeroNeedsRevive(victim,victim_player_id)
			end
			
		else
			-- other units deaths
			if IsZombie(victim) then
				_G.ZOMBIE_UNIT_COUNT = _G.ZOMBIE_UNIT_COUNT - 1

				-- check for zombie unit debt
				if _G.ZOMBIE_UNITS_WAITING_TO_SPAWN ~= nil then
					if _G.ZOMBIE_UNITS_WAITING_TO_SPAWN > 0 then
						local horde_abil = _G.CURSED_UNIT:FindAbilityByName("zombie_summon_wave_lua")
						if horde_abil then
							while (_G.ZOMBIE_UNITS_WAITING_TO_SPAWN > 0) and (_G.ZOMBIE_UNIT_COUNT < _G.ZOMBIE_UNIT_MAX_COUNT) do
								local location = horde_abil:ChooseZombieRandomSpawnLocation(attacker:GetAbsOrigin(), _G.CURSED_UNIT:GetPlayerOwnerID(), horde_abil:GetSpecialValueFor("max_radius"))
								Game_Events:SpawnZombie(location, _G.CURSED_UNIT:GetPlayerOwnerID(), true)
								_G.ZOMBIE_UNITS_WAITING_TO_SPAWN = _G.ZOMBIE_UNITS_WAITING_TO_SPAWN - 1
							end
						end
					end
				end
			end
			
			-- a loser unit dies. needs respawn for ghost and the wolf do what?
			if victim:GetUnitName() == "wolf_loser_main_unit" or victim:GetUnitName() == "ghost_loser_main_unit" then
				if not victim_player.Main_Unit:IsAlive() then
					Game_Events:OnLoserUnitDeath(victim, victim_player_id)
				end
			end
		end
	end
end

------------------------------------------------------------------
--                     Execute Order Filter                     --
------------------------------------------------------------------
function CAddonTemplateGameMode:FilterExecuteOrder( filterTable )
	
	local units = filterTable["units"]
    local order_type = filterTable["order_type"]
    local issuer = filterTable["issuer_player_id_const"]
	local abilityIndex = filterTable["entindex_ability"]
	local abil = EntIndexToHScript(abilityIndex)
	local targetIndex = filterTable["entindex_target"]
	local target = EntIndexToHScript(targetIndex)
	--[[
    local x = tonumber(filterTable["position_x"])
    local y = tonumber(filterTable["position_y"])
    local z = tonumber(filterTable["position_z"])
	local point = Vector(x,y,z)
	]]
	local queue = filterTable["queue"] == 1

	--Check if the order is the glyph type
	if order_type == DOTA_UNIT_ORDER_GLYPH then
		return false
	end

	-- giving items to buildings, giving keys...
	if order_type == DOTA_UNIT_ORDER_GIVE_ITEM then
		if IsBuildingOrSpire(target) then
			SendErrorMessage(issuer, "Cannot give items to buildings")
			return false
		elseif abil:GetAbilityName() == "item_keystone_key" then
			-- check if target already holding onto another key
			for i=0,8 do
				local carried_item = target:GetItemInSlot(i)
				if carried_item then
					if carried_item:GetAbilityName() == "item_keystone_key" then
						SendErrorMessage(issuer, "Target already holding on to a Key")
						return false
					end
				end
			end
		end
	end

	--casting abilities and items
	if order_type == DOTA_UNIT_ORDER_CAST_TARGET then
		-- prevent items from being used on buildings
		if abil:GetAbilityName() == "item_flask" or abil:GetAbilityName() == "item_clarity" then
			if IsBuildingOrSpire(target) then
				SendErrorMessage(issuer, "Cannot use item on buildings")
				return false
			end

		--casting key on keystone. make sure the keystone is not filled
		elseif abil:GetAbilityName() == "item_keystone_key" then
			if IsBuildingOrSpire(target) and target:GetUnitName() == "keystone" then
				if not _G.SPIRE_UNIT:HasModifier("modifier_endgame_portal_lua") then
					local index = getIndexTable(_G.KEYSTONE_UNIT, target)
					if index then
						local mytable = CustomNetTables:GetTableValue("keystone_status", tostring(index))
						if (mytable.keys >= _G.KEYS_TO_ACTIVATE_KEYSTONE[CountPlayersInGame()]) or (mytable.activated > 1) then
							SendErrorMessage(issuer, "Keystone already activated")
							return false
						end
					end
				else
					--endgame portal
					SendErrorMessage(issuer, "Escape Portal already opened!")
					PingLocationOnClient(_G.SPIRE_UNIT:GetAbsOrigin(), issuer)
					return false
				end
			else
				--target is not a keystone
				SendErrorMessage(issuer, "Must use on a Keystone")
				return false
			end

		--casting truth lens. only can cast on main unit
		elseif abil:GetAbilityName() == "item_truth_lens" then
			local targetplayerid = target:GetPlayerOwnerID()
			if (not PlayerResource:IsValidPlayerID(targetplayerid)) or (target ~= GetMainUnit(targetplayerid)) then
				--target is not a main unit
				SendErrorMessage(issuer, "Must use on Villager/Hero")
				return false
			end
		-- guardian revive can only cast on tombstones
		elseif abil:GetAbilityName() == "tombstone_revive_lua" then
			if target:GetUnitName() ~= "tombstone_unit" then
				SendErrorMessage(issuer, "Must cast on a Tombstone")
				return false
			end
		-- guardian resurrect can only cast on ghosts
		elseif abil:GetAbilityName() == "guardian_resurrect_lua" then
			if target:GetUnitName() ~= "ghost_loser_main_unit" then
				SendErrorMessage(issuer, "Must cast on Ghosts")
				return false
			end

		-- illusionist cannot cast on cursed forms
		elseif abil:GetAbilityName() == "illusionist_conjure_image_lua" then
			if IsInCursedForm(target) then
				SendErrorMessage(issuer, "Cannot cast on Cursed Forms")
				return false
			end

		-- defender energy shield cannot cast on cursed forms
		elseif abil:GetAbilityName() == "defender_energy_shield_lua" then
			if IsInCursedForm(target) then
				SendErrorMessage(issuer, "Cannot cast on Cursed Forms")
				return false
			end
		end

	end

	-- swapping 'toggle' items when dropping them on ground or giving item to other unit
	if order_type == DOTA_UNIT_ORDER_DROP_ITEM or order_type == DOTA_UNIT_ORDER_GIVE_ITEM then
		-- item torchlight
		if abil:GetAbilityName() == "item_torch_active" then
			local unit = EntIndexToHScript(filterTable.units["0"])
			-- turning off torch
			local modifier = unit:FindModifierByName( "modifier_item_torch_lua" )
			if modifier then
				--remove torch modifier
				modifier:Destroy()
			end
			local mytable = {caster = unit, ability = abil}
			swap_to_item(mytable, "item_torch_inactive")
			abil2 = unit:FindItemInInventory("item_torch_inactive")
			filterTable.entindex_ability = abil2:entindex()
			return true
		end
	end

	if order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
		local unit = EntIndexToHScript(filterTable.units["0"])

		-- wolf vs allied building friendly fire turn off
		if unit:GetUnitName() == "wolf_loser_main_unit" then
			if target:GetTeam() == unit:GetTeam() then
				SendErrorMessage(unit:GetPlayerOwnerID(), "Cannot attack allies")
				return false
			end
		end
	end

	-- item picking up
	if order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then
        if not target or not IsValidEntity(target) then return false end
        local item = target:GetContainedItem()
		
		-- sheep_basket and keystone key
		if item:GetAbilityName() == "item_sheep_basket" or item:GetAbilityName() == "item_keystone_key" then
			local unit = EntIndexToHScript(filterTable.units["0"])
			-- test mode check
			if unit ~= GetMainUnit(issuer) then

				-- Does the selected group have main unit?
				local selectedUnits = PlayerResource:GetSelectedEntities(issuer)
				local mainunits = 0
				for _,ent_index in pairs(selectedUnits) do
					local u = EntIndexToHScript(ent_index)
					if u == GetMainUnit(issuer) then
						mainunits = mainunits + 1
					end
				end
				if mainunits > 0 then
					local main_unit = GetMainUnit(issuer)
					if IsInCursedForm(main_unit) then
						SendErrorMessage(issuer, "Cannot pick up in Cursed Form")
						return false
					else
						-- check if main unit already holding onto another key
						for i=0,8 do
							local carried_item = main_unit:GetItemInSlot(i)
							if carried_item then
								if carried_item:GetAbilityName() == "item_keystone_key" then
									SendErrorMessage(issuer, "Cannot pick up more than one Key")
									return false
								end
							end
						end
						main_unit:PickupDroppedItem(target)
						return false
					end
				else
					SendErrorMessage(issuer, "Only Villager/Hero can pick up")
					return false
				end
			
			-- unit is a main unit
			--test mode check
			elseif unit:IsAlive() and IsValidEntity(unit) then
				if IsInCursedForm(unit) then
					SendErrorMessage(issuer, "Cannot pick up in Cursed Form")
					return false
				else
					-- check if main unit already holding onto another key
					for i=0,8 do
						local carried_item = unit:GetItemInSlot(i)
						if carried_item then
							if carried_item:GetAbilityName() == "item_keystone_key" then
								SendErrorMessage(issuer, "Cannot pick up more than one Key")
								return false
							end
						end
					end
				end
			end

		end
	end

	-- actions for scout track abil
	if order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
		if abil:GetAbilityName() == "tracker_track_lua" then
			local buffer = abil:GetSpecialValueFor("buffer_time")
			if _G.CURSED_CREATURE == "werewolf" then
				if (GameRules:GetGameModeEntity().HalfCycleTimeRemaining <= buffer) or (GameRules:GetGameModeEntity().HalfCycleTimeRemaining >= (_G.DAY_DURATION - buffer)) then
					SendErrorMessage(issuer, "Too close to sunrise/sunset")
					return false
				end
			end
		end
	end

	-- actions for activating xel naga and tobmstone revival
	if order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET or order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
		local unit = EntIndexToHScript(filterTable.units["0"])

		if target:IsAlive() and IsValidEntity(target) then
			if target:GetUnitName() == "xelnaga_tower" or target:GetUnitName() == "goldmine" or target:HasModifier("modifier_revival_dummy") then
				return false
			end
		end
	end

	--Return true by default to keep all other orders the same
	return true
end

------------------------------------------------------------------
--                       Experience Filter                      --
------------------------------------------------------------------
function CAddonTemplateGameMode:FilterExperience( filterTable )
    local experience = filterTable["experience"]
    local playerID = filterTable["player_id_const"]
    local reason = filterTable["reason_const"]

    -- Disable all hero kill experience
    if reason == DOTA_ModifyXP_HeroKill then
        return false
    end
    return true
end

------------------------------------------------------------------
--                          Gold Filter                         --
------------------------------------------------------------------
function CAddonTemplateGameMode:FilterGold( filterTable )
    local gold = filterTable["gold"]
    local playerID = filterTable["player_id_const"]
    local reason = filterTable["reason_const"]

    -- Disable all hero kill gold and death gold loss
    if reason == DOTA_ModifyGold_HeroKill or reason == DOTA_ModifyGold_Death then
        return false
    end
    return true
end

--[[
	TO DO LIST
	- vampire
	- gold mining penalty for player deaths?
	
	LIST OF CHECKS FOR TESTING
	- TOOLSMODE
	- hero goldcosts -> hero_selection.js
	- hero upgrades -> hero_upgrades.js
]]