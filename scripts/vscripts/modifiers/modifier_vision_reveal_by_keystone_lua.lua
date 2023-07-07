modifier_vision_reveal_by_keystone_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_vision_reveal_by_keystone_lua:IsHidden()
	return false
end

function modifier_vision_reveal_by_keystone_lua:IsDebuff()
	return true
end

function modifier_vision_reveal_by_keystone_lua:IsPurgable()
	return false
end

function modifier_vision_reveal_by_keystone_lua:DestroyOnExpire()
	return true
end

function modifier_vision_reveal_by_keystone_lua:GetTexture()
	return "medusa_stone_gaze"
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_vision_reveal_by_keystone_lua:OnCreated( kv )
	if IsServer() then
		-- sfx
		local unit = self:GetParent()
		EmitSoundOn("Hero_KeeperOfTheLight.ManaLeak.Target", unit)
		self:GetParent():EmitSound("Hero_KeeperOfTheLight.ManaLeak.Target.FP")
		--self.effect_precast1 = ParticleManager:CreateParticle( "particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger_path_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        self.effect_precast1 = ParticleManager:CreateParticle( "particles/econ/courier/courier_trail_hw_2013/courier_trail_hw_2013.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
        ParticleManager:SetParticleControlEnt(self.effect_precast1, 0, unit, PATTACH_ABSORIGIN_FOLLOW, nil, unit:GetOrigin(), true)

        --particle_precast = "particles/units/heroes/hero_demonartist/hero_demonartist_track_shield.vpcf"
		self.effect_precast2 = ParticleManager:CreateParticle( "particles/econ/wards/f2p/f2p_ward/ward_true_sight.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
		ParticleManager:SetParticleControlEnt(self.effect_precast2, 0, unit, PATTACH_ABSORIGIN_FOLLOW, nil, unit:GetOrigin(), true)

		-- vision
		self:StartIntervalThink(0.25)
		self:OnIntervalThink()
	end
end

function modifier_vision_reveal_by_keystone_lua:OnRefresh( kv )
end

function modifier_vision_reveal_by_keystone_lua:OnDestroy( kv )
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

function modifier_vision_reveal_by_keystone_lua:OnIntervalThink()
    if self and self:GetParent():IsAlive() and IsValidEntity(self:GetParent()) then
        if _G.SPIRE_UNIT:HasModifier("modifier_spire_giving_vision_lua") then
            local i = _G.CURSED_UNIT:GetTeam()
            if GameRules:IsDaytime() then
                AddFOWViewer(i, self:GetParent():GetAbsOrigin(), _G.KEYSTONE_REVEAL_DAYTIME_VISION, 0.25, true)
            else
                AddFOWViewer(i, self:GetParent():GetAbsOrigin(), _G.KEYSTONE_REVEAL_NIGHTTIME_VISION, 0.25, true)
            end
        else
            self:Destroy()
        end
	end
end