LinkLuaModifier( "modifier_item_torch_lua", "modifiers/items/modifier_item_torch_lua", LUA_MODIFIER_MOTION_NONE )

------------------------------------------------------------------

-- Toggle
function OnToggle(event)
    -- unit identifier
    local caster = event.caster
    local abil = event.ability
    local modifier = caster:FindModifierByName( "modifier_item_torch_lua" )

    if abil:GetAbilityName() == "item_torch_inactive" then
        -- turning on torch light
        if not modifier then
            if caster:IsAlive() then
                caster:AddNewModifier(
                    caster, -- player source
                    abil, -- ability source
                    "modifier_item_torch_lua", -- modifier name
                    {} -- kv
                )

                -- swap item with item_torch_active
                local item = caster:FindItemInInventory("item_torch_inactive")
                if item then
                    -- swap item based on item slot. this function is from utils
                    swap_to_item(event, "item_torch_active")
                end
                
                --local sound_cast = "Hero_TemplarAssassin.Meld"
                --EmitSoundOn( sound_cast, caster )
            end
        end

    else
        -- turning off torch light
		if modifier then
			--remove torch modifier
			modifier:Destroy()
        end
        
        local item = caster:FindItemInInventory("item_torch_active")
        if item then
            -- swap item based on item slot. this function is from utils
            swap_to_item(event, "item_torch_inactive")
        end
	end
end

-- on unequip. only used by active torch
function OnUnequip(event)
    local caster = event.caster
    local modifier = caster:FindModifierByName( "modifier_item_torch_lua" )

    -- turning off torch light
    if modifier then
        --remove torch modifier
        modifier:Destroy()
    end
end