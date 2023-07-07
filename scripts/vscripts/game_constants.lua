--....................................TEST SETTINGS............................................

--for editting/testing mode, set to true
TOOLS_MODE = true
COUNT_TESTING_UNITS = 3
DISTANCE_TESTING_UNITS = 1000
ALWAYS_IS_CURSED = true

--................................TEAM-RELATED SETTINGS........................................

--setting individual teams
_G.MAX_PLAYERS = 10
_G.CUSTOM_TEAM_PLAYER_COUNT = {}
_G.CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 1
_G.CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 1
_G.CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_1] = 1
_G.CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_2] = 1
_G.CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_3] = 1
_G.CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_4] = 1
_G.CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_5] = 1
_G.CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_6] = 1
_G.CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_7] = 1
_G.CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_8] = 1

--setting full team list. used for transferring player to his original team after gohst resurrection. guardian_resurrect_lua
TEAM_LIST = {}
TEAM_LIST[1] = DOTA_TEAM_GOODGUYS
TEAM_LIST[2] = DOTA_TEAM_BADGUYS
TEAM_LIST[3] = DOTA_TEAM_CUSTOM_1
TEAM_LIST[4] = DOTA_TEAM_CUSTOM_2
TEAM_LIST[5] = DOTA_TEAM_CUSTOM_3
TEAM_LIST[6] = DOTA_TEAM_CUSTOM_4
TEAM_LIST[7] = DOTA_TEAM_CUSTOM_5
TEAM_LIST[8] = DOTA_TEAM_CUSTOM_6
TEAM_LIST[9] = DOTA_TEAM_CUSTOM_7
TEAM_LIST[10] = DOTA_TEAM_CUSTOM_8

-- setting team and player colours
_G.TeamColors = {}
_G.TeamColors[DOTA_TEAM_GOODGUYS] = { 0, 66, 255 }    -- Blue 0042ff - Team #2
_G.TeamColors[DOTA_TEAM_BADGUYS]  = { 28, 230, 185 }     -- Cyan 1ce6b9 - Team #3
_G.TeamColors[DOTA_TEAM_CUSTOM_1] = { 84, 0, 129 }    -- Purple 540081 - Team #6
_G.TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 252, 1 }     -- Yellow fffc01 - Team #7
_G.TeamColors[DOTA_TEAM_CUSTOM_3] = { 254, 138, 14 }     -- Orange fe8a0e - Team #8
_G.TeamColors[DOTA_TEAM_CUSTOM_4] = { 229, 91, 176 }    -- Pink e55bb0 - Team #9
_G.TeamColors[DOTA_TEAM_CUSTOM_5] = { 162, 181, 72 }     -- Olive a2b548 - Team #10
_G.TeamColors[DOTA_TEAM_CUSTOM_6] = { 126, 191, 241 }    -- Light Blue 7ebff1 - Team #11
_G.TeamColors[DOTA_TEAM_CUSTOM_7] = { 16, 98, 70 }    -- Aqua 106246 - Team #12
_G.TeamColors[DOTA_TEAM_CUSTOM_8] = { 78, 42, 4 }    -- Brown 4e2a04 - Team #13
_G.TeamColorSaturationValue = 0.6 -- 0.0 to 1.0. higher number = more saturation. 1.0 = original color (might be too dark for HPbars)


--................................TIME-RELATED SETTINGS........................................

_G.GAME_SETUP_AUTO_LAUNCH_DELAY = 15
_G.STARTING_WARMUP_SPIRE_SFX_START = 5
_G.STARTING_WARMUP_SPIRE_SFX_DURATION = 4 -- must be less than starting_warmup_game_time
_G.POST_GAME_TIME = 15

if TOOLS_MODE then
    _G.DAY_DURATION = 20.0
    _G.TRANSITION_WARNING_TIME = 10 -- timer countdown
    _G.TIME_AS_UNKNOWN_ROLES_MIN = 11 -- must be less than day_duration
    _G.TIME_AS_UNKNOWN_ROLES_MAX = 15 -- must be less than day_duration

else
    _G.DAY_DURATION = 90.0
    _G.TRANSITION_WARNING_TIME = 30 -- timer countdown
    _G.TIME_AS_UNKNOWN_ROLES_MIN = 30 -- must be less than day_duration
    _G.TIME_AS_UNKNOWN_ROLES_MAX = 60 -- must be less than day_duration
end

_G.DC_TIME_ALLOWANCE = 300 --must be more than day_duration

_G.TREE_REGROW_TIME = 120

if TOOLS_MODE then
    --_G.SHEEP_BUCKET_SPAWN_INTERVAL = 10
    --_G.SHEEP_BUCKET_LIFESPAN = 5
    _G.HERO_REVIVE_TIME = 15
else
    --_G.SHEEP_BUCKET_SPAWN_INTERVAL = 80
    --_G.SHEEP_BUCKET_LIFESPAN = 40
    _G.HERO_REVIVE_TIME = 30
end

_G.WOLF_GHOST_SPAWN_TIME = 5
_G.WOLF_GHOST_DEATH_RESPAWN_TIME = 15

--...................................MISC. SETTINGS............................................

UNSEEN_FOW_PITCH_BLACK = false
_G.MAP_CENTREPOINT = Vector(-1200,550,0)
_G.CURSED_CREATURE = nil --this will be a global string of ,'werewolf', 'vampire', 'zombie', 'alien'
GOLD_PER_TICK = 0
if TOOLS_MODE then
    _G.STARTING_GOLD = 9999
    _G.STARTING_LUMBER = 3000
else
    _G.STARTING_GOLD = 50
    _G.STARTING_LUMBER = 150
end
_G.DAILY_GOLD = {130, 160, 180, 200, 215, 230, 240, 250}
_G.STARTING_FOOD_LIMIT = 8
_G.STARTING_SHEEP_LIMIT = 5
_G.HERO_MAX_LEVEL = 10
_G.XP_PER_LEVEL_TABLE = {}
for i=1, _G.HERO_MAX_LEVEL do
    _G.XP_PER_LEVEL_TABLE[i] = i * 100
end

--disable all runes
ENABLED_RUNES = {}
ENABLED_RUNES[DOTA_RUNE_DOUBLEDAMAGE] = false
ENABLED_RUNES[DOTA_RUNE_HASTE] = false
ENABLED_RUNES[DOTA_RUNE_ILLUSION] = false
ENABLED_RUNES[DOTA_RUNE_INVISIBILITY] = false
ENABLED_RUNES[DOTA_RUNE_REGENERATION] = false
ENABLED_RUNES[DOTA_RUNE_BOUNTY] = false

--..................................UNIT CONSTANTS.............................................

_G.STARTING_UNIT_NAME = "farmer"

_G.MAIN_UNIT_ABILITY_TABLE = {}
_G.MAIN_UNIT_ABILITY_TABLE["farmer"] = {"choose_hero_lua", "farmer_panic"}
_G.MAIN_UNIT_ABILITY_TABLE["defender"] = {"defender_shield_bash_lua", "defender_shield_taunt_lua", "defender_energy_shield_lua"}
_G.MAIN_UNIT_ABILITY_TABLE["scout"] = {"tracker_track_lua", "tracker_snare_lua", "tracker_trap_lua"}
_G.MAIN_UNIT_ABILITY_TABLE["barbarian"] = {"barbarian_rage_lua", "barbarian_axe_throw_lua", "barbarian_charge_lua"}
_G.MAIN_UNIT_ABILITY_TABLE["ranger"] = {"ranger_swap_arrow_lua", "ranger_swap_arrow_teleport_lua", "ranger_knockback_lua", "ranger_powershot_lua"}
_G.MAIN_UNIT_ABILITY_TABLE["illusionist"] = {"illusionist_glimmer_lua", "illusionist_conjure_image_lua", "illusionist_invisible_wall_lua", "illusionist_arcane_blast_lua", "illusionist_flicker_lua"}
_G.MAIN_UNIT_ABILITY_TABLE["guardian"] = {"guardian_heal_lua", "guardian_patience_lua", "tombstone_revive_lua", "guardian_resurrect_lua"}
_G.MAIN_UNIT_ABILITY_TABLE["boomer"] = {"boomer_flare_lua", "boomer_sugar_rush_lua", "boomer_boomershot_lua"}
_G.MAIN_UNIT_ABILITY_TABLE["samurai"] = {"samurai_flash_step_lua", "samurai_counter_lua"}
_G.MAIN_UNIT_ABILITY_TABLE["druid"] = {"druid_tree_vision_lua", "druid_shapeshift_to_bird_lua", "druid_shapeshift_to_bear_lua"}
_G.MAIN_UNIT_ABILITY_TABLE["assassin"] = {"assassin_backstab_lua", "assassin_invis_lua", "assassin_flashbang_lua"}

--..................................BUILDING CONSTANTS.............................................

--============================================ KEYSTONES ================================================

_G.KEYS_TO_ACTIVATE_KEYSTONE = {1,2,2,2,2,3,3,4,4,4}
_G.KEYSTONE_ACTIVATION_STARTUP_TIME = 3.0 --when all keys are put in but the activation hasnt started
_G.KEYSTONE_ACTIVATION_DELAY = 10 --activation started. how long does the cursed player have to decide
_G.KEYSTONE_REVEAL_DAYTIME_VISION = 600
_G.KEYSTONE_REVEAL_NIGHTTIME_VISION = 300

_G.KEYSTONE_LOCATIONS = {}
if TOOLS_MODE then
    _G.KEYSTONE_LOCATIONS[1] = Vector(-2000,0,0) --for testing purpose
else
    _G.KEYSTONE_LOCATIONS[1] = Vector(-5440,-5250,0)
end
_G.KEYSTONE_LOCATIONS[2] = Vector(-4353,4220,0)
_G.KEYSTONE_LOCATIONS[3] = Vector(4540,3390,0)
_G.KEYSTONE_LOCATIONS[4] = Vector(830,0,0)
if TOOLS_MODE then
    _G.KEYSTONE_LOCATIONS[5] = Vector(-2000,1000,0) --for testing purpose
    _G.KEYSTONES_TO_HUMANS_WIN = 2
    _G.KEYSTONES_TO_CURSED_WIN = 1
else
    _G.KEYSTONE_LOCATIONS[5] = Vector(2050,-3840,0)
    _G.KEYSTONES_TO_HUMANS_WIN = 3
    _G.KEYSTONES_TO_CURSED_WIN = 3
end

--============================================ KEYSPAWNS ================================================

_G.KEY_SPAWN_LOCATIONS = {}
_G.KEY_SPAWNING_TIME_MIN = {}
_G.KEY_SPAWNING_TIME_MAX = {}
if TOOLS_MODE then
    _G.KEY_SPAWN_LOCATIONS[1] = Vector(-2000,500,0) --for testing purpose
    for i=1,10,1 do
        _G.KEY_SPAWNING_TIME_MIN[i] = 3
        _G.KEY_SPAWNING_TIME_MAX[i] = 5
    end
else
    _G.KEY_SPAWN_LOCATIONS[1] = Vector(-3020,-4750,0)
    _G.KEY_SPAWNING_TIME_MIN = {40,40,40,40,40,32,32,25,25,25}
    _G.KEY_SPAWNING_TIME_MAX = {70,70,70,70,70,60,60,52,52,52}
end
_G.KEY_SPAWN_LOCATIONS[2] = Vector(-5200,1900,0)
_G.KEY_SPAWN_LOCATIONS[3] = Vector(810,5500,0)
_G.KEY_SPAWN_LOCATIONS[4] = Vector(5500,1500,0)
_G.KEY_SPAWN_LOCATIONS[5] = Vector(2420,-5130,0)

_G.KEY_SPAWN_RADIUS = 300

--============================================ XELNAGA ================================================

_G.XELNAGA_LOCATIONS={}
_G.XELNAGA_LOCATIONS[1] = Vector(-1275,-3780,0)
_G.XELNAGA_LOCATIONS[2] = Vector(-5060,-2110,0)
_G.XELNAGA_LOCATIONS[3] = Vector(-2050,4600,0)
_G.XELNAGA_LOCATIONS[4] = Vector(2360,3480,0)
_G.XELNAGA_LOCATIONS[5] = Vector(3770,-450,0)
_G.XELNAGA_LOCATIONS[6] = Vector(4730,-4870,0)
_G.XELNAGA_ACTIVATED_DAYTIME_VISION = {1400,1500,1200,1200,1400,1300}
_G.XELNAGA_ACTIVATED_NIGHTTIME_VISION = {1400,1500,1200,1200,1400,1300}

--[[
available in activation lua file
_G.XELNAGA_ACTIVATION_TIME = {}
_G.XELNAGA_ACTIVATION_TIME[1] = 120
_G.XELNAGA_ACTIVATION_TIME[2] = 20
_G.XELNAGA_ACTIVATION_TIME[3] = 12
]]

-- available in npc_abil file
_G.XELNAGA_DEACTIVATION_TIME = 10
_G.XELNAGA_UNLOCK_PATTERN = {1,1,2,2} -- total sum MUST be equal to number of xelnaga towers
_G.XELNAGA_REVEAL_CURSED_DAYTIME_VISION = 600
_G.XELNAGA_REVEAL_CURSED_NIGHTTIME_VISION = 300

if TOOLS_MODE then
    _G.XELNAGA_REVEAL_REQUIREMENT = 1
else
    _G.XELNAGA_REVEAL_REQUIREMENT = 6
end

--============================================ GOLDMINE ================================================

_G.GOLDMINE_COUNT = 5
_G.GOLDMINE_MAP_BORDER_OFFSET_DISTANCE = 500
_G.GOLDMINE_CENTRE_DISTANCE = 2200 --1500
_G.GOLDMINE_GOLDMINE_DISTANCE = 1500
_G.GOLDMINE_XELNAGA_DISTANCE = 1500
_G.GOLDMINE_KEYSTONE_DISTANCE = 1000
_G.GOLDMINE_KEYSPAWNER_DISTANCE = 1500

--============================================ ENDGAME PORTAL ================================================

_G.ENDGAME_PORTAL_DISTANCE = 450
if TOOLS_MODE then
    _G.ENDGAME_PORTAL_DURATION = 20
else
    _G.ENDGAME_PORTAL_DURATION = 35
end

--..................................CURSED UNIT CONSTANTS.............................................

_G.CURSED_TYPES = {}
-- comment cursed creatures that are not implemented in the game
--_G.CURSED_TYPES[1] = "werewolf"
_G.CURSED_TYPES[1] = "vampire"
--_G.CURSED_TYPES[2] = "vampire" 
--_G.CURSED_TYPES[3] = "zombie"
--_G.CURSED_TYPES[4] = "alien"
_G.WEREWOLF_TRANSFORM_TIME = 1.2 -- found in npc_abilities, "transform_werewolf"
_G.WEREWOLF_TRANSFORM_COOLDOWN = 15
_G.VAMPIRE_TRANSFORM_COOLDOWN = 7
_G.CURSED_ABILITY_TABLE = {}
_G.CURSED_ABILITY_TABLE["werewolf"] = {"wolf_sniff", "mirana_leap_lua", "werewolf_instinct_lua", "werewolf_crit_strike_lua", "ursa_enrage_lua"}
_G.CURSED_ABILITY_TABLE["vampire"] = {"vampire_ascend_lua", "vampire_blood_bath_lua", "vampire_delirium_lua", "vampire_sol_skin_lua", "vampire_shadow_ward_lua"}
_G.CURSED_ABILITY_TABLE["zombie"] = {"zombie_main_passive_lua", "zombie_pounce_lua", "zombie_tombstone_lua", "zombie_acid_lua", "zombie_summon_wave_lua"}
_G.ZOMBIE_UNIT_TABLE = {"zombie_unit_basic", "zombie_unit_runner", "zombie_unit_carrier", "zombie_unit_tank"}

if TOOLS_MODE then
    _G.ZOMBIE_UNIT_MAX_COUNT = 150
else
    _G.ZOMBIE_UNIT_MAX_COUNT = 150
end

--tier hero number requirements. how many heroes in game required before tier is unlocked in game
--tiers currently not implemented in game for testing reasons
--_G.TIER2_HERO_COUNT_UNLOCK_CRITERIA = 0
--_G.TIER3_HERO_COUNT_UNLOCK_CRITERIA = 0

-- global tables for cursed depending on number of players
-- werewolf bonus stats. base = starting of game. end = final stat to approach, using AsymptotePointValue() in utils.lua
_G.WEREWOLF_STATS_TABLE = {}
_G.WEREWOLF_STATS_TABLE[1] = {factor = 0.75, base_hp = 250, end_hp = 480, base_atk_dmg = 45, end_atk_dmg = 90, base_as = 72, end_as = 100, base_ms = 450, end_ms = 625, base_atk_range = 25, base_night_vision = 1300}
_G.WEREWOLF_STATS_TABLE[2] = {factor = 0.75, base_hp = 250, end_hp = 480, base_atk_dmg = 45, end_atk_dmg = 90, base_as = 72, end_as = 100, base_ms = 450, end_ms = 625, base_atk_range = 25, base_night_vision = 1300}
_G.WEREWOLF_STATS_TABLE[3] = {factor = 0.75, base_hp = 250, end_hp = 480, base_atk_dmg = 45, end_atk_dmg = 90, base_as = 72, end_as = 100, base_ms = 450, end_ms = 625, base_atk_range = 25, base_night_vision = 1300}
_G.WEREWOLF_STATS_TABLE[4] = {factor = 0.75, base_hp = 250, end_hp = 480, base_atk_dmg = 45, end_atk_dmg = 90, base_as = 72, end_as = 100, base_ms = 450, end_ms = 625, base_atk_range = 25, base_night_vision = 1300}
_G.WEREWOLF_STATS_TABLE[5] = {factor = 0.75, base_hp = 250, end_hp = 530, base_atk_dmg = 45, end_atk_dmg = 99, base_as = 72, end_as = 107, base_ms = 450, end_ms = 625, base_atk_range = 25, base_night_vision = 1300}
_G.WEREWOLF_STATS_TABLE[6] = {factor = 0.75, base_hp = 250, end_hp = 590, base_atk_dmg = 45, end_atk_dmg = 107, base_as = 72, end_as = 113, base_ms = 450, end_ms = 625, base_atk_range = 25, base_night_vision = 1300}
_G.WEREWOLF_STATS_TABLE[7] = {factor = 0.7, base_hp = 250, end_hp = 640, base_atk_dmg = 45, end_atk_dmg = 113, base_as = 72, end_as = 119, base_ms = 450, end_ms = 625, base_atk_range = 25, base_night_vision = 1300}
_G.WEREWOLF_STATS_TABLE[8] = {factor = 0.68, base_hp = 250, end_hp = 680, base_atk_dmg = 45, end_atk_dmg = 119, base_as = 72, end_as = 127, base_ms = 450, end_ms = 625, base_atk_range = 25, base_night_vision = 1300}
_G.WEREWOLF_STATS_TABLE[9] = {factor = 0.65, base_hp = 250, end_hp = 710, base_atk_dmg = 45, end_atk_dmg = 126, base_as = 72, end_as = 135, base_ms = 450, end_ms = 625, base_atk_range = 25, base_night_vision = 1300}
_G.WEREWOLF_STATS_TABLE[10] = {factor = 0.62, base_hp = 250, end_hp = 735, base_atk_dmg = 45, end_atk_dmg = 133, base_as = 72, end_as = 146, base_ms = 450, end_ms = 625, base_atk_range = 25, base_night_vision = 1300}

_G.VAMPIRE_STATS_TABLE = {}
_G.VAMPIRE_STATS_TABLE[1] = {factor = 0.75, base_hp = 150, end_hp = 320, base_atk_dmg = 30, end_atk_dmg = 65, base_as = 48, end_as = 75, base_ms = 380, end_ms = 420, base_night_vision = 100, mp_regen = 6}
_G.VAMPIRE_STATS_TABLE[2] = {factor = 0.75, base_hp = 150, end_hp = 320, base_atk_dmg = 30, end_atk_dmg = 65, base_as = 48, end_as = 75, base_ms = 380, end_ms = 420, base_night_vision = 100, mp_regen = 6}
_G.VAMPIRE_STATS_TABLE[3] = {factor = 0.75, base_hp = 150, end_hp = 320, base_atk_dmg = 30, end_atk_dmg = 65, base_as = 48, end_as = 75, base_ms = 380, end_ms = 420, base_night_vision = 100, mp_regen = 6}
_G.VAMPIRE_STATS_TABLE[4] = {factor = 0.75, base_hp = 150, end_hp = 360, base_atk_dmg = 30, end_atk_dmg = 65, base_as = 48, end_as = 75, base_ms = 380, end_ms = 420, base_night_vision = 100, mp_regen = 6}
_G.VAMPIRE_STATS_TABLE[5] = {factor = 0.75, base_hp = 150, end_hp = 370, base_atk_dmg = 30, end_atk_dmg = 71, base_as = 48, end_as = 81, base_ms = 380, end_ms = 420, base_night_vision = 100, mp_regen = 6}
_G.VAMPIRE_STATS_TABLE[6] = {factor = 0.75, base_hp = 150, end_hp = 410, base_atk_dmg = 30, end_atk_dmg = 78, base_as = 48, end_as = 86, base_ms = 380, end_ms = 420, base_night_vision = 100, mp_regen = 6}
_G.VAMPIRE_STATS_TABLE[7] = {factor = 0.7, base_hp = 150, end_hp = 450, base_atk_dmg = 30, end_atk_dmg = 84, base_as = 48, end_as = 92, base_ms = 380, end_ms = 420, base_night_vision = 100, mp_regen = 6}
_G.VAMPIRE_STATS_TABLE[8] = {factor = 0.68, base_hp = 150, end_hp = 490, base_atk_dmg = 30, end_atk_dmg = 91, base_as = 48, end_as = 98, base_ms = 380, end_ms = 420, base_night_vision = 100, mp_regen = 6}
_G.VAMPIRE_STATS_TABLE[9] = {factor = 0.65, base_hp = 150, end_hp = 520, base_atk_dmg = 30, end_atk_dmg = 98, base_as = 48, end_as = 105, base_ms = 380, end_ms = 420, base_night_vision = 100, mp_regen = 6}
_G.VAMPIRE_STATS_TABLE[10] = {factor = 0.62, base_hp = 150, end_hp = 550, base_atk_dmg = 30, end_atk_dmg = 106, base_as = 48, end_as = 114, base_ms = 380, end_ms = 420, base_night_vision = 100, mp_regen = 6}


--.................................MODELLING SETTINGS..........................................

WEREWOLF_UNIT_WOLF_3D_MODEL = "models/items/lycan/ultimate/blood_moon_hunter_shapeshift_form/blood_moon_hunter_shapeshift_form.vmdl"
DRUID_FLYING_3D_MODEL = "models/items/beastmaster/hawk/legacy_of_the_nords_legacy_of_the_nords_owl/legacy_of_the_nords_legacy_of_the_nords_owl.vmdl"
DRUID_BEAR_3D_MODEL = "models/items/lone_druid/bear/elemental_curse_set_elemental_curse_spirit_bear/elemental_curse_set_elemental_curse_spirit_bear.vmdl"
ILLUSIONIST_WALL_3D_MODEL = "models/props_rock/riveredge_rock007a.vmdl"
TOMBSTONE_MODEL = "models/props_gameplay/tombstoneb01.vmdl"
VAMPIRE_3D_MODEL = "models/heroes/nightstalker/nightstalker_night.vmdl"
VAMPIRE_WARD_3D_MODEL = "models/items/pugna/ward/draining_wight/draining_wight.vmdl"
ZOMBIE_MAIN_3D_MODEL = "models/heroes/life_stealer/life_stealer.vmdl"