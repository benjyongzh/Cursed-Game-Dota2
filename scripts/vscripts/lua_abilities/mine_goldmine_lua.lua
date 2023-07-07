mine_goldmine_lua = class({})
LinkLuaModifier( "modifier_goldmine_being_mined", "modifiers/modifier_goldmine_being_mined", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mining_lua", "modifiers/modifier_mining_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function mine_goldmine_lua:IsHiddenAbilityCastable()
    return true
end

function mine_goldmine_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    
    local modifier = target:FindModifierByName("modifier_goldmine_being_mined")
    if modifier then
        modifier:IncrementStackCount()
    else
        target:AddNewModifier(target, self, "modifier_goldmine_being_mined", {})
    end

    caster:AddNewModifier(caster, self, "modifier_mining_lua", {duration = self:GetChannelTime()})    

    -- record ability target
    self.target = target:entindex()
end

function mine_goldmine_lua:OnChannelFinish( bInterrupted )
	local caster = self:GetCaster()
    local target = EntIndexToHScript(self.target)

    local modifier = target:FindModifierByName("modifier_goldmine_being_mined")
    if modifier then
        if modifier:GetStackCount() > 1 then
            modifier:DecrementStackCount()
        else
            modifier:Destroy()
        end
    end

    caster:RemoveAbility(self:GetAbilityName())
    caster:FindModifierByName("modifier_mining_lua"):Destroy()

    self.target = nil
end