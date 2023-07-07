modifier_werewolf_crit_strike_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_werewolf_crit_strike_lua:IsHidden()
	-- actual true
	return true
end

function modifier_werewolf_crit_strike_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_werewolf_crit_strike_lua:OnCreated( kv )
	-- references
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_damage = self:GetAbility():GetSpecialValueFor( "crit_damage" )
	--if IsServer() then
	--	self.real_crit_chance = self.crit_chance
	--	self:StartIntervalThink(0.25)
	--end
end

function modifier_werewolf_crit_strike_lua:OnRefresh( kv )
	-- references
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_damage = self:GetAbility():GetSpecialValueFor( "crit_damage" )
	--if IsServer() then
	--	self.real_crit_chance = self.crit_chance
	--	self:StartIntervalThink(0.25)
	--end
end

function modifier_werewolf_crit_strike_lua:OnDestroy( kv )
end

--[[
function modifier_werewolf_crit_strike_lua:OnIntervalThink()
	if IsServer() then
	end
end
]]

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_werewolf_crit_strike_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end

function modifier_werewolf_crit_strike_lua:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) and IsInCursedForm(self:GetParent()) then
		if self:RollChance( self.crit_chance ) then
			self.record = params.record
			return self.crit_damage
		end
	end
end

function modifier_werewolf_crit_strike_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			self:PlayEffects( params.target )
		end
	end
end
--------------------------------------------------------------------------------
-- Helper
function modifier_werewolf_crit_strike_lua:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_werewolf_crit_strike_lua:PlayEffects( target )
    -- on werewolf-----------------------------------------------------------------------------------------------
	local particle_cast = "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_crimson_ti8_sword_crit_overtheshoulder.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetParent():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 0, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
    ParticleManager:ReleaseParticleIndex( effect_cast )
    
    -- on target-------------------------------------------------------------------------------------------------
    particle_cast = "particles/generic_gameplay/generic_hit_blood.vpcf"
	effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
    ParticleManager:ReleaseParticleIndex( effect_cast )
    
    -------------------------------------------------------------------------------------------------------------
	local sound_cast = "Hero_Mars.Shield.Crit"
	EmitSoundOn( sound_cast, target )
end