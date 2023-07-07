modifier_vampire_illusion_buff_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_vampire_illusion_buff_lua:IsHidden()
	return false
end

function modifier_vampire_illusion_buff_lua:IsDebuff()
	return false
end

function modifier_vampire_illusion_buff_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_vampire_illusion_buff_lua:OnCreated( kv )
	-- references
	self.speed = kv.speed
end

function modifier_vampire_illusion_buff_lua:OnRefresh( kv )
	
end

function modifier_vampire_illusion_buff_lua:OnDestroy( kv )
	if IsServer() then
		self:GetParent():ForceKill( false )
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_vampire_illusion_buff_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY,

	}

	return funcs
end

function modifier_vampire_illusion_buff_lua:GetModifierMoveSpeed_Absolute()
	return self.speed
end