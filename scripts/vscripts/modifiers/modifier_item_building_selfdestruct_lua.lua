modifier_item_building_selfdestruct_lua = class({})

function modifier_item_building_selfdestruct_lua:IsPurgable()
    return false
end

function modifier_item_building_selfdestruct_lua:IsHidden()
	return false
end

function modifier_item_building_selfdestruct_lua:IsDebuff()
	return true
end

function modifier_item_building_selfdestruct_lua:CheckState()
    local state = {
        [MODIFIER_STATE_SILENCED] = true
    }
    return state
end

function modifier_item_building_selfdestruct_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_item_building_selfdestruct_lua:GetTexture()
    return "elder_titan_echo_stomp"
end

function modifier_item_building_selfdestruct_lua:OnCreated()
    
    if IsServer() then
        local building = self:GetParent()
        self.max_time = self:GetAbility():GetSpecialValueFor("channel_duration")
        self.timer = 0
        self.refund_pct = self:GetAbility():GetSpecialValueFor("refund_pct")
        self.min_dmg = self:GetAbility():GetSpecialValueFor("min_dmg")

        -- item for self-destruct and cancel
        local item = building:FindItemInInventory("item_building_selfdestruct_lua")
        if item then
            local data = {caster = self:GetParent(), ability = item}
            swap_to_item(data, "item_building_selfdestruct_cancel_lua")
        end

        self:StartIntervalThink( 0.05 )
        self:OnIntervalThink()
        
        -- sfx
        EmitSoundOn("Hero_Tinker.MechaBoots.Loop", building)
    end
end

function modifier_item_building_selfdestruct_lua:OnRefresh()
    
    if IsServer() then
        self.timer = 0
        self:StartIntervalThink( 0.05 )
        self:OnIntervalThink()
        
        -- sfx
        StopSoundOn("Hero_Tinker.MechaBoots.Loop", self:GetParent())
        EmitSoundOn("Hero_Tinker.MechaBoots.Loop", self:GetParent())
    end
end

function modifier_item_building_selfdestruct_lua:OnDestroy()
    if IsServer() then
        local building = self:GetParent()

        -- item for self-destruct and cancel
        local item = building:FindItemInInventory("item_building_selfdestruct_cancel_lua")
        if item then
            local data = {caster = self:GetParent(), ability = item}
            swap_to_item(data, "item_building_selfdestruct_lua")
        end

        -- sfx
        StopSoundOn("Hero_Tinker.MechaBoots.Loop", building)
    end
end

function modifier_item_building_selfdestruct_lua:OnIntervalThink()
    if not self:GetParent():IsAlive() then return end
    self.timer = self.timer + 0.05
    if self.timer >= self.max_time then
        local building = self:GetParent()
        local playerid = building:GetPlayerOwnerID()

        -- get building's gold and lumber values
        local gold = (building:GetKeyValue("GoldCost") * self.refund_pct)/100
        local lumber = (building:GetKeyValue("LumberCost") * self.refund_pct)/100

        -- refund resources
        Resources:ModifyGold( playerid, gold )
        SendOverheadEventMessage(building:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, building, gold, building:GetPlayerOwner())
        Resources:ModifyLumber( playerid, lumber )
        SendOverheadEventMessage(building:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, building, lumber, building:GetPlayerOwner())

        -- self-destruct
        building:ForceKill(false)

        -- sfx
        StopSoundOn("Hero_Tinker.MechaBoots.Loop", building)
        EmitSoundOn("Hero_Furion.Teleport_Disappear", building)
    end
end

function modifier_item_building_selfdestruct_lua:OnTakeDamage(keys)
    if IsServer() then
		local damage_taken = keys.damage
		local unit = keys.unit
        local min_dmg = self.min_dmg
		if unit == self:GetParent() and unit:IsAlive() and damage_taken >= min_dmg then
			self:ForceRefresh()
		end
	end
end

function modifier_item_building_selfdestruct_lua:OnDeath(kv)
    if IsServer() and self:GetParent() == kv.unit then
        if self then
            self:Destroy()
        end
	end
end


function modifier_item_building_selfdestruct_lua:GetEffectName()
    --return "particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6.vpcf"
    return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner_status.vpcf"
end

function modifier_item_building_selfdestruct_lua:GetEffectAttachType()
    --return PATTACH_ABSORIGIN_FOLLOW
	return PATTACH_OVERHEAD_FOLLOW
end