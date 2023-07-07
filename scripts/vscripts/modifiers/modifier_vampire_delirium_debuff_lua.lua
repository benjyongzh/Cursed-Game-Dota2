modifier_vampire_delirium_debuff_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_vampire_delirium_debuff_lua:IsHidden()
	return false
end

function modifier_vampire_delirium_debuff_lua:IsDebuff()
	return true
end

function modifier_vampire_delirium_debuff_lua:IsStunDebuff()
	return false
end

function modifier_vampire_delirium_debuff_lua:IsPurgable()
	return true
end

function modifier_vampire_delirium_debuff_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_vampire_delirium_debuff_lua:GetTexture()
	return "nightstalker_crippling_fear"
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_vampire_delirium_debuff_lua:OnCreated( kv )
    self.vision = self:GetAbility():GetSpecialValueFor("flash_vision_debuff_amount")
end

function modifier_vampire_delirium_debuff_lua:OnRefresh( kv )
    self.vision = self:GetAbility():GetSpecialValueFor("flash_vision_debuff_amount")
end

function modifier_vampire_delirium_debuff_lua:OnRemoved()
end

function modifier_vampire_delirium_debuff_lua:OnDestroy()
end

-------------------------------------------------------------------------------
--[[function modifier_vampire_delirium_debuff_lua:GetModifierMoveSpeedBonus_Percentage()
    return -self.ms_slow
end]]

--[[function modifier_vampire_delirium_debuff_lua:GetModifierMiss_Percentage()
    return self.atk_miss
end]]

function modifier_vampire_delirium_debuff_lua:GetFixedDayVision()
    return self.vision
end

function modifier_vampire_delirium_debuff_lua:GetFixedNightVision()
    return self.vision
end

function modifier_vampire_delirium_debuff_lua:DeclareFunctions()
	local funcs = {
        --MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        --MODIFIER_PROPERTY_MISS_PERCENTAGE,
        MODIFIER_PROPERTY_FIXED_DAY_VISION,
        MODIFIER_PROPERTY_FIXED_NIGHT_VISION
	}

	return funcs
end

--------------------------------------------------------------------------------
-- Graphics & Animations


function modifier_vampire_delirium_debuff_lua:GetEffectName()
	return "particles/units/heroes/hero_abaddon/abaddon_curse_counter_debuff.vpcf"
end

function modifier_vampire_delirium_debuff_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

