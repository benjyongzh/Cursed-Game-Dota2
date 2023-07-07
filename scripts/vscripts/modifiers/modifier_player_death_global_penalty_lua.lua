modifier_player_death_global_penalty_lua = class({})

function modifier_player_death_global_penalty_lua:IsDebuff() return true end

function modifier_player_death_global_penalty_lua:IsHidden() return false end

function modifier_player_death_global_penalty_lua:IsPurgable() return false end

function modifier_player_death_global_penalty_lua:IsPurgeException() return false end

function modifier_player_death_global_penalty_lua:IsStunDebuff() return false end

function modifier_player_death_global_penalty_lua:RemoveOnDeath() return true end

--------------------------------------------------------------------------------

function modifier_player_death_global_penalty_lua:GetTexture()
	return "nevermore_dark_lord"
end

function modifier_player_death_global_penalty_lua:OnCreated( kv )
	-- references
	if IsServer() then
		self:SetStackCount(self:GetAbility():GetLevel())
	end
	self.armor_penalty = self:GetStackCount() * (-2)
end

function modifier_player_death_global_penalty_lua:OnRefresh( kv )
	-- references
	if IsServer() then
		self:SetStackCount(self:GetAbility():GetLevel())
	end
	self.armor_penalty = self:GetStackCount() * (-2)
end

--------------------------------------------------------------------------------

function modifier_player_death_global_penalty_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_player_death_global_penalty_lua:GetModifierPhysicalArmorBonus()
	return self.armor_penalty
end