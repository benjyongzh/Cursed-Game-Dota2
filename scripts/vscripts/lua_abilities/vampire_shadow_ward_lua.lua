vampire_shadow_ward_lua = class({})
LinkLuaModifier( "modifier_vampire_shadow_ward_lua", "modifiers/modifier_vampire_shadow_ward_lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
function vampire_shadow_ward_luaOnAbilityPhaseStart()

	local position = self:GetCursorPosition()
	local caster = self:GetCaster()
	local player_id = caster:GetPlayerOwnerID()

	if position.z < 100 then
		return true 
	else 
		SendErrorMessage(player_id, "You can only place the ward on lower ground")
		return false
	end			
end	

--------------------------------------------------------------------------------
-- Ability Start
function vampire_shadow_ward_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor("duration")

    --create trap
	local unit = CreateUnitByName(
		"vampire_ward_unit",
		self:GetCursorPosition(),
		true,
		caster,
		caster:GetOwner(),
		caster:GetTeamNumber()
	)

	--add effect modifier
	unit:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_vampire_shadow_ward_lua", -- modifier name
		{
			duration = duration,
		} -- kv
	)

end