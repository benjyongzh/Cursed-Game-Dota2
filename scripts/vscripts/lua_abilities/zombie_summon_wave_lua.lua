zombie_summon_wave_lua = class({})

--------------------------------------------------------------------------------

function zombie_summon_wave_lua:OnSpellStart()
    -- get references
    local caster = self:GetCaster()
    local playerid = caster:GetPlayerOwnerID()
    local zombies_per_player = self:GetSpecialValueFor("zombies_per_player")
    local zombies_max = self:GetSpecialValueFor("zombies_per_player_max")
    local radius = self:GetSpecialValueFor("max_radius")

    if _G.ZOMBIE_UNITS_WAITING_TO_SPAWN == nil then
        _G.ZOMBIE_UNITS_WAITING_TO_SPAWN = 0
    end

    local j_counter = 0
    Timers:CreateTimer(self:GetSpecialValueFor("spawn_interval"),function()
        if TOOLS_MODE then
            -- for testing
            local enemies = FindUnitsInRadius(
                caster:GetTeam(),	-- int, your team number
                caster:GetAbsOrigin(),	-- point, center point
                nil,	-- handle, cacheUnit. (not known)
                FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                0,	-- int, flag filter
                FIND_CLOSEST,	-- int, order filter
                false	-- bool, can grow cache
            )
            for _,unit in pairs(enemies) do
                if _G.ZOMBIE_UNIT_COUNT < _G.ZOMBIE_UNIT_MAX_COUNT then

                    -- havent reached global max unit count
                    if j < zombies_max then
                        -- havent reached limit per player. spawn zombie as planned                              
                        local location = zombie_summon_wave_lua:ChooseZombieRandomSpawnLocation(unit:GetAbsOrigin(), playerid, radius)
                        Game_Events:SpawnZombie(location, playerid, true)
                    else
                        -- reached limit per player. add to waiting_to_spawn integer to spawn later
                        _G.ZOMBIE_UNITS_WAITING_TO_SPAWN = _G.ZOMBIE_UNITS_WAITING_TO_SPAWN + 1
                    end

                else
                    -- reached global max unit count. add to waiting_to_spawn integer to spawn later
                    _G.ZOMBIE_UNITS_WAITING_TO_SPAWN = _G.ZOMBIE_UNITS_WAITING_TO_SPAWN + 1
                end
            end
        else
            for i = 0, 15, 1 do
                if PlayerResource:IsValidPlayerID(i) and i ~= playerid then
                --if PlayerResource:IsValidPlayerID(i) then for testing
                    local mainunit = GetMainUnit(i)
                    if mainunit:IsAlive() and IsValidEntity(mainunit) then
    
                        if _G.ZOMBIE_UNIT_COUNT < _G.ZOMBIE_UNIT_MAX_COUNT then

                            -- havent reached global max unit count
                            if j_counter < zombies_max then
                                -- havent reached limit per player. spawn zombie as planned                              
                                local location = zombie_summon_wave_lua:ChooseZombieRandomSpawnLocation(mainunit:GetAbsOrigin(), playerid, radius)
                                Game_Events:SpawnZombie(location, playerid, true)
                            else
                                -- reached limit per player. add to waiting_to_spawn integer to spawn later
                                _G.ZOMBIE_UNITS_WAITING_TO_SPAWN = _G.ZOMBIE_UNITS_WAITING_TO_SPAWN + 1
                            end

                        else
                            -- reached global max unit count. add to waiting_to_spawn integer to spawn later
                            _G.ZOMBIE_UNITS_WAITING_TO_SPAWN = _G.ZOMBIE_UNITS_WAITING_TO_SPAWN + 1
                        end
                    end
                end
            end
        end            

        j_counter = j_counter + 1
        if j_counter < zombies_per_player then
            return self:GetSpecialValueFor("spawn_interval")
        end
    end)   

	-- play effects
	--PlaySoundOnAllClients("Hero_DeathProphet.Exorcism.Cast")
	PlaySoundOnAllClients("Zombie_Summon_Wave_alert")
end



function zombie_summon_wave_lua:ChooseZombieRandomSpawnLocation(center, cursed_playerid, radius)
    local location = center + RandomVector(math.random(50,radius))
    local trees = GridNav:GetAllTreesAroundPoint(location, 40, true)
    local isvisible = true
    local attempt_counter = 0 -- make sure there is no infinite loop. computer gives up after 500 tries so that it doesnt crash
    while attempt_counter < 500 and isvisible and #trees > 0 do
        local visibility_counter = 0
        for k = 0,15,1 do
            if PlayerResource:IsValidPlayerID(k) and k ~= cursed_playerid and GetMainUnit(k):IsAlive() then
            --if PlayerResource:IsValidPlayerID(k) and GetMainUnit(k):IsAlive() then for testing
                if IsLocationVisible(k, location) then
                    -- location is visible by a player
                    visibility_counter = visibility_counter + 1
                end
            end
        end
        if visibility_counter > 0 then
            -- location is visible by at least 1 living player
            isvisible = true
            location = center + RandomVector(math.random(1,radius))
            trees = GridNav:GetAllTreesAroundPoint(location, 40, true)
            local traverse_counter = 0
            while traverse_counter < 500 and (not GridNav:IsTraversable(location)) and #trees > 0 do
                location = center + RandomVector(math.random(1,radius))
                trees = GridNav:GetAllTreesAroundPoint(location, 40, true)
                traverse_counter = traverse_counter + 1
            end
            if traverse_counter >= 500 then
                -- give up. no location is traversable
                isvisible = false
            end
        else
            -- location is not visible to any living player. suitable for spawning
            isvisible = false
        end
    end

    return location
end