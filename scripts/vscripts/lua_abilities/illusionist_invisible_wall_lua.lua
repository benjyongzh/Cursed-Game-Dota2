illusionist_invisible_wall_lua = class({})
LinkLuaModifier( "modifier_illusionist_invisible_wall_lua_dummy", "modifiers/modifier_illusionist_invisible_wall_lua_dummy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_illusionist_invisible_wall_lua_charges", "modifiers/modifier_illusionist_invisible_wall_lua_charges", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

-- Passive Modifier
function illusionist_invisible_wall_lua:GetIntrinsicModifierName()
	return "modifier_illusionist_invisible_wall_lua_charges"
end


function illusionist_invisible_wall_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function illusionist_invisible_wall_lua:OnSpellStart()
    local caster = self:GetCaster()
    local location = self:GetCursorPosition()
    local duration = self:GetSpecialValueFor("duration")
    local radius = self:GetSpecialValueFor("radius")

    local dummy = CreateUnitByName(
		"dummy_unit",
		location,
		true,
		caster,
		caster:GetOwner(),
		caster:GetTeamNumber()
    )

    location = dummy:GetOrigin() -- register location as dummy's location
    dummy:SetNeverMoveToClearSpace(true)

	dummy:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_illusionist_invisible_wall_lua_dummy", -- modifier name
		{ duration = self:GetSpecialValueFor("duration"), aoe = radius } -- kv
    )

    --dummy:SetModel(ILLUSIONIST_WALL_3D_MODEL)

    local units = FindUnitsInRadius(
		caster:GetTeamNumber(),
		location,
		nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    for _,unit in pairs(units) do
        if (not IsBuildingOrSpire(unit)) and (not unit:HasModifier("modifier_illusionist_invisible_wall_lua_dummy")) then
            FindClearSpaceForUnit( unit, unit:GetOrigin(), true )
        end
    end

end
