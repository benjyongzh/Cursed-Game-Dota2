modifier_defender_energy_shield_lua = class({})

function modifier_defender_energy_shield_lua:IsPurgable()
  return false
end

function modifier_defender_energy_shield_lua:IsHidden()
    return false
end

function modifier_defender_energy_shield_lua:IsDebuff()
    return false
end

function modifier_defender_energy_shield_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_defender_energy_shield_lua:OnCreated(kv)
    if IsServer() then
        self.hitpoints = kv.hp
        self.regendelay = kv.regendelay
        self.owner = kv.ownerindex
        self:SetStackCount( self.hitpoints )
        if self.regendelay > 0 then
            self.isregenerating = false
        else
            self.isregenerating = true
        end
        self:StartIntervalThink(0.03)

        -- worldpanels for shieldbar display
        if self.worldpanel == nil then
            self.worldpanel = WorldPanels:CreateWorldPanelForAll(
                {layout = "file://{resources}/layout/custom_game/worldpanels/defender_energy_shield.xml",
                entity = self:GetParent(),
                entityHeight = 200,
                data = {current_shield = self:GetStackCount(), max_shield = self:GetAbility().max_hp}
            })
        end

        -- sfx
        EmitSoundOn("Hero_FacelessVoid.TimeDilation.Cast.ti7_layer", self:GetParent())
        local effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(effect, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
        ParticleManager:ReleaseParticleIndex(effect)

        if self.hitpoints > 0 then
            self.effect1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_arc_pnt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControlEnt(self.effect1, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true)
            self.effect2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_sphere_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControlEnt(self.effect2, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true)
        else
            self.effect1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControlEnt(self.effect1, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true)
        end
    end
end

function modifier_defender_energy_shield_lua:OnRefresh()
    if IsServer() then
        -- worldpanels for shieldbar display
        if self.worldpanel then
            self.worldpanel:Delete()
        end
        self.worldpanel = WorldPanels:CreateWorldPanelForAll(
            {layout = "file://{resources}/layout/custom_game/worldpanels/defender_energy_shield.xml",
            entity = self:GetParent(),
            entityHeight = 200,
            data = {current_shield = self:GetStackCount(), max_shield = self:GetAbility().max_hp}
        })
        if self.regendelay > 0 then
            self.isregenerating = false
        else
            self.isregenerating = true
        end

    end
end

function modifier_defender_energy_shield_lua:OnDestroy()
    if IsServer() then
        if self.effect1 then 
            ParticleManager:DestroyParticle(self.effect1, true)
        end
        if self.effect2 then 
            ParticleManager:DestroyParticle(self.effect2, true)
        end
        local defender = EntIndexToHScript(self.owner)
        if self:GetParent() ~= defender then
            -- pass modifier back to defender
            if IsValidEntity(defender) then
                defender:AddNewModifier(defender, self:GetAbility(), "modifier_defender_energy_shield_lua", {hp = self.hitpoints, regendelay = self.regendelay, ownerindex = self.owner})
                self:GetAbility().parent = defender
            end
        end
        -- worldpanels for shieldbar display
        if self.worldpanel then
            self.worldpanel:Delete()
        end
    end
end

function modifier_defender_energy_shield_lua:OnIntervalThink()
    if IsServer() then
        if self.regendelay <= 0 then
            if self.isregenerating == true then
                self.hitpoints = self.hitpoints + (0.03 * (self:GetAbility():GetSpecialValueFor("hp")/self:GetAbility():GetSpecialValueFor("regen_duration")) )
                if self.hitpoints >= self:GetAbility().max_hp then
                    self.hitpoints = self:GetAbility().max_hp
                    self.isregenerating = false

                    -- sfx for finishing shield regen
                    EmitSoundOn("Hero_Medusa.MysticSnake.Return", self:GetParent())
                    StopSoundOn("NeutralItem.TeleportToStash", self:GetParent())
                    StopSoundOn("Hero_Tinker.GridEffect", self:GetParent())
                    local effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
                    ParticleManager:SetParticleControlEnt(effect, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
                    ParticleManager:ReleaseParticleIndex(effect)
                end
                self:SetStackCount( self.hitpoints )
            end
        else
            self.regendelay = self.regendelay - 0.03
            if self.regendelay <= 0 then
                -- sfx for starting regen
                EmitSoundOn("NeutralItem.TeleportToStash", self:GetParent())
                EmitSoundOn("Hero_Tinker.GridEffect", self:GetParent())
                local effect = ParticleManager:CreateParticle( "particles/neutral_fx/roshan_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
                ParticleManager:SetParticleControlEnt(effect, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true)
                ParticleManager:ReleaseParticleIndex(effect)

                if self.effect1 then 
                    ParticleManager:DestroyParticle(self.effect1, true)
                end
                if self.effect2 then 
                    ParticleManager:DestroyParticle(self.effect2, true)
                end
                self.effect1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_arc_pnt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
                ParticleManager:SetParticleControlEnt(self.effect1, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true)
                self.effect2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_sphere_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
                ParticleManager:SetParticleControlEnt(self.effect2, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true)
                self.isregenerating = true
            end
            -- worldpanel regen bar
            CustomGameEventManager:Send_ServerToAllClients("defender_energy_shield_regen_bar", {regenleft = self.regendelay, fullregendelay = self:GetAbility().fullregendelay})
        end

        -- detecting if holder is cursed
        if IsInCursedForm(self:GetParent()) then
            self:Destroy()
        end
    end
end

function modifier_defender_energy_shield_lua:OnTakeDamage(keys)
	if IsServer() then
		local damage_taken = keys.damage
		local unit = keys.unit
        if unit == self:GetParent() and unit:IsAlive() then
            local heal = damage_taken
            if damage_taken > self.hitpoints then
                heal = self.hitpoints
            end
            unit:SetHealth(unit:GetHealth() + heal)
            local stacks = self:GetStackCount()
            if damage_taken > stacks then
                if self.hitpoints > 0 then
                    -- sfx for depleting shield
                    EmitSoundOn("Hero_FacelessVoid.TimeDilation.Cast", self:GetParent())
                    local effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_spellshield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
                    ParticleManager:SetParticleControlEnt(effect, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
                    ParticleManager:ReleaseParticleIndex(effect)

                    if self.effect1 then 
                        ParticleManager:DestroyParticle(self.effect1, true)
                    end
                    if self.effect2 then 
                        ParticleManager:DestroyParticle(self.effect2, true)
                    end
                    self.effect1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
                    ParticleManager:SetParticleControlEnt(self.effect1, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true)
                end
                self.hitpoints = 0
            else
                self.hitpoints = self.hitpoints - damage_taken
                -- sfx for hitting shield
                EmitSoundOn("Hero_Disruptor.KineticField.End", self:GetParent())
                --local effect = ParticleManager:CreateParticle( "particles/econ/items/medusa/medusa_daughters/medusa_daughters_mana_shield_shell_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
                --ParticleManager:SetParticleControlEnt(effect, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true)
                local effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_supernova_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
                ParticleManager:SetParticleControlEnt(effect, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
                ParticleManager:ReleaseParticleIndex(effect)

            end
            self:SetStackCount( self.hitpoints )
            self.regendelay = self:GetAbility().fullregendelay
            self.isregenerating = false
		end
	end
end

function modifier_defender_energy_shield_lua:OnDeath(kv)
    if IsServer() and self:GetParent() == kv.unit then
        --[[
        local abil = self:GetAbility()
        local defender = EntIndexToHScript(self.owner)
        if IsValidEntity(defender) then
            defender:AddNewModifier(defender, self:GetAbility(), "modifier_defender_energy_shield_lua", {hp = self.hitpoints, regendelay = self.regendelay, ownerindex = self.owner})
            abil.parent = defender
        end
        ]]
        self:Destroy()
	end
end