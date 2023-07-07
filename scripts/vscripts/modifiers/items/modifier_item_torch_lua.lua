modifier_item_torch_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_item_torch_lua:IsHidden()
	return false
end

function modifier_item_torch_lua:IsDebuff()
	return false
end

function modifier_item_torch_lua:IsPurgable()
	return false
end

function modifier_item_torch_lua:GetTexture()
	return "keeper_of_the_light_illuminate"
end

function modifier_item_torch_lua:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_torch_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
	}

	return funcs
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_item_torch_lua:OnCreated( kv )
	-- references
    self.bonus_nightvision = self:GetAbility():GetSpecialValueFor( "night_vision_extra_range" )

    if  IsServer() then

        self:StartIntervalThink( 0.1 )
        self:OnIntervalThink()

        -- sfx
        local sound_cast = "General.ButtonClick"
        EmitSoundOn( sound_cast, self:GetParent() )
        local particle = "particles/units/heroes/hero_puck/puck_illusory_orb_sphere_halo.vpcf"
        self.effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(self.effect, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
    end
    
end

--------------------------------------------------------------------------------

function modifier_item_torch_lua:OnRefresh( kv )
	-- references
    if IsServer() then
        self:StartIntervalThink( 0.1 )
        self:OnIntervalThink()
    end
end

--------------------------------------------------------------------------------

function modifier_item_torch_lua:OnIntervalThink()
    -- vision
    if not (GameRules:IsDaytime()) then
        AddFOWViewer( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent():GetNightTimeVisionRange(), 0.1, false )

        -- find enemy units around parent and give them vision of parent
        local enemies = FindUnitsInRadius(
            self:GetParent():GetTeam(),
            self:GetParent():GetAbsOrigin(),
            nil,
            self:GetParent():GetNightTimeVisionRange(),
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_ALL,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false)

        for _,unit in pairs(enemies) do
            --if not unit:CanEntityBeSeenByMyTeam(self:GetParent()) then
                AddFOWViewer( unit:GetTeamNumber(), self:GetParent():GetOrigin(), 200, 0.1, true )
            --end
            --print("can enemy see me? " .. tostring(unit:CanEntityBeSeenByMyTeam(self:GetParent())))
        end
    end
end

--------------------------------------------------------------------------------

function modifier_item_torch_lua:OnRemoved()
    if IsServer() then
        -- sfx
        local sound_cast = "General.ButtonClickRelease"
        EmitSoundOn( sound_cast, self:GetParent() )
        if self.effect ~= nil then
            ParticleManager:DestroyParticle(self.effect, true)
        end
    end
end

--------------------------------------------------------------------------------

function modifier_item_torch_lua:GetBonusNightVision()
    if IsServer() then
        if not (GameRules:IsDaytime()) then
            return self.bonus_nightvision
        end
    end
end

--------------------------------------------------------------------------------

function modifier_item_torch_lua:OnDestroy()
    if IsServer() then
        -- sfx
        local sound_cast = "General.ButtonClickRelease"
        EmitSoundOn( sound_cast, self:GetParent() )
        if self.effect ~= nil then
            ParticleManager:DestroyParticle(self.effect, true)
        end
    end
end

