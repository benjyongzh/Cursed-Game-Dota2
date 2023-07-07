modifier_xelnaga_tower_passive_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_xelnaga_tower_passive_lua:IsHidden()
	return true
end

function modifier_xelnaga_tower_passive_lua:IsDebuff()
	return false
end

function modifier_xelnaga_tower_passive_lua:IsStunDebuff()
	return false
end

function modifier_xelnaga_tower_passive_lua:IsPurgable()
	return false
end

function modifier_xelnaga_tower_passive_lua:RemoveOnDeath()
	return true
end

function modifier_xelnaga_tower_passive_lua:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
    }
    return state
end

function modifier_xelnaga_tower_passive_lua:DeclareFunctions()
	return MODIFIER_PROPERTY_VISUAL_Z_DELTA
end

function modifier_xelnaga_tower_passive_lua:GetVisualZDelta()
	return GetGroundHeight(self:GetParent():GetAbsOrigin(), nil)
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_xelnaga_tower_passive_lua:OnCreated()
    if IsServer() then

        -- references
        self.prox = self:GetAbility():GetSpecialValueFor("required_distance")
        self.day_vision = self:GetAbility():GetSpecialValueFor("day_vision_radius")
        self.night_vision = self:GetAbility():GetSpecialValueFor("night_vision_radius")
        self:GetParent().is_giving_vision = false

        -- Start interval
        self:StartIntervalThink( 0.1 )
        --self:OnIntervalThink()
    end
end

function modifier_xelnaga_tower_passive_lua:OnRefresh()
	if IsServer() then

        -- references
        self.prox = self:GetAbility():GetSpecialValueFor("required_distance")
        self.day_vision = self:GetAbility():GetSpecialValueFor("day_vision_radius")
        self.night_vision = self:GetAbility():GetSpecialValueFor("night_vision_radius")
        self:GetParent().is_giving_vision = false

        -- Start interval
        self:StartIntervalThink( 0.1 )
        --self:OnIntervalThink()
    end
end


--------------------------------------------------------------------------------
-- Interval Effects
function modifier_xelnaga_tower_passive_lua:OnIntervalThink()

    if IsServer() then
        local tower = self:GetParent()

        --check if tower is already activated or is locked
        if tower:HasModifier("modifier_xelnaga_tower_activated_vision_lua") or tower:HasModifier("modifier_xelnaga_tower_locked_lua") then
            if tower.is_giving_vision == true then
                --add sfx for turning off vision
                EmitSoundOn("Hero_Warlock.ShadowWordCastBad", tower)
                if self.sound_loop then
                    StopSoundOn(self.sound_loop, self:GetParent())
                end
                if self.effect_precast1 then
                    ParticleManager:DestroyParticle( self.effect_precast1, true )
                end
                if self.effect_precast2 then
                    ParticleManager:DestroyParticle( self.effect_precast2, true )
                end
                local particle_precast = "particles/econ/items/outworld_devourer/od_shards_exile_gold/od_shards_exile_prison_end_gold.vpcf"
                local effect_precast = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, tower )
                ParticleManager:SetParticleControlEnt(effect_precast, 0, tower, PATTACH_ABSORIGIN_FOLLOW, nil, tower:GetOrigin(), true)
                ParticleManager:ReleaseParticleIndex(effect_precast)

            end
            tower.is_giving_vision = false
        else
            -- tower not activated, give vision to nearby units only
            local all_units = FindUnitsInRadius( -- selecting all units in the map.
            tower:GetTeamNumber(),
            tower:GetOrigin(),
            nil,
            self.prox,
            DOTA_UNIT_TARGET_TEAM_BOTH,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false
            )
            
            -- eliminate building units and cursed units
            local real_units = {}
            for _,unit in pairs(all_units) do
                if not IsBuildingOrSpire(unit) and not IsInCursedForm(unit) and not IsZombie(unit) then
                    table.insert(real_units, unit)
                end
            end
            -- there is at least 1 unit in the proximity
            if #real_units > 0 then
                for _,unit in pairs(real_units) do
                    --add FOWviewer
                    if GameRules:IsDaytime() then
                        AddFOWViewer( unit:GetTeamNumber(), tower:GetOrigin(), self.day_vision, 0.1, false )
                    else
                        AddFOWViewer( unit:GetTeamNumber(), tower:GetOrigin(), self.night_vision, 0.1, false )
                    end
                    if tower.is_giving_vision == false then
                        --add sfx for turning on vision
                        EmitSoundOn("Hero_Dark_Seer.Surge", tower)

                        self.sound_loop = "Hero_Dark_Seer.Wall_of_Replica_lp"
                        EmitSoundOn(self.sound_loop, tower)

                        local particle_precast = "particles/units/heroes/heroes_underlord/au_debut_rift.vpcf"
                        self.effect_precast1 = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, tower )
                        ParticleManager:SetParticleControlEnt(self.effect_precast1, 0, tower, PATTACH_ABSORIGIN_FOLLOW, nil, tower:GetOrigin(), true)
                        
                        particle_precast = "particles/world_outpost/world_outpost_channel_glow.vpcf"
                        self.effect_precast2 = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, tower )
                        ParticleManager:SetParticleControlEnt(self.effect_precast2, 0, tower, PATTACH_POINT_FOLLOW, "attach_fx", tower:GetOrigin(), true)
                        
                        particle_precast = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start_streaks.vpcf"
                        local effect_precast3 = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, tower )
                        ParticleManager:ReleaseParticleIndex(effect_precast3)

                        particle_precast = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_start_beam.vpcf"
                        effect_precast3 = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, tower )
                        ParticleManager:SetParticleControlEnt(effect_precast3, 0, tower, PATTACH_POINT_FOLLOW, "attach_hitloc", tower:GetOrigin(), true)
                        ParticleManager:ReleaseParticleIndex(effect_precast3)
                    end
                    tower.is_giving_vision = true
                end

            -- there are 0 units in the proximity
            else
                if tower.is_giving_vision == true then
                    --add sfx for turning off vision
                    EmitSoundOn("Hero_Warlock.ShadowWordCastBad", tower)
                    if self.sound_loop then
                        StopSoundOn(self.sound_loop, self:GetParent())
                    end
                    if self.effect_precast1 then
                        ParticleManager:DestroyParticle( self.effect_precast1, true )
                    end
                    if self.effect_precast2 then
                        ParticleManager:DestroyParticle( self.effect_precast2, true )
                    end
                    local particle_precast = "particles/econ/items/outworld_devourer/od_shards_exile_gold/od_shards_exile_prison_end_gold.vpcf"
                    local effect_precast = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, tower )
                    ParticleManager:SetParticleControlEnt(effect_precast, 0, tower, PATTACH_ABSORIGIN_FOLLOW, nil, tower:GetOrigin(), true)
                    ParticleManager:ReleaseParticleIndex(effect_precast)

                end
                tower.is_giving_vision = false
            end
        end
    end
end
