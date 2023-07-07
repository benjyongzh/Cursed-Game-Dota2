--------------------------------------------------------------------------------
modifier_mining_lua = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_mining_lua:IsHidden()
	return false
end

function modifier_mining_lua:IsDebuff()
	return false
end

function modifier_mining_lua:IsPurgable()
	return false
end

function modifier_mining_lua:DestroyOnDeath()
	return true
end

function modifier_mining_lua:OnCreated()
	if IsServer() then
        -- references
        self.min_interval = self:GetAbility():GetSpecialValueFor("min_interval")
        self.max_interval = self:GetAbility():GetSpecialValueFor("max_interval")
        self.min_gold = self:GetAbility():GetSpecialValueFor("min_gold")
        self.max_gold = self:GetAbility():GetSpecialValueFor("max_gold")
        self.goldmine = self:GetAbility():GetCursorTarget()
        self:StartIntervalThink(RandomFloat(self.min_interval, self.max_interval))
        -- sfx
        --self.fx = ParticleManager:CreateParticle( "particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_ambient_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        self.fx = ParticleManager:CreateParticle( "particles/econ/events/ti10/bottle_ti10_ring_bokeh.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(self.fx, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
    end
end

function modifier_mining_lua:OnRefresh()
	-- references
	if IsServer() then
        self.min_interval = self:GetAbility():GetSpecialValueFor("min_interval")
        self.max_interval = self:GetAbility():GetSpecialValueFor("max_interval")
        self.min_gold = self:GetAbility():GetSpecialValueFor("min_gold")
        self.max_gold = self:GetAbility():GetSpecialValueFor("max_gold")
        self:StartIntervalThink(RandomFloat(self.min_interval, self.max_interval))
        -- sfx
    end
end

function modifier_mining_lua:OnIntervalThink()
	if not self:GetParent():IsAlive() then return end
	if IsServer() then

		local caster = self:GetParent()
		local hPlayer = caster:GetPlayerOwner()
        local player_ID = caster:GetPlayerOwnerID()
        
        local goldmine = self.goldmine
        local goldmine_modifier = goldmine:FindModifierByName("modifier_goldmine_being_mined")
        if goldmine_modifier then
            local stacks = goldmine_modifier:GetStackCount()

            local gold_value = (RandomInt(self.min_gold, self.max_gold))/stacks

            -- add player's gold
            Resources:ModifyGold( player_ID, gold_value )
            SendOverheadEventMessage(hPlayer, OVERHEAD_ALERT_GOLD, caster, gold_value, hPlayer)
        end
        
        self:StartIntervalThink(RandomFloat(self.min_interval, self.max_interval))

        -- sfx
	end
end

function modifier_mining_lua:OnDestroy()
    if IsServer() then
        -- sfx
        if self.fx then
            ParticleManager:DestroyParticle(self.fx, true)
        end
    end
end