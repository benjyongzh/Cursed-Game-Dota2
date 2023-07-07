modifier_vampire_sol_skin_lua = class({})

--------------------------------------------------------------------------------

function modifier_vampire_sol_skin_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_vampire_sol_skin_lua:IsDebuff()
    return true
end

--------------------------------------------------------------------------------

function modifier_vampire_sol_skin_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

--[[
function modifier_vampire_sol_skin_lua:OnCreated()
    if IsServer() then
        local interval = self:GetAbility():GetSpecialValueFor("interval")
        local full_burn_duration = self:GetAbility():GetSpecialValueFor("burn_duration")
        local damage = interval*((self:GetParent():GetMaxHealth()/100)/full_burn_duration)
        
        self.damageTable = {
            victim = self:GetParent(),
            attacker = self:GetParent(),
            damage = damage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility(), --Optional.
        }
        -- Start interval
        self:StartIntervalThink( interval )
        self:OnIntervalThink()
    end
end

--------------------------------------------------------------------------------

function modifier_vampire_sol_skin_lua:OnRefresh(kv)    

    if IsServer() then
        local interval = self:GetAbility():GetSpecialValueFor("interval")
        local full_burn_duration = self:GetAbility():GetSpecialValueFor("burn_duration")
        local damage = interval*((self:GetParent():GetMaxHealth()/100)/full_burn_duration)
        
        self.damageTable = {
            victim = self:GetParent(),
            attacker = self:GetParent(),
            damage = damage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility(), --Optional.
        }
        -- restart interval tick
        self:StartIntervalThink( interval )
        self:OnIntervalThink()
    end

end

function modifier_vampire_sol_skin_lua:OnDestroy()
end

--------------------------------------------------------------------------------

function modifier_vampire_sol_skin_lua:OnIntervalThink()
    if GameRules:IsDaytime() then
        ApplyDamage( self.damageTable )
    end
end

--------------------------------------------------------------------------------

--Graphics & Animations
function modifier_vampire_sol_skin_lua:GetEffectName()
    if GameRules:IsDaytime() then
        return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
    end
    return ""
end

function modifier_vampire_sol_skin_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
]]