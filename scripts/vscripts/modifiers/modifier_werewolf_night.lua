modifier_werewolf_night = class({})
LinkLuaModifier("modifier_werewolf_day", "modifiers/modifier_werewolf_day", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function modifier_werewolf_night:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:IsDebuff()
    return false
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:GetTexture()
	return "lycan_shapeshift"
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:OnCreated()

    -- get stats from customnettables. made in addon_game_mode
    local mytable = CustomNetTables:GetTableValue("cursed_stats", "0")

    if IsServer() then
        self:SetStackCount(_G.DAY_COUNTER)
        self.extra_hp = AsymptotePointValue(mytable.base_hp, mytable.end_hp, mytable.factor, (self:GetStackCount()-1))

        --self.hull_radius_factor = 1.25 -- original hull size for villager is 24. so werewolf size should be bigger than 24. size 36 (using factor 1.5) is too big.  
        
        self.sound_count = 0
        self.sound_min = 15
        self.sound_max = 25
        math.randomseed(GameRules:GetGameTime())
        self.sound_next = math.random(self.sound_min, self.sound_max)     

        local wolf = self:GetParent()

        --[[
        self.original_max_hp = wolf:GetMaxHealth()
        local new_max_hp = self.original_max_hp + self.extra_hp
        wolf:SetMaxHealth(new_max_hp)
        wolf:SetBaseMaxHealth(new_max_hp)
        wolf:SetHealth(wolf:GetHealth() + self.extra_hp)
        ]]

        --[[
        local nFXIndex_1 = ParticleManager:CreateParticle( "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_trail_steam_red.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( nFXIndex_1, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        self:AddParticle( nFXIndex_1, false, false, -1, false, false )
        ]]
    
        -- setting hull radius
        --wolf:SetHullRadius(wolf:GetHullRadius() * self.hull_radius_factor)

        -- purge
        wolf:Purge(false, true, false, true, false)

        -- checking for torch item and swapping it out
        local modifier = wolf:FindModifierByName( "modifier_item_torch_lua" )
		if modifier then
			--remove torch modifier
			modifier:Destroy()
        end
        local item = wolf:FindItemInInventory("item_torch_active")
        if item then
            -- swap item based on item slot. this function is from utils
            local mytable = {caster = wolf, ability = item}
            swap_to_item(mytable, "item_torch_inactive")
        end

        -- model scale
        wolf:SetModelScale(1.08)

        -- attack capability
        if not wolf.attack_cap then
            wolf.attack_cap = wolf:GetAttackCapability()
        end
        wolf:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)

        -- Start interval
        self:StartIntervalThink( 0.25 )
        self:OnIntervalThink()
    end

    -- stats for client
    local stacks = self:GetStackCount()
    self.bonus_damage = self:AsymptotePointValue(mytable.base_atk_dmg, mytable.end_atk_dmg, mytable.factor, stacks-1)
    self.bonus_atk_speed = self:AsymptotePointValue(mytable.base_as, mytable.end_as, mytable.factor, stacks-1)
    self.abs_ms = self:AsymptotePointValue(mytable.base_ms, mytable.end_ms, mytable.factor, stacks-1)
    self.bonus_range = 128 - self:GetParent():GetBaseAttackRange() + self:AsymptotePointValue(mytable.base_atk_range, mytable.base_atk_range, mytable.factor, stacks-1)
    self.bonus_nightvision = self:AsymptotePointValue(mytable.base_night_vision, mytable.base_night_vision, mytable.factor, stacks-1)    
end

-- copied from utils.lua but it must be here because feking client side doesnt understand global functions etc
function modifier_werewolf_night:AsymptotePointValue(startvalue, maxvalue, factor, point_in_time)
	local a = startvalue
	local b = maxvalue
	local y = b - ( (b - a) * ( factor ^ point_in_time ) ) -- factor 0.5 means halflife. bigger factor -> slower approach to maxvalue
	return y
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:OnRefresh(kv)    
    -- get stats from customnettables. made in addon_game_mode
    local mytable = CustomNetTables:GetTableValue("cursed_stats", "0")

    if IsServer() then
        local wolf = self:GetParent()
        self:SetStackCount(_G.DAY_COUNTER)

        self.extra_hp = AsymptotePointValue(mytable.base_hp, mytable.end_hp, mytable.factor, (self:GetStackCount()-1))

        --[[
        local new_max_hp = self.original_max_hp + self.extra_hp
        local original_hp_pct = wolf:GetHealthPercent()
        wolf:SetMaxHealth(new_max_hp)
        wolf:SetBaseMaxHealth(new_max_hp)
        wolf:SetHealth((original_hp_pct/100) * new_max_hp)
        ]]

        self.sound_count = 0
        self.sound_min = 15
        self.sound_max = 25
        math.randomseed(GameRules:GetGameTime())
        self.sound_next = math.random(self.sound_min, self.sound_max)

        -- restart interval tick
        self:StartIntervalThink( 0.25 )
        self:OnIntervalThink()
    end

    -- stats for client
    local stacks = self:GetStackCount()
    self.bonus_damage = self:AsymptotePointValue(mytable.base_atk_dmg, mytable.end_atk_dmg, mytable.factor, stacks-1)
    self.bonus_atk_speed = self:AsymptotePointValue(mytable.base_as, mytable.end_as, mytable.factor, stacks-1)
    self.abs_ms = self:AsymptotePointValue(mytable.base_ms, mytable.end_ms, mytable.factor, stacks-1)
    self.bonus_range = 128 - self:GetParent():GetBaseAttackRange() + self:AsymptotePointValue(mytable.base_atk_range, mytable.base_atk_range, mytable.factor, stacks-1)
    self.bonus_nightvision = self:AsymptotePointValue(mytable.base_night_vision, mytable.base_night_vision, mytable.factor, stacks-1)
end

function modifier_werewolf_night:OnDestroy()
    if IsServer() then
        local wolf = self:GetParent()

        --[[
        local original_hp_pct = wolf:GetHealthPercent()
        wolf:SetMaxHealth(self.original_max_hp)
        wolf:SetBaseMaxHealth(self.original_max_hp)
        wolf:SetHealth((original_hp_pct/100) * self.original_max_hp)
        ]]

        -- setting hull radius
        --wolf:SetHullRadius(wolf:GetHullRadius() * (1/self.hull_radius_factor))

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
        wolf:SetModelScale(model_scale[wolf:GetUnitName()])

        -- reset attack capability
        wolf:SetAttackCapability(wolf.attack_cap)
    end
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:OnIntervalThink()
    if IsServer() then
        if GameRules:IsDaytime() then
            self:Destroy()
            self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_werewolf_day", {})
        end

        self.sound_count = self.sound_count + 0.25
        
        -- sfx periodic
        if self.sound_count >= self.sound_next then
            local wolf = self:GetParent()
            local pos = wolf:GetOrigin()
            local sound_wolf = {}
            sound_wolf[1] = "Ambient.Diretide.Wolf.1"
            sound_wolf[2] = "Ambient.Diretide.Wolf.2"
            sound_wolf[3] = "Ambient.Diretide.Wolf.3"
            sound_wolf[4] = "Ambient.Diretide.Wolf.4"
            local r = math.random(1,4)
            EmitSoundOn(sound_wolf[r], wolf)
            self.sound_count = 0
            math.randomseed(GameRules:GetGameTime())
            self.sound_next = math.random(self.sound_min, self.sound_max)
        end
    end


    
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
        MODIFIER_PROPERTY_MODEL_CHANGE,
        --MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_MAX_ATTACK_RANGE,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function  modifier_werewolf_night:CheckState()
	local state = {
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:GetModifierBaseAttack_BonusDamage()
    return self.bonus_damage
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_atk_speed
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:GetModifierMoveSpeedOverride()
    return self.abs_ms
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:GetModifierAttackRangeBonus()
    return self.bonus_range
end
--------------------------------------------------------------------------------

function modifier_werewolf_night:GetBonusNightVision()
    return self.bonus_nightvision
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:GetModifierModelChange()
	return WEREWOLF_UNIT_WOLF_3D_MODEL
end

--------------------------------------------------------------------------------
--[[
function modifier_werewolf_night:GetModifierModelScale()
	return -10
end
]]

--------------------------------------------------------------------------------

function modifier_werewolf_night:GetModifierMaxAttackRange()
	return 150
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:GetAttackSound()
	return "Hero_Nightstalker.Attack"
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:GetModifierPhysicalArmorBonus()
    return 3
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:GetModifierIgnoreMovespeedLimit()
    return 1
end

--------------------------------------------------------------------------------

function modifier_werewolf_night:GetModifierProjectileName()
    return ""
end

function modifier_werewolf_night:GetModifierExtraHealthBonus()
	return self.extra_hp
end

--------------------------------- aura ---------------------------------------

LinkLuaModifier("modifier_wolf_pack_lua", "modifiers/modifier_wolf_pack_lua", LUA_MODIFIER_MOTION_NONE)

function  modifier_werewolf_night:IsAura()
    return true
end

function  modifier_werewolf_night:IsAuraActiveOnDeath()
	return false
end

function  modifier_werewolf_night:GetAuraRadius()
	return 900
end

function  modifier_werewolf_night:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function  modifier_werewolf_night:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function  modifier_werewolf_night:GetAuraEntityReject( hEntity )
	if IsServer() then
		if hEntity:HasModifier("modifier_wolf_passive_lua") then
			return false
		else
			return true
		end
	end
end

function  modifier_werewolf_night:GetModifierAura()
	return "modifier_wolf_pack_lua"
end