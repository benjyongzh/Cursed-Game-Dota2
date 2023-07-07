modifier_campfire_passive_lua = class({})

function modifier_campfire_passive_lua:OnCreated()
	if IsServer() and self:GetAbility():IsTrained() then
		local ability = self:GetAbility()
		self.interval = ability:GetSpecialValueFor("regen_interval")
        self.lumbercost = ability:GetSpecialValueFor("lumber_cost")
        self.lumberinterval = ability:GetSpecialValueFor("lumber_interval")
        self.lumberintervalcounter = self.lumberinterval/self.interval
        self.radius = ability:GetSpecialValueFor("radius")
        
        self:StartIntervalThink( self.interval )
        
		self.mainParticle = ParticleManager:CreateParticle("particles/battlepass/healing_campfire_flame.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.mainParticle, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true)
	end
end

function modifier_campfire_passive_lua:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
		if self.mainParticle then
			ParticleManager:DestroyParticle(self.mainParticle, false)
			ParticleManager:ReleaseParticleIndex(self.mainParticle)
		end
	end
end

function modifier_campfire_passive_lua:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:Destroy() return end

	local hAbility = self:GetAbility()
    if not self:GetCaster():IsAlive() then return end

    self.lumberintervalcounter = self.lumberintervalcounter + 1
    if self.lumberintervalcounter >= self.lumberinterval/self.interval then
        local playerid = self:GetCaster():GetPlayerOwnerID()
        if Resources:HasEnoughLumber(playerid , 1 ) and GetFarmer(playerid):IsAlive() then
            Resources:ModifyLumber( playerid, -1 )
        else
            hAbility:ToggleAbility()
        end
        self.lumberintervalcounter = 0
    end
end

function modifier_campfire_passive_lua:IsAura()
	return true
end

function modifier_campfire_passive_lua:IsAuraActiveOnDeath()
	return false
end

function modifier_campfire_passive_lua:GetAuraRadius()
	return self.radius
end

function modifier_campfire_passive_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_campfire_passive_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_campfire_passive_lua:GetAuraEntityReject( hEntity )
	if IsServer() then
		if IsBuildingOrSpire(hEntity) then
			return true
		else
			return false
		end
	end
end

function modifier_campfire_passive_lua:GetModifierAura()
	return "modifier_campfire_passive_lua_heal"
end

function modifier_campfire_passive_lua:IsHidden()
	return true
end