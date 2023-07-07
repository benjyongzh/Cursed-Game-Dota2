modifier_barbarian_charge_knocked_lua = class({})

--------------------------------------------------------------------------------

-- Classifications
function modifier_barbarian_charge_knocked_lua:IsHidden()
	return false
end

function modifier_barbarian_charge_knocked_lua:IsDebuff()
	return true
end

function modifier_barbarian_charge_knocked_lua:IsPurgable()
	return false
end

function modifier_barbarian_charge_knocked_lua:OnCreated( kv )
	-- references
	if IsServer() then
		self.ms_slow = -kv.slow
	end
end

function modifier_barbarian_charge_knocked_lua:OnRefresh( kv )
	-- references
	if IsServer() then
		self.ms_slow = -kv.slow
	end
end	

-- Modifier Effects
function modifier_barbarian_charge_knocked_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_barbarian_charge_knocked_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_barbarian_charge_knocked_lua:GetEffectName()
	return "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_stunned_symbol.vpcf"
end

function modifier_barbarian_charge_knocked_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end