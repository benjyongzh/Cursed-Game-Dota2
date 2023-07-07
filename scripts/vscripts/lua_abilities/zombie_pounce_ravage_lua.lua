zombie_pounce_ravage_lua = class({})
LinkLuaModifier( "modifier_zombie_pounce_ravage_lua_channel", "modifiers/modifier_zombie_pounce_ravage_lua_channel", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_pounce_ravage_lua_debuff", "modifiers/modifier_zombie_pounce_ravage_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function zombie_pounce_ravage_lua:IsHiddenAbilityCastable()
    return true
end

function zombie_pounce_ravage_lua:OnSpellStart()
    local caster = self:GetCaster()
    self.target = self:GetCursorTarget()
    local modifier = caster:FindModifierByName( "modifier_zombie_pounce_ravage_lua_channel" )
    if not modifier then
        caster:AddNewModifier(caster, self, "modifier_zombie_pounce_ravage_lua_channel", {target_index = self.target:entindex()})
    end

    modifier = self.target:FindModifierByName( "modifier_zombie_pounce_ravage_lua_debuff" )
    if not modifier then
        self.target:AddNewModifier(caster, self, "modifier_zombie_pounce_ravage_lua_debuff", {})
    end
end

function zombie_pounce_ravage_lua:OnChannelFinish( bInterrupted )
    local caster = self:GetCaster()
    local modifier = caster:FindModifierByName( "modifier_zombie_pounce_ravage_lua_channel" )
    if modifier then
        modifier:Destroy()
    end
    modifier = self.target:FindModifierByName( "modifier_zombie_pounce_ravage_lua_debuff" )
    if modifier then
        modifier:Destroy()
    end

    -- checking abil target
    if self.target then
        self.target = nil
    end

    -- removing this abil
    caster:RemoveAbility(self:GetAbilityName())
end

function zombie_pounce_ravage_lua:OnChannelThink()
    -- checking if the units actually has the specific modifier
    local modifier1 = self:GetCaster():FindModifierByName( "modifier_zombie_pounce_ravage_lua_channel" )
    local modifier2 = self.target:FindModifierByName( "modifier_zombie_pounce_ravage_lua_debuff" )
    if not modifier1 then
        if modifier2 then
            modifier2:Destroy()
        end
    elseif not modifier2 then
        modifier1:Destroy()
    end
end