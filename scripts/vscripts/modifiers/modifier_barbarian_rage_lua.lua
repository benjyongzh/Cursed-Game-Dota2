modifier_barbarian_rage_lua = class({})
--------------------------------------------------------------------------------

function modifier_barbarian_rage_lua:IsHidden()
	return ( self:GetStackCount() == 0 )
end

--------------------------------------------------------------------------------

function modifier_barbarian_rage_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_barbarian_rage_lua:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_barbarian_rage_lua:OnCreated( kv )
	self.fiery_soul_attack_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
	self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	self.fiery_soul_max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	self.duration_tooltip = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )
	self.damage = self:GetAbility():GetSpecialValueFor( "own_damage_per_stack" )

	-- check for upgrade
	if IsServer() then
		local unit = self:GetParent()
		local abil = unit:FindAbilityByName("barbarian_upgrade_1")
		if abil then
			if abil:GetLevel() > 0 then
				self.damage = self.damage - self:GetAbility():GetSpecialValueFor( "upgrade_self_dmg_reduce" )
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_barbarian_rage_lua:OnRefresh( kv )
	self.fiery_soul_attack_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
	self.fiery_soul_move_speed_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
	self.fiery_soul_max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
	self.duration_tooltip = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )
	self.damage = self:GetAbility():GetSpecialValueFor( "own_damage_per_stack" )

	-- check for upgrade
	if IsServer() then
		local unit = self:GetParent()
		local abil = unit:FindAbilityByName("barbarian_upgrade_1")
		if abil then
			if abil:GetLevel() > 0 then
				self.damage = self.damage - self:GetAbility():GetSpecialValueFor( "upgrade_self_dmg_reduce" )
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_barbarian_rage_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_barbarian_rage_lua:OnIntervalThink()
	if IsServer() then
		self:StartIntervalThink( -1 )
		self:SetStackCount( 0 )
	end
end

--------------------------------------------------------------------------------

function modifier_barbarian_rage_lua:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetStackCount() * self.fiery_soul_move_speed_bonus
end

--------------------------------------------------------------------------------

function modifier_barbarian_rage_lua:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetStackCount() * self.fiery_soul_attack_speed_bonus
end

--------------------------------------------------------------------------------

function modifier_barbarian_rage_lua:OnAttackLanded( params )

	if IsServer() then
		if params.attacker==self:GetParent() then
			if self:GetStackCount() < self.fiery_soul_max_stacks then
				self:IncrementStackCount()
			else
				self:SetStackCount( self:GetStackCount() )
				self:ForceRefresh()
			end
			self:SetDuration( self.duration_tooltip, true )
			self:StartIntervalThink( self.duration_tooltip )
			local damageTable = {
				victim = self:GetParent(),
				attacker = self:GetParent(),
				damage = self:GetStackCount() * self.damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = self:GetAbility(), --Optional.
			}
			
			ApplyDamage(damageTable)
		end
	end

	return 0
end
--------------------------------------------------------------------------------