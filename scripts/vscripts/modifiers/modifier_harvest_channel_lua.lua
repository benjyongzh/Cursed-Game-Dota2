modifier_harvest_channel_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_harvest_channel_lua:IsHidden()
	return false
end

function modifier_harvest_channel_lua:IsDebuff()
	return false
end

function modifier_harvest_channel_lua:IsStunDebuff()
	return false
end

function modifier_harvest_channel_lua:IsPurgable()
	return false
end

function modifier_harvest_channel_lua:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_harvest_channel_lua:OnCreated( kv )
    -- references
    self.interval_duration = self:GetAbility():GetSpecialValueFor("interval")
    self.intervals_per_stack = self:GetAbility():GetSpecialValueFor("intervals_per_stack")
    self.lumber_per_stack = self:GetAbility():GetSpecialValueFor("lumber_per_stack")
    self.max_stack = self:GetAbility():GetSpecialValueFor("max_stack")
    self.interval_count = -1

	if IsServer() then
        self:StartIntervalThink( self.interval_duration )
        self:OnIntervalThink()
    end
end

function modifier_harvest_channel_lua:OnRefresh( kv )
	-- references
    self.interval_duration = self:GetAbility():GetSpecialValueFor("interval")
    self.intervals_per_stack = self:GetAbility():GetSpecialValueFor("intervals_per_stack")
    self.lumber_per_stack = self:GetAbility():GetSpecialValueFor("lumber_per_stack")
    self.max_stack = self:GetAbility():GetSpecialValueFor("max_stack")
    self.interval_count = -1

	if IsServer() then
        self:StartIntervalThink( self.interval_duration )
        self:OnIntervalThink()
    end
end

------------------------------------------------------
-- Interval Effects
function modifier_harvest_channel_lua:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()
        local lumber_stack_modifier = caster:FindModifierByName("modifier_lumber_stacks_lua")
        if lumber_stack_modifier:GetStackCount() < self.max_stack then
            
            caster:StartGesture(ACT_DOTA_ATTACK)
            self.interval_count = self.interval_count + 1

            if math.floor((self.interval_count)/self.intervals_per_stack) > 0 then
                lumber_stack_modifier:IncrementStackCount()
                self.interval_count = 0
            end

            if lumber_stack_modifier:GetStackCount() ~= 0 then
                if lumber_stack_modifier:GetStackCount() >= self.max_stack then
                    caster:RemoveGesture(ACT_DOTA_ATTACK)
                    caster:Interrupt()
                    caster:CastAbilityImmediately(caster:FindAbilityByName("return_lumber_lua"), caster:GetPlayerOwnerID())
                end
            end
        else
            caster:RemoveGesture(ACT_DOTA_ATTACK)
            caster:Interrupt()
            caster:CastAbilityImmediately(caster:FindAbilityByName("return_lumber_lua"), caster:GetPlayerOwnerID())
        end
    end
end
