function OnSpellStart(event)
    -- unit identifier
    local caster = event.caster
    local playerid = caster:GetPlayerOwnerID()
    local target = event.target

    local playername = PlayerResource:GetPlayerName(target:GetPlayerOwnerID())
    local teamID = target:GetTeam()
    local color = ColorForTeam(teamID)
    Notifications:Bottom(playerid, {text=playername .. " ", duration=12, style = {color="rgb(" .. color[1] .. "," .. color[2] .. "," .. color[3] .. ")"}})

    -- notification
    if target == _G.CURSED_UNIT then
        Notifications:Bottom(playerid, {text="is the Cursed", style={color="red"}, continue = true})
    else
        Notifications:Bottom(playerid, {text="is not the Cursed", continue = true})
    end

    -- sfx
    EmitSoundOn( "Hero_DarkWillow.Ley.Stun", target)
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_wisp_aoe_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )    
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_ABSORIGIN_FOLLOW, nil, target:GetOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 2, target, PATTACH_ABSORIGIN_FOLLOW, nil, target:GetOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)
end