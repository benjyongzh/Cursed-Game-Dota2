modifier_zombie_acid_dummy_lua = class({})

function modifier_zombie_acid_dummy_lua:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_BLIND] = true
    }

    return state
end

function modifier_zombie_acid_dummy_lua:DestroyOnExpire()
  return true
end

function modifier_zombie_acid_dummy_lua:IsPurgable()
  return false
end

function modifier_zombie_acid_dummy_lua:OnCreated()
	if IsServer() and self:GetAbility():IsTrained() then
		local ability = self:GetAbility()
		self.interval = ability:GetSpecialValueFor("interval")
        self.damage = ability:GetSpecialValueFor("dmg_per_interval")
        self.radius = ability:GetSpecialValueFor("radius")
        
        self:StartIntervalThink( self.interval )
        self:OnIntervalThink()
        
        -- sfx
        EmitSoundOn( "Hero_Viper.Nethertoxin.Cast", self:GetParent() )
        EmitSoundOn( "hero_viper.viperStrikeImpact", self:GetParent() )
        
		self:GetParent():EmitSound("Hero_Viper.NetherToxin")
		self.effect1 = ParticleManager:CreateParticle("particles/zombie_acid_puddle.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        
		effect = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_acid_spray_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        --ParticleManager:SetParticleControlEnt(self.mainParticle, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(effect)
	end
end

function modifier_zombie_acid_dummy_lua:OnDestroy()
    if IsServer() then
        self:StartIntervalThink(-1)
		if self.effect1 then
			ParticleManager:DestroyParticle(self.effect1, false)
			ParticleManager:ReleaseParticleIndex(self.effect1)
        end        
		self:GetParent():StopSound("Hero_Viper.NetherToxin")
        --delete the damn summon
        self:GetParent():ForceKill(false)
    end
end

function modifier_zombie_acid_dummy_lua:OnIntervalThink()
	--find enemies
    local dummy = self:GetParent()
    local enemies = FindUnitsInRadius(
        dummy:GetTeam(),
        dummy:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
        )

    for _,enemy in pairs(enemies) do
        -- damage
        local damageTable = {
            victim = enemy,
            attacker = self:GetAbility():GetCaster(),
            damage = self.damage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
            ability = self:GetAbility(), --Optional.
        }
        ApplyDamage(damageTable)

        -- sfx
        local effect = ParticleManager:CreateParticle("particles/econ/items/viper/viper_ti7_immortal/viper_poison_crimson_attack_ti7_explosion_flash_goo.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
        ParticleManager:SetParticleControl(effect, 3, enemy:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(effect)
    end

    -- sfx
    --for i = 0, 15, 1 do
    --    local distance = math.random(1, self.radius)
    --    local effect = ParticleManager:CreateParticle("particles/econ/items/viper/viper_ti7_immortal/viper_poison_crimson_attack_ti7_explosion_flash_goo.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    --    ParticleManager:SetParticleControl(effect, 3, self:GetParent():GetAbsOrigin() + RandomVector(distance))
    --    ParticleManager:ReleaseParticleIndex(effect)
    --end

end

function modifier_zombie_acid_dummy_lua:IsAura()
	return true
end

function modifier_zombie_acid_dummy_lua:IsAuraActiveOnDeath()
	return false
end

function modifier_zombie_acid_dummy_lua:GetAuraRadius()
	return self.radius
end

function modifier_zombie_acid_dummy_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_zombie_acid_dummy_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_zombie_acid_dummy_lua:GetAuraEntityReject( hEntity )
	if IsServer() then
		if IsBuildingOrSpire(hEntity) then
			return true
		else
			return false
		end
	end
end

function modifier_zombie_acid_dummy_lua:GetModifierAura()
	return "modifier_zombie_acid_debuff_lua"
end

function modifier_zombie_acid_dummy_lua:IsHidden()
	return true
end