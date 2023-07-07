druid_tree_vision_lua = class({})
LinkLuaModifier( "modifier_druid_tree_vision_lua", "modifiers/modifier_druid_tree_vision_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function druid_tree_vision_lua:Init()
    ListenToGameEvent('tree_cut', Dynamic_Wrap(self, 'OnTreeCut'), self)
end

function druid_tree_vision_lua:OnSpellStart()
    local caster = self:GetCaster()
    local tree = self:GetCursorTarget()
    local spell_duration = self:GetSpecialValueFor("duration")

    -- check for upgrade 1
    local abil = self:GetCaster():FindAbilityByName("druid_upgrade_1")
	if abil then
		if abil:GetLevel() > 0 then
			spell_duration = spell_duration + self:GetSpecialValueFor( "upgrade_duration_increase" )
		end
    end
    
    local modifier = "modifier_druid_tree_vision_lua"
    local eye = CreateUnitByName("druid_tree_eye", tree:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
    eye:SetOwner(caster)
    eye:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
    eye:AddNewModifier(caster, self, modifier, {duration = spell_duration})

    --sfx
    
    EmitSoundOn("Hero_Pugna.NetherWard.Wight", caster)
end

function druid_tree_vision_lua:OnTreeCut(keys)
    --for k,v in pairs(keys) do
    --    print(k,v)
    --end
    local point = Vector(keys.tree_x,keys.tree_y,0.0)
    local hKiller = PlayerResource:GetPlayer(keys.killerID)
    local killer_teamID = PlayerResource:GetTeam(keys.killerID)
    --find eye units around this tree. small radius.
    local eyes = FindUnitsInRadius(killer_teamID,
                              point,
                              nil,
                              10,
                              DOTA_UNIT_TARGET_TEAM_BOTH,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
                              FIND_ANY_ORDER,
                              false)

    -- detect if they have the modifier_druid_tree_vision
    print(#eyes)
    for _,unit in pairs(eyes) do
        if unit:GetUnitName() == "druid_tree_eye" then
            --sfx
            EmitSoundOn("Hero_Wisp.Spirits.Target", unit)
            local particle_cast = "particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end_sparks.vpcf"
            local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, unit )
            ParticleManager:SetParticleControl(effect_cast, 1, unit:GetOrigin())
            ParticleManager:ReleaseParticleIndex(effect_cast)
            --kill
            unit:ForceKill(false)
        end
    end
end
