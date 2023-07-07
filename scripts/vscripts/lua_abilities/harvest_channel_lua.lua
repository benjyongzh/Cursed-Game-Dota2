harvest_channel_lua = class({})
LinkLuaModifier( "modifier_lumber_stacks_lua", "modifiers/modifier_lumber_stacks_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_harvest_channel_lua", "modifiers/modifier_harvest_channel_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_being_harvested_lua", "modifiers/modifier_being_harvested_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function harvest_channel_lua:GetIntrinsicModifierName()
	return "modifier_lumber_stacks_lua"
end

function harvest_channel_lua:OnSpellStart()
    local caster = self:GetCaster()
    local player_id = caster:GetPlayerOwnerID()
    local modifier = caster:FindModifierByName( "modifier_return_lumber_lua" )
    if modifier then
        modifier:Destroy()
    end

    self.target_tree = self:GetCursorTarget()
    if self.target_tree.being_harvested == true then
        -- target tree is already being harvested. find another one nearby
        local max_search_radius = self:GetSpecialValueFor("next_tree_detection_radius")
        -- search for trees around the initial target tree
        local trees = GridNav:GetAllTreesAroundPoint(self.target_tree:GetOrigin(), max_search_radius, false)
        if #trees > 1 then
            local path_lengths = {}
            for _,tree in pairs(trees) do
                local new_tree_location = tree:GetOrigin()
                local distance = self:GetSpecialValueFor("distance_from_tree")
                local direction = (caster:GetOrigin() - new_tree_location):Normalized()
                direction.z = 0
                -- make a circle around each tree and select the point on that circle that's closest to the caster
                local new_closest_point = GetGroundPosition(new_tree_location + (distance * direction), nil)
                -- measure the path length from the caster and the closest_point
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
                        -- if they are legit, then go harvest them instead. "return" stops the loop from continuing
                        local target_tree = v.tree_unit
                        -- boolean on the caster to make sure it does not set "being_harvested" to false when it changes tree target
                        caster.changing_tree_target = true
                        --print("changing tree target")
                        caster:CastAbilityOnTarget(target_tree, caster:FindAbilityByName("harvest_channel_lua"), player_id)
                        return
                    end
                end
            else
                caster:CastAbilityImmediately(caster:FindAbilityByName("return_lumber_lua"), caster:GetPlayerOwnerID())
                caster.tree_to_harvest = nil
                SendErrorMessage(player_id, "No vacant trees nearby")
                UTIL_MessageText(player_id, "No vacant trees nearby", 255, 0, 0, 0)
            end
        else
            caster:CastAbilityImmediately(caster:FindAbilityByName("return_lumber_lua"), caster:GetPlayerOwnerID())
            caster.tree_to_harvest = nil
            SendErrorMessage(player_id, "No vacant trees nearby")
            UTIL_MessageText(player_id, "No vacant trees nearby", 255, 0, 0, 0)
        end
    else
        -- caster is no longer in a state of changing tree target
        caster.changing_tree_target = false
        caster.tree_to_harvest = self.target_tree
        caster:AddNewModifier(caster, self, "modifier_harvest_channel_lua", {})
        self.target_tree.being_harvested = true
        -- sfx
        local particle = "particles/econ/events/fall_major_2016/teleport_start_fm06_leaves.vpcf"
	    self.effect_precast = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, caster )
	    ParticleManager:SetParticleControl(self.effect_precast, 1, self.target_tree:GetOrigin())
    end
end

function harvest_channel_lua:OnChannelFinish( bInterrupted )
    local caster = self:GetCaster()
    local modifier = caster:FindModifierByName( "modifier_harvest_channel_lua" )
    if modifier then
        modifier:Destroy()
    end
    -- checking if the caster is changing tree targets if yes, then it does not set "being_harvested" to false for his original target tree
    if caster.changing_tree_target == false then
        self.target_tree.being_harvested = false -- check this
    end
    -- sfx
    if self.effect_precast ~= nil then
        ParticleManager:DestroyParticle( self.effect_precast, true )
    end
end

function harvest_channel_lua:OnChannelThink()
    local elapsed_time = GameRules:GetGameTime() - self:GetChannelStartTime()
    local caster = self:GetCaster()
    local player_id = caster:GetPlayerOwnerID()
    -- checking if the unit actually has the specific modifier for harvesting. it could be stuck.
    if elapsed_time > 0.2 then
        -- if it hasn't acquired modifier in 0.2 after casting then return to hut to reset bug
        if not caster:HasModifier("modifier_harvest_channel_lua") then
            --print("error. recasting again")
            --caster:CastAbilityOnTarget(self.target_tree, caster:FindAbilityByName("harvest_channel_lua"), player_id)
            caster:CastAbilityImmediately(caster:FindAbilityByName("return_lumber_lua"), player_id)
        end
    end
    -- sfx
    local whole_number = math.floor(elapsed_time)
    local remainder = elapsed_time - whole_number
    if remainder >= 0.49 and remainder <= 0.51 then
        EmitSoundOn("Hero_Sniper.MKG_impact", caster)
    end
end
