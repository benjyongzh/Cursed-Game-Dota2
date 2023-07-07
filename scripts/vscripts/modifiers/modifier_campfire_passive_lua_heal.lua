modifier_campfire_passive_lua_heal = class({})

function modifier_campfire_passive_lua_heal:IsDebuff() return false end

function modifier_campfire_passive_lua_heal:IsHidden() return false end

function modifier_campfire_passive_lua_heal:IsPurgable() return false end

function modifier_campfire_passive_lua_heal:IsPurgeException() return false end

function modifier_campfire_passive_lua_heal:IsStunDebuff() return false end

function modifier_campfire_passive_lua_heal:RemoveOnDeath() return true end

-- function modifier_campfire_passive_lua_heal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end -- Why was this made to stack

-------------------------------------------

function modifier_campfire_passive_lua_heal:OnCreated()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:Destroy() return end

	self.hp_regen = self:GetAbility():GetSpecialValueFor("hp_regen")
	self.mp_regen = self:GetAbility():GetSpecialValueFor("mp_regen")
	
	if IsServer() then
		self.interval = self:GetAbility():GetSpecialValueFor("regen_interval")
		self:StartIntervalThink( self.interval )
	end
end

function modifier_campfire_passive_lua_heal:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:Destroy() return end

	local hParent = self:GetParent()
    local hp_heal = self.hp_regen * self.interval
	local mp_heal = self.mp_regen * self.interval

	hParent:Heal(hp_heal, self:GetCaster())
	hParent:GiveMana(mp_heal)
	SendOverheadEventMessage(hParent, OVERHEAD_ALERT_HEAL, hParent, hp_heal, hParent)
end