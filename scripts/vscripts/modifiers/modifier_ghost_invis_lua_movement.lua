modifier_ghost_invis_lua_movement = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ghost_invis_lua_movement:IsHidden()
	return true
end

function modifier_ghost_invis_lua_movement:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ghost_invis_lua_movement:OnCreated( kv )
	if IsServer() then
		-- references
        self.speed = kv.speed -- special value
        self.turnrate = kv.turn_rate
        self.dt = 0.03
        self:StartIntervalThink(self.dt)
	end
end

function modifier_ghost_invis_lua_movement:OnRefresh( kv )
	if IsServer() then
		-- references
        self.speed = kv.speed -- special value
        self.turnrate = kv.turn_rate
        self.dt = 0.03
        self:StartIntervalThink(self.dt)
	end
end

function modifier_ghost_invis_lua_movement:OnDestroy()
end

function modifier_ghost_invis_lua_movement:OnIntervalThink()
	local parent = self:GetParent()
	local current_pos = parent:GetAbsOrigin()
	local direction = self:GetParent():GetForwardVector():Normalized()

	-- set position
	local target = direction*self.speed*self.dt

	-- change position
	parent:SetAbsOrigin( GetGroundPosition((current_pos + target ), nil) )
end

function modifier_ghost_invis_lua_movement:GetModifierTurnRate_Percentage()
	return -self.turnrate
end

function modifier_ghost_invis_lua_movement:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	}

	return funcs
end

function modifier_ghost_invis_lua_movement:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
    }

    return state
end