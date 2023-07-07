modifier_spire = class({})


LinkLuaModifier ( "modifier_spire_lua_heal", "modifiers/modifier_spire_lua_heal", LUA_MODIFIER_MOTION_NONE)

function modifier_spire:OnCreated(event)
    if IsServer() then
        local unit = self:GetParent()
        local particle = "particles/econ/items/pugna/pugna_ward_golden_nether_lord/pugna_gold_ambient.vpcf"
        self.effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, unit)
        ParticleManager:SetParticleControlEnt(self.effect, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true)
    end

end

function modifier_spire:GetModifierDisableTurning()
    return 1
end

function modifier_spire:GetModifierIgnoreCastAngle()
    return 1
end

function modifier_spire:CheckState() 
    return { [MODIFIER_STATE_MAGIC_IMMUNE] = true,
             [MODIFIER_STATE_INVULNERABLE] = true,
             [MODIFIER_STATE_ROOTED] = true,
             [MODIFIER_STATE_STUNNED] = true,
             [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
             [MODIFIER_STATE_BLIND] = true,
             [MODIFIER_STATE_NO_HEALTH_BAR] = true,
             [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
             [MODIFIER_STATE_UNSELECTABLE] = true
            }
end

function modifier_spire:DeclareFunctions() 
  return { MODIFIER_PROPERTY_DISABLE_TURNING,
           MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
           MODIFIER_PROPERTY_MOVESPEED_LIMIT, }
end

function modifier_spire:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_spire:GetModifierMoveSpeed_Limit()
    return 0
end

function modifier_spire:IsHidden()
    return true
end

function modifier_spire:IsPurgable()
    return false
end

function modifier_spire:IsAura()
	return true
end

function modifier_spire:IsAuraActiveOnDeath()
	return false
end

function modifier_spire:GetAuraRadius()
	return 450
end

function modifier_spire:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_spire:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_spire:GetAuraEntityReject( hEntity )
    if IsServer() then
        if IsZombie(hEntity) or hEntity:GetUnitName() == "zombie_main_unit" then
            return true
        end
    end
end

function modifier_spire:GetModifierAura()
	return "modifier_spire_lua_heal"
end