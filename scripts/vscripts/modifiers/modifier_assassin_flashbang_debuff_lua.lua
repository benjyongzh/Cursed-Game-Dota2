modifier_assassin_flashbang_debuff_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_assassin_flashbang_debuff_lua:IsHidden()
	return false
end

function modifier_assassin_flashbang_debuff_lua:IsDebuff()
	return true
end

function modifier_assassin_flashbang_debuff_lua:IsStunDebuff()
	return false
end

function modifier_assassin_flashbang_debuff_lua:IsPurgable()
	return true
end

function modifier_assassin_flashbang_debuff_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_assassin_flashbang_debuff_lua:GetTexture()
	return "keeper_of_the_light_blinding_light"
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_assassin_flashbang_debuff_lua:OnCreated( kv )
    self.ms_slow = self:GetAbility():GetSpecialValueFor("flash_ms_slow_pct")
    self.atk_miss = self:GetAbility():GetSpecialValueFor("flash_attack_miss_pct")
    self.vision = self:GetAbility():GetSpecialValueFor("flash_vision_debuff_amount")
    if IsServer() then
        --sfx
        --[[
        local particle_precast = "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf"
		local effect = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(effect, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
        ParticleManager:ReleaseParticleIndex( effect )
        ]]
    end
end

function modifier_assassin_flashbang_debuff_lua:OnRefresh( kv )
    self.ms_slow = self:GetAbility():GetSpecialValueFor("flash_ms_slow_pct")
    self.atk_miss = self:GetAbility():GetSpecialValueFor("flash_attack_miss_pct")
    self.vision = self:GetAbility():GetSpecialValueFor("flash_vision_debuff_amount")
end

function modifier_assassin_flashbang_debuff_lua:OnRemoved()
end

function modifier_assassin_flashbang_debuff_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_assassin_flashbang_debuff_lua:CheckState()
	local state = {
		--[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

-------------------------------------------------------------------------------
function modifier_assassin_flashbang_debuff_lua:GetModifierMoveSpeedBonus_Percentage()
    return -self.ms_slow
end

function modifier_assassin_flashbang_debuff_lua:GetModifierMiss_Percentage()
    return self.atk_miss
end

function modifier_assassin_flashbang_debuff_lua:GetFixedDayVision()
    return self.vision
end

function modifier_assassin_flashbang_debuff_lua:GetFixedNightVision()
    return self.vision
end

function modifier_assassin_flashbang_debuff_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_MISS_PERCENTAGE,
        MODIFIER_PROPERTY_FIXED_DAY_VISION,
        MODIFIER_PROPERTY_FIXED_NIGHT_VISION
	}

	return funcs
end

--------------------------------------------------------------------------------
-- Graphics & Animations


function modifier_assassin_flashbang_debuff_lua:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf"
end

function modifier_assassin_flashbang_debuff_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
