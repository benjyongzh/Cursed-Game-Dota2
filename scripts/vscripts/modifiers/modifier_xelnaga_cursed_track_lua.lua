modifier_xelnaga_cursed_track_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_xelnaga_cursed_track_lua:IsHidden()
	return false
end

function modifier_xelnaga_cursed_track_lua:IsDebuff()
	return true
end

function modifier_xelnaga_cursed_track_lua:IsPurgable()
	return false
end

function modifier_xelnaga_cursed_track_lua:DestroyOnExpire()
	return true
end

function modifier_xelnaga_cursed_track_lua:GetTexture()
	return "medusa_stone_gaze"
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_xelnaga_cursed_track_lua:OnCreated( kv )
	if IsServer() then
		-- sfx
		local unit = self:GetParent()
		EmitSoundOn("Hero_KeeperOfTheLight.ManaLeak.Target", unit)
		self:GetParent():EmitSound("Hero_KeeperOfTheLight.ManaLeak.Target.FP")
		local particle_precast = "particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger_path_owner.vpcf"
		self.effect_precast1 = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, unit )
		ParticleManager:SetParticleControlEnt(self.effect_precast1, 0, unit, PATTACH_ABSORIGIN_FOLLOW, nil, unit:GetOrigin(), true)

		particle_precast = "particles/units/heroes/hero_demonartist/hero_demonartist_track_shield.vpcf"
		self.effect_precast2 = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, unit )
		ParticleManager:SetParticleControlEnt(self.effect_precast2, 0, unit, PATTACH_OVERHEAD_FOLLOW, nil, unit:GetOrigin(), true)

		-- vision
		self:StartIntervalThink(0.25)
		self:OnIntervalThink()
	end
end

function modifier_xelnaga_cursed_track_lua:OnRefresh( kv )
end

function modifier_xelnaga_cursed_track_lua:OnDestroy( kv )
	if IsServer() then
		-- sfx
		self:GetParent():StopSound("Hero_KeeperOfTheLight.ManaLeak.Target.FP")
		if self.effect_precast1 then
			ParticleManager:DestroyParticle( self.effect_precast1, true )
		end
		if self.effect_precast2 then
			ParticleManager:DestroyParticle( self.effect_precast2, true )
		end
	end
end

function modifier_xelnaga_cursed_track_lua:OnIntervalThink()
	if self and self:GetParent():IsAlive() and IsValidEntity(self:GetParent()) then
		for i=0,15 do
			if PlayerResource:IsValidPlayer(i) and self:GetParent():GetPlayerOwnerID() ~= i then
				if GameRules:IsDaytime() then
					AddFOWViewer(PlayerResource:GetTeam(i), self:GetParent():GetAbsOrigin(), _G.XELNAGA_REVEAL_CURSED_DAYTIME_VISION, 0.25, true)
				else
					AddFOWViewer(PlayerResource:GetTeam(i), self:GetParent():GetAbsOrigin(), _G.XELNAGA_REVEAL_CURSED_NIGHTTIME_VISION, 0.25, true)
				end
			end
        end
	end
end

--[[
function modifier_xelnaga_cursed_track_lua:CheckState()
    local state = {
        [MODIFIER_STATE_PROVIDES_VISION] = true,
    }
    return state
end
]]