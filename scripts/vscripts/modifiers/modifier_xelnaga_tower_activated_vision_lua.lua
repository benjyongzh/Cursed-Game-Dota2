modifier_xelnaga_tower_activated_vision_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_xelnaga_tower_activated_vision_lua:IsHidden()
	return false
end

function modifier_xelnaga_tower_activated_vision_lua:IsDebuff()
	return false
end

function modifier_xelnaga_tower_activated_vision_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_xelnaga_tower_activated_vision_lua:OnCreated( kv )
	if IsServer() then
		-- sfx
		local tower = self:GetParent()

		-- FOW index check
		self.index = getIndexTable(_G.XELNAGA_TOWER_UNIT, tower)
		
        PlaySoundOnAllClients("Outpost.Captured.Notification")
		EmitSoundOn("Hero_ArcWarden.TempestDouble", tower)
		tower:EmitSound("Hero_Wisp.Overcharge")

		local particle_precast = "particles/units/heroes/heroes_underlord/au_debut_rift.vpcf"
		self.effect_precast1 = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, tower )
		ParticleManager:SetParticleControlEnt(self.effect_precast1, 0, tower, PATTACH_ABSORIGIN_FOLLOW, nil, tower:GetOrigin(), true)
		
		--particle_precast = "particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack_trail.vpcf"
		particle_precast = "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_proj_core.vpcf"
		--particle_precast = "particles/items4_fx/nullifier_proj_core.vpcf"
		self.effect_precast2 = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, tower )
		ParticleManager:SetParticleControlEnt(self.effect_precast2, 3, tower, PATTACH_POINT_FOLLOW, "attach_fx", tower:GetOrigin(), true)

		particle_precast = "particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_moonfall.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_precast, PATTACH_ABSORIGIN_FOLLOW, tower )
		ParticleManager:SetParticleControlEnt(effect_cast, 1, tower, PATTACH_ABSORIGIN_FOLLOW, nil, tower:GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(effect_cast, 5, tower, PATTACH_ABSORIGIN_FOLLOW, nil, tower:GetOrigin(), true)
		ParticleManager:ReleaseParticleIndex(effect_cast)

		-- vision + anim
		--self.anim_counter = 0
		--StartAnimation(tower, {duration = 8, activity=ACT_DOTA_IDLE, rate=1, translate="captured"})
		self:StartIntervalThink(0.25)
		self:OnIntervalThink()
	end
end

function modifier_xelnaga_tower_activated_vision_lua:OnRefresh( kv )
end

function modifier_xelnaga_tower_activated_vision_lua:OnDestroy( kv )
	if IsServer() then
		-- sfx
        PlaySoundOnAllClients("Outpost.Captured.Notification")
		EmitSoundOn("Hero_Dark_Seer.Wall_of_Replica_Start", self:GetParent())
		EmitSoundOn("Hero_SkywrathMage.AncientSeal.Target", self:GetParent())
		if self.effect_precast1 then
			ParticleManager:DestroyParticle( self.effect_precast1, true )
		end
		if self.effect_precast2 then
			ParticleManager:DestroyParticle( self.effect_precast2, true )
		end
		EndAnimation(self:GetParent())
		self:GetParent():StopSound("Hero_Wisp.Overcharge")
	end
end

function modifier_xelnaga_tower_activated_vision_lua:OnIntervalThink()
	if self then
		for i=0,15 do
			if PlayerResource:IsValidPlayer(i) then
				if GameRules:IsDaytime() then
					AddFOWViewer(PlayerResource:GetTeam(i), self:GetParent():GetAbsOrigin(), _G.XELNAGA_ACTIVATED_DAYTIME_VISION[self.index], 0.25, false)
				else
					AddFOWViewer(PlayerResource:GetTeam(i), self:GetParent():GetAbsOrigin(), _G.XELNAGA_ACTIVATED_NIGHTTIME_VISION[self.index], 0.25, false)
				end
			end
		end
		--[[
		self.anim_counter = self.anim_counter + 0.25
		if self.anim_counter >= 8 then
			StartAnimation(self:GetParent(), {duration = 8, activity=ACT_DOTA_IDLE, rate=1, translate="captured"})
			self.anim_counter = 0
		end
		]]
	end
end

function modifier_xelnaga_tower_activated_vision_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}

	return funcs
end

function modifier_xelnaga_tower_activated_vision_lua:GetActivityTranslationModifiers()
	if IsServer() then
		return "captured"
	end
end