modifier_zombie_lesser_passive_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_lesser_passive_lua:IsHidden()
	-- actual true
	return true
end

function modifier_zombie_lesser_passive_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_zombie_lesser_passive_lua:OnCreated( kv )
	-- references
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
end

function modifier_zombie_lesser_passive_lua:OnRefresh( kv )
	-- references
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
end

function modifier_zombie_lesser_passive_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_zombie_lesser_passive_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_zombie_lesser_passive_lua:OnAttackLanded( kv )
    if IsServer() and (not self:GetParent():PassivesDisabled()) then
        if self:GetParent() == kv.attacker and (kv.target:GetTeam() ~= self:GetParent():GetTeam()) and (not IsBuildingOrSpire(kv.target)) and (not kv.target:HasModifier("modifier_ghost_passive_lua")) then
            if self:RollChance( self.chance ) then
                -- actions
                local target = kv.target
                target:AddNewModifier(
                    self:GetParent(),
                    self:GetAbility(),
                    "modifier_zombie_lesser_passive_lua_ms_slow",
                    {
                        duration = self:GetAbility():GetSpecialValueFor("slow_duration"),
                    }
                )

                -- sfx
                EmitSoundOn("DOTA_Item.Maim", self:GetParent())
            end
        end
	end
end

--------------------------------------------------------------------------------
-- Helper
function modifier_zombie_lesser_passive_lua:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end