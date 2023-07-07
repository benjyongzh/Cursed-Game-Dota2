modifier_zombie_pounce_ravage_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_pounce_ravage_lua_debuff:IsHidden()
	return false
end

function modifier_zombie_pounce_ravage_lua_debuff:IsDebuff()
	return true
end

function modifier_zombie_pounce_ravage_lua_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_zombie_pounce_ravage_lua_debuff:OnCreated( kv )
    if IsServer() then
        -- remove knockback modifier if any
        local modifier = self:GetParent():FindModifierByName("modifier_zombie_pounce_lua_knockback")
        if modifier then
            modifier:Destroy()
        end

        -- sfx
        self.effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(self.effect, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
        self:GetParent():EmitSound("Hero_Bane.FiendsGrip.Cast")
        self:GetParent():EmitSound("Hero_Bane.FiendsGrip")
        
        self.interval = self:GetAbility():GetSpecialValueFor("ravage_interval")
        self:StartIntervalThink(self.interval)
        self:OnIntervalThink()
	end
end

function modifier_zombie_pounce_ravage_lua_debuff:OnDestroy( kv )
    if IsServer() then
        self:GetParent():RemoveGesture(ACT_DOTA_FLAIL)

        -- sfx
        if self.effect then
            ParticleManager:DestroyParticle(self.effect, false)
            ParticleManager:ReleaseParticleIndex( self.effect )
        end
        self:GetParent():StopSound("Hero_Bane.FiendsGrip.Cast")
        self:GetParent():StopSound("Hero_Bane.FiendsGrip")

	end
end

function modifier_zombie_pounce_ravage_lua_debuff:OnIntervalThink()
    local unit = self:GetParent()
    if unit:IsAlive() and IsValidEntity(unit) then
        -- animation
        unit:StartGesture(ACT_DOTA_FLAIL)

        -- sfx
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_clean_lights.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex( effect_cast )

        local effect_cast = ParticleManager:CreateParticle( "particles/abilities/rupture_burst.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
        ParticleManager:ReleaseParticleIndex( effect_cast )

        effect_cast = ParticleManager:CreateParticle( "particles/econ/items/sniper/sniper_charlie/sniper_assassinate_impact_blood_charlie.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        --ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetAbsOrigin())
        --ParticleManager:SetParticleControl(effect_cast, 1, self:GetParent():GetAbsOrigin())
        ParticleManager:SetParticleControlEnt(effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
        ParticleManager:SetParticleControlEnt(effect_cast, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
		ParticleManager:ReleaseParticleIndex( effect_cast )

        EmitSoundOn("Hero_Pudge.Dismember", self:GetParent())
        EmitSoundOn("Hero_DeathProphet.Exorcism.Damage", self:GetParent())
    else
        self:Destroy()
    end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_zombie_pounce_ravage_lua_debuff:CheckState()
	local state = {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_BLIND] = true,
	}

	return state
end

function modifier_zombie_pounce_ravage_lua_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_rupture.vpcf"
end