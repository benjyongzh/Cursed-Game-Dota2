modifier_zombie_carrier_passive_lua = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_carrier_passive_lua:IsHidden()
	return true
end

function modifier_zombie_carrier_passive_lua:IsDebuff()
	return false
end

function modifier_zombie_carrier_passive_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_zombie_carrier_passive_lua:OnCreated()
end

function modifier_zombie_carrier_passive_lua:OnDestroy()
end

function modifier_zombie_carrier_passive_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_zombie_carrier_passive_lua:OnDeath(kv)
    if IsServer() then
        if self:GetParent() == kv.unit then
            -- destroy trees in area
            local trees = GridNav:GetAllTreesAroundPoint( self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor( "tree_destroy_radius" ), true )
            for _,tree in pairs(trees) do
                if tree:IsStanding() then
                    tree:CutDown(self:GetParent():GetTeam())
                end
            end

            -- spawn basic zombies
            for i=1, self:GetAbility():GetSpecialValueFor( "num_zombies_spawn" ) do
                Game_Events:SpawnZombieBasic(self:GetParent():GetAbsOrigin() + RandomVector(math.random(1,self:GetAbility():GetSpecialValueFor( "spawn_max_offset_dist" ))), self:GetParent():GetPlayerOwnerID(), true)
            end

            -- sfx
            EmitSoundOn("Hero_LifeStealer.Consume", self:GetParent())
            local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody_low.vpcf", PATTACH_ABSORIGIN, self:GetParent())
            ParticleManager:ReleaseParticleIndex(effect)

            -- destroy this modifier
            self:Destroy()
        end
	end
end