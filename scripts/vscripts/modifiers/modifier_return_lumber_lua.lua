modifier_return_lumber_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_return_lumber_lua:IsHidden()
	return false
end

function modifier_return_lumber_lua:IsDebuff()
	return false
end

function modifier_return_lumber_lua:IsStunDebuff()
	return false
end

function modifier_return_lumber_lua:IsPurgable()
	return false
end

function modifier_return_lumber_lua:RemoveOnDeath()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_return_lumber_lua:OnCreated( kv )
    -- references
    self.hut_radius = self:GetAbility():GetSpecialValueFor("hut_detection_radius")
    self.next_tree_radius = self:GetAbility():GetSpecialValueFor("next_tree_detection_radius")
    self.tree_distance = self:GetAbility():GetSpecialValueFor("distance_from_tree")
    self.positions = {}
    self.interval = 0.1
    self.stationery_allowance = 1.0

	if IsServer() then
        self:StartIntervalThink( self.interval )
        self:OnIntervalThink()
    end
end

function modifier_return_lumber_lua:OnRefresh( kv )
	-- references
    self.hut_radius = self:GetAbility():GetSpecialValueFor("hut_detection_radius")
    self.next_tree_radius = self:GetAbility():GetSpecialValueFor("next_tree_detection_radius")
    self.tree_distance = self:GetAbility():GetSpecialValueFor("distance_from_tree")
    self.positions = {}
    self.interval = 0.1
    self.stationery_allowance = 1.0

	if IsServer() then
        self:StartIntervalThink( self.interval )
        self:OnIntervalThink()
    end
end

------------------------------------------------------
-- Interval Effects
function modifier_return_lumber_lua:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()
        local player_id = caster:GetPlayerOwnerID()
        if GetHut(player_id) ~= nil then
            local hut = GetHut(player_id)
            table.insert(self.positions, caster:GetOrigin())
            local vector = Vector(caster:GetOrigin().x-hut:GetOrigin().x, caster:GetOrigin().y-hut:GetOrigin().y, caster:GetOrigin().z-hut:GetOrigin().z)
            local distance_from_hut = math.sqrt(vector.x * vector.x + vector.y * vector.y)--get absolute distance value
            -- check distance from hut. if the unit is close enough to return the lumber
            if distance_from_hut <= self.hut_radius then
                local lumber_stack_modifier = caster:FindModifierByName("modifier_lumber_stacks_lua")
                local lumber_per_stack = caster:FindAbilityByName("harvest_channel_lua"):GetSpecialValueFor("lumber_per_stack")
                local total_lumber = lumber_stack_modifier:GetStackCount() * lumber_per_stack
                if total_lumber > 0 then
                    -- add the player's lumber
                    Resources:ModifyLumber( player_id, total_lumber )
                    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hut, total_lumber, nil)
                    -- reset unit's lumber stack to 0
                    lumber_stack_modifier:SetStackCount( 0 )

                    -- sfx
                    EmitSoundOn("BodyImpact_Common.Medium", hut)
                end
                
                if caster.tree_to_harvest == nil then
                    -- search for trees around the caster for the next tree to harvest on
                    local trees = GridNav:GetAllTreesAroundPoint(caster:GetOrigin(), self.next_tree_radius, false)
                    if #trees > 1 then
                        local path_lengths = {}
                        for _,tree in pairs(trees) do
                            local new_tree_location = tree:GetOrigin()
                            local distance = self.tree_distance
                            local direction = (caster:GetOrigin() - new_tree_location):Normalized()
                            direction.z = 0
                            -- make a circle around each tree and select the point on that circle that's closest to the caster
                            local new_closest_point = GetGroundPosition(new_tree_location + (distance * direction), nil)
                            local length = GridNav:FindPathLength(caster:GetOrigin(), new_closest_point)
                            -- if length < 0 means that closest_point is not walkable
                            -- for length > 0, record down the length and the corresponding tree
                            if length > 0 then
                                table.insert(path_lengths, {tree_unit = tree, distance = length})
                            end
                        end
                        if path_lengths ~= {} then
                            -- sort the table according to ascending order of the "distance" value
                            table.sort(path_lengths, function(a,b) return a.distance < b.distance end)
                            -- cycle thru all potential next_trees, starting from the shortest distance
                            for i,v in pairs(path_lengths) do
                                -- check if they are also being harvested, and if they are standing
                                if v.tree_unit:IsStanding() and v.tree_unit.being_harvested ~= true then
                                    -- if they are legit, then go harvest them. "return" stops the loop from continuing
                                    local target_tree = v.tree_unit
                                    caster:CastAbilityOnTarget(target_tree, caster:FindAbilityByName("harvest_channel_lua"), player_id)
                                    return
                                end
                            end
                        else
                            -- no nearby trees around the caster atm
                            caster:Stop()
                            SendErrorMessage(player_id, "No trees nearby Hut")
                            UTIL_MessageText(player_id, "No trees nearby Hut to harvest", 255, 0, 0, 0)
                            self:Destroy()
                        end
                    else
                        -- no nearby trees around the caster atm
                        caster:Stop()
                        SendErrorMessage(player_id, "No trees nearby Hut")
                        UTIL_MessageText(player_id, "No trees nearby Hut to harvest", 255, 0, 0, 0)
                        self:Destroy()
                    end
                else
                    caster:CastAbilityOnTarget(caster.tree_to_harvest, caster:FindAbilityByName("harvest_channel_lua"), player_id)
                end
            else
                -- checking if the unit is moving for the past 1 second
                if #self.positions >= (self.stationery_allowance/self.interval) then
                    if self.positions[#self.positions-(self.stationery_allowance/self.interval)] ~= nil and self.positions[#self.positions] == self.positions[#self.positions-(self.stationery_allowance/self.interval)] then
                        --print("recasting returnlumber")
                        -- reseting counter and recasting return_lumber
                        self.positions = {}
                        caster:CastAbilityImmediately(caster:FindAbilityByName("return_lumber_lua"), player_id) --use multiple positions
                    end
                end
            end
        else
            -- no Hut detected
            caster:Stop()
            SendErrorMessage(player_id, "No Hut to return to")
            self:Destroy()
        end
    end
end

-- this removes the return lumber modifier when u interrupt the worker while he is returning
function modifier_return_lumber_lua:OnOrder(kv)
    if IsServer() then
        if self:GetParent() == kv.unit then
            local ordertype = kv.order_type
            local point = kv.new_pos
            local hut = GetHut(kv.unit:GetPlayerOwnerID())
            if ordertype == 1 and point == hut:GetOrigin() then
            else
                self:GetParent().tree_to_harvest = nil
                self:Destroy()
            end
        end
    end
end

function modifier_return_lumber_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ORDER
	}

	return funcs
end