ranger_knockback_lua = class({})
LinkLuaModifier( "modifier_ranger_knockback_lua", "modifiers/modifier_ranger_knockback_lua", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------------------

function ranger_knockback_lua:GetAOERadius()
    return self:GetSpecialValueFor( "radius" )
end

function ranger_knockback_lua:OnSpellStart()
	-- get references
    local caster = self:GetCaster()
    local centre = caster:GetAbsOrigin()
    local enemies = FindUnitsInRadius(
        caster:GetTeam(),
        centre,
        nil,
        self:GetSpecialValueFor("radius"),
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false)

    -- Make the found units move to (0, 0, 0)

    local real_enemies = {}
    
    -- backstab angle and damage from backstab passive
    local angle =  self:GetSpecialValueFor("knockback_angle")

    for _,unit in pairs(enemies) do
        -- check for units in front of caster
        if (not IsBuildingOrSpire(unit)) and unit:GetUnitName() ~= "dummy_unit" then

            -- The y value of the angles vector contains the angle we actually want: where units are directionally facing in the world.
            local caster_facing_angle = caster:GetAnglesAsVector().y
            local origin_difference = caster:GetAbsOrigin() - unit:GetAbsOrigin()

            -- Get the radian of the origin difference between the attacker and Riki. We use this to figure out at what angle the victim is at relative to Riki.
            local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
            
            -- Convert the radian to degrees.
            origin_difference_radian = origin_difference_radian * 180
            local unit_angle = origin_difference_radian / math.pi
            -- Makes angle "0 to 360 degrees" as opposed to "-180 to 180 degrees" aka standard dota angles.
            unit_angle = unit_angle + 180.0
            
            -- Finally, get the angle at which the victim is facing Riki.
            local result_angle = unit_angle - caster_facing_angle
            result_angle = math.abs(result_angle)
            
            -- Check for the backstab angle.
            if (result_angle >= (360 - (angle/2))) or (result_angle <= angle/2) then
                table.insert(real_enemies, unit)
            end
        end
    end

    if #real_enemies > 0 then
        for _,unit in pairs(real_enemies) do
            local unit_pos = unit:GetAbsOrigin()
            local vector = Vector(unit_pos.x-centre.x, unit_pos.y-centre.y, unit_pos.z-centre.z)
            local distance_from_source = math.sqrt(vector.x * vector.x + vector.y * vector.y)
            local distance_to_travel = self:GetSpecialValueFor("knockback_distance") - distance_from_source
            vector = vector:Normalized()
            unit:AddNewModifier(
                caster,
                self,
                "modifier_ranger_knockback_lua",
                {
                    direction_x = vector.x,
                    direction_y = vector.y,
                    distance = distance_to_travel,
                    speed = self:GetSpecialValueFor("knockback_speed")
                }
            )

            -- check for upgrade 1
            local abil = caster:FindAbilityByName("ranger_upgrade_1")
            if abil then
                if abil:GetLevel() > 0 then
                    -- deal damage
                    local damageTable = {
                        victim = unit,
                        attacker = caster,
                        damage = self:GetSpecialValueFor("upgrade_damage"),
                        damage_type = DAMAGE_TYPE_PHYSICAL,
                        ability = self, --Optional.
                    }
                    ApplyDamage(damageTable)
                end
            end

        end
        EmitSoundOn( "Roshan.Attack.Post", self:GetCaster() )
    end
    -- sfx
    local particle = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf"
    local effect = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, caster )
    ParticleManager:SetParticleControlEnt( effect, 0, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex( effect )

    StartAnimation(self:GetCaster(), {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.2})
    EmitSoundOn( "Hero_PhantomLancer.SpiritLance.Impact", self:GetCaster() )
end
