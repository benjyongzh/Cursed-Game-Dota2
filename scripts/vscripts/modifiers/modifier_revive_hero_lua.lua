modifier_revive_hero_lua = class({})
--------------------------------------------------------------------------------

function modifier_revive_hero_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_revive_hero_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_revive_hero_lua:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_revive_hero_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_revive_hero_lua:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------

function modifier_revive_hero_lua:OnCreated( kv )
    local ability = self:GetAbility()
    self.duration = ability:GetSpecialValueFor("channel_time")
    self.sfx_interval = ability:GetSpecialValueFor("sfx_interval")
    self.time_elapsed = 0.0

    if IsServer() then
        local particle_cast = "particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6_arc.vpcf"
        self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl(self.effect_cast, 3, self:GetParent():GetOrigin())

        self:StartIntervalThink( self.sfx_interval )
        self:OnIntervalThink()
        
	end
end

--------------------------------------------------------------------------------

function modifier_revive_hero_lua:OnRefresh( kv )
    
    local ability = self:GetAbility()
    self.duration = ability:GetSpecialValueFor("channel_time")
    self.sfx_interval = ability:GetSpecialValueFor("sfx_interval")
    self.time_elapsed = 0.0
    if IsServer() then
        if self.effect_cast ~= nil then
            ParticleManager:DestroyParticle(self.effect_cast)
        end
        local particle_cast = "particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6_arc.vpcf"
        self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl(self.effect_cast, 3, self:GetParent():GetOrigin())

        self:StartIntervalThink( self.sfx_interval )
        self:OnIntervalThink()
	end
end

--------------------------------------------------------------------------------

function modifier_revive_hero_lua:OnIntervalThink()
    if IsServer() then
        --print(self.time_elapsed)
        --print(self.duration)
        if self.time_elapsed <= self.duration then
            local angle = (self.time_elapsed * (self.sfx_interval/self.duration)) * 360

            ParticleManager:SetParticleControlForward(self.effect_cast, 0, RotatePosition(Vector(0,0,0), QAngle(0, angle, 0), Vector(0,1,0)))

            self.time_elapsed = self.time_elapsed + self.sfx_interval  
        else
            ParticleManager:DestroyParticle(self.effect_cast)
            self:Destroy()
        end
	end
end