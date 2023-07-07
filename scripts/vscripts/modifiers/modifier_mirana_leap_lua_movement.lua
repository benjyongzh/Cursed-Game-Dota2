modifier_mirana_leap_lua_movement = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mirana_leap_lua_movement:IsHidden()
	return true
end

function modifier_mirana_leap_lua_movement:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_mirana_leap_lua_movement:OnCreated( kv )
	if IsServer() then
		-- Arc movement, with parameters:
		-- - Horizontal distance
		-- - Horizontal speed
		-- - Vertical peak

		-- references
		self.speed = self:GetAbility():GetSpecialValueFor( "leap_speed" ) -- special value
		self.origin = self:GetParent():GetOrigin()
		--self.distance = self:GetAbility():GetSpecialValueFor( "leap_distance" ) -- special value
		self.distance = kv.distance

		-- load data
		self.duration = self.distance/self.speed
		self.hVelocity = self.speed
		--self.direction = self:GetParent():GetForwardVector()
		self.direction = Vector(kv.direction_x, kv.direction_y, kv.direction_z)
		self.peak = 100 --original is 200
		
		-- sync
		self.elapsedTime = 0
		self.motionTick = {}
		self.motionTick[0] = 0
		self.motionTick[1] = 0
		self.motionTick[2] = 0

		-- vertical motion model
		-- self.gravity = -10*1000
		self.gravity = -self.peak/(self.duration*self.duration*0.125)
		self.vVelocity = (-0.5)*self.gravity*self.duration

		-- disable ability
		self:GetAbility():SetActivated( false )

		if self:ApplyVerticalMotionController() == false then 
			self:Destroy()
		end
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end
	end
end

function modifier_mirana_leap_lua_movement:OnRefresh( kv )
	
end

function modifier_mirana_leap_lua_movement:OnDestroy( kv )
	if IsServer() then
		self:GetAbility():SetActivated( true )
		self:GetParent():InterruptMotionControllers( true )

		local caster = self:GetParent()
		-----------------------------------sfx-----------------------------------
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact_dust.vpcf", PATTACH_ABSORIGIN, caster )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		EmitSoundOn( "Hero_EarthShaker.EchoSlamSmall", caster)
		EmitSoundOn( "Tiny.Grow", caster)
        -------------------------------------------------------find enemies in radius
        local enemies = FindUnitsInRadius(
			caster:GetTeam(),
			caster:GetAbsOrigin(),
			nil,
			self:GetAbility():GetSpecialValueFor( "leap_damage_radius" ),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
		for i,unit in pairs(enemies) do
			if not IsBuildingOrSpire(unit) then
        		-- applydamage
				local damageTable = {
					victim = unit,
					attacker = caster,
					damage = self:GetAbility():GetSpecialValueFor( "leap_damage" ),
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = self:GetAbility() --Optional.
				}
				ApplyDamage(damageTable)

				-- sfx
				local nFXIndex = ParticleManager:CreateParticle( "particles/abilities/rupture_burst.vpcf", PATTACH_ABSORIGIN, unit )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				-- apply slow modifier if leap is high level
				if self:GetAbility():GetLevel() > 1 then
					unit:AddNewModifier(
						caster, -- player source
						self:GetAbility(), -- ability source
						"modifier_mirana_leap_lua", -- modifier name
						{duration=self:GetAbility():GetSpecialValueFor( "leap_bonus_duration" )} -- kv  
						)
					-- sfx
					EmitSoundOn( "hero_bloodseeker.rupture.cast", unit)
				end
			end
		end 
		
		-- cutting trees down in AOE
		local trees = GridNav:GetAllTreesAroundPoint( caster:GetAbsOrigin(), self:GetAbility():GetSpecialValueFor( "leap_damage_radius" )/2, true )
		for _,tree in pairs(trees) do
			if tree:IsStanding() then
				tree:CutDown(caster:GetTeam())
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_mirana_leap_lua_movement:SyncTime( iDir, dt )
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

function modifier_mirana_leap_lua_movement:UpdateHorizontalMotion( me, dt )
	self:SyncTime(1, dt)
	local parent = self:GetParent()
	
	-- set position
	local target = self.direction*self.hVelocity*self.elapsedTime

	-- change position
	parent:SetOrigin( self.origin + target )
end

function modifier_mirana_leap_lua_movement:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

function modifier_mirana_leap_lua_movement:UpdateVerticalMotion( me, dt )
	self:SyncTime(2, dt)
	local parent = self:GetParent()

	-- set relative position
	local target = self.vVelocity*self.elapsedTime + 0.5*self.gravity*self.elapsedTime*self.elapsedTime

	-- change height
	parent:SetOrigin( Vector( parent:GetOrigin().x, parent:GetOrigin().y, self.origin.z+target ) )
end

function modifier_mirana_leap_lua_movement:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end