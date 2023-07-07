transform_to_werewolf_lua = class({})

--------------------------------------------------------------------------------

function transform_to_werewolf_lua:IsHiddenAbilityCastable()
    return true
end

function transform_to_werewolf_lua:OnAbilityPhaseStart()
    --animation
    StartAnimation(self:GetCaster(), {duration=self:GetCastPoint(), activity=ACT_DOTA_SHARPEN_WEAPON_OUT, rate=0.6})
    EmitSoundOnEntityForPlayer("Hero_Lycan.Shapeshift.Cast", self:GetCaster(), self:GetCaster():GetPlayerOwnerID())

	-- sfx
	self.effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_loadout.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( self.effect, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex(self.effect)

	return true -- if success
end

function transform_to_werewolf_lua:OnAbilityPhaseInterrupted()
	--animation
    EndAnimation(self:GetCaster())
    
	-- stop effects 
    StopSoundOn( "Hero_Lycan.Shapeshift.Cast", self:GetCaster() )
    if self.effect then
        ParticleManager:DestroyParticle( self.effect, true )
    end
    -- remove this abil
    self:GetCaster():RemoveAbility(self:GetAbilityName())
end

--------------------------------------------------------------------------------

-- Ability Effect Start
function transform_to_werewolf_lua:OnSpellStart()
    local caster = self:GetCaster()

    Game_Events:TransformIntoCursed()
    
    EmitSoundOnEntityForPlayer("Hero_Lycan.Howl.Team", caster, caster:GetPlayerOwnerID())

    if self.effect then
        ParticleManager:DestroyParticle( self.effect, true )
    end

    -- remove this abil
    caster:RemoveAbility(self:GetAbilityName())
end

function transform_to_werewolf_lua:ProcsMagicStick()
	return false
end