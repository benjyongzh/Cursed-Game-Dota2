modifier_zombie_tombstone_lua = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_tombstone_lua:IsHidden()
	return true
end

function modifier_zombie_tombstone_lua:IsDebuff()
	return false
end

function modifier_zombie_tombstone_lua:IsPurgable()
	return false
end

function modifier_zombie_tombstone_lua:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = false,
        [MODIFIER_STATE_NO_HEALTH_BAR] = false,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = false,
    }

    return state
end

function modifier_zombie_tombstone_lua:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_zombie_tombstone_lua:OnCreated( kv )
	if IsServer() then
        self.ability = self:GetAbility()
        self.interval = self.ability:GetSpecialValueFor("interval")
        self.radius = self.ability:GetSpecialValueFor("radius")
        self.offset = self.ability:GetSpecialValueFor("spawn_loc_offset")

        -- destroy trees in area
        local trees = GridNav:GetAllTreesAroundPoint( self:GetParent():GetAbsOrigin(), self.ability:GetSpecialValueFor( "tree_destroy_radius" ), true )
        for _,tree in pairs(trees) do
            if tree:IsStanding() then
                tree:CutDown(self:GetParent():GetTeam())
            end
        end

        self:StartIntervalThink(self.interval)
        self:OnIntervalThink()

        -- sfx
        EmitSoundOn("Hero_Undying.Mausoleum", self:GetParent())
        local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_tombstone_monument.vpcf", PATTACH_ABSORIGIN, self:GetParent())
        ParticleManager:ReleaseParticleIndex(effect)
        
	end
end

function modifier_zombie_tombstone_lua:OnIntervalThink()

	local origin = self:GetParent():GetOrigin()
	local team = self:GetParent():GetTeam()

	--================================= find enemies for spawning zombie ===========================
	units = FindUnitsInRadius(
        team,	-- int, your team number
        origin,	-- point, center point
        nil,	-- handle, cacheUnit. (not known)
        self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
        0,	-- int, flag filter
        FIND_CLOSEST,	-- int, order filter
        false	-- bool, can grow cache
	)
	if #units > 0 then
		for _,enemy in pairs(units) do
            if not IsBuildingOrSpire(enemy) then
                if _G.ZOMBIE_UNIT_COUNT < _G.ZOMBIE_UNIT_MAX_COUNT then
                    -- spawn zombie
                    local location = enemy:GetAbsOrigin() + RandomVector(math.random(1,self.offset))
                    Game_Events:SpawnZombie(location, self:GetParent():GetPlayerOwnerID(), true )
                end
			end
		end		
	end
end

function modifier_zombie_tombstone_lua:OnDestroy()
    if IsServer() then
        -- sfx
        EmitSoundOn("Hero_Undying.Decay.Target.PaleAugur", self:GetParent())
        local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_tower_destruction.vpcf", PATTACH_ABSORIGIN, self:GetParent())
        ParticleManager:ReleaseParticleIndex(effect)

        --delete the damn summon
        self:GetParent():ForceKill(false)
    end
end

function modifier_zombie_tombstone_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_zombie_tombstone_lua:OnDeath(kv)
    if IsServer() then
        if self:GetParent() == kv.unit then
            self:Destroy()
        end
	end
end