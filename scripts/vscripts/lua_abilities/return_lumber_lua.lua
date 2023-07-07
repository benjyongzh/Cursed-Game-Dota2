return_lumber_lua = class({})
LinkLuaModifier( "modifier_return_lumber_lua", "modifiers/modifier_return_lumber_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function return_lumber_lua:OnSpellStart()
    local caster = self:GetCaster()
    local player_id = caster:GetPlayerOwnerID()
    local modifier = caster:FindModifierByName( "modifier_harvest_channel_lua" )
    if modifier then
        modifier:Destroy()
    end
    if GetHut(player_id) ~= nil then
        local hut = GetHut(player_id)
        caster:AddNewModifier(caster, self, "modifier_return_lumber_lua", {})
        caster:MoveToPosition(hut:GetOrigin())
    else
        caster:Stop()
        SendErrorMessage(player_id, "No Hut to return to")
    end
end