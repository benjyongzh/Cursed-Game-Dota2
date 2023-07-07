modifier_spire_lua_heal = class({})

function modifier_spire_lua_heal:IsDebuff() return false end

function modifier_spire_lua_heal:IsHidden() return false end

function modifier_spire_lua_heal:IsPurgable() return false end

function modifier_spire_lua_heal:IsPurgeException() return false end

function modifier_spire_lua_heal:IsStunDebuff() return false end

function modifier_spire_lua_heal:RemoveOnDeath() return true end

-- function modifier_spire_lua_heal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end -- Why was this made to stack

-------------------------------------------

function modifier_spire_lua_heal:OnCreated()
	self.hp_regen = 20
	self.mp_regen = 20
	
	if IsServer() then
		self.interval = 0.2
		self:StartIntervalThink( self.interval )
	end
end

function modifier_spire_lua_heal:OnIntervalThink()
	local hParent = self:GetParent()
    local hp_heal = self.hp_regen * self.interval
	local mp_heal = self.mp_regen * self.interval

	hParent:Heal(hp_heal, self:GetCaster())
	hParent:GiveMana(mp_heal)
	--SendOverheadEventMessage(hParent, OVERHEAD_ALERT_HEAL, hParent, hp_heal, hParent)
end

function modifier_spire_lua_heal:GetTexture()
	return "pugna_life_drain"
end