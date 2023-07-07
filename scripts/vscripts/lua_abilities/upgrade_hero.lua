function upgrade_hero_attribute(event)
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetAbilityName()
    local player_ID = caster:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(player_ID)
    local gold = ability:GetSpecialValueFor("gold_cost")
    local lumber_cost = ability:GetSpecialValueFor("lumber_cost")

    if CustomNetTables:GetTableValue("player_hero", tostring(player_ID)).chosen > 0 then
        if Resources:HasEnoughLumber( player_ID, lumber_cost ) then
            local attri_gain = ability:GetSpecialValueFor("attribute_gain")
            if ability_name == "upgrade_str" then
                hero:ModifyStrength(attri_gain)
            elseif ability_name == "upgrade_agi" then
                hero:ModifyAgility(attri_gain)
            elseif ability_name == "upgrade_int" then
                hero:ModifyIntellect(attri_gain)
            end
            Resources:ModifyLumber( player_ID, -lumber_cost)
        else
            ability:EndCooldown()
            Resources:ModifyGold( player_ID, gold)
        end
    else
        SendErrorMessage(player_ID, "Choose a hero first")
        ability:EndCooldown()
        Resources:ModifyGold( player_ID, gold)
    end    
end