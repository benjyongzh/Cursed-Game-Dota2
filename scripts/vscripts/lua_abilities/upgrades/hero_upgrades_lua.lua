function UnlockAbility(event)
    local caster = event.caster
    local ability = event.ability
    if ability:GetAbilityName() == "ranger_upgrade_2" then
        local new_abil = caster:FindAbilityByName("ranger_swap_arrow_teleport_lua")
        if new_abil then
            new_abil:SetLevel(1)
        end

    elseif ability:GetAbilityName() == "illusionist_upgrade_1" then
        local new_abil = caster:FindAbilityByName("illusionist_invisible_wall_lua")
        if new_abil then
            new_abil:SetLevel(1)
        end

    elseif ability:GetAbilityName() == "guardian_upgrade_2" then
        local new_abil = caster:FindAbilityByName("guardian_resurrect_lua")
        if new_abil then
            new_abil:SetLevel(1)
        end

    end
end

LinkLuaModifier( "modifier_barbarian_upgrade_3_lua", "modifiers/upgrades/modifier_barbarian_upgrade_3_lua", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_guardian_upgrade_3_lua", "modifiers/upgrades/modifier_guardian_upgrade_3_lua", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_samurai_upgrade_1_lua", "modifiers/upgrades/modifier_samurai_upgrade_1_lua", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_samurai_upgrade_2_lua", "modifiers/upgrades/modifier_samurai_upgrade_2_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_druid_upgrade_3_lua", "modifiers/upgrades/modifier_druid_upgrade_3_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_assassin_upgrade_1_lua", "modifiers/upgrades/modifier_assassin_upgrade_1_lua", LUA_MODIFIER_MOTION_NONE )

function UpgradeValue(event)
    local caster = event.caster
    local ability = event.ability
    if ability:GetAbilityName() == "defender_upgrade_2" then
        local target_abil = caster:FindAbilityByName("defender_energy_shield_lua")
        if target_abil then
            target_abil.max_hp = target_abil.max_hp + ability:GetSpecialValueFor( "shield_hp_increase" )
            local modifier = target_abil.parent:FindModifierByName("modifier_defender_energy_shield_lua")
            if modifier then
                modifier:ForceRefresh()
            end
        end

    elseif ability:GetAbilityName() == "defender_upgrade_3" then
        local target_abil = caster:FindAbilityByName("defender_energy_shield_lua")
        if target_abil then
            target_abil.fullregendelay = target_abil.fullregendelay - ability:GetSpecialValueFor( "cd_decrease" )
            local modifier = target_abil.parent:FindModifierByName("modifier_defender_energy_shield_lua")
            if modifier then
                modifier:ForceRefresh()
            end
        end

    elseif ability:GetAbilityName() == "scout_upgrade_3" then
        caster:SetBaseMoveSpeed(caster:GetBaseMoveSpeed() + ability:GetSpecialValueFor( "ms_bonus" ))

    elseif ability:GetAbilityName() == "barbarian_upgrade_1" then
        local modifier = caster:FindModifierByName("modifier_barbarian_rage_lua")
        if modifier then
            modifier:ForceRefresh()
        end

    --elseif ability:GetAbilityName() == "barbarian_upgrade_3" then
    --    local abil = caster:FindAbilityByName("barbarian_axe_throw_lua")
    --    caster:AddNewModifier(caster, abil, "modifier_barbarian_upgrade_3_lua",{})

    elseif ability:GetAbilityName() == "guardian_upgrade_3" then
        local abil = caster:FindAbilityByName("guardian_patience_lua")
        caster:AddNewModifier(caster, abil, "modifier_guardian_upgrade_3_lua",{})

    --elseif ability:GetAbilityName() == "samurai_upgrade_1" then
    --    local abil = caster:FindAbilityByName("samurai_flash_step_lua")
    --    caster:AddNewModifier(caster, abil, "modifier_samurai_upgrade_1_lua",{})
    --elseif ability:GetAbilityName() == "samurai_upgrade_2" then
    --    local abil = caster:FindAbilityByName("samurai_flash_step_lua")
    --    caster:AddNewModifier(caster, abil, "modifier_samurai_upgrade_2_lua",{})

    elseif ability:GetAbilityName() == "druid_upgrade_3" then
        caster:AddNewModifier(caster, ability, "modifier_druid_upgrade_3_lua",{})

        local modifier1 = caster:FindModifierByName("modifier_druid_shapeshift_bear_lua")
        local modifier2 = caster:FindModifierByName("modifier_druid_shapeshift_bird_lua")
        if modifier1 then
            modifier1:ForceRefresh()
        end
        if modifier2 then
            modifier2:ForceRefresh()
        end

    elseif ability:GetAbilityName() == "assassin_upgrade_1" then
        local abil = caster:FindAbilityByName("assassin_flashbang_lua")
        caster:AddNewModifier(caster, abil, "modifier_assassin_upgrade_1_lua",{})

    elseif ability:GetAbilityName() == "assassin_upgrade_2" then
        local modifier = caster:FindModifierByName("modifier_assassin_backstab_lua")
        if modifier then
            modifier:ForceRefresh()
        end



    end
end