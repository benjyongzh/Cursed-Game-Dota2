modifier_xelnaga_tower_being_activated_lua_stacks = class({})
LinkLuaModifier( "modifier_xelnaga_tower_being_activated_lua_countdown", "modifiers/modifier_xelnaga_tower_being_activated_lua_countdown", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Classifications
function modifier_xelnaga_tower_being_activated_lua_stacks:IsHidden()
	return false
end

function modifier_xelnaga_tower_being_activated_lua_stacks:IsDebuff()
	return false
end

function modifier_xelnaga_tower_being_activated_lua_stacks:IsPurgable()
	return false
end

function modifier_xelnaga_tower_being_activated_lua_stacks:DestroyOnExpire()
	return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_xelnaga_tower_being_activated_lua_stacks:OnCreated( kv )
	if IsServer() then
		
		EmitSoundOn("Hero_WitchDoctor.Maledict_Cast", self:GetParent())
		self:GetParent():EmitSound("Hero_Phoenix.SunRay.Loop")
		self:SetStackCount( 1 )

		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_xelnaga_tower_being_activated_lua_countdown", {})

		-- sfx
		self.effect_1 = ParticleManager:CreateParticle( "particles/world_outpost/world_outpost_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(self.effect_1, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_fx", self:GetParent():GetOrigin(), true)
	end
end

function modifier_xelnaga_tower_being_activated_lua_stacks:OnRefresh( kv )
	if IsServer() then
	end
end

function modifier_xelnaga_tower_being_activated_lua_stacks:OnDestroy( kv )
	if IsServer() then
		self:GetParent():StopSound("Hero_Phoenix.SunRay.Loop")
		local modifier = self:GetParent():FindModifierByName("modifier_xelnaga_tower_being_activated_lua_countdown")
		if modifier then
			modifier:Destroy()
		end

		-- sfx
		if self.effect_1 then
			ParticleManager:DestroyParticle(self.effect_1, true)
		end
	end
end

function modifier_xelnaga_tower_being_activated_lua_stacks:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_xelnaga_tower_being_activated_lua_stacks:GetOverrideAnimation( params )
	return ACT_DOTA_CHANNEL_ABILITY_1
end