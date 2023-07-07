modifier_zombie_lesser_passive_lua_ms_slow = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_lesser_passive_lua_ms_slow:IsHidden()
	return false
end

function modifier_zombie_lesser_passive_lua_ms_slow:IsDebuff()
	return true
end

function modifier_zombie_lesser_passive_lua_ms_slow:IsStunDebuff()
	return false
end

function modifier_zombie_lesser_passive_lua_ms_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_zombie_lesser_passive_lua_ms_slow:OnCreated( kv )
	-- references
	self.ms_slow = -self:GetAbility():GetSpecialValueFor("slow_ms_pct")
	--sfx
	if IsServer() then
		self.fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_bane/bane_fiendsgrip_hands.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(self.fx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true)
	end
end

function modifier_zombie_lesser_passive_lua_ms_slow:OnRefresh( kv )
	-- references
	self.ms_slow = -self:GetAbility():GetSpecialValueFor("slow_ms_pct")
end

function modifier_zombie_lesser_passive_lua_ms_slow:OnDestroy( kv )
	if IsServer() then
		if self.fx then
			ParticleManager:DestroyParticle(self.fx, false)
			ParticleManager:ReleaseParticleIndex(self.fx)
		end
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_zombie_lesser_passive_lua_ms_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_zombie_lesser_passive_lua_ms_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations

function modifier_zombie_lesser_passive_lua_ms_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_phantoml_slowlance.vpcf"
end