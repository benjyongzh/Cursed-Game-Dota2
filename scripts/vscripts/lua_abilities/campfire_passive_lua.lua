campfire_passive_lua = class({})
LinkLuaModifier("modifier_campfire_passive_lua", "modifiers/modifier_campfire_passive_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_campfire_passive_lua_heal", "modifiers/modifier_campfire_passive_lua_heal", LUA_MODIFIER_MOTION_NONE)

function campfire_passive_lua:GetAbilityTextureName()
	return "troll_warlord_fervor"
end

function campfire_passive_lua:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

function campfire_passive_lua:OnToggle()
    local modifier = self:GetCaster():FindModifierByName( "modifier_campfire_passive_lua" )
    if self:GetToggleState() then
        if not modifier then
            if Resources:HasEnoughLumber( self:GetCaster():GetPlayerOwnerID(), 1 ) then
                self:GetCaster():AddNewModifier(
                    self:GetCaster(), -- player source
                    self, -- ability source
                    "modifier_campfire_passive_lua", -- modifier name
                    {} -- kv
                )
                EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration", self:GetCaster())
                EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetCaster())
            else
                --SendErrorMessage(playerID, "#error_not_enough_lumber")
                self:ToggleAbility()
            end
		end

    else
        if modifier then
            --remove invis modifier
            modifier:Destroy()
            EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Off", self:GetCaster())
            StopSoundEvent("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetCaster())
		end
    end
end