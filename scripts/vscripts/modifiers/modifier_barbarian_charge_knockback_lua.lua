modifier_barbarian_charge_knockback_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_barbarian_charge_knockback_lua:IsHidden()
	return true
end

function modifier_barbarian_charge_knockback_lua:IsDebuff()
	return true
end

function modifier_barbarian_charge_knockback_lua:IsPurgable()
	return false
end

function modifier_barbarian_charge_knockback_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_barbarian_charge_knockback_lua:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_barbarian_charge_knockback_lua:OnCreated( kv )
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
        
		-- vertical motion model
		self.peak = 180 --original is 200
		self.gravity = -self.peak/(self.duration*self.duration*0.125)
		self.vVelocity = (-0.5)*self.gravity*self.duration
		
		
		-- sync
		self.elapsedTime = 0
		self.motionTick = {}
		self.motionTick[0] = 0
		self.motionTick[1] = 0
		self.motionTick[2] = 0

		if self:ApplyVerticalMotionController() == false then 
			self:Destroy()
		end
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end

		self:GetParent():Interrupt()
	end
end

function modifier_barbarian_charge_knockback_lua:OnRefresh( kv )
	
end

function modifier_barbarian_charge_knockback_lua:OnDestroy( kv )
	if IsServer() then
		self:GetParent():InterruptMotionControllers( true )
	end
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_barbarian_charge_knockback_lua:SyncTime( iDir, dt )
	-- check if already synced
	if self.motionTick[1]==self.motionTick[2] then
		self.motionTick[0] = self.motionTick[0] + 1
		self.elapsedTime = self.elapsedTime + dt
	end

	-- sync time
	self.motionTick[iDir] = self.motionTick[0]
	
	-- end motion
	if self.elapsedTime > self.duration and self.motionTick[1]==self.motionTick[2] then
		self:Destroy()
	end
end

function modifier_barbarian_charge_knockback_lua:UpdateHorizontalMotion( me, dt )
	self:SyncTime(1, dt)
	local parent = self:GetParent()
	
	-- set position
	local target = self.direction*self.hVelocity*self.elapsedTime

	-- change position
    parent:SetOrigin( self.origin + target )
    
    -- cutting trees down in AOE
    local trees = GridNav:GetAllTreesAroundPoint( parent:GetAbsOrigin(), 80, true )
    for _,tree in pairs(trees) do
        if tree:IsStanding() then
            tree:CutDown(parent:GetTeam())
        end
    end
end

function modifier_barbarian_charge_knockback_lua:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

function modifier_barbarian_charge_knockback_lua:UpdateVerticalMotion( me, dt )
	self:SyncTime(2, dt)
	local parent = self:GetParent()

	-- set relative position
	local target = self.vVelocity*self.elapsedTime + 0.5*self.gravity*self.elapsedTime*self.elapsedTime

	-- change height
	parent:SetOrigin( Vector( parent:GetOrigin().x, parent:GetOrigin().y, self.origin.z+target ) )
end

function modifier_barbarian_charge_knockback_lua:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end