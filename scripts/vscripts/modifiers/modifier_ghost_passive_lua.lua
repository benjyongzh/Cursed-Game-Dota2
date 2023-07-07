modifier_ghost_passive_lua = class({})

function modifier_ghost_passive_lua:IsHidden()
	return true
end

function modifier_ghost_passive_lua:RemoveOnDeath()
	return true
end

function modifier_ghost_passive_lua:IsDebuff()
	return false
end

function modifier_ghost_passive_lua:IsPurgable()
	return false
end

function modifier_ghost_passive_lua:IsAura()
	return not self:GetParent():HasModifier("modifier_ghost_invis_lua")
end

function modifier_ghost_passive_lua:IsAuraActiveOnDeath()
	return false
end

function modifier_ghost_passive_lua:GetAuraRadius()
	return self.radius
end

function modifier_ghost_passive_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ghost_passive_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ghost_passive_lua:GetAuraEntityReject( hEntity )
	if IsServer() then
		if IsBuildingOrSpire(hEntity) then
			return true
		else
			return false
		end
	end
end

function modifier_ghost_passive_lua:GetModifierAura()
	return "modifier_ghost_passive_lua_haunt"
end

--------------------------------------------------------------------------------

function modifier_ghost_passive_lua:CheckState()
    local state = {
        --[MODIFIER_STATE_UNSELECTABLE] = true,
        --[MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        --[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        --[MODIFIER_STATE_ROOTED] = true,
        --[MODIFIER_STATE_STUNNED] = true,
        --[MODIFIER_STATE_INVULNERABLE] = true,
        --[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
        --[MODIFIER_STATE_NO_TEAM_SELECT] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        --[MODIFIER_STATE_UNTARGETABLE] = true
    }
    return state
end

function modifier_ghost_passive_lua:GetVisualZDelta()
	return 0
end

--------------------------------------------------------------------------------

function modifier_ghost_passive_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
	return funcs
end

function modifier_ghost_passive_lua:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("range")
	self.sound_count = 1
	if IsServer() then
		--self:StartIntervalThink( 2 )
		local modifier = self:GetParent():FindModifierByName("modifier_truesight")
		if not modifier then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_truesight", {})
		end
	end
end

--[[
-- sfx periodic
function modifier_ghost_passive_lua:OnIntervalThink()
	local ghost = self:GetParent()
	local pos = ghost:GetOrigin()
	local sound_whisper = {}
	sound_whisper[1] = "Ambient.Diretide.Whispering.1"
	sound_whisper[2] = "Ambient.Diretide.Whispering.2"
	sound_whisper[3] = "Ambient.Diretide.Whispering.3"
	sound_whisper[4] = "Ambient.Diretide.Whispering.4"
	sound_whisper[5] = "Ambient.Diretide.Whispering.5"
	--EmitSoundOn(sound_whisper[self.sound_count], ghost)
	for i=0,15 do
		if PlayerResource:IsValidPlayer(i) then
			--local mytable = CustomNetTables:GetTableValue("farmer_alive", tostring(i))
			if GetFarmer(i) ~= nil and GetFarmer(i):IsAlive() then
				local farmer = GetFarmer(i)
				EmitSoundOnLocationForAllies(pos, sound_whisper[self.sound_count], farmer)
			-- sound effects only apply to players with a farmer
			--else
			--	EmitSoundOnLocationForAllies(pos, sound_whisper[self.sound_count], ghost)
			end
		end
	end
	if self.sound_count >= 5 then
		self.sound_count = 1
	else
		self.sound_count = self.sound_count + 1
	end
end
]]