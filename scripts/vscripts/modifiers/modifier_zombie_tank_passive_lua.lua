modifier_zombie_tank_passive_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_tank_passive_lua:IsHidden()
	return true
end

function modifier_zombie_tank_passive_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_zombie_tank_passive_lua:OnCreated( kv )
	if IsServer() then
        self.distance = self:GetAbility():GetSpecialValueFor("knockback_distance") -- special value
        self.speed = self:GetAbility():GetSpecialValueFor("knockback_speed") -- special value
        self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration") -- special value
        self.tree_radius = self:GetAbility():GetSpecialValueFor("tree_destroy_radius") -- special value
	end
end

function modifier_zombie_tank_passive_lua:OnRefresh( kv )
	if IsServer() then
        self.distance = self:GetAbility():GetSpecialValueFor("knockback_distance") -- special value
        self.speed = self:GetAbility():GetSpecialValueFor("knockback_speed") -- special value
        self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration") -- special value
        self.tree_radius = self:GetAbility():GetSpecialValueFor("tree_destroy_radius") -- special value
	end
end

function modifier_zombie_tank_passive_lua:OnDestroy( kv )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_zombie_tank_passive_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}

	return funcs
end

function modifier_zombie_tank_passive_lua:OnAttackLanded( kv )
	local attacker = kv.attacker
	local target = kv.target
	if IsServer() then
		if attacker == self:GetParent() then
            if not target:IsBuilding() and target:GetTeamNumber() ~= attacker:GetTeamNumber() and not IsBuildingOrSpire(target) then
                local location = target:GetAbsOrigin()
                local centre = attacker:GetAbsOrigin()
                local vector = Vector(location.x-centre.x, location.y-centre.y, location.z-centre.z)
                vector = vector:Normalized()
                target:AddNewModifier(
                    attacker,
                    self:GetAbility(),
                    "modifier_zombie_tank_passive_lua_knockback",
                    {
                        direction_x = vector.x,
                        direction_y = vector.y,
                        distance = self.distance,
                        speed = self.speed,
                        stun_duration = self.stun_duration,
                        tree_radius = self.tree_radius,
                    }
                )
            end
		end
	end
end

function modifier_zombie_tank_passive_lua:GetAttackSound()
	return "Hero_Tiny_Tree.Impact"
end