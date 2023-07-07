transform_to_vampire_lua = class({})

--------------------------------------------------------------------------------

function transform_to_vampire_lua:IsHiddenAbilityCastable()
    return true
end

function transform_to_vampire_lua:OnAbilityPhaseStart()
    --animation
    StartAnimation(self:GetCaster(), {duration=self:GetCastPoint(), activity=ACT_DOTA_SHARPEN_WEAPON_OUT, rate=1.2})
    EmitSoundOnEntityForPlayer("Hero_DeathProphet.CarrionSwarm.Damage", self:GetCaster(), self:GetCaster():GetPlayerOwnerID())

	-- sfx
	self.effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_death_prophet/death_prophet_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( self.effect, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex(self.effect)

	return true -- if success
end

function transform_to_vampire_lua:OnAbilityPhaseInterrupted()
	--animation
    EndAnimation(self:GetCaster())
    
	-- stop effects 
    StopSoundOn( "Hero_DeathProphet.CarrionSwarm.Damage", self:GetCaster() )
    if self.effect then
        ParticleManager:DestroyParticle( self.effect, true )
    end
    -- remove this abil
    self:GetCaster():RemoveAbility(self:GetAbilityName())
end

--------------------------------------------------------------------------------

-- Ability Effect Start
function transform_to_vampire_lua:OnSpellStart()
    local caster = self:GetCaster()

    Game_Events:TransformIntoCursed()

    if self.effect then
        ParticleManager:DestroyParticle( self.effect, true )
    end

    -- remove this abil
    caster:RemoveAbility(self:GetAbilityName())
end

function transform_to_vampire_lua:ProcsMagicStick()
	return false
end