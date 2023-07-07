modifier_zombie_main_passive_lua_aura = class({})

--------------------------------------------------------------------------------

function modifier_zombie_main_passive_lua_aura:IsDebuff()
	return false
end

function modifier_zombie_main_passive_lua_aura:Ishidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_zombie_main_passive_lua_aura:OnCreated( kv )
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_atk_dmg_pct" )
end

--------------------------------------------------------------------------------

function modifier_zombie_main_passive_lua_aura:OnRefresh( kv )
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_atk_dmg_pct" )
end

--------------------------------------------------------------------------------

function modifier_zombie_main_passive_lua_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_zombie_main_passive_lua_aura:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_damage_pct
end