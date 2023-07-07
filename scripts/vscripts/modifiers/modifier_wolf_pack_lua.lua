modifier_wolf_pack_lua = class({})

function modifier_wolf_pack_lua:IsHidden()
	return false
end

function modifier_wolf_pack_lua:IsDebuff()
	return false
end

function modifier_wolf_pack_lua:IsPurgable()
	return false
end

function modifier_wolf_pack_lua:GetTexture()
	return "lycan_shapeshift"
end

--------------------------------------------------------------------------------

function modifier_wolf_pack_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_wolf_pack_lua:OnCreated()
	self.atk_pct = 40
end

function modifier_wolf_pack_lua:OnRefresh()
	self.atk_pct = 40
end

function  modifier_wolf_pack_lua:GetModifierBaseDamageOutgoing_Percentage()
    return self.atk_pct
end