modifier_zombie_pounce_ravage_lua_channel = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_pounce_ravage_lua_channel:IsHidden()
	return false
end

function modifier_zombie_pounce_ravage_lua_channel:IsDebuff()
	return false
end

function modifier_zombie_pounce_ravage_lua_channel:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_zombie_pounce_ravage_lua_channel:OnCreated( kv )
    if IsServer() then
        self.interval = self:GetAbility():GetSpecialValueFor("ravage_interval")
        self.target = EntIndexToHScript(kv.target_index)

        self.damagetable = {
            victim = self.target,
            attacker = self:GetParent(),
            damage = self:GetAbility():GetSpecialValueFor("ravage_dmg_per_interval"),
            damage_type = self:GetAbility():GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
            ability = self:GetAbility(), --Optional.
        }

        self:StartIntervalThink(self.interval)
        self:OnIntervalThink()

        -- sfx
        EmitSoundOn("Hero_LifeStealer.OpenWounds.Cast", self:GetParent())
	end
end

function modifier_zombie_pounce_ravage_lua_channel:OnDestroy( kv )
    if IsServer() then
        self:GetParent():RemoveGesture(ACT_DOTA_ATTACK)
	end
end

function modifier_zombie_pounce_ravage_lua_channel:OnIntervalThink()
    if self.target:IsAlive() and IsValidEntity(self.target) then
        local caster = self:GetParent()
        -- damage
        ApplyDamage(self.damagetable)

        -- animation
        caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 1/self.interval)

        EmitSoundOn("Hero_LifeStealer.Attack", self:GetParent())
        
    else
        self:Destroy()
    end
end

function modifier_zombie_pounce_ravage_lua_channel:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_zombie_pounce_ravage_lua_channel:OnTakeDamage(keys)
	if IsServer() then
		local damage_taken = keys.damage
		local unit = keys.unit
		local min_dmg = self:GetAbility():GetSpecialValueFor("ravage_min_dmg_cancel")
        if unit == self:GetParent() and unit:IsAlive() and damage_taken >= min_dmg then
            self:GetParent():Stop()
            EmitSoundOn("high_five.impact", self:GetParent())
		end
	end
end