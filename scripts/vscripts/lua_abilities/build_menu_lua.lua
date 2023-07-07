if build_menu_lua == nil then
    build_menu_lua = class({})
end

function build_menu_lua:OnSpellStart()
    local caster = self:GetCaster()

    for i=0,5 do
        local main_ability = caster:GetAbilityByIndex(i):GetAbilityName()
        local sub_ability = caster:GetAbilityByIndex(i+6):GetAbilityName()
        caster:SwapAbilities(main_ability, sub_ability, false, true)
    end
    
    -- any extra abilities, put here
    local abil = caster:GetAbilityByIndex(12):GetAbilityName() --ability number 13
    caster:FindAbilityByName(abil):SetHidden(false)
    
    caster.Is_In_Build_Menu = true
end