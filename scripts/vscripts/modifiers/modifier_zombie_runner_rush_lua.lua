modifier_zombie_runner_rush_lua = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_zombie_runner_rush_lua:IsHidden()
	-- actual true
	return true
end

function modifier_zombie_runner_rush_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_zombie_runner_rush_lua:OnCreated( kv )
	-- references
	self.max_distance = self:GetAbility():GetSpecialValueFor( "max_distance" )
	self.min_distance = self:GetAbility():GetSpecialValueFor( "min_distance" )
end

function modifier_zombie_runner_rush_lua:OnRefresh( kv )
	-- references
	self.max_distance = self:GetAbility():GetSpecialValueFor( "max_distance" )
	self.min_distance = self:GetAbility():GetSpecialValueFor( "min_distance" )
end

function modifier_zombie_runner_rush_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_zombie_runner_rush_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
	}

	return funcs
end

function modifier_zombie_runner_rush_lua:OnOrder(kv)
    if IsServer() then
        if self:GetParent() == kv.unit then
            if kv.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE or kv.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
                if kv.target ~= nil and kv.target:GetTeam() ~= kv.unit:GetTeam() then
                    local target_origin = kv.target:GetAbsOrigin()
                    local caster_origin = kv.unit:GetAbsOrigin()
                    if self:GetAbility():IsCooldownReady() and self.target ~= kv.target then
                        
                        self.target = kv.target
                        --local distance = math.sqrt((caster_origin.x - target_origin.x)^2 + (caster_origin.y - target_origin.y)^2)
                        local distance = GridNav:FindPathLength(target_origin, caster_origin)
                        if distance >= self.min_distance and distance <= self.max_distance then
                            kv.unit:AddNewModifier(kv.unit, self:GetAbility(), "modifier_zombie_runner_rush_lua_ms_buff", {duration = self:GetAbility():GetCooldown(self:GetAbility():GetLevel())})
                            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
                        elseif distance > self.max_distance then
                            self:StartIntervalThink(0.1)
                        end
                    end
                end
            else
                self.target = nil
                local modifier = self:GetParent():FindModifierByName("modifier_zombie_runner_rush_lua_ms_buff")
                if modifier then
                    modifier:Destroy()
                end
                self:StartIntervalThink(-1)
            end
        end
    end
end

function modifier_zombie_runner_rush_lua:OnIntervalThink()
    local target_origin = self.target:GetAbsOrigin()
    local caster_origin = self:GetParent():GetAbsOrigin()
    --local distance = math.sqrt((caster_origin.x - target_origin.x)^2 + (caster_origin.y - target_origin.y)^2)
    local distance = GridNav:FindPathLength(target_origin, caster_origin)
    if distance <= self.max_distance then
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_zombie_runner_rush_lua_ms_buff", {duration = self:GetAbility():GetCooldown(self:GetAbility():GetLevel())})
        self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
        self:StartIntervalThink(-1)
    end
end