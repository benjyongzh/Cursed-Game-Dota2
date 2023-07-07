modifier_spire_giving_vision_lua = class({})

LinkLuaModifier ( "modifier_vision_reveal_by_keystone_lua", "modifiers/modifier_vision_reveal_by_keystone_lua", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------

function modifier_spire_giving_vision_lua:IsDebuff()
	return true
end

function modifier_spire_giving_vision_lua:IsHidden()
	return true
end

function modifier_spire_giving_vision_lua:IsPurgable()
	return false
end

function modifier_spire_giving_vision_lua:OnCreated()
    if IsServer() then
        EmitSoundOn("hero_bloodseeker.bloodRite.silence", self:GetParent())
        effect = ParticleManager:CreateParticle( "particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl(effect, 0, self:GetParent():GetOrigin())
        ParticleManager:ReleaseParticleIndex( effect )

        self.fx = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_blackhole_i.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(self.fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

        self:StartIntervalThink(0.2)
    end
end

function modifier_spire_giving_vision_lua:OnRefresh()
end

function modifier_spire_giving_vision_lua:OnDestroy()
    if IsServer() then
        if self.fx then
            ParticleManager:DestroyParticle( self.fx, false )
            ParticleManager:ReleaseParticleIndex(self.fx)
        end
    end
end

function modifier_spire_giving_vision_lua:OnIntervalThink()
    -- check keystones
    local keystones_activated_bad = 0
    for i=1, #_G.KEYSTONE_UNIT do
        local keystone = _G.KEYSTONE_UNIT[i]
        local modifier1 = keystone:FindModifierByName("modifier_keystone_sabotaged_lua")
        if modifier1 then
            keystones_activated_bad = keystones_activated_bad + 1
        end
    end
    if keystones_activated_bad < _G.KEYSTONES_TO_CURSED_WIN then
        -- not enough bad keystones (will be impt when alien is in game. who can disable keystones)
        self:Destroy()
    else
        -- enough sabotaged keystones
        for i = 0, 15, 1 do
            if PlayerResource:IsValidPlayerID(i) then
                if i ~= _G.CURSED_UNIT:GetPlayerOwnerID() then
                    local unit = GetMainUnit(i)
                    if unit:IsAlive() and IsValidEntity(unit) then
                        local modifier = unit:FindModifierByName("modifier_vision_reveal_by_keystone_lua")
                        if not modifier then
                            unit:AddNewModifier(unit, nil, "modifier_vision_reveal_by_keystone_lua", {})
                        end
                    end
                end
            end
        end

        --[[
        --testing
        local all_units = FindUnitsInRadius( -- selecting all units in the map.
            DOTA_TEAM_NOTEAM,
            Vector(0,0,0),
            nil,
            FIND_UNITS_EVERYWHERE,
            DOTA_UNIT_TARGET_TEAM_BOTH,
            DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
            DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
            FIND_ANY_ORDER,
            false
        )
        -- counting only farmer starting units
        for i,unit in pairs(all_units) do
            if unit:IsAlive() and unit ~= _G.CURSED_UNIT then
                local modifier = unit:FindModifierByName("modifier_vision_reveal_by_keystone_lua")
                if not modifier then
                    unit:AddNewModifier(unit, nil, "modifier_vision_reveal_by_keystone_lua", {})
                end
            end
        end
        ]]
    end
end