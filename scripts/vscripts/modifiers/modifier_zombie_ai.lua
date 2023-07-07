modifier_zombie_ai = class({})

LinkLuaModifier( "modifier_zombie_runner_rush_lua_ms_buff", "modifiers/modifier_zombie_runner_rush_lua_ms_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_ai:IsHidden()
	return false
end

function modifier_zombie_ai:IsDebuff()
	return false
end

function modifier_zombie_ai:IsStunDebuff()
	return false
end

function modifier_zombie_ai:IsPurgable()
	return false
end

function modifier_zombie_ai:RemoveOnDeath()
	return true
end

function modifier_zombie_ai:GetTexture()
	return "undying_tombstone_zombie_deathstrike"
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_zombie_ai:OnCreated(kv)
    if IsServer() then
        self.team = self:GetParent():GetTeam()
        self.roaming = kv.roaming
        self:StartIntervalThink(RandomFloat( 0.5, 1.0 ))
        self:OnIntervalThink()
    end
end

function modifier_zombie_ai:OnRefresh(kv)
	if IsServer() then
        self.team = self:GetParent():GetTeam()
        self.roaming = kv.roaming
        self:StartIntervalThink(RandomFloat( 0.5, 1.0 ))
        self:OnIntervalThink()
    end
end

------------------------------------------------------
-- Interval Effects
function modifier_zombie_ai:OnIntervalThink()
    local unit = self:GetParent()
    if unit:IsAlive() and IsValidEntity(unit) then

        if not unit:HasModifier("modifier_zombie_runner_rush_lua_ms_buff") then

            -- find enemies in vicinity first
            local units = FindUnitsInRadius(
                self.team,	-- int, your team number
                self:GetParent():GetAbsOrigin(),	-- point, center point
                nil,	-- handle, cacheUnit. (not known)
                900,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
                FIND_CLOSEST,	-- int, order filter
                false	-- bool, can grow cache
            )
            if #units > 0 then
                for _,enemy in pairs(units) do
                    if not IsBuildingOrSpire(enemy) then
                        if self:GetParent():CanEntityBeSeenByMyTeam(enemy) then
                            -- enemy visible. attack directly
                            self:GetParent():SetForceAttackTarget(enemy)
                            self:GetParent():MoveToTargetToAttack(enemy)
                            -- if runner zombie, check rush abil
                            local abil = self:GetParent():FindAbilityByName("zombie_runner_rush_lua")
                            if abil and abil:IsCooldownReady() then
                                local max_distance = abil:GetSpecialValueFor( "max_distance" )
	                            local min_distance = abil:GetSpecialValueFor( "min_distance" )
                                local distance = GridNav:FindPathLength(enemy:GetAbsOrigin(), self:GetParent():GetAbsOrigin())
                                if distance >= min_distance and distance <= max_distance then
                                    self:GetParent():AddNewModifier(self:GetParent(), abil, "modifier_zombie_runner_rush_lua_ms_buff", {duration = abil:GetSpecialValueFor( "max_duration" )})
                                    abil:StartCooldown(abil:GetCooldown(abil:GetLevel()))
                                end
                            end
                        else
                            -- enemy nearby but not visible. attack ground at location
                            if self.roaming > 0 then
                                self:GetParent():MoveToPositionAggressive(enemy:GetAbsOrigin())
                            end
                        end
                        break
                    end
                end

            -- no nearby enemy units. attack ground at nearest enemy in map
            else
                self:GetParent():SetForceAttackTarget( nil )
                if self.roaming > 0 then
                    local units2 = FindUnitsInRadius(
                        self.team,	-- int, your team number
                        self:GetParent():GetAbsOrigin(),	-- point, center point
                        nil,	-- handle, cacheUnit. (not known)
                        FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                        DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                        DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
                        FIND_CLOSEST,	-- int, order filter
                        false	-- bool, can grow cache
                    )
                    if #units2 > 0 then
                        for _,enemy in pairs(units2) do
                            if not IsBuildingOrSpire(enemy) then
                                self:GetParent():MoveToPositionAggressive(enemy:GetAbsOrigin())
                                break
                            end
                        end
                    end
                end
            end
        end

        -- do it again
        self:StartIntervalThink(RandomFloat( 0.5, 1.0 ))
    end
end
