modifier_zombie_pounce_lua_charging = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_pounce_lua_charging:IsHidden()
	return false
end

function modifier_zombie_pounce_lua_charging:IsDebuff()
	return false
end

function modifier_zombie_pounce_lua_charging:IsPurgable()
	return false
end

function modifier_zombie_pounce_lua_charging:DestroyOnExpire()
	return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_zombie_pounce_lua_charging:OnCreated( kv )
    if IsServer() then
        self:SetStackCount(0)
        self.interval = 0.03
		self:StartIntervalThink(self.interval)
        self:OnIntervalThink()

        -- sfx
        EmitSoundOn("life_stealer_lifest_anger_01", self:GetParent())
	end
end

function modifier_zombie_pounce_lua_charging:OnDestroy( kv )
    if IsServer() then
        --world panel
    --    if self.worldpanel then
    --        self.worldpanel:Delete()
    --    end
        StopSoundOn("life_stealer_lifest_anger_01", self:GetParent())
	end
end

function modifier_zombie_pounce_lua_charging:OnIntervalThink()
    if self:GetStackCount() >= 100 then
        self:SetStackCount(100)
    else
        self:SetStackCount(self:GetStackCount() + ( (self.interval/self:GetAbility():GetSpecialValueFor("max_charging_time")) * 100 ) )
    end
end


function modifier_zombie_pounce_lua_charging:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_MUTED] = true,
    }

    return state
end

--------------------------------------------------------------------------------

function modifier_zombie_pounce_lua_charging:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_zombie_pounce_lua_charging:GetModifierMoveSpeedBonus_Percentage()
    return -self:GetAbility():GetSpecialValueFor("ms_slow_pct")
end