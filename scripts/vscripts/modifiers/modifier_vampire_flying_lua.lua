modifier_vampire_flying_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_vampire_flying_lua:IsHidden()
	return false
end

function modifier_vampire_flying_lua:IsDebuff()
	return false
end

function modifier_vampire_flying_lua:IsPurgable()
	return false
end

function modifier_vampire_flying_lua:GetTexture()
	return "night_stalker_darkness"
end

function modifier_vampire_flying_lua:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------

function modifier_vampire_flying_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_vampire_flying_lua:CheckState()
    local state = {
        [MODIFIER_STATE_FLYING] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end

--------------------------------------------------------------------------------

function modifier_vampire_flying_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
        MODIFIER_PROPERTY_VISUAL_Z_DELTA,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS 
	}

	return funcs
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_vampire_flying_lua:OnCreated( kv )
	-- references
    self.bonus_nightvision = self:GetAbility():GetSpecialValueFor( "night_vision" )
    self.ms_speed = self:GetAbility():GetSpecialValueFor( "ms_change_constant" )

    if IsServer() then
        -- abilities
        --self:GetParent():SwapAbilities("vampire_ascend_lua", "vampire_impact_lua", false, true)
        for i=0, 20 do
            local abil = self:GetParent():GetAbilityByIndex(i)
            if abil ~= nil then
                if IsItemInTable(_G.CURSED_ABILITY_TABLE[_G.CURSED_CREATURE], abil:GetAbilityName()) then
                    abil:SetActivated(false)
                --if abil:GetAbilityName() ~= "vampire_impact_lua" then
                --    abil:SetActivated(false)
                --else
                --    abil:SetActivated(true)
                end
            end
        end

        -- sfx
        EmitSoundOn( "Hero_DoomBringer.PreAttack", self:GetParent())

        self:StartIntervalThink( 0.1 )
        self:OnIntervalThink()
    end
    
end

--------------------------------------------------------------------------------

function modifier_vampire_flying_lua:OnRefresh( kv )
	-- references
    self.bonus_nightvision = self:GetAbility():GetSpecialValueFor( "night_vision" )
    self.ms_speed = self:GetAbility():GetSpecialValueFor( "ms_change_constant" )
    if IsServer() then
        self:StartIntervalThink( 0.1 )
        self:OnIntervalThink()
    end
end

--------------------------------------------------------------------------------

function modifier_vampire_flying_lua:OnIntervalThink()
    -- vision
    AddFOWViewer( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent():GetNightTimeVisionRange(), 0.1, false )
end

--------------------------------------------------------------------------------

function modifier_vampire_flying_lua:GetBonusNightVision()
	return self.bonus_nightvision
end

--------------------------------------------------------------------------------

function modifier_vampire_flying_lua:GetModifierMoveSpeedBonus_Constant()
    return self.ms_speed
end

--------------------------------------------------------------------------------

function modifier_vampire_flying_lua:GetVisualZDelta()
	return 200
end

--------------------------------------------------------------------------------

function modifier_vampire_flying_lua:OnDestroy()
    local caster = self:GetParent()

    if IsServer() then
        --self:GetParent():SwapAbilities("vampire_impact_lua", "vampire_ascend_lua", false, true)
        for i=0, 20 do
            local abil = self:GetParent():GetAbilityByIndex(i)
            if abil ~= nil then
                if IsItemInTable(_G.CURSED_ABILITY_TABLE[_G.CURSED_CREATURE], abil:GetAbilityName()) then
                --if abil:GetAbilityName() ~= "vampire_impact_lua" then
                    abil:SetActivated(true)
                --else
                --    abil:SetActivated(false)
                end
            end
        end
        
        if self:GetAbility():GetLevel() < 3 then
            local trees = GridNav:GetAllTreesAroundPoint( caster:GetAbsOrigin(), 100, true )
            for _,tree in pairs(trees) do
                if tree:IsStanding() then
                    tree:CutDown(caster:GetTeam())
                end
            end
        end

        EmitSoundOn( "Hero_DoomBringer.PreAttack", self:GetParent())
    end

end

function modifier_vampire_flying_lua:GetActivityTranslationModifiers()
	return "hunter_night"
end