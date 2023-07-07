modifier_druid_shapeshift_bear_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_druid_shapeshift_bear_lua:IsHidden()
	return false
end

function modifier_druid_shapeshift_bear_lua:IsDebuff()
	return false
end

function modifier_druid_shapeshift_bear_lua:IsPurgable()
	return false
end

function modifier_druid_shapeshift_bear_lua:GetTexture()
	return "lone_druid_true_form"
end

function modifier_druid_shapeshift_bear_lua:RemoveOnDeath()
	return true
end
--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bear_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bear_lua:CheckState()
    local state = {
        [MODIFIER_STATE_MUTED] = true,
    }

    return state
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bear_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}

	return funcs
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_druid_shapeshift_bear_lua:OnCreated( kv )
	-- references
    self.atk_dmg = self:GetAbility():GetSpecialValueFor("attack_damage")
    self.atk_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
    self.ms_bonus = self:GetAbility():GetSpecialValueFor("ms_bonus")
    self.manacost = self:GetAbility():GetSpecialValueFor("mp_pct_per_second")

    if IsServer() then
        -- check for upgrade 3
        --[[
        local abil = self:GetParent():FindAbilityByName("druid_upgrade_3")
        if abil then
            if abil:GetLevel() > 0 then
                self.manacost = self.manacost * (1 - (self:GetAbility():GetSpecialValueFor("upgrade_mp_cost_reduce_pct")/100))
            end
        end
        ]]

        for i=0, 20 do
            local abil = self:GetParent():GetAbilityByIndex(i)
            if abil ~= nil and abil ~= self:GetAbility() and abil:GetAbilityName() ~= "druid_shapeshift_from_bear_lua" then
                abil:SetActivated(false)
            end
        end

        self:GetParent():SwapAbilities("druid_shapeshift_to_bear_lua", "druid_shapeshift_from_bear_lua", false, true)
        -- attack capability
        if not self:GetParent().attack_cap then
            self:GetParent().attack_cap = self:GetParent():GetAttackCapability()
        end
        self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
        
        self:StartIntervalThink( 0.1 )
        self:OnIntervalThink()

        -- Play effects
        EmitSoundOn( "Hero_Medusa.ManaShield.On", self:GetParent() )

		--sfx when bear
        EmitSoundOn( "Hero_Antimage.Blink_in", self:GetParent() )
        
		--sfx before bear
		local particle_precast = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_compression.vpcf"
		local effect = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl(effect, 0, self:GetParent():GetOrigin())
		ParticleManager:ReleaseParticleIndex( effect )
    end
    
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bear_lua:OnRefresh( kv )
	-- references
    self.atk_dmg = self:GetAbility():GetSpecialValueFor("attack_damage")
    self.atk_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
    self.ms_bonus = self:GetAbility():GetSpecialValueFor("ms_bonus")
    self.manacost = self:GetAbility():GetSpecialValueFor("mp_pct_per_second")
    
    if IsServer() then
        -- check for upgrade 3
        --[[
        local abil = self:GetParent():FindAbilityByName("druid_upgrade_3")
        if abil then
            if abil:GetLevel() > 0 then
                self.manacost = self.manacost * (1 - (self:GetAbility():GetSpecialValueFor("upgrade_mp_cost_reduce_pct")/100))
            end
        end
        ]]

        self:StartIntervalThink( 0.1 )
        self:OnIntervalThink()
    end
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bear_lua:OnIntervalThink()
    local unit = self:GetParent()
    if unit:GetMana() <= 1.0 then
        local abil = unit:FindAbilityByName("druid_shapeshift_from_bear_lua")
        if not abil:IsInAbilityPhase() then
            unit:CastAbilityNoTarget(abil, unit:GetPlayerOwnerID())
            print("druid turning from bear now")
        end
    else
        unit:ReduceMana(0.1*(unit:GetManaRegen() + (0.01 * self.manacost) * unit:GetMaxMana()))
    end
end

--------------------------------------------------------------------------------
--[[
function modifier_druid_shapeshift_bear_lua:OnRemoved()
    if IsServer() then
        for i=0, 20 do
            local abil = self:GetParent():GetAbilityByIndex(i)
            if abil ~= nil and abil ~= self:GetAbility() and abil:GetAbilityName() ~= "druid_shapeshift_to_bear_lua" then
                abil:SetActivated(true)
            end
        end

        -- Play effects
        local sound_cast = "Hero_Medusa.ManaShield.Off"
        EmitSoundOn( sound_cast, self:GetParent() )
    end
end
]]
--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bear_lua:OnDestroy()
    if IsServer() then
        for i=0, 20 do
            local abil = self:GetParent():GetAbilityByIndex(i)
            if abil ~= nil and abil ~= self:GetAbility() and abil:GetAbilityName() ~= "druid_shapeshift_to_bear_lua" then
                abil:SetActivated(true)
            end
        end
        
        self:GetParent():SwapAbilities("druid_shapeshift_from_bear_lua", "druid_shapeshift_to_bear_lua", false, true)

        -- reset attack capability
        self:GetParent():SetAttackCapability(self:GetParent().attack_cap)

        -- Play effects
        EmitSoundOn( "Hero_Medusa.ManaShield.Off", self:GetParent() )
        
        --sfx after transform
        EmitSoundOn( "Hero_Antimage.Blink_in", self:GetParent() )
        local particle_precast = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_end.vpcf"
        local effect = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl(effect, 0, self:GetParent():GetOrigin())
        ParticleManager:ReleaseParticleIndex( effect )
    end
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bear_lua:GetModifierBaseAttack_BonusDamage()
	return self.atk_dmg
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bear_lua:GetModifierAttackSpeedBonus_Constant()
	return self.atk_speed
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bear_lua:GetModifierMoveSpeedBonus_Constant()
	return self.ms_bonus
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bear_lua:GetModifierModelChange()
	return DRUID_BEAR_3D_MODEL
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bear_lua:GetModifierModelScale()
	return -10
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bear_lua:GetModifierAttackRangeBonus()
	return -350
end

--------------------------------------------------------------------------------

function modifier_druid_shapeshift_bear_lua:GetAttackSound()
	return "Hero_LifeStealer.Attack"
end

--------------------------------------------------------------------------------
-- Modifier Effects
--[[
function modifier_druid_shapeshift_bear_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end


function modifier_druid_shapeshift_bear_lua:GetModifierIncomingDamage_Percentage()
	return absorb
end
]]
