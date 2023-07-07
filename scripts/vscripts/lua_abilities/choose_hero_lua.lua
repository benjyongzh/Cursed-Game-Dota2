choose_hero_lua = class({})

function choose_hero_lua:OnSpellStart()
    local caster = self:GetCaster()
    local hPlayer = caster:GetPlayerOwner()
    local playerid = caster:GetPlayerOwnerID()
    CustomGameEventManager:Send_ServerToPlayer(hPlayer, "toggle_display_hero_selection",{})
end