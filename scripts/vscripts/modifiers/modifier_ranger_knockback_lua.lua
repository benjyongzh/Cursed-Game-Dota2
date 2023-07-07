modifier_ranger_knockback_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ranger_knockback_lua:IsHidden()
	return false
end

function modifier_ranger_knockback_lua:IsDebuff()
	return true
end

function modifier_ranger_knockback_lua:IsPurgable()
	return false
end

function modifier_ranger_knockback_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_ranger_knockback_lua:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ranger_knockback_lua:OnCreated( kv )
	if IsServer() then
		-- Arc movement, with parameters:
		-- - Horizontal distance
		-- - Horizontal speed
		-- - Vertical peak

        -- references
        self.origin = self:GetParent():GetOrigin()
		self.distance = kv.distance
		self.direction = Vector(kv.direction_x, kv.direction_y, 0 )
		self.speed = kv.speed

		-- load data
		self.duration = self.distance/self.speed
		self.hVelocity = self.speed
		
		
		-- sync
		self.elapsedTime = 0
		self.motionTick = {}
		self.motionTick[0] = 0
		self.motionTick[1] = 0

		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end

		self:GetParent():Interrupt()
	end
end

function modifier_ranger_knockback_lua:OnRefresh( kv )
	
end

function modifier_ranger_knockback_lua:OnDestroy( kv )
	if IsServer() then
		self:GetAbility():SetActivated( true )
		self:GetParent():InterruptMotionControllers( true )
	end
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_ranger_knockback_lua:SyncTime( iDir, dt )
	-- check if already synced
	self.motionTick[0] = self.motionTick[0] + 1
	self.elapsedTime = self.elapsedTime + dt

	-- sync time
	self.motionTick[iDir] = self.motionTick[0]
	
	-- end motion
	if self.elapsedTime > self.duration then
		self:Destroy()
	end
end

function modifier_ranger_knockback_lua:UpdateHorizontalMotion( me, dt )
	self:SyncTime(1, dt)
	local parent = self:GetParent()
	
	-- set position
	local target = self.direction*self.hVelocity*self.elapsedTime

	-- change position
    parent:SetOrigin( self.origin + target )
    
    -- stop moving if hit tree
    local trees = GridNav:GetAllTreesAroundPoint( parent:GetAbsOrigin(), 90, false )
    for _,tree in pairs(trees) do
        if tree:IsStanding() then
            self:Destroy()
        end
    end
end

function modifier_ranger_knockback_lua:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end