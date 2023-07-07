modifier_illusionist_fly_lua = class({})
LinkLuaModifier( "modifier_illusionist_flown_lua", "modifiers/modifier_illusionist_flown_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

-- Classifications
function modifier_illusionist_fly_lua:IsHidden()
	return false
end

function modifier_illusionist_fly_lua:IsDebuff()
	return true
end

function modifier_illusionist_fly_lua:IsStunDebuff()
	return false
end

function modifier_illusionist_fly_lua:IsPurgable()
	return true
end

function modifier_illusionist_fly_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_illusionist_fly_lua:OnCreated( keys )
	if IsServer() then
	
		local caster = keys.caster
		local target = self:GetParent()
		local ability = keys.ability

		self.flyduration = keys.Flyduration
		self.cycloneimmunetime = keys.Cycloneimmunetime
	
		-- Position variables
		local target_origin = self:GetParent():GetAbsOrigin()
		local target_initial_x = target_origin.x
		local target_initial_y = target_origin.y
		local target_initial_z = target_origin.z
		local position = Vector(target_initial_x, target_initial_y, target_initial_z)  --This is updated whenever the target has their position changed.
		
		
		local ground_position = GetGroundPosition(position, target)
		local cyclone_initial_height = keys.CycloneInitialHeight + ground_position.z
		local cyclone_min_height = keys.CycloneMinHeight + ground_position.z
		local cyclone_max_height = keys.CycloneMaxHeight + ground_position.z
		local tornado_start = GameRules:GetGameTime()
	
		-- Height per time calculation
		local time_to_reach_initial_height = self.flyduration / 10  --1/10th of the total cyclone duration will be spent ascending and descending to and from the initial height.
		local initial_ascent_height_per_frame = ((cyclone_initial_height - position.z) / time_to_reach_initial_height) * .03  --This is the height to add every frame when the unit is first cycloned, and applies until the caster reaches their max height.
		
		local up_down_cycle_height_per_frame = initial_ascent_height_per_frame / 3  --This is the height to add or remove every frame while the caster is in up/down cycle mode.
		if up_down_cycle_height_per_frame > 7.5 then  --Cap this value so the unit doesn't jerk up and down for short-duration cyclones.
			up_down_cycle_height_per_frame = 7.5
		end
		
		local final_descent_height_per_frame = nil  --This is calculated when the unit begins descending.
	
		-- Time to go down
		local time_to_stop_fly = self.flyduration - time_to_reach_initial_height
	
		-- Loop up and down
		local going_up = true
	
		-- Loop every frame for the duration
		Timers:CreateTimer(function()
			local time_in_air = GameRules:GetGameTime() - tornado_start
			
			-- First send the target to the cyclone's initial height.
			if position.z < cyclone_initial_height and time_in_air <= time_to_reach_initial_height then
				--print("+",initial_ascent_height_per_frame,position.z)
				position.z = position.z + initial_ascent_height_per_frame
				target:SetAbsOrigin(position)
				return 0.03
	
			-- Go down until the target reaches the ground.
			elseif time_in_air > time_to_stop_fly and time_in_air <= self.flyduration then
				--Since the unit may be anywhere between the cyclone's min and max height values when they start descending to the ground,
				--the descending height per frame must be calculated when that begins, so the unit will end up right on the ground when the duration is supposed to end.
				if final_descent_height_per_frame == nil then
					local descent_initial_height_above_ground = position.z - ground_position.z
					--print("ground position: " .. GetGroundPosition(position, target).z)
					--print("position.z : " .. position.z)
					final_descent_height_per_frame = (descent_initial_height_above_ground / time_to_reach_initial_height) * .03
				end
				
				--print("-",final_descent_height_per_frame,position.z)
				position.z = position.z - final_descent_height_per_frame
				target:SetAbsOrigin(position)
				return 0.03
	
			-- Do Up and down cycles
			elseif time_in_air <= self.flyduration then
				-- Up
				if position.z < cyclone_max_height and going_up then 
					--print("going up")
					position.z = position.z + up_down_cycle_height_per_frame
					target:SetAbsOrigin(position)
					return 0.03
	
				-- Down
				elseif position.z >= cyclone_min_height then
					going_up = false
					--print("going down")
					position.z = position.z - up_down_cycle_height_per_frame
					target:SetAbsOrigin(position)
					return 0.03
	
				-- Go up again
				else
					--print("going up again")
					going_up = true
					return 0.03
				end
	
			-- End
			else
				--print(GetGroundPosition(target:GetAbsOrigin(), target))
				--print("End TornadoHeight")
			end
		end)	
	
		-- Start interval
		self:StartIntervalThink( 0.03 )
		self:OnIntervalThink()

	end
end


function modifier_illusionist_fly_lua:OnRefresh( kv )

	self:StartIntervalThink( 0.03 )
	self:OnIntervalThink()

end

function modifier_illusionist_fly_lua:OnRemoved()
	if IsServer() then
		self:GetParent():AddNewModifier(
			self:GetParent(), -- player source
			self, -- ability source
			"modifier_illusionist_flown_lua", -- modifier name
			{
				duration = self.cycloneimmunetime
			} -- kv
		)
	end
end

function modifier_illusionist_fly_lua:OnDestroy(keys)

	--[[Set it so the target is facing the same direction as they were when they were hit by the tornado.
	if keys.target.invoker_tornado_forward_vector ~= nil then
		keys.target:SetForwardVector(self:Parent():GetAbsOrigin())
	end
	
	--[[if keys.caster.invoker_tornado_landing_damage_bonus ~= nil then
		ApplyDamage({victim = keys.target, attacker = keys.caster, damage = keys.BaseDamage + keys.caster.invoker_tornado_landing_damage_bonus, damage_type = DAMAGE_TYPE_MAGICAL,})
	else  --Failsafe.
		ApplyDamage({victim = keys.target, attacker = keys.caster, damage = keys.BaseDamage, damage_type = DAMAGE_TYPE_MAGICAL,})
	end
	
	keys.target.invoker_tornado_degrees_to_spin = nil]]	

end
---------------------------------------------------------------------------------
function modifier_illusionist_fly_lua:OnIntervalThink(keys)
    local target = self:GetParent()
	
	local spin = 2*0.03*360

	target:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0, spin, 0), target:GetForwardVector()))
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_illusionist_fly_lua:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE]         = false,
	    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED]           = true,		
		[MODIFIER_STATE_ROOTED]            = true,				
		[MODIFIER_STATE_DISARMED]          = true,			
		[MODIFIER_STATE_INVULNERABLE]      = true,		
		[MODIFIER_STATE_NO_HEALTH_BAR]     = true		
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_illusionist_fly_lua:GetEffectName()
	return "particles/econ/items/invoker/invoker_ti6/invoker_tornado_child_ti6_leaves.vpcf"
end

function modifier_illusionist_fly_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end