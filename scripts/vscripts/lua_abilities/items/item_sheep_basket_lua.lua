function OnPickup(event)
    -- unit identifier
    local caster = event.caster
    local abil = event.ability
    local playerID = caster:GetPlayerOwnerID()
    local basket_value = abil:GetSpecialValueFor("sheep_limit_increase")
    Resources:ModifySheepLimit( playerID, basket_value )

    --local Line = ("Picked up an " .. ColorIt("Additional Sheep", "orange") .. ".")
    --GameRules:SendCustomMessageToTeam(Line, caster:GetTeam(), 0, 0)
    Notifications:Bottom(playerID, {text="Picked up an ", duration=7})
    Notifications:Bottom(playerID, {text="Additional Sheep", style={color="orange"}, continue=true})

    -- sfx
    EmitSoundOn( "Hero_ShadowShaman.SheepHex.Target", caster)
    EmitSoundOnClient("Rune.Regen", caster:GetPlayerOwner())

    -- remove item
    if abil then
        UTIL_Remove(abil)
    end
end