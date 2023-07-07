revive_hero_lua = class({})

--------------------------------------------------------------------------------
-- Ability Start
function revive_hero_lua:OnSpellStart()
	-- unit identifier
    local caster = self:GetCaster()
    local player_id = caster:GetPlayerOwnerID()

    --if CustomNetTables:GetTableValue("player_chosen_hero", tostring(player_id)).hero == nil then
    
    local mytable = CustomNetTables:GetTableValue("player_hero", tostring(player_id))
    if mytable.hero == nil then
        SendErrorMessage(player_id, "You have no Hero yet")
        caster:Stop()
    else
        local spire = SPIRE_UNIT
        local vector = Vector(caster:GetOrigin().x-spire:GetOrigin().x, caster:GetOrigin().y-spire:GetOrigin().y, caster:GetOrigin().z-spire:GetOrigin().z)
        local distance_from_source = math.sqrt(vector.x * vector.x + vector.y * vector.y)--get absolute distance value
        --local mytable = CustomNetTables:GetTableValue("hero_need_respawn", tostring(player_id))
        local max_distance = self:GetSpecialValueFor("cast_range")
        if mytable.needrespawn > 0 then
            if distance_from_source <= max_distance then
                if not IsInCursedForm(caster) then
                    -- Play effects
                    self.sound_cast = "Hero_Wisp.Overcharge"
                    EmitSoundOn( self.sound_cast, caster )
                    local particle_cast = "particles/units/heroes/hero_wisp/wisp_relocate_channel.vpcf"
                    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
                    ParticleManager:SetParticleControlEnt(self.effect_cast, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true)
                else
                    SendErrorMessage(player_id, "Cannot revive in Cursed Form")
                    caster:Stop()
                end
            else
                SendErrorMessage(player_id, "Must be near Spire")
                caster:Stop()
            end
        else
            local farmer = GetFarmer(player_id)
            if (farmer == nil) or (farmer:IsAlive() ~= true) then
                SendErrorMessage(player_id, "Your Villager is dead. Hero cannot be revived")
                caster:Stop()
            else
                SendErrorMessage(player_id, "Your hero is already alive")
                caster:Stop()
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Ability Channeling
function revive_hero_lua:OnChannelFinish( bInterrupted )
    local caster = self:GetCaster()
    local player_id = caster:GetPlayerOwnerID()

    local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()
	--print(channel_pct)
	if channel_pct > 0.99 then
        -- respawn dead hero
        if not caster:GetPlayerOwner().class_hero:IsAlive() then
            caster:GetPlayerOwner().class_hero:RespawnHero(false, false)
            local respawn_location = GetFarmer(player_id):GetOrigin() + RandomVector(200)
            FindClearSpaceForUnit(caster:GetPlayerOwner().class_hero, respawn_location, true)
            
            -- sfx
            EmitSoundOn("Hero_Chen.TeleportIn", caster:GetPlayerOwner().class_hero)
            EmitSoundOn("Hero_Chen.HandOfGodHealHero", caster:GetPlayerOwner().class_hero)
            local particle_cast = "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf"
            local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster:GetPlayerOwner().class_hero)
            ParticleManager:SetParticleControlEnt(effect_cast, 1, caster:GetPlayerOwner().class_hero, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetPlayerOwner().class_hero:GetOrigin(), true)
            ParticleManager:ReleaseParticleIndex(effect_cast)
        else
            SendErrorMessage(player_id, "Hero already revived")
        end
    end

    StopSoundOn( self.sound_cast, caster )
    --caster:RemoveModifierByName("modifier_revive_hero_lua")
    if self.effect_cast ~= nil then
        ParticleManager:DestroyParticle( self.effect_cast, true )
        self.effect_cast = nil
    end
end

