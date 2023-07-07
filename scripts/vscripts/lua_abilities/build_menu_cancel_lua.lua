if build_menu_cancel_lua == nil then
    build_menu_cancel_lua = class({})
end

function build_menu_cancel_lua:OnSpellStart()
    local caster = self:GetCaster()
    if caster.Is_In_Build_Menu == true then
        for i=0,5 do
            local main_ability = caster:GetAbilityByIndex(i):GetAbilityName()
            local sub_ability = caster:GetAbilityByIndex(i+6):GetAbilityName()
            caster:SwapAbilities(main_ability, sub_ability, false, true)
        end

        -- any extra abilties do here separately

        local abil = caster:GetAbilityByIndex(12):GetAbilityName() --ability number 13
        caster:FindAbilityByName(abil):SetHidden(true)

        caster.Is_In_Build_Menu = false
        --print('you have exited the build menu')
    end

end