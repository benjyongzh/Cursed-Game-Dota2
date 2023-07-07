guardian_resurrect_lua = class({})
LinkLuaModifier( "modifier_guardian_resurrect_lua", "modifiers/modifier_guardian_resurrect_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_guardian_resurrect_ghost_lua", "modifiers/modifier_guardian_resurrect_ghost_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_guardian_resurrect_lua_stacks", "modifiers/modifier_guardian_resurrect_lua_stacks", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function guardian_resurrect_lua:GetIntrinsicModifierName()
	return "modifier_guardian_resurrect_lua_stacks"
end

function guardian_resurrect_lua:OnAbilityPhaseStart()
    local target = self:GetCursorTarget()
    local caster = self:GetCaster()
    local helped_player_id = target:GetPlayerOwnerID()
    local caster_player_id = caster:GetPlayerOwnerID()

    local mainunit = GetMainUnit(helped_player_id)
    if mainunit:IsAlive() and IsValidEntity(mainunit) then
        SendErrorMessage(caster_player_id, "Ghost player already has Hero alive")
        return false
    end

    if target:GetUnitName() ~= "ghost_loser_main_unit" or (not IsValidEntity(target)) then
        SendErrorMessage(caster_player_id, "Can only cast on Ghosts")
        return false
    end
    if target:HasModifier("modifier_ghost_invis_lua") then
        SendErrorMessage(caster_player_id, "Ghost cannot be in Invisible Form")
        return false
    end

    self.target = target

    -- apply stun modifier to target
    self.target:AddNewModifier(caster, self, "modifier_guardian_resurrect_ghost_lua", {})

    -- play effects 
    local sound_cast = "Hero_Omniknight.Repel.TI8"
    EmitSoundOn( sound_cast, self:GetCaster() )
    
    -- sfx on target
    self.effect_target1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_wisp/wisp_relocate_marker_endpoint.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target )
    ParticleManager:SetParticleControlEnt(self.effect_target1, 0, self.target, PATTACH_ABSORIGIN_FOLLOW, nil, self.target:GetAbsOrigin(), true)
    self.effect_target2 = ParticleManager:CreateParticle( "particles/econ/events/winter_major_2016/teleport_start_winter_major_2016_a_model.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target )
    ParticleManager:SetParticleControlEnt(self.effect_target2, 0, self.target, PATTACH_ABSORIGIN_FOLLOW, nil, self.target:GetAbsOrigin(), true)
    self.effect_target3 = ParticleManager:CreateParticle( "particles/econ/events/ti7/teleport_end_ti7_lvl3_rays.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target )
    ParticleManager:SetParticleControlEnt(self.effect_target3, 0, self.target, PATTACH_ABSORIGIN_FOLLOW, nil, self.target:GetAbsOrigin(), true)

    -- sfx on caster
    self.effect_caster1 = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start_v2_special_glyphs.vpcf", PATTACH_WORLDORIGIN, caster )
    ParticleManager:SetParticleControl(self.effect_caster1, 0, caster:GetAbsOrigin())
    self.effect_caster2 = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start_v2_special_lines.vpcf", PATTACH_WORLDORIGIN, caster )
    ParticleManager:SetParticleControl(self.effect_caster2, 0, caster:GetAbsOrigin())
    self.effect_caster3 = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start_v2_special_streak_highlight.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
    ParticleManager:SetParticleControlEnt(self.effect_caster3, 0, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
    self.effect_caster4 = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_echoslam_start_v2_special_streak.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
    ParticleManager:SetParticleControlEnt(self.effect_caster4, 0, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)

    return true -- if success
end

function guardian_resurrect_lua:OnAbilityPhaseInterrupted()
	--animation
    --self:GetCaster():RemoveGesture(ACT_DOTA_SPAWN)
    
	-- stop effects 
	local sound_cast = "Hero_Omniknight.Repel.TI8"
    StopSoundOn( sound_cast, self:GetCaster() )
    if self.effect_target1 then
        ParticleManager:DestroyParticle( self.effect_target1, true )
    end
    if self.effect_target2 then
        ParticleManager:DestroyParticle( self.effect_target2, true )
    end
    if self.effect_target3 then
        ParticleManager:DestroyParticle( self.effect_target3, true )
    end
    if self.effect_caster1 then
        ParticleManager:DestroyParticle( self.effect_caster1, true )
    end
    if self.effect_caster2 then
        ParticleManager:DestroyParticle( self.effect_caster2, true )
    end
    if self.effect_caster3 then
        ParticleManager:DestroyParticle( self.effect_caster3, true )
    end
    if self.effect_caster4 then
        ParticleManager:DestroyParticle( self.effect_caster4, true )
    end

    local modifier = self.target:FindModifierByName("modifier_guardian_resurrect_ghost_lua")
    if modifier then
        modifier:Destroy()
    end
    
    -- reset target
    self.target = nil
end

function guardian_resurrect_lua:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    if IsValidEntity(self.target) and self.target:IsAlive() and self.target == target then
        local helped_player_id = self.target:GetPlayerOwnerID()
        local mainunit = GetMainUnit(helped_player_id)
        if mainunit:IsAlive() and IsValidEntity(mainunit) then
            SendErrorMessage(caster:GetPlayerOwnerID(), "Player already revived")
            self:EndCooldown()
            caster:GiveMana(self:GetManaCost(self:GetLevel()))
            self.target:ForceKill(false)
        else
            if not self.target:IsAlive() then
                SendErrorMessage(caster:GetPlayerOwnerID(), "target Ghost died while Resurrecting")
                self:EndCooldown()
                caster:GiveMana(self:GetManaCost(self:GetLevel()))
            else
                -- respawn dead hero
                local location = self.target:GetAbsOrigin()
                mainunit:RespawnUnit()
                FindClearSpaceForUnit(mainunit, location, true)

                -- revert back to original team
                PlayerResource:SetCustomTeamAssignment(helped_player_id, _G.TEAM_LIST[helped_player_id - 1])
                _G.CUSTOM_TEAM_PLAYER_COUNT[_G.GHOST_TEAM] = _G.CUSTOM_TEAM_PLAYER_COUNT[_G.GHOST_TEAM] - 1
                GameRules:SetCustomGameTeamMaxPlayers(_G.GHOST_TEAM, _G.CUSTOM_TEAM_PLAYER_COUNT[_G.GHOST_TEAM])

                -- success sfx
                EmitSoundOn("Hero_Chen.TeleportIn", mainunit)
                EmitSoundOn("Hero_Omniknight.GuardianAngel.Cast", caster)
                mainunit:AddNewModifier(caster, self, "modifier_guardian_resurrect_lua", {duration=5})

                self.target:ForceKill(false)
            end
        end
    else
        SendErrorMessage(caster:GetPlayerOwnerID(), "Invalid target")
        self:EndCooldown()
        caster:GiveMana(self:GetManaCost(self:GetLevel()))
    end

    -- stop castering sfx
	local sound_cast = "Hero_Omniknight.Repel.TI8"
    StopSoundOn( sound_cast, caster )
    if self.effect_target1 then
        ParticleManager:DestroyParticle( self.effect_target1, true )
    end
    if self.effect_target2 then
        ParticleManager:DestroyParticle( self.effect_target2, true )
    end
    if self.effect_target3 then
        ParticleManager:DestroyParticle( self.effect_target3, true )
    end
    if self.effect_caster1 then
        ParticleManager:DestroyParticle( self.effect_caster1, true )
    end
    if self.effect_caster2 then
        ParticleManager:DestroyParticle( self.effect_caster2, true )
    end
    if self.effect_caster3 then
        ParticleManager:DestroyParticle( self.effect_caster3, true )
    end
    if self.effect_caster4 then
        ParticleManager:DestroyParticle( self.effect_caster4, true )
    end

    local modifier = self.target:FindModifierByName("modifier_guardian_resurrect_ghost_lua")
    if modifier then
        modifier:Destroy()
    end

    self.target = nil
end