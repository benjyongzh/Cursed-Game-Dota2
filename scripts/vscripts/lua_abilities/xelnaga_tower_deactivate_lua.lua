xelnaga_tower_deactivate_lua = class({})

--------------------------------------------------------------------------------

function xelnaga_tower_deactivate_lua:IsHiddenAbilityCastable()
    return true
end

function xelnaga_tower_deactivate_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    
    local modifier = target:FindModifierByName("modifier_xelnaga_tower_activated_vision_lua")
    if not modifier then
        return
    end

    -- Play effects
    EmitSoundOn( "Hero_Sven.StormBolt", self:GetCaster() )
    self:GetCaster():EmitSound("Ability.static.loop")
    self.effect_1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:SetParticleControlEnt(self.effect_1, 0, target, PATTACH_POINT_FOLLOW, "attach_fx", target:GetOrigin(), true)
    
    self.target = target
end

function xelnaga_tower_deactivate_lua:OnChannelFinish( bInterrupted )
	local caster = self:GetCaster()
    local target = self.target

    if self.effect_1 then
		ParticleManager:DestroyParticle(self.effect_1, true)
    end

    --EndAnimation(caster)

    -- sfx
    self:GetCaster():StopSound("Ability.static.loop")

    -- cancel if fail
    if bInterrupted then
        self.target = nil
		return
    end
    
    -- if channel full
    local index = getIndexTable(_G.XELNAGA_TOWER_UNIT, target)
    local modifier = target:FindModifierByName("modifier_xelnaga_tower_activated_vision_lua")
    if modifier then
        modifier:Destroy()

        -- notifications
        --Notifications:BottomToAll({ability = self:GetAbilityName(), duration=8})
        Notifications:BottomToAll({text="Outpost Tower " .. index .. " has been ", duration = 8})
        Notifications:BottomToAll({text="deactivated", style={color="red"}, continue = true})

        -- game event
        CustomNetTables:SetTableValue("xelnaga_status", tostring(index), {activated = false})
        Game_Events:XelNagaUpdate()
    end
    
    -- remove this ability
    --caster:RemoveAbility(self:GetAbilityName())
    self.target = nil
end