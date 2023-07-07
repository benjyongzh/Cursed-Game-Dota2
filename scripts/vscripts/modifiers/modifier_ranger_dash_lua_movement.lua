modifier_ranger_dash_lua_movement = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ranger_dash_lua_movement:IsHidden()
	return false
end

function modifier_ranger_dash_lua_movement:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ranger_dash_lua_movement:OnCreated( kv )
	if IsServer() then
		-- Arc movement, with parameters:
		-- - Horizontal distance
		-- - Horizontal speed
		-- - Vertical peak

		-- references
		self.origin = self:GetParent():GetOrigin()
		local target_point = self:GetAbility():GetCursorPosition()
		local vector = Vector((target_point.x - self.origin.x), (target_point.y - self.origin.y), 0.0)
		self.distance = math.sqrt(vector.x * vector.x + vector.y * vector.y)
		if self.distance > self:GetAbility():GetSpecialValueFor( "max_range" ) then
			self.distance = self:GetAbility():GetSpecialValueFor( "max_range" )
		end
		self.direction = vector:Normalized()
		self.speed = self:GetAbility():GetSpecialValueFor( "dash_speed" ) -- special value

		-- load data
		self.duration = self.distance/self.speed
		self.hVelocity = self.speed
		
		
		-- sync
		self.elapsedTime = 0
		self.motionTick = {}
		self.motionTick[0] = 0
		self.motionTick[1] = 0

		-- vertical motion model
		-- self.gravity = -10*1000
		--self.gravity = -self.peak/(self.duration*self.duration*0.125)
		--self.vVelocity = (-0.5)*self.gravity*self.duration

		-- disable ability
		self:GetAbility():SetActivated( false )

		--[[
		if self:ApplyVerticalMotionController() == false then 
			self:Destroy()
		end
		]]
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end
	end
end

function modifier_ranger_dash_lua_movement:OnRefresh( kv )
	
end

function modifier_ranger_dash_lua_movement:OnDestroy( kv )
	if IsServer() then
		self:GetAbility():SetActivated( true )
		self:GetParent():InterruptMotionControllers( true )

		local caster = self:GetParent()
		-----------------------------------sfx-----------------------------------
		--local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact_dust.vpcf", PATTACH_ABSORIGIN, caster )
		--ParticleManager:ReleaseParticleIndex( nFXIndex )
		--EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", caster)
		--EmitSoundOn( "Tiny.Grow", caster)
	end
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_ranger_dash_lua_movement:SyncTime( iDir, dt )
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

function modifier_ranger_dash_lua_movement:UpdateHorizontalMotion( me, dt )
	self:SyncTime(1, dt)
	local parent = self:GetParent()
	
	-- set position
	local target = self.direction*self.hVelocity*self.elapsedTime

	-- change position
	parent:SetOrigin( self.origin + target )
end

function modifier_ranger_dash_lua_movement:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end