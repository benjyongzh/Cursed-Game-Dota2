modifier_vampire_bloodrage_lua = class({})
--------------------------------------------------------------------------------

function modifier_vampire_bloodrage_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_vampire_bloodrage_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_vampire_bloodrage_lua:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_vampire_bloodrage_lua:OnCreated( kv )
	if IsServer() then
		self:SetStackCount( kv.stack )
		--self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_bloodrage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		--ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
		--self:AddParticle( self.nFXIndex, false, false, -1, false, false )
		self.bloodrage_heal = self:GetAbility():GetSpecialValueFor("heal_per_stack")
		local hParent = self:GetParent()
    	local hp_heal = self.bloodrage_heal * self:GetStackCount()
		hParent:Heal(hp_heal, hParent)
	end
	
	self.bloodrage_attack_speed_bonus = self:GetAbility():GetSpecialValueFor("as_bonus_per_stack")
	self.bloodrage_move_speed_bonus =  self:GetAbility():GetSpecialValueFor("ms_bonus_per_stack")
end

--------------------------------------------------------------------------------

function modifier_vampire_bloodrage_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_vampire_bloodrage_lua:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetStackCount() * self.bloodrage_move_speed_bonus
end

--------------------------------------------------------------------------------

function modifier_vampire_bloodrage_lua:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetStackCount() * self.bloodrage_attack_speed_bonus
end

--------------------------------------------------------------------------------
--Graphics & Animations
function modifier_vampire_bloodrage_lua:GetEffectName()
	return "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff.vpcf"
end

function modifier_vampire_bloodrage_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
