modifier_zombie_pounce_lua_movement = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_pounce_lua_movement:IsHidden()
	return true
end

function modifier_zombie_pounce_lua_movement:IsPurgable()
	return false
end

function modifier_zombie_pounce_lua_movement:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

--[[
function modifier_zombie_pounce_lua_movement:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}

	return funcs
end

function modifier_zombie_pounce_lua_movement:GetModifierDisableTurning()
	return true
end
]]

--------------------------------------------------------------------------------
-- Initializations
function modifier_zombie_pounce_lua_movement:OnCreated( kv )
	if IsServer() then
		-- Arc movement, with parameters:
		-- - Horizontal distance
		-- - Horizontal speed
		-- - Vertical peak

		-- references
		self.speed = self:GetAbility():GetSpecialValueFor( "leap_speed" ) -- special value
		self.origin = self:GetParent():GetOrigin()
        self.distance = kv.distance
        self.fraction = kv.fraction

        self.damage = self.fraction * ( self:GetAbility():GetSpecialValueFor( "max_damage" ) - self:GetAbility():GetSpecialValueFor( "min_damage" ) ) + self:GetAbility():GetSpecialValueFor( "min_damage" )

		-- load data
		self.duration = self.distance/self.speed
		self.hVelocity = self.speed
		self.direction = Vector(kv.direction_x, kv.direction_y, kv.direction_z)
		self.peak = self.fraction * 65
		print("leap peak is " .. self.peak)
		
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
        
        self:StartIntervalThink(0.03)

		-- disable ability
		self:GetAbility():SetActivated( false )

		if self:ApplyVerticalMotionController() == false then 
			self:Destroy()
		end
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end

		-- animation
		self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_LIFESTEALER_INFEST_END, (1/2) * (1/self.duration))

		-- sfx
		EmitSoundOn("Hero_LifeStealer.Rage", self:GetParent())
	end
end

function modifier_zombie_pounce_lua_movement:OnRefresh( kv )
	
end

function modifier_zombie_pounce_lua_movement:OnDestroy( kv )
	if IsServer() then
		local caster = self:GetParent()
		self:GetParent():InterruptMotionControllers( true )
		self:GetParent():RemoveGesture(ACT_DOTA_LIFESTEALER_INFEST_END)
		--StopSoundOn("Hero_LifeStealer.Rage", self:GetParent())
		-- knockback
		if self:GetAbility():GetLevel() > 1 then
			local enemies1 = FindUnitsInRadius(
				caster:GetTeam(),
				caster:GetAbsOrigin(),
				nil,
				self:GetAbility():GetSpecialValueFor( "knockback_radius" ),
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_CLOSEST,
				false
			)
			if #enemies1>0 then
				for i,unit in pairs(enemies1) do
					if not IsBuildingOrSpire(unit) then
						if not unit:HasModifier("modifier_zombie_pounce_ravage_lua_debuff") then
							local unit_pos = unit:GetAbsOrigin()
							local centre = caster:GetAbsOrigin()
							local vector = Vector(unit_pos.x-centre.x, unit_pos.y-centre.y, unit_pos.z-centre.z)
							vector = vector:Normalized()
							unit:AddNewModifier(
								caster,
								self:GetAbility(),
								"modifier_zombie_pounce_lua_knockback",
								{
									direction_x = vector.x,
									direction_y = vector.y,
									distance = self:GetAbility():GetSpecialValueFor("knockback_distance"),
									speed = self:GetAbility():GetSpecialValueFor("knockback_speed")
								}
							)
						end
					end
				end
			end
		end

		-- destroy trees
		local trees = GridNav:GetAllTreesAroundPoint( caster:GetAbsOrigin(), self:GetAbility():GetSpecialValueFor( "tree_destroy_radius" ), true )
		for _,tree in pairs(trees) do
			if tree:IsStanding() then
				tree:CutDown(caster:GetTeam())
			end
		end
	end
end

function modifier_zombie_pounce_lua_movement:OnIntervalThink()
	local caster = self:GetParent()

    -------------------------------------------------------find enemies in radius
    local enemies = FindUnitsInRadius(
        caster:GetTeam(),
        caster:GetAbsOrigin(),
        nil,
        self:GetAbility():GetSpecialValueFor( "leap_radius" ),
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false
    )
    if #enemies>0 then
        for i,unit in pairs(enemies) do
            if not IsBuildingOrSpire(unit) then
                -- applydamage
                local damageTable = {
                    victim = unit,
                    attacker = caster,
                    damage = self.damage,
                    damage_type = self:GetAbility():GetAbilityDamageType(),
                    damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
                    ability = self:GetAbility() --Optional.
                }
				ApplyDamage(damageTable)

                -- sfx
                local nFXIndex = ParticleManager:CreateParticle( "particles/abilities/rupture_burst.vpcf", PATTACH_ABSORIGIN, unit )
                ParticleManager:ReleaseParticleIndex( nFXIndex )
                EmitSoundOn( "hero_bloodseeker.rupture.cast", unit)

                -- remove this movement modifier
				self:Destroy()
				
				-- make caster cast channeling zombie spell on unit
				local abil = caster:FindAbilityByName("zombie_pounce_ravage_lua")
				if not abil then
					caster:AddAbility("zombie_pounce_ravage_lua")
					abil = caster:FindAbilityByName("zombie_pounce_ravage_lua")
				end
				abil:SetLevel(self:GetAbility():GetLevel())
				caster:CastAbilityOnTarget(unit, abil, caster:GetPlayerOwnerID())
				

                print("zombie has reached a unit mid-leap")
                return
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_zombie_pounce_lua_movement:SyncTime( iDir, dt )
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

function modifier_zombie_pounce_lua_movement:UpdateHorizontalMotion( me, dt )
	self:SyncTime(1, dt)
	local parent = self:GetParent()
	
	-- set position
	local target = self.direction*self.hVelocity*self.elapsedTime

	-- change position
	parent:SetOrigin( self.origin + target )
end

function modifier_zombie_pounce_lua_movement:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

function modifier_zombie_pounce_lua_movement:UpdateVerticalMotion( me, dt )
	self:SyncTime(2, dt)
	local parent = self:GetParent()

	-- set relative position
	local target = self.vVelocity*self.elapsedTime + 0.5*self.gravity*self.elapsedTime*self.elapsedTime

	-- change height
	parent:SetOrigin( Vector( parent:GetOrigin().x, parent:GetOrigin().y, self.origin.z+target ) )
end

function modifier_zombie_pounce_lua_movement:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end