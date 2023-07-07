
LinkLuaModifier("modifier_item_building_selfdestruct_lua", "modifiers/modifier_item_building_selfdestruct_lua", LUA_MODIFIER_MOTION_NONE)

-- on starting self-destruct sequence
function OnSelfdestructCast(event)
    local caster = event.caster
    local ability = event.ability
    local modifier = caster:FindModifierByName( "modifier_item_building_selfdestruct_lua" )

    if not modifier then
        caster:AddNewModifier(
            caster, -- player source
            ability, -- ability source
            "modifier_item_building_selfdestruct_lua", -- modifier name
            {duration = ability:GetSpecialValueFor("channel_duration")} -- kv
        )
    end
end

-- on cancelling self-destruct
function OnSelfdestructCancel(event)
    local caster = event.caster
    local ability = event.ability
    local modifier = caster:FindModifierByName( "modifier_item_building_selfdestruct_lua" )

    if modifier then
        modifier:Destroy()
    end
end