druid_summon_bird_lua = class({})
LinkLuaModifier( "modifier_druid_summons_lua", "modifiers/modifier_druid_summons_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function druid_summon_bird_lua:OnSpellStart()
    local caster = self:GetCaster()

    --check if a bird is already summoned, and kill it
    if caster.has_a_summoned_bird == true then
        caster.summoned_bird_unit:ForceKill(false)
    end
    local spell_duration = self:GetSpecialValueFor("duration")
    local modifier = "modifier_druid_summons_lua"
    local bird = CreateUnitByName("druid_bird_summon", caster:GetAbsOrigin()+(caster:GetForwardVector():Normalized()*300), true, caster, caster, caster:GetTeamNumber())
    bird:SetOwner(caster)
    bird:SetControllableByPlayer(caster.playerID, true)
    bird:AddNewModifier(caster, self, modifier, {duration = spell_duration, spell_caster = caster})
    --renew bird unit handler
    caster.summoned_bird_unit = bird
    caster.has_a_summoned_bird = true

    --sfx
    
    EmitSoundOn("Hero_Beastmaster_Bird.Death", caster)
    EmitSoundOn("Hero_Winter_Wyvern.SplinterBlast.Cast", caster)
    local particle_cast = "particles/econ/events/ti5/blink_dagger_start_lvl2_ti5.vpcf"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, bird )
    ParticleManager:SetParticleControl(effect_cast, 1, bird:GetOrigin())
    ParticleManager:ReleaseParticleIndex(effect_cast)
end