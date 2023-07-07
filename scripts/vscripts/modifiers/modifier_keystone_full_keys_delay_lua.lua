modifier_keystone_full_keys_delay_lua = class({})

LinkLuaModifier ( "modifier_keystone_activation_delay_lua", "modifiers/modifier_keystone_activation_delay_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function modifier_keystone_full_keys_delay_lua:IsDebuff()
	return true
end

function modifier_keystone_full_keys_delay_lua:IsHidden()
	return true
end

function modifier_keystone_full_keys_delay_lua:IsPurgable()
	return false
end

function modifier_keystone_full_keys_delay_lua:OnCreated()
    if IsServer() then
        self.completetime = _G.KEYSTONE_ACTIVATION_STARTUP_TIME
        self.elapsedtime = 0
        self:StartIntervalThink(0.03)
        self:OnIntervalThink()

        -- sfx
        EmitSoundOn( "ui.crafting_mech", self:GetParent())
        self:GetParent():EmitSound("Hero_Wisp.Relocate.Arc")
        
        self.effect = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_channel_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(self.effect, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.effect, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

        CustomGameEventManager:Send_ServerToAllClients("keystone_completed_start_countdown", {ent_index = self:GetParent():entindex(), duration = self.completetime})
    end
end

function modifier_keystone_full_keys_delay_lua:OnDestroy()
    if IsServer() then
        CustomGameEventManager:Send_ServerToAllClients("keystone_completed_stop_countdown", {ent_index = self:GetParent():entindex()})

        -- sfx
        self:GetParent():StopSound("Hero_Wisp.Relocate.Arc")
        if self.effect then
            ParticleManager:DestroyParticle(self.effect, true)
        end
    end
end

function modifier_keystone_full_keys_delay_lua:OnIntervalThink()
    local unit = self:GetParent()
    local modifier = unit:FindModifierByName("modifier_keystone_passive_lua_stacks")
    if (modifier) and (modifier:GetStackCount() >= _G.KEYS_TO_ACTIVATE_KEYSTONE[CountPlayersInGame()]) then
        self.elapsedtime = self.elapsedtime + 0.03
        if self.elapsedtime >= self.completetime then
            -- keystone activated
            local ks_index = getIndexTable(_G.KEYSTONE_UNIT, self:GetParent())

            CustomNetTables:SetTableValue("keystone_status", tostring(ks_index), {activated = true, keys = _G.KEYS_TO_ACTIVATE_KEYSTONE[CountPlayersInGame()]})
            if unit:HasModifier("modifier_keystone_markedbycursed_lua") then
                -- javascript for option to sabotage keystone
                CustomGameEventManager:Send_ServerToPlayer(_G.CURSED_UNIT:GetPlayerOwner(), "keystone_sabotage_prompt",{index = ks_index, ent_index = unit:entindex(), time_limit = _G.KEYSTONE_ACTIVATION_DELAY})
            end

            -- give modifier to keystone for the duration of the delay(for the cursed player to make decision). when modifier expires, keystone will activate
            
            unit:AddNewModifier(unit, nil, "modifier_keystone_activation_delay_lua", {duration = _G.KEYSTONE_ACTIVATION_DELAY})

            -- notification
            Notifications:BottomToAll({text="A Keystone is charging up...", duration = 5})

            -- sfx
            PlaySoundOnAllClients("Keystone_completed")

            -- update hud for keystone
            CustomGameEventManager:Send_ServerToAllClients("keystone_hud_update", {index = ks_index, activated = true, keys = _G.KEYS_TO_ACTIVATE_KEYSTONE[CountPlayersInGame()], max_keys = _G.KEYS_TO_ACTIVATE_KEYSTONE[CountPlayersInGame()], ent_index = unit:entindex(), activators = unit.activators})
            
            -- remove key items from activators
            for _,playerid in pairs(unit.activators) do
                if PlayerResource:IsValidPlayerID(playerid) then
                    local activator_unit = GetMainUnit(playerid)
                    if activator_unit and activator_unit:IsAlive() and IsValidEntity(activator_unit) then
                        activator_unit:Stop()
                        for i=0, 8, 1 do  --Remove all dummy items from the player's inventory.
                            local current_item = activator_unit:GetItemInSlot(i)
                            if current_item ~= nil then
                                if current_item:GetName() == "item_keystone_key" then
                                    UTIL_Remove(current_item)
                                end
                            end
                        end
                        -- sfx
                        if unit.activator_fx[activator_unit:entindex()] then
                            ParticleManager:DestroyParticle(unit.activator_fx[activator_unit:entindex()], true)
                        end
                        activator_unit:StopSound("Hero_ShadowShaman.Shackles")
                    end
                end
            end

            -- destroy keystone passive stack modifier
            modifier:Destroy()

            -- destroy this modifier
            self:Destroy()
            
        end
    else
        self:Destroy()
    end
end
