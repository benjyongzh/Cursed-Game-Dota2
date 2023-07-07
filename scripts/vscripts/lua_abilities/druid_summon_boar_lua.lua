druid_summon_boar_lua = class({})
LinkLuaModifier( "modifier_druid_summons_lua", "modifiers/modifier_druid_summons_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function druid_summon_boar_lua:OnSpellStart()
    local caster = self:GetCaster()

    --check if a boar is already summoned, and kill it
    if caster.has_a_summoned_boar == true then
        caster.summoned_boar_unit:ForceKill(false)
    end
    local spell_duration = self:GetSpecialValueFor("duration")
    local modifier = "modifier_druid_summons_lua"
    local boar = CreateUnitByName("druid_boar_summon", caster:GetAbsOrigin()+(caster:GetForwardVector():Normalized()*300), true, caster, caster, caster:GetTeamNumber())
    boar:SetOwner(caster)
    boar:SetControllableByPlayer(caster:GetPlayerID(), true)
    boar:AddNewModifier(caster, self, modifier, {duration = spell_duration, spell_caster = caster})
    --renew boar unit handler
    caster.summoned_boar_unit = boar
    caster.has_a_summoned_boar = true

    --sfx
    
    EmitSoundOn("Hero_Beastmaster_Boar.Death", caster)
    EmitSoundOn("Hero_Winter_Wyvern.SplinterBlast.Cast", caster)
    local particle_cast = "particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, boar )
    ParticleManager:SetParticleControl(effect_cast, 1, boar:GetOrigin())
    ParticleManager:ReleaseParticleIndex(effect_cast)
end