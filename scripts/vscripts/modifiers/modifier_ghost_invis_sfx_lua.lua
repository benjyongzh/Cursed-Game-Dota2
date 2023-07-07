modifier_ghost_invis_sfx_lua = class({})

function modifier_ghost_invis_sfx_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_invis_sfx_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_invis_sfx_lua:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_BLIND] = true,
        [MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
        [MODIFIER_STATE_NO_TEAM_SELECT] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true
    }

    return state
end


function modifier_ghost_invis_sfx_lua:GetVisualZDelta()
	return 50
end

--------------------------------------------------------------------------------

function modifier_ghost_invis_sfx_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ghost_invis_sfx_lua:OnCreated(kv)
    if IsServer() and self:GetAbility():IsTrained() then
        self.time_interval = 0.03
        self.sfx_interval = kv.sfxinterval
        self.timer = 0
        self.ghost_unit = EntIndexToHScript(kv.ent_index)
        self:StartIntervalThink( self.time_interval )
        local particle = "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast_trail_smoke_black.vpcf"
        self.effect = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_ghost_invis_sfx_lua:OnDestroy()
    if IsServer() then
        if self.effect ~= nil then
            ParticleManager:DestroyParticle(self.effect, true)
        end
        self:GetParent():ForceKill(false)
	end
end

--------------------------------------------------------------------------------

function modifier_ghost_invis_sfx_lua:OnIntervalThink()
    if not IsServer() then return end
    if not self:GetParent():IsAlive() then return end
    local ghost = self.ghost_unit
    if not ghost:IsAlive() then self:Destroy() return end
    if not ghost:HasModifier("modifier_ghost_invis_lua") then self:Destroy() return end
    
    -- setting position
	local target = ghost:GetAbsOrigin()

	-- change position
    self:GetParent():SetAbsOrigin(GetGroundPosition(target, nil))
    
    -- black smoke sfx positioning
    ParticleManager:SetParticleControl(self.effect, 3, self:GetParent():GetOrigin())

    self.timer = self.timer + self.time_interval
    -- sfx
    if self.timer >= self.sfx_interval then
        --local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_phantom_death.vpcf"
        --local offset = Vector(0,0,50)
        local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_phantom_death_ground_smoke.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetOrigin())
        ParticleManager:ReleaseParticleIndex( effect_cast )

        --[[
        particle_cast = "particles/units/heroes/hero_clinkz/clinkz_death_smoke.vpcf"
        effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetOrigin())
        ParticleManager:ReleaseParticleIndex( effect_cast )
        ]]

        particle_cast = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_death_black_steam.vpcf"
        effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl(effect_cast, 3, Vector(0,0,50) + self:GetParent():GetOrigin())
        ParticleManager:ReleaseParticleIndex( effect_cast )
        
        self.timer = 0
    end
end