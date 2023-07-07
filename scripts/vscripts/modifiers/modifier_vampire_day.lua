modifier_vampire_day = class({})
LinkLuaModifier("modifier_vampire_night", "modifiers/modifier_vampire_night", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function modifier_vampire_day:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_vampire_day:IsDebuff()
    return true
end

--------------------------------------------------------------------------------

function modifier_vampire_day:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_vampire_day:GetTexture()
	return "night_stalker_hunter_in_the_night"
end

--------------------------------------------------------------------------------

function modifier_vampire_day:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------

function modifier_vampire_day:OnCreated()

    -- get stats from customnettables. made in addon_game_mode
    local mytable = CustomNetTables:GetTableValue("cursed_stats", "0")

    if IsServer() then
        self:SetStackCount(_G.DAY_COUNTER)
        self.extra_hp = AsymptotePointValue(mytable.base_hp, mytable.end_hp, mytable.factor, (self:GetStackCount()-1))  

        local vampire = self:GetParent()

        -- checking for torch item and swapping it out
        local modifier = vampire:FindModifierByName( "modifier_item_torch_lua" )
		if modifier then
			--remove torch modifier
			modifier:Destroy()
        end
        local item = vampire:FindItemInInventory("item_torch_active")
        if item then
            -- swap item based on item slot. this function is from utils
            local mytable = {caster = vampire, ability = item}
            swap_to_item(mytable, "item_torch_inactive")
        end
        
        self.wings = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/nightstalker/black_nihility/black_nihility_night_back.vmdl"})
        self.legs = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/nightstalker/nightstalker_legarmor_night.vmdl"})
        self.tail = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/nightstalker/nightstalker_tail_night.vmdl"})
        -- lock to bone
        self.wings:FollowEntity(vampire, true)
        self.legs:FollowEntity(vampire, true)
        self.tail:FollowEntity(vampire, true)

        -- model scale
        vampire:SetModelScale(1.00)

        -- attack capability
        if not vampire.attack_cap then
            vampire.attack_cap = vampire:GetAttackCapability()
        end
        vampire:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)

        -- Start interval
        self:StartIntervalThink( 0.25 )
        self:OnIntervalThink()
    end

    -- stats for client
    local stacks = self:GetStackCount()
    self.bonus_damage = self:AsymptotePointValue(mytable.base_atk_dmg, mytable.end_atk_dmg, mytable.factor, stacks-1)
    self.bonus_atk_speed = self:AsymptotePointValue(mytable.base_as, mytable.end_as, mytable.factor, stacks-1)
    self.abs_ms = self:AsymptotePointValue(mytable.base_ms, mytable.end_ms, mytable.factor, stacks-1)
    self.bonus_nightvision = self:AsymptotePointValue(mytable.base_night_vision, mytable.base_night_vision, mytable.factor, stacks-1)    
    self.mp_regen = self:AsymptotePointValue(mytable.mp_regen, mytable.mp_regen, mytable.factor, stacks-1)
end

-- copied from utils.lua but it must be here because feking client side doesnt understand global functions etc
function modifier_vampire_day:AsymptotePointValue(startvalue, maxvalue, factor, point_in_time)
	local a = startvalue
	local b = maxvalue
	local y = b - ( (b - a) * ( factor ^ point_in_time ) ) -- factor 0.5 means halflife. bigger factor -> slower approach to maxvalue
	return y
end

--------------------------------------------------------------------------------

function modifier_vampire_day:OnRefresh(kv)    
    -- get stats from customnettables. made in addon_game_mode
    local mytable = CustomNetTables:GetTableValue("cursed_stats", "0")

    if IsServer() then
        local vampire = self:GetParent()
        self:SetStackCount(_G.DAY_COUNTER)
        self.extra_hp = AsymptotePointValue(mytable.base_hp, mytable.end_hp, mytable.factor, (self:GetStackCount()-1))

        -- restart interval tick
        self:StartIntervalThink( 0.25 )
        self:OnIntervalThink()
    end

    -- stats for client
    local stacks = self:GetStackCount()
    self.bonus_damage = self:AsymptotePointValue(mytable.base_atk_dmg, mytable.end_atk_dmg, mytable.factor, stacks-1)
    self.bonus_atk_speed = self:AsymptotePointValue(mytable.base_as, mytable.end_as, mytable.factor, stacks-1)
    self.abs_ms = self:AsymptotePointValue(mytable.base_ms, mytable.end_ms, mytable.factor, stacks-1)
    self.bonus_nightvision = self:AsymptotePointValue(mytable.base_night_vision, mytable.base_night_vision, mytable.factor, stacks-1)
    self.mp_regen = self:AsymptotePointValue(mytable.mp_regen, mytable.mp_regen, mytable.factor, stacks-1)
end

function modifier_vampire_day:OnDestroy()
    if IsServer() then
        local vampire = self:GetParent()

        --remove wings n stuff
        UTIL_Remove(self.wings)
        UTIL_Remove(self.legs)
        UTIL_Remove(self.tail)

        -- reset to original model scale
        local model_scale = {}
        model_scale["farmer"] = 1.2
        model_scale["defender"] = 1.05
        model_scale["scout"] = 1.0
        model_scale["barbarian"] = 0.9
        model_scale["ranger"] = 1.1
        model_scale["illusionist"] = 0.75
        model_scale["guardian"] = 0.8
        model_scale["boomer"] = 0.6
        model_scale["samurai"] = 1.05
        model_scale["druid"] = 1.15
        model_scale["assassin"] = 1.1
        vampire:SetModelScale(model_scale[vampire:GetUnitName()])

        -- reset attack capability
        vampire:SetAttackCapability(vampire.attack_cap)
    end
end

--------------------------------------------------------------------------------

function modifier_vampire_day:OnIntervalThink()
    if IsServer() then
        if not GameRules:IsDaytime() then
            self:Destroy()
            self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vampire_night", {})
        end

        local abil = self:GetParent():FindAbilityByName("vampire_sol_skin_lua")
        if abil then
            local full_burn_duration = abil:GetSpecialValueFor("burn_duration")
            local burndamage = 0.25*(self:GetParent():GetMaxHealth()/full_burn_duration)
            local damagetable = {
                victim = self:GetParent(),
                attacker = self:GetParent(),
                damage = burndamage,
                damage_type = abil:GetAbilityDamageType(),
                ability = self:GetAbility(), --Optional.
            }
            ApplyDamage( damagetable )
        end
    end
end

--------------------------------------------------------------------------------

function modifier_vampire_day:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function  modifier_vampire_day:CheckState()
	local state = {
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_vampire_day:GetModifierBaseAttack_BonusDamage()
    return self.bonus_damage
end

--------------------------------------------------------------------------------

function modifier_vampire_day:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_atk_speed
end

--------------------------------------------------------------------------------

function modifier_vampire_day:GetModifierMoveSpeedOverride()
    return self.abs_ms
end

--------------------------------------------------------------------------------

function modifier_vampire_day:GetBonusNightVision()
    return self.bonus_nightvision
end

--------------------------------------------------------------------------------

function modifier_vampire_day:GetModifierModelChange()
	return VAMPIRE_3D_MODEL
end

--------------------------------------------------------------------------------

function modifier_vampire_day:GetAttackSound()
	return "Hero_Nightstalker.Attack"
end

--------------------------------------------------------------------------------

function modifier_vampire_day:GetModifierIgnoreMovespeedLimit()
    return 1
end

--------------------------------------------------------------------------------

function modifier_vampire_day:GetModifierProjectileName()
    return ""
end

--------------------------------------------------------------------------------

function modifier_vampire_day:GetModifierExtraHealthBonus()
	return self.extra_hp
end

--------------------------------------------------------------------------------

function modifier_vampire_day:GetModifierConstantManaRegen()
	return self.mp_regen
end

--------------------------------------------------------------------------------

--Graphics & Animations
function modifier_vampire_day:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_vampire_day:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
