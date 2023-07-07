modifier_ursa_enrage_lua = class({})

--------------------------------------------------------------------------------

function modifier_ursa_enrage_lua:IsHidden()
	return false
end

function modifier_ursa_enrage_lua:IsDebuff()
	return false
end

function modifier_ursa_enrage_lua:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function modifier_ursa_enrage_lua:OnCreated( kv )
	-- get reference
	self.damage_reduction_day = self:GetAbility():GetSpecialValueFor("damage_reduction_day")
	self.damage_reduction_night = self:GetAbility():GetSpecialValueFor("damage_reduction_night")
	self.damage_reduction = 0
    -----------------------------------lifestealer casting sfx-----------------------------------
    if IsServer() then
        self:StartIntervalThink(0.2)
        self:OnIntervalThink()
        -- sfx
        local particle_cast = "particles/units/heroes/hero_life_stealer/life_stealer_rage_cast.vpcf"
        -- Create Particle
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(
            effect_cast,
            2,
            self:GetParent(),
            PATTACH_CENTER_FOLLOW,
            "attach_hitloc",
            self:GetParent():GetOrigin(), -- unknown
            true -- unknown, true
        )
        self:AddParticle(
            effect_cast,
            false,
            false,
            -1,
            false,
            false
        )
    end
end

function modifier_ursa_enrage_lua:OnIntervalThink()
    if GameRules:IsDaytime() then
        self.damage_reduction = self.damage_reduction_day
    else
        self.damage_reduction = self.damage_reduction_night
    end
end

function modifier_ursa_enrage_lua:OnRefresh()
end

function modifier_ursa_enrage_lua:OnDestroy()
end
--------------------------------------------------------------------------------

function modifier_ursa_enrage_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ursa_enrage_lua:GetModifierIncomingDamage_Percentage( params )
	return -self.damage_reduction
end

--------------------------------------------------------------------------------

---------------------------------lifestealer body darkening effect----------------------------------------
function modifier_ursa_enrage_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end
