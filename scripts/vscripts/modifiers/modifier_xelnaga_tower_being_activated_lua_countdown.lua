modifier_xelnaga_tower_being_activated_lua_countdown = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_xelnaga_tower_being_activated_lua_countdown:IsHidden()
	return false
end

function modifier_xelnaga_tower_being_activated_lua_countdown:IsDebuff()
	return false
end

function modifier_xelnaga_tower_being_activated_lua_countdown:IsPurgable()
	return false
end

function modifier_xelnaga_tower_being_activated_lua_countdown:DestroyOnExpire()
	return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_xelnaga_tower_being_activated_lua_countdown:OnCreated( kv )
    if IsServer() then
		self.table = {}
		self.table[1] = 120
		self.table[2] = 20
		self.table[3] = 12
		self.table[4] = 12
		self.table[5] = 12
		self.table[6] = 12
		self.table[7] = 12
		self.table[8] = 12
		self.table[9] = 12
		self.table[10] = 12
        self.time = self.table[1]
        self.per_second = 1
        self:SetStackCount(1200)

		self:StartIntervalThink(0.03)
        self:OnIntervalThink()
        
        -- world panel
        if self.worldpanel == nil then
            self.worldpanel = WorldPanels:CreateWorldPanelForAll(
                {layout = "file://{resources}/layout/custom_game/worldpanels/xelnaga_activate.xml",
                entity = self:GetParent(),
                entityHeight = 420,
                data = {current = self:GetStackCount(), table = self.table}
            })
        end
	end
end

function modifier_xelnaga_tower_being_activated_lua_countdown:OnDestroy( kv )
    if IsServer() then
        --world panel
        if self.worldpanel then
            self.worldpanel:Delete()
        end
	end
end

function modifier_xelnaga_tower_being_activated_lua_countdown:OnIntervalThink()
    -- update time left
    local stack_modi = self:GetParent():FindModifierByName("modifier_xelnaga_tower_being_activated_lua_stacks")
    if stack_modi then
        local stacks = stack_modi:GetStackCount()
        if stacks > 3 then
            stacks = 3
        end
        self.per_second = self.table[1]/self.table[stacks]
        self.time = self.time - (0.03 * self.per_second)
        self:SetStackCount((self.time/self.table[1]) * 1200)
    end

    -- if channel full
    if self:GetStackCount() <= 1 then
        local index = getIndexTable(_G.XELNAGA_TOWER_UNIT, self:GetParent())
        stack_modi:Destroy()
        local modifier1 = self:GetParent():FindModifierByName("modifier_xelnaga_tower_activated_vision_lua")
        if not modifier1 then
            self:GetParent():AddNewModifier(nil, nil, "modifier_xelnaga_tower_activated_vision_lua", {})

            -- notifications
            --Notifications:BottomToAll({ability = self:GetAbilityName(), duration=8})
            Notifications:BottomToAll({text="Outpost Tower " .. index .. " has been activated", duration = 8})

            -- game event
            CustomNetTables:SetTableValue("xelnaga_status", tostring(index), {activated = true})
            Game_Events:XelNagaUpdate()
        end
        EndAnimation(self:GetParent())
    end
end