modifier_endgame_portal_lua = class({})

function modifier_endgame_portal_lua:OnCreated()
    if IsServer() then
        self.timer = _G.ENDGAME_PORTAL_DURATION
        self:StartIntervalThink(0.1)

        local unit = self:GetParent()
        local vector = Vector(0,0,320)

        -- sfx
        local effect_precast = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/loadout/void_spirit_portal_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        --ParticleManager:SetParticleControlEnt(effect_precast, 0, tower, PATTACH_ABSORIGIN_FOLLOW, nil, tower:GetOrigin(), true)
        ParticleManager:SetParticleControl(effect_precast,1,unit:GetAbsOrigin() + vector)
        ParticleManager:SetParticleControlForward(effect_precast, 1, unit:GetForwardVector())
        ParticleManager:ReleaseParticleIndex(effect_precast)

        self.fx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/astral_step_portal_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControl(self.fx1,1,unit:GetAbsOrigin() + vector)
        ParticleManager:SetParticleControlForward(self.fx1, 1, unit:GetForwardVector())

        self.fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/astral_step_portal_selected_steam.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControl(self.fx2,1,unit:GetAbsOrigin() + vector)
        ParticleManager:SetParticleControlForward(self.fx2, 1, unit:GetForwardVector())
        
        self.fx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/astral_step_portal_selected_steam_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControl(self.fx3,1,unit:GetAbsOrigin() + vector)
        ParticleManager:SetParticleControlForward(self.fx3, 1, unit:GetForwardVector())

        -- start pano for countdown
        CustomGameEventManager:Send_ServerToAllClients("start_endgame_portal_timer", {duration = self.timer})
    end
end

function modifier_endgame_portal_lua:OnDestroy()
    if IsServer() then

        local unit = self:GetParent()
        local modifier = unit:FindModifierByName("modifier_endgame_portal_cancel_debuff_lua")

        --[[
        if modifier and _G.GAME_HAS_ENDED ~= true then
            -- do not end game. close portal without any effect. this scenario is only occuring from alien cursed form disrupting a keystone
        end
        ]]

        -- sfx
        local vector = Vector(0,0,320)
        if self.fx1 then
            ParticleManager:DestroyParticle( self.fx1, false )
            ParticleManager:ReleaseParticleIndex(self.fx1)
        end
        if self.fx2 then
            ParticleManager:DestroyParticle( self.fx2, false )
            ParticleManager:ReleaseParticleIndex(self.fx2)
        end
        if self.fx3 then
            ParticleManager:DestroyParticle( self.fx3, false )
            ParticleManager:ReleaseParticleIndex(self.fx3)
        end
        if self.fx4 then
            ParticleManager:DestroyParticle( self.fx4, false )
            ParticleManager:ReleaseParticleIndex(self.fx4)
        end

        local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/astral_step_portal_selected_embers.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControl(effect,1,unit:GetAbsOrigin() + vector)
        ParticleManager:SetParticleControlForward(effect, 1, unit:GetForwardVector())
        ParticleManager:ReleaseParticleIndex(effect)

        effect = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/astral_step_portal_selected_embers_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControl(effect,1,unit:GetAbsOrigin() + vector)
        ParticleManager:SetParticleControlForward(effect, 1, unit:GetForwardVector())
        ParticleManager:ReleaseParticleIndex(effect)

        EmitSoundOn("Hero_Phoenix.SuperNova.Death", unit)
        EmitSoundOn("Hero_Furion.Teleport_Disappear", unit)

        -- remove pano
        CustomGameEventManager:Send_ServerToAllClients("remove_endgame_portal_timer", {})
    end
end

function modifier_endgame_portal_lua:OnIntervalThink()
    if self:GetParent():IsAlive() then
        if _G.GAME_HAS_ENDED ~= true then
            self.timer = self.timer - 0.1
            local all_valid_units = {}
            local within_range_units = {}
            for i = 0, 15, 1 do 
                if PlayerResource:IsValidPlayerID(i) then
                    local main_unit = GetMainUnit(i)
                    if main_unit:IsAlive() and (IsValidEntity(main_unit)) and (main_unit ~= _G.CURSED_UNIT) then
                        --check alive
                        table.insert(all_valid_units, main_unit)
                        --check within range of portal
                        local distance = GetDistance(main_unit:GetAbsOrigin(), self:GetParent():GetAbsOrigin())
                        if distance <= _G.ENDGAME_PORTAL_DISTANCE then
                            table.insert(within_range_units, main_unit)
                        end
                    end
                end
            end
            if (#within_range_units >= #all_valid_units) or (self.timer <= 0.1) then
                -- game ending sequence
                Game_Events:EndgamePortalSuccessSequence()
            end
        end
    end
end