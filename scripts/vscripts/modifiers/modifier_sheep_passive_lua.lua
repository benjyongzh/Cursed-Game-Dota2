--------------------------------------------------------------------------------
modifier_sheep_passive_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sheep_passive_lua:IsHidden()
	return false
end

function modifier_sheep_passive_lua:IsDebuff()
	return false
end

function modifier_sheep_passive_lua:IsPurgable()
	return false
end

function modifier_sheep_passive_lua:DestroyOnDeath()
	return true
end

function modifier_sheep_passive_lua:OnCreated()
	-- references
	self.time_interval = self:GetAbility():GetSpecialValueFor("time_interval")
	self.gold_interval = self:GetAbility():GetSpecialValueFor("gold_interval")
	self.gold_timer_counter = 0
	self:SetStackCount(1)
	if IsServer() then
        self:StartIntervalThink(self.time_interval)
    end
end

function modifier_sheep_passive_lua:OnRefresh()
	-- references
	self.time_interval = self:GetAbility():GetSpecialValueFor("time_interval")
	self.gold_interval = self:GetAbility():GetSpecialValueFor("gold_interval")
	if IsServer() then
        self:StartIntervalThink(self.time_interval)
    end
end

function modifier_sheep_passive_lua:OnIntervalThink()

	local sheep = self:GetParent()
    local player_id = sheep:GetPlayerOwnerID()
	local mana = self:GetParent():GetMana() 

	local mana_interval = self:GetAbility():GetSpecialValueFor("mana_tier_interval")
	local tier = 1 + (math.floor(mana/mana_interval))
	self.gold_timer_counter = self.gold_timer_counter + self.time_interval
	self:SetStackCount(tier)
    if IsServer() and sheep:IsAlive() then
        if self.gold_timer_counter >= self.gold_interval then
            local base_gold = self:GetAbility():GetSpecialValueFor("base_gold")
            local extra_gold = self:GetAbility():GetSpecialValueFor("gold_per_tier")
            local total_gold = base_gold + (tier * extra_gold)

            Resources:ModifyGold( player_id, total_gold)
            SendOverheadEventMessage(sheep:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, sheep, total_gold, sheep:GetPlayerOwner())

            self.gold_timer_counter = 0
        end
    end
end

