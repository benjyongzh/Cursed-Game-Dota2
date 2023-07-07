modifier_generic_take_damage_alert_lua = class({})


function modifier_generic_take_damage_alert_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_generic_take_damage_alert_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_generic_take_damage_alert_lua:OnCreated()
    if IsServer() then
        self.ready = true
    end
end

function modifier_generic_take_damage_alert_lua:OnTakeDamage(kv)
    if IsServer() then
        if (self.ready == true) and (self:GetParent() == kv.unit) and (kv.attacker:GetTeam() ~= kv.unit:GetTeam()) and (self:GetParent():IsAlive()) and (IsValidEntity(self:GetParent())) then
            --action
            local location = self:GetParent():GetAbsOrigin()
            CustomGameEventManager:Send_ServerToPlayer(
                self:GetParent():GetPlayerOwner(),
                "check_if_location_on_screen",
                {
                    coord_x = location.x,
                    coord_y = location.y,
                    coord_z = location.z,
                    entindex = self:GetParent():entindex(),
                    reason = 1,
                }
            )
            local screen_effect = ParticleManager:CreateParticleForPlayer("particles/generic_gameplay/screen_death_indicator_flash.vpcf", PATTACH_EYES_FOLLOW, self:GetParent():GetPlayerOwner(), self:GetParent():GetPlayerOwner())
            ParticleManager:SetParticleControl(screen_effect, 1, Vector(1,0,0))
            ParticleManager:ReleaseParticleIndex(screen_effect)
        end
    end
end


function modifier_generic_take_damage_alert_lua:OnIntervalThink()
    self.ready = true
    self:StartIntervalThink(-1)
end

--------------------------------------------------------------------------------

function modifier_generic_take_damage_alert_lua:DeclareFunctions() 
    return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end
  
function modifier_generic_take_damage_alert_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end