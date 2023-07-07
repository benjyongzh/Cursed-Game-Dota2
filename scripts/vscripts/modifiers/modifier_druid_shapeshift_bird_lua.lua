modifier_druid_shapeshift_bird_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_druid_shapeshift_bird_lua:IsHidden()
	return false
end

function modifier_druid_shapeshift_bird_lua:IsDebuff()
	return false
end

function modifier_druid_shapeshift_bird_lua:IsPurgable()
	return false
end

function modifier_druid_shapeshift_bird_lua:GetTexture()
	return "beastmaster_call_of_the_wild_hawk"
end

function modifier_druid_shapeshift_bird_lua:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bird_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bird_lua:CheckState()
    local state = {
        [MODIFIER_STATE_FLYING] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_MUTED] = true,
    }

    return state
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bird_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_FIXED_DAY_VISION,
        MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_VISUAL_Z_DELTA,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}

	return funcs
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_druid_shapeshift_bird_lua:OnCreated( kv )
	-- references
    self.vision = self:GetAbility():GetSpecialValueFor( "fixed_vision" )
    self.ms_speed = -self:GetAbility():GetSpecialValueFor( "ms_change_constant" )
    self.manacost = self:GetAbility():GetSpecialValueFor("mp_pct_per_second")

    if  IsServer() then
        local unit = self:GetParent()

        -- check for upgrade 3
        --[[
        local abil = unit:FindAbilityByName("druid_upgrade_3")
        if abil then
            if abil:GetLevel() > 0 then
                self.manacost = self.manacost * (1 - (self:GetAbility():GetSpecialValueFor("upgrade_mp_cost_reduce_pct")/100))
            end
        end
        ]]

        -- hp alteration
        self.hp_reduce_pct = self:GetAbility():GetSpecialValueFor("hp_reduction_pct")
        self.original_max_hp = unit:GetMaxHealth()
        local hp_difference = (self.hp_reduce_pct/100) * self.original_max_hp
        local new_max_hp = self.original_max_hp - hp_difference
        local original_hp_pct = unit:GetHealthPercent()
        
        unit:SetMaxHealth(new_max_hp)
        unit:SetBaseMaxHealth(new_max_hp)
        unit:SetHealth((original_hp_pct/100) * new_max_hp)

        -- abilities
        for i=0, 20 do
            local abil = self:GetParent():GetAbilityByIndex(i)
            if abil ~= nil and abil ~= self:GetAbility() and abil:GetAbilityName() ~= "druid_shapeshift_from_bird_lua" then
                abil:SetActivated(false)
            end
        end

        self:StartIntervalThink( 0.1 )
        self:OnIntervalThink()
        
		--real action
		self:GetParent():SwapAbilities("druid_shapeshift_to_bird_lua", "druid_shapeshift_from_bird_lua", false, true)

        -- Play effects
        EmitSoundOn( "Hero_Medusa.ManaShield.On", self:GetParent() )

		--sfx before bird
		local particle_precast = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_compression.vpcf"
		local effect = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl(effect, 0, self:GetParent():GetOrigin())
        ParticleManager:ReleaseParticleIndex( effect )
        
		--sfx when bird
		EmitSoundOn( "Hero_Antimage.Blink_in", self:GetParent() )
		particle_precast = "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle_end.vpcf"
		effect = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(effect, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
		ParticleManager:ReleaseParticleIndex( effect )
    end
    
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bird_lua:OnRefresh( kv )
	-- references
    self.vision = self:GetAbility():GetSpecialValueFor( "fixed_vision" )
    self.ms_speed = -self:GetAbility():GetSpecialValueFor( "ms_change_constant" )
    self.manacost = self:GetAbility():GetSpecialValueFor("mp_pct_per_second")
    
    
    
    if IsServer() then
        -- check for upgrade 3
        local abil = self:GetParent():FindAbilityByName("druid_upgrade_3")
        if abil then
            if abil:GetLevel() > 0 then
                self.manacost = self.manacost * (1 - (self:GetAbility():GetSpecialValueFor("upgrade_mp_cost_reduce_pct")/100))
            end
        end

        self.hp_reduce_pct = self:GetAbility():GetSpecialValueFor("hp_reduction_pct")
        local unit = self:GetParent()
        local hp_difference = (self.hp_reduce_pct/100) * self.original_max_hp
        local new_max_hp = self.original_max_hp - hp_difference
        local original_hp_pct = unit:GetHealthPercent()
        
        unit:SetMaxHealth(new_max_hp)
        unit:SetBaseMaxHealth(new_max_hp)
        unit:SetHealth((original_hp_pct/100) * new_max_hp)


        self:StartIntervalThink( 0.1 )
        self:OnIntervalThink()
    end
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bird_lua:OnIntervalThink()
    -- vision
    AddFOWViewer( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self.vision, 0.1, false )

    -- mana
    local unit = self:GetParent()
    if unit:GetMana() <= 1.0 then
        local abil = unit:FindAbilityByName("druid_shapeshift_from_bird_lua")
        if not abil:IsInAbilityPhase() then
            unit:CastAbilityNoTarget(abil, unit:GetPlayerOwnerID())
            print("druid turning from bird now")
        end
    else
        unit:ReduceMana(0.1*(unit:GetManaRegen() + (0.01 * self.manacost) * unit:GetMaxMana()))
    end
end

function modifier_druid_shapeshift_bird_lua:OnDestroy()
    if IsServer() then
        -- hp alteration
        local unit = self:GetParent()
        local original_hp_pct = unit:GetHealthPercent()
        unit:SetMaxHealth(self.original_max_hp)
        unit:SetBaseMaxHealth(self.original_max_hp)
        unit:SetHealth((original_hp_pct/100) * self.original_max_hp)

        --real action
        unit:SwapAbilities("druid_shapeshift_from_bird_lua", "druid_shapeshift_to_bird_lua", false, true)

        -- abilities
        for i=0, 20 do
            local abil = self:GetParent():GetAbilityByIndex(i)
            if abil ~= nil and abil ~= self:GetAbility() and abil:GetAbilityName() ~= "druid_shapeshift_to_bird_lua" then
                abil:SetActivated(true)
            end
        end

        -- Play effects
        EmitSoundOn( "Hero_Medusa.ManaShield.Off", unit )

        --sfx before transform
        local particle_precast = "particles/econ/courier/courier_hermit_crab/hermit_crab_skady_ambient_end_flakes.vpcf"
		local effect = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, unit )
		ParticleManager:SetParticleControlEnt(effect, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true)
        ParticleManager:ReleaseParticleIndex( effect )
        
        --sfx after transform
        EmitSoundOn( "Hero_Antimage.Blink_in", unit )
        particle_precast = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_end.vpcf"
        effect = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN, unit )
        ParticleManager:SetParticleControl(effect, 0, unit:GetOrigin())
        ParticleManager:ReleaseParticleIndex( effect )
    end
end


--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bird_lua:GetFixedDayVision()
	return self.vision
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bird_lua:GetFixedNightVision()
	return self.vision
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bird_lua:GetModifierMoveSpeedBonus_Constant()
    return self.ms_speed
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bird_lua:GetModifierModelChange()
	return DRUID_FLYING_3D_MODEL
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bird_lua:GetModifierModelScale()
	return 10
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bird_lua:GetVisualZDelta()
	return 200
end

--------------------------------------------------------------------------------

