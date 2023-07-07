defender_energy_shield_lua = class({})
LinkLuaModifier( "modifier_defender_energy_shield_lua", "modifiers/modifier_defender_energy_shield_lua", LUA_MODIFIER_MOTION_NONE )

function defender_energy_shield_lua:OnUpgrade()
    -- init
    self.parent = self:GetCaster()
    self.owner = self:GetCaster():entindex() -- defender
    self.max_hp = self:GetSpecialValueFor("hp")
    self.fullregendelay = self:GetSpecialValueFor( "regen_delay" )

    -- check for upgrade hp
    local upgrade2 = self.parent:FindAbilityByName("defender_upgrade_2")
	if upgrade2 then
		if upgrade2:GetLevel() > 0 then
			self.max_hp = self.max_hp + self:GetSpecialValueFor( "upgrade_hp" )
		end
    end
    
    -- check for upgrade regen delay
    local upgrade3 = self.parent:FindAbilityByName("defender_upgrade_2")
	if upgrade3 then
		if upgrade3:GetLevel() > 0 then
			self.fullregendelay = self.fullregendelay - self:GetSpecialValueFor( "upgrade_regen_delay_reduction" )
		end
    end

    self.regendelay = 0
    self.parent:AddNewModifier(self:GetCaster(), self, "modifier_defender_energy_shield_lua", {hp = self.max_hp, regendelay = self.regendelay, ownerindex = self.owner})

    -- worldpanels for shieldbar display
    local modifier = self.parent:FindModifierByName("modifier_defender_energy_shield_lua")
    if modifier then
        if modifier.worldpanel == nil then
            modifier.worldpanel = WorldPanels:CreateWorldPanelForAll(
                {layout = "file://{resources}/layout/custom_game/worldpanels/defender_energy_shield.xml",
                entity = self.parent,
                entityHeight = 200,
                data = {current_shield = modifier:GetStackCount(), max_shield = self.max_hp}
            })
        end
    end
end

-- Ability cast on building
function defender_energy_shield_lua:CastFilterResultTarget( hTarget )
	if IsBuildingOrSpire(hTarget) then
		return UF_FAIL_BUILDING
    end
    if hTarget == self:GetCaster() then
		return UF_FAIL_OTHER
	end
	return UF_SUCCESS
end

function defender_energy_shield_lua:GetCustomCastErrorTarget( hTarget )
	if IsBuildingOrSpire(hTarget) then
		return "#dota_hud_error_cant_cast_on_building"
    end
    if hTarget == self:GetCaster() then
		return "Cannot cast on self"
	end
	return ""
end

function defender_energy_shield_lua:OnSpellStart()
    local caster = self:GetCaster()
	local target = self:GetCursorTarget()
    local modifiercaster = caster:FindModifierByName("modifier_defender_energy_shield_lua")

    local shield_hp = nil
    local regen_delay = nil
    -- making sure the defender is the owner of the shield. if not, then relinquish whoever is the current owner first
    if modifiercaster and self.parent == caster then
        if target:IsAlive() and IsValidEntity(target) then
            shield_hp = modifiercaster:GetStackCount()
            regen_delay = modifiercaster.regendelay
            modifiercaster:Destroy()
        end
    else
        if self.parent ~= caster then
            if self.parent:IsAlive() and IsValidEntity(self.parent) then
                local modifierothers = self.parent:FindModifierByName("modifier_defender_energy_shield_lua")
                if modifierothers then
                    shield_hp = modifierothers:GetStackCount()
                    regen_delay = modifierothers.regendelay
                    modifierothers:Destroy()
                end
            end
        end
    end
    target:AddNewModifier(caster, self, "modifier_defender_energy_shield_lua", {duration = self:GetSpecialValueFor("duration"),  hp = shield_hp, regendelay = regen_delay, ownerindex = self.owner})
    -- pass possession
    self.parent = target
end