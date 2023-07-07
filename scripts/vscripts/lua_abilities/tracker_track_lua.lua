tracker_track_lua = class({})
LinkLuaModifier( "modifier_tracker_track_debuff_lua", "modifiers/modifier_tracker_track_debuff_lua", LUA_MODIFIER_MOTION_NONE )
-------------------------------------------------------------------------
--On ability start
function tracker_track_lua:OnSpellStart(kv)

    -- unit identifier + local location
    local caster = self:GetCaster()
    local enemies = FindUnitsInRadius(
        caster:GetTeam(),
        caster:GetAbsOrigin(),
        nil,
        FIND_UNITS_EVERYWHERE,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        0,
        false
        )
    
    local cursed_count = 0     
    for _,unit in pairs(enemies) do    
        if IsInCursedForm(unit) then
            math.randomseed(GameRules:GetGameTime())
            local max_radius = self:GetSpecialValueFor("marker_size")/2
            local random_angle = RandomInt(1,360)
            random_angle = math.rad(random_angle)
            local random_distance = RandomInt(1, max_radius)
            --cos for x, sin for y
            local x_offset = random_distance * math.cos(random_angle)
            local y_offset = random_distance * math.sin(random_angle)
            local detected_circle_centre = Vector(unit:GetAbsOrigin().x + x_offset, unit:GetAbsOrigin().y + y_offset, 0.0)

            local debuff_duration = self:GetSpecialValueFor("duration")
            
            -- minimap pinging
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
                if n < (debuff_duration-1)/interval then
                    n = n + 1
                    return interval
                end
            end)
            
            -- debuff modifier
            unit:AddNewModifier(
                caster, -- player source
                self, -- ability source
                "modifier_tracker_track_debuff_lua", -- modifier name
                { duration = debuff_duration } -- kv
                )
            -- effects
            local sound_cast = "Ability.track"
            EmitSoundOn( sound_cast, unit )
            cursed_count = cursed_count + 1
        end
    end
    
    if cursed_count < 1 then
        --no werewolf around you
        self:StartCooldown(self:GetSpecialValueFor("cooldown_for_fail"))
        SendErrorMessage(caster:GetPlayerOwnerID(), "No Cursed detected")
    end
end
