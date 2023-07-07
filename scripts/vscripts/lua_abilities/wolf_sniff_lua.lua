wolf_sniff = class({})

-------------------------------------------------------------------------
--On ability start
function wolf_sniff:OnSpellStart(kv)

    -- unit identifier + local location
    local caster = self:GetCaster()
    local radius = self:GetSpecialValueFor("detection_radius")
    local enemies = {}
    if self:GetLevel() > 1 then
        enemies = FindUnitsInRadius(
            caster:GetTeam(),
            caster:GetAbsOrigin(),
            nil,
            FIND_UNITS_EVERYWHERE, -- global
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false
        )
    else
        enemies = FindUnitsInRadius(
            caster:GetTeam(),
            caster:GetAbsOrigin(),
            nil,
            radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false
        )
    end
    
    if #enemies > 0 then
        local enemy = nil

        -- defining what the target is, based on the level. at level 2, sniff detects only farmers or heroes
        if self:GetLevel() == 2 then
            for _,unit in pairs(enemies) do
                if unit:GetUnitName() == _G.STARTING_UNIT_NAME or unit:IsRealHero() then
                    if unit:GetUnitName() ~= "npc_dota_hero_omniknight" then
                        enemy = unit
                        break
                    end
                end
            end
        else
            for _,unit in pairs(enemies) do
                if not unit:HasModifier("modifier_spire") then
                    enemy = unit
                    break
                end
            end
        end

        local max_radius = self:GetSpecialValueFor("marker_size")/2
        math.randomseed(GameRules:GetGameTime())
        local random_angle = RandomInt(1,360)
        random_angle = math.rad(random_angle)
        local random_distance = RandomInt(1, max_radius)
        --cos for x, sin for y
        local x_offset = random_distance * math.cos(random_angle)
        local y_offset = random_distance * math.sin(random_angle)
        local detected_circle_centre = Vector(enemy:GetAbsOrigin().x + x_offset, enemy:GetAbsOrigin().y + y_offset, 0.0)

        ------------------------------ continuous pinging --------------------------------
        
        local interval = 0.15
        local n = 0
        Timers:CreateTimer(0.5, function()
            local ping_random_angle = RandomInt(1,360)
            ping_random_angle = math.rad(ping_random_angle)
            local ping_random_distance = RandomInt(1, max_radius)
            --cos for x, sin for y
            local ping_x_offset = random_distance * math.cos(ping_random_angle)
            local ping_y_offset = random_distance * math.sin(ping_random_angle)
            MinimapEvent(
                caster:GetTeam(),
                caster,
                detected_circle_centre.x + ping_x_offset,
                detected_circle_centre.y + ping_y_offset,
                DOTA_MINIMAP_EVENT_HINT_LOCATION,
                1
            )
            if n < (self:GetSpecialValueFor("duration")-1)/interval then
                n = n + 1
                return interval
            end
        end)

        -- sound effects
        local sound_cast = "Ability.sniff"
        EmitSoundOn( sound_cast, caster )
    end
end
