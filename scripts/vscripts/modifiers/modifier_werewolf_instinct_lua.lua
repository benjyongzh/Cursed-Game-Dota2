modifier_werewolf_instinct_lua = class({})

--------------------------------------------------------------------------------

function modifier_werewolf_instinct_lua:IsHidden()
	return false
end

function modifier_werewolf_instinct_lua:IsDebuff()
	return false
end

function modifier_werewolf_instinct_lua:IsPurgable()
	return true
end
--------------------------------------------------------------------------------

function modifier_werewolf_instinct_lua:OnCreated( kv )
	-- get reference
	self.lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal_pct")
	self.dmg_incoming = self:GetAbility():GetSpecialValueFor("dmg_extra_incoming_pct")
    if IsServer() then
        --sfx
        local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_buff_start_rope.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( effect_cast, 6, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		
		if self:GetAbility():GetLevel() > 1 then
			self:StartIntervalThink(0.1)
		end
    end
end

function modifier_werewolf_instinct_lua:OnRefresh( kv )
	-- get reference
	self.lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal_pct")
	self.dmg_incoming = self:GetAbility():GetSpecialValueFor("dmg_extra_incoming_pct")
	if IsServer() then
		if self:GetAbility():GetLevel() > 1 then
			self:StartIntervalThink(0.1)
		end
	end
end

function modifier_werewolf_instinct_lua:OnDestroy( kv )
	-- get reference
	self.lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal_pct")
    self.dmg_incoming = self:GetAbility():GetSpecialValueFor("dmg_extra_incoming_pct")
end

function modifier_werewolf_instinct_lua:OnIntervalThink()
	if self:GetParent():IsAlive() and self:GetAbility():GetLevel() > 1 then
		AddFOWViewer( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetAbility():GetSpecialValueFor("vision_radius"), 0.1, false )
	end
end
--------------------------------------------------------------------------------

function modifier_werewolf_instinct_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_werewolf_instinct_lua:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = (self:GetAbility():GetLevel() < 2),
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_werewolf_instinct_lua:GetModifierIncomingDamage_Percentage( params )
	return self.dmg_incoming
end

--------------------------------------------------------------------------------

function modifier_werewolf_instinct_lua:OnAttackLanded( kv ) -- lifesteal
    if not IsServer() then return end
    if (kv.attacker == self:GetParent()) and (kv.target:GetTeamNumber() ~= kv.attacker:GetTeamNumber()) and (not IsBuildingOrSpire(kv.target)) then
        local heal = kv.damage * self.lifesteal/100
        self:GetParent():Heal( heal, self:GetAbility() )

        -- sfx
        local particle_cast = "particles/generic_gameplay/generic_lifesteal.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:ReleaseParticleIndex( effect_cast )
    end
end

-------------------------------------- sfx --------------------------------------

function modifier_werewolf_instinct_lua:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf"
end

function modifier_werewolf_instinct_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end