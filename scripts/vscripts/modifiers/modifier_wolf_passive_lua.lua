modifier_wolf_passive_lua = class({})

function modifier_wolf_passive_lua:IsHidden()
	return true
end

function modifier_wolf_passive_lua:IsDebuff()
	return false
end

function modifier_wolf_passive_lua:IsPurgable()
	return false
end

function modifier_wolf_passive_lua:CheckState()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
    return state
end

--------------------------------------------------------------------------------

function modifier_wolf_passive_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_wolf_passive_lua:OnCreated()
	self.night_ms = self:GetAbility():GetSpecialValueFor("night_ms")
	self.day_ms = self:GetParent():GetBaseMoveSpeed()
	self.ms_to_use = self.day_ms
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_wolf_passive_lua:OnIntervalThink()
	if IsServer() then
		if not GameRules:IsDaytime() then
			self.ms_to_use = self.night_ms
		else
			self.ms_to_use = self.day_ms
		end
	end
end

function  modifier_wolf_passive_lua:GetModifierMoveSpeedOverride()
    return self.ms_to_use
end