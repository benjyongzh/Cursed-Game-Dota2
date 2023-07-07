modifier_zealot_zealot_rush_lua_ms_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_zealot_zealot_rush_lua_ms_buff:IsHidden()
	-- actual true
	return false
end

function modifier_zealot_zealot_rush_lua_ms_buff:IsDebuff()
	return false
end

function modifier_zealot_zealot_rush_lua_ms_buff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_zealot_zealot_rush_lua_ms_buff:OnCreated( kv )
	-- references
    self.buffms = self:GetAbility():GetSpecialValueFor("movespeed")
    if IsServer() then
        -- sfx
        local particle = "particles/units/heroes/hero_omniknight/omniknight_degeneration_debuff.vpcf"
        self.effect = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(self.effect, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
        EmitSoundOn("Hero_PhantomLancer.Doppelwalk", self:GetParent())
    end
end

function modifier_zealot_zealot_rush_lua_ms_buff:OnRefresh( kv )
	-- references
    self.buffms = self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_zealot_zealot_rush_lua_ms_buff:OnDestroy( kv )
    if IsServer() then
        if self.effect ~= nil then
            ParticleManager:DestroyParticle(self.effect, true)
        end
    end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_zealot_zealot_rush_lua_ms_buff:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_EVENT_ON_ATTACK_START,
	}

	return funcs
end

function modifier_zealot_zealot_rush_lua_ms_buff:CheckState()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
    return state
end

function modifier_zealot_zealot_rush_lua_ms_buff:GetModifierMoveSpeed_Absolute()
    return self.buffms
end

function modifier_zealot_zealot_rush_lua_ms_buff:OnAttackStart(kv)
    if self:GetParent() == kv.attacker then
        self:Destroy()
    end
end

function modifier_zealot_zealot_rush_lua_ms_buff:GetStatusEffectName()
    return "particles/status_fx/status_effect_beserkers_call.vpcf"
end