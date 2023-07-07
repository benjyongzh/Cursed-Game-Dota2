modifier_barbarian_charge_lua_movement = class({})
LinkLuaModifier( "modifier_barbarian_charge_knocked_lua", "modifiers/modifier_barbarian_charge_knocked_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_barbarian_charge_knockback_lua", "modifiers/modifier_barbarian_charge_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
--------------------------------------------------------------------------------
-- Classifications
function modifier_barbarian_charge_lua_movement:IsHidden()
	return true
end

function modifier_barbarian_charge_lua_movement:IsPurgable()
	return false
end

function modifier_barbarian_charge_lua_movement:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_barbarian_charge_lua_movement:OnCreated( kv )
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
		self.peak = 0 --original is 200
		
		-- sync
		self.elapsedTime = 0
		self.motionTick = {}
		self.motionTick[0] = 0
		self.motionTick[1] = 0
		
		-- disable ability
		self:GetAbility():SetActivated( false )
		
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()	
		end
		-- Start interval
		self:StartIntervalThink( 0.03 )
		self:OnIntervalThink()

		-- sfx
		self.effect1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash_trail_base.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(self.effect1, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self.effect2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash_trail_d.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(self.effect2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	
	end
end

function modifier_barbarian_charge_lua_movement:OnRefresh( kv )
	
end

function modifier_barbarian_charge_lua_movement:OnDestroy( kv )
	if IsServer() then
		--self:GetParent():RemoveGesture(ACT_DOTA_RUN)
		EndAnimation(self:GetParent())

		self:GetAbility():SetActivated( true )
		self:GetParent():InterruptMotionControllers( true )

		-- sfx
		if self.effect1 then
			ParticleManager:DestroyParticle(self.effect1, true)
		end
		if self.effect2 then
			ParticleManager:DestroyParticle(self.effect2, true)
		end
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------

function modifier_barbarian_charge_lua_movement:OnIntervalThink(kv)
	
	local caster = self:GetParent()
	local centre = self:GetParent():GetAbsOrigin()
	local distance_vector = Vector(centre.x-self.origin.x, centre.y-self.origin.y, centre.z-self.origin.z)
	local distance = math.sqrt(distance_vector.x * distance_vector.x + distance_vector.y * distance_vector.y)--get absolute distance value
	
	------cut tree while charging/moving
	local trees = GridNav:GetAllTreesAroundPoint( caster:GetAbsOrigin(), self:GetAbility():GetSpecialValueFor( "leap_damage_radius" )/6, true )
	for _,tree in pairs(trees) do
		if tree:IsStanding() then
			tree:CutDown(caster:GetTeam())
			-- self damage
			local slef_dmg = self:GetAbility():GetSpecialValueFor("self_damage_tree")
			local current_hp = caster:GetHealth()
			if slef_dmg > current_hp then
				slef_dmg = current_hp -1
			end
			local slef_dmg_table = {
				victim = caster,
				attacker = caster,
				damage = slef_dmg,
				damage_type = DAMAGE_TYPE_PURE,
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = self:GetAbility(), --Optional.
			}
			ApplyDamage(slef_dmg_table)
		end
	end

	-------find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeam(),
		caster:GetAbsOrigin(),
		nil,
		self:GetAbility():GetSpecialValueFor( "leap_damage_radius" ),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	--------bonus damage based on distance
	local bonus = self:GetAbility():GetSpecialValueFor( "bonus_damage" )*(distance/self:GetAbility():GetSpecialValueFor( "leap_distance" ))

	if #enemies > 0 then
		for _,unit in pairs(enemies) do
			if not IsBuildingOrSpire(unit) and not unit:HasModifier("modifier_barbarian_charge_knocked_lua") then
				
				local new_damage = self:GetAbility():GetSpecialValueFor( "leap_damage" ) + bonus
				-- applydamage
				local damageTable = {
					victim = unit,
					attacker = caster,
					damage = new_damage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = self:GetAbility() --Optional.
				}
				ApplyDamage(damageTable)

				local location = unit:GetOrigin()
				local vector = Vector(location.x-centre.x, location.y-centre.y, location.z-centre.z)
				local distance_from_source = math.sqrt(vector.x * vector.x + vector.y * vector.y)
				local distance_to_travel = self:GetAbility():GetSpecialValueFor("knockback_distance") + (self:GetAbility():GetSpecialValueFor("bonus_knockback")*(distance/self:GetAbility():GetSpecialValueFor( "leap_distance" )))
				vector = vector:Normalized()
				unit:AddNewModifier(
					caster, -- player source
					self:GetAbility(), -- ability source
					"modifier_barbarian_charge_knockback_lua", -- modifier name
					{
						direction_x = vector.x,
						direction_y = vector.y,
						distance = distance_to_travel,
						speed = self:GetAbility():GetSpecialValueFor("knockback_speed")
					} -- kv -- kv  
				)

				-- slow + immunity modifier
				unit:AddNewModifier(
					caster, -- player source
					self:GetAbility(), -- ability source
					"modifier_barbarian_charge_knocked_lua", -- modifier name
					{
						duration = self:GetAbility():GetSpecialValueFor("slow_duration"),
						slow = self:GetAbility():GetSpecialValueFor("ms_slow_pct")
					} -- kv -- kv  
				)

				-- self damage
				local slef_dmg = self:GetAbility():GetSpecialValueFor("self_damage_unit")
				local current_hp = caster:GetHealth()
				if slef_dmg > current_hp then
					slef_dmg = current_hp -1
				end
				local slef_dmg_table = {
					victim = caster,
					attacker = caster,
					damage = slef_dmg,
					damage_type = DAMAGE_TYPE_PURE,
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = self:GetAbility(), --Optional.
				}
				ApplyDamage(slef_dmg_table)

				-- sfx
				EmitSoundOn("Hero_Pangolier.Gyroshell.Stun" , unit)
			end
		end		
	end
	--self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_RUN, 3)

end

----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Motion effects
function modifier_barbarian_charge_lua_movement:SyncTime( iDir, dt )
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

function modifier_barbarian_charge_lua_movement:UpdateHorizontalMotion( me, dt )
	self:SyncTime(1, dt)
	local parent = self:GetParent()
	
	-- set position
	local target = self.direction*self.hVelocity*self.elapsedTime

	-- change position
	parent:SetOrigin( self.origin + target )
end

function modifier_barbarian_charge_lua_movement:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

function modifier_barbarian_charge_lua_movement:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf"
end

function modifier_barbarian_charge_lua_movement:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
