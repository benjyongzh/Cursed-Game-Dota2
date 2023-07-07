modifier_vampire_shadow_ward_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_vampire_shadow_ward_lua:IsHidden()
	return false
end

function modifier_vampire_shadow_ward_lua:IsDebuff()
	return false
end

function modifier_vampire_shadow_ward_lua:IsPurgable()
	return false
end

--destroy dumm on expire
function modifier_vampire_shadow_ward_lua:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_vampire_shadow_ward_lua:OnCreated( kv )
	if IsServer() then
		self.duration = self:GetAbility():GetSpecialValueFor("duration")
		self.timer = 0
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self.warning_interval = self:GetAbility():GetSpecialValueFor("warning_interval")
		self.warning_timer = self.warning_interval
		self.sfx_duration = 2
		self.sfx_timer = self.sfx_duration
		self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_IDLE, 0.4)
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		--sfx
		EmitSoundOn( "Hero_Pugna.NetherWard", self:GetParent())
		
	end
end


function modifier_vampire_shadow_ward_lua:OnIntervalThink()
	self.timer = self.timer + self.interval
	if self.timer <= self.duration then
		GameRules:BeginNightstalkerNight(self.interval)
		-- warning ping for enemies
		self.warning_timer = self.warning_timer + self.interval
		if self.warning_timer >= self.warning_interval then
			for i=0,15,1 do
				if PlayerResource:IsValidPlayerID(i) and i ~= self:GetParent():GetPlayerOwnerID() then
					PingLocationOnClient(self:GetParent():GetAbsOrigin(), i)
					Notifications:Bottom(i, {text="Vampire's Shadow Ward detected", style={color="red"}, duration=self.warning_interval})
				end
			end
			self.warning_timer = 0
		end
		-- sfx sound
		self.sfx_timer = self.sfx_timer + self.interval
		if self.sfx_timer >= self.sfx_duration then
			StopSoundOn( "Hero_Slark.Pounce.Leash.Immortal", self:GetParent())
			EmitSoundOn( "Hero_Slark.Pounce.Leash.Immortal", self:GetParent())
			self.sfx_timer = 0
		end
	else
		self:Destroy()
	end
end

function modifier_vampire_shadow_ward_lua:OnDestroy( kv )
	--sfx
	if IsServer() then
		StopSoundOn( "Hero_Slark.Pounce.Leash.Immortal", self:GetParent())
		EmitSoundOn( "Hero_Slark.Pounce.End", self:GetParent())
		self:GetParent():ForceKill(false)
		
	end
end

function modifier_vampire_shadow_ward_lua:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end