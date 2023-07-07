modifier_zombie_main_passive_lua = class({})

function modifier_zombie_main_passive_lua:OnCreated()
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.vision = self:GetAbility():GetSpecialValueFor("vision_radius")
    self.bonus_ms = self:GetAbility():GetSpecialValueFor("bonus_ms")

	if IsServer() and self:GetAbility():IsTrained() then
        self.interval = self:GetAbility():GetSpecialValueFor("interval")
        self:SetStackCount(0)
        
        -- for stationery zombie spawns at keystones etc
        self.zombie_spawn_min_time = self:GetAbility():GetSpecialValueFor("zombie_spawn_min_time")
        self.zombie_spawn_max_time = self:GetAbility():GetSpecialValueFor("zombie_spawn_max_time")
        self.counter = 0
        self.spawn_time = math.random(self.zombie_spawn_min_time,self.zombie_spawn_max_time)

        self:StartIntervalThink( self.interval )
        self:OnIntervalThink()
	end
end

function modifier_zombie_main_passive_lua:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
		if self.mainParticle1 then
			ParticleManager:DestroyParticle(self.mainParticle1, false)
            ParticleManager:ReleaseParticleIndex(self.mainParticle1)
            self.mainParticle1 = nil
        end
        if self.mainParticle2 then
			ParticleManager:DestroyParticle(self.mainParticle2, false)
            ParticleManager:ReleaseParticleIndex(self.mainParticle2)
            self.mainParticle2 = nil
		end
	end
end

function modifier_zombie_main_passive_lua:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:Destroy() return end

	local hAbility = self:GetAbility()
    if not self:GetParent():IsAlive() then self:Destroy() return end

    -- checking for enemies nearby
    local enemies = FindUnitsInRadius(
        self:GetParent():GetTeam(),
        self:GetParent():GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false)

    if #enemies>0 then
        self:SetStackCount(1)
        
        -- fow
        for _,unit in pairs(enemies) do
            AddFOWViewer( self:GetParent():GetTeamNumber(), unit:GetAbsOrigin(), self.vision, self.interval, true )
        end
        
        -- sfx
        if not self.mainParticle1 then
            self.mainParticle1 = ParticleManager:CreateParticle( "particles/items2_fx/mask_of_madness.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControlEnt(self.mainParticle1, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true)
        end
        if not self.mainParticle2 then
            self.mainParticle2 = ParticleManager:CreateParticle( "particles/items2_fx/mask_of_madness.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:SetParticleControlEnt(self.mainParticle2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetOrigin(), true)
        end
    else
        self:SetStackCount(0)
        
        -- sfx
        if self.mainParticle1 then
			ParticleManager:DestroyParticle(self.mainParticle1, false)
            ParticleManager:ReleaseParticleIndex(self.mainParticle1)
            self.mainParticle1 = nil
        end
        if self.mainParticle2 then
			ParticleManager:DestroyParticle(self.mainParticle2, false)
            ParticleManager:ReleaseParticleIndex(self.mainParticle2)
            self.mainParticle2 = nil
		end
    end

    -- stationery zombie spawning
    self.counter = self.counter + self.interval
    if self.counter >= self.spawn_time then
        if _G.ZOMBIE_UNIT_COUNT < _G.ZOMBIE_UNIT_MAX_COUNT then
            
            local horde_abil = self:GetParent():FindAbilityByName("zombie_summon_wave_lua")
            local buildingtable = {}
            local radius = self:GetAbility():GetSpecialValueFor("zombie_spawn_radius")
            local limit = self:GetAbility():GetSpecialValueFor("zombie_spawn_limit_per_building")

            -- unactivated keystones
            for i=1, #_G.KEYSTONE_LOCATIONS do
                if not _G.KEYSTONE_UNIT[i]:HasModifier("modifier_keystone_sabotaged_lua") and not _G.KEYSTONE_UNIT[i]:HasModifier("modifier_keystone_activatedgood_lua") then
                    local zombies = GetZombiesInRadius(_G.KEYSTONE_UNIT[i]:GetAbsOrigin(), radius)
                    if #zombies < limit then
                        table.insert(buildingtable, _G.KEYSTONE_UNIT[i])
                    end
                end
            end
            -- unactivated outposts
            for i=1, #_G.XELNAGA_LOCATIONS do
                if not _G.XELNAGA_TOWER_UNIT[i]:HasModifier("modifier_xelnaga_tower_activated_vision_lua") then
                    local zombies = GetZombiesInRadius(_G.XELNAGA_TOWER_UNIT[i]:GetAbsOrigin(), radius)
                    if #zombies < limit then
                        table.insert(buildingtable, _G.XELNAGA_TOWER_UNIT[i])
                    end
                end
            end
            -- mangotrees
            for i=1, #_G.KEY_SPAWN_LOCATIONS do
                local zombies = GetZombiesInRadius(_G.KEY_SPAWNER_UNIT[i]:GetAbsOrigin(), radius)
                if #zombies < limit then
                    table.insert(buildingtable, _G.KEY_SPAWNER_UNIT[i])
                end
            end

            -- choose a random building to spawn at
            local building = nil
            if #buildingtable > 0 then
                if #buildingtable > 1 then
                    building = buildingtable[math.random(1,#buildingtable)]
                else
                    building = buildingtable[1]
                end
                local location = horde_abil:ChooseZombieRandomSpawnLocation(building:GetAbsOrigin(), self:GetParent():GetPlayerOwnerID(), radius)
                Game_Events:SpawnZombie(location, self:GetParent():GetPlayerOwnerID(), false)
            end
            
            -- restart spawn counters
            self.counter = 0
            self.spawn_time = math.random(self.zombie_spawn_min_time,self.zombie_spawn_max_time)
        end
    end
end

function modifier_zombie_main_passive_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT_UNIQUE,
	}

	return funcs
end

function modifier_zombie_main_passive_lua:GetModifierMoveSpeedBonus_Constant_Unique()
	return self:GetStackCount() * self.bonus_ms
end

-- ================================================= AURA =====================================

function modifier_zombie_main_passive_lua:IsAura()
	return true
end

function modifier_zombie_main_passive_lua:IsAuraActiveOnDeath()
	return false
end

function modifier_zombie_main_passive_lua:GetAuraRadius()
	return self.radius
end

function modifier_zombie_main_passive_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_zombie_main_passive_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

function modifier_zombie_main_passive_lua:GetAuraEntityReject( hEntity )
	if IsServer() then
		if IsBuildingOrSpire(hEntity) then
			return true
		else
			return false
		end
	end
end

function modifier_zombie_main_passive_lua:GetModifierAura()
	return "modifier_zombie_main_passive_lua_aura"
end

function modifier_zombie_main_passive_lua:IsHidden()
	return true
end