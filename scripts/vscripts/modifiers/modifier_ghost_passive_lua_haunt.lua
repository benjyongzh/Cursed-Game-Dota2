modifier_ghost_passive_lua_haunt = class({})

function modifier_ghost_passive_lua_haunt:IsDebuff() return true end

function modifier_ghost_passive_lua_haunt:IsHidden() return false end

function modifier_ghost_passive_lua_haunt:IsPurgable() return false end

function modifier_ghost_passive_lua_haunt:IsPurgeException() return false end

function modifier_ghost_passive_lua_haunt:IsStunDebuff() return false end

function modifier_ghost_passive_lua_haunt:RemoveOnDeath() return true end

---------------------------------------------------------------------------------------------------------------------------------

function modifier_ghost_passive_lua_haunt:OnCreated()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:Destroy() return end

    local ability = self:GetAbility()
    self.interval = ability:GetSpecialValueFor("interval")
    self.ms_reduce_pct = ability:GetSpecialValueFor("ms_reduction_pct")
	self.turnrate = ability:GetSpecialValueFor("turn_rate")
	--self.propertyscalefactor = 0
	--if IsServer() then
	--	self:StartIntervalThink( self.interval )
	--end
end

function modifier_ghost_passive_lua_haunt:OnRefresh()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:Destroy() return end

    local ability = self:GetAbility()
    self.interval = ability:GetSpecialValueFor("interval")
    self.ms_reduce_pct = ability:GetSpecialValueFor("ms_reduction_pct")
	self.turnrate = ability:GetSpecialValueFor("turn_rate")
	--self.propertyscalefactor = 0
	
	--if IsServer() then
	--	self:StartIntervalThink( self.interval )
	--end
end

---------------------------------------------------------------------------------------------------------------------------------

--[[
function modifier_ghost_passive_lua_haunt:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:Destroy() return end
    if not self:GetParent():IsAlive() then return end
	local hParent = self:GetParent()
	local ghost = self:GetCaster()
	if ghost:HasModifier("modifier_ghost_invis_lua") then
		self.propertyscalefactor = 0
	else
		self.propertyscalefactor = 1
	end
end
]]

---------------------------------------------------------------------------------------------------------------------------------

-- Modifier Effects
function modifier_ghost_passive_lua_haunt:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	}

	return funcs
end

function modifier_ghost_passive_lua_haunt:GetModifierMoveSpeedBonus_Percentage()
	return -self.ms_reduce_pct --* self.propertyscalefactor
end

function modifier_ghost_passive_lua_haunt:GetModifierTurnRate_Percentage()
	return -self.turnrate --* self.propertyscalefactor
end

function modifier_ghost_passive_lua_haunt:GetStatusEffectName()
	return "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf"
end