item_unit_upgrade_lua = class({})

--------------------------------------------------------------------------------
-- Ability Start

function item_unit_upgrade_lua:OnAbilityPhaseStart()
    local caster = self:GetCaster()

    -- sfx
    local sound_cast = "Shrine.Recharged"
	EmitSoundOn( sound_cast, caster )
    local particle = "particles/econ/items/monkey_king/mk_ti9_immortal/mk_ti9_immortal_army_ray.vpcf"
    self.effect = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(self.effect, 3, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetOrigin(), true)

    return true
end

function item_unit_upgrade_lua:OnAbilityPhaseInterrupted()
    local sound_cast = "Shrine.Recharged"
	StopSoundOn( sound_cast, self:GetCaster() )
	ParticleManager:DestroyParticle( self.effect, true )
end

function item_unit_upgrade_lua:OnSpellStart()
    local caster = self:GetCaster()
    local unitname = caster:GetUnitName()
    local hPlayer = caster:GetPlayerOwner()
    local player_ID = caster:GetPlayerOwnerID()
    local mytable = CustomNetTables:GetTableValue("unit_upgrades", tostring(player_ID))
    local new_unit_name = nil

    if unitname == "sellsword_unit" then
        if mytable.melee == "zealot" then
            new_unit_name = "zealot_unit"
        elseif mytable.melee == "warrior" then
            new_unit_name = "warrior_unit"
        end
            
    elseif unitname == "bowman_unit" then
        if mytable.ranged == "hunter" then
            new_unit_name = "hunter_unit"
        elseif mytable.ranged == "rifleman" then
            new_unit_name = "rifleman_unit"
        end
    end

    local hero = hPlayer.fake_omniknight_hero
    local unit = CreateUnitByName(new_unit_name, caster:GetAbsOrigin(), true, hero, hPlayer, caster:GetTeam())
    unit:SetOwner(hero)
    unit:SetControllableByPlayer(player_ID, true)

    -- add unit into table of units
    table.insert(hPlayer.Units, unit)

    -- remove old unit
    caster:ForceKill(false) -- this reduces foodused by 1 too. hence the next line
    Resources:ModifyFoodUsed( player_ID, 1 )

    -- sfx
    local sound_cast = "Shrine.Recharged"
	StopSoundOn( sound_cast, caster )
    if self.effect then
        ParticleManager:DestroyParticle(self.effect, true)
    end
    EmitSoundOn("Hero_Terrorblade.Reflection" , unit)
    local particle = "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7_gold_impact_sparks.vpcf"
    local effect = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, unit )
    ParticleManager:SetParticleControl( effect, PATTACH_ABSORIGIN_FOLLOW, unit:GetOrigin() )
    ParticleManager:ReleaseParticleIndex(effect)
end