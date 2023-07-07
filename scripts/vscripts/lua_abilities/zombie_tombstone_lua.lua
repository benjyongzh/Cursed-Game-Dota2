zombie_tombstone_lua = class({})
LinkLuaModifier( "modifier_zombie_tombstone_lua", "modifiers/modifier_zombie_tombstone_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function zombie_tombstone_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor("duration")

    local playerid = caster:GetPlayerOwnerID()
    local hPlayer = caster:GetPlayerOwner()
    local omniknight = GetFakeHero(playerid)
    --create tombstone
	local unit = CreateUnitByName("zombie_tombstone_unit", point, true, omniknight, hPlayer, PlayerResource:GetTeam(playerid))
    unit:SetOwner(omniknight)

	--add effect modifier
	unit:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_zombie_tombstone_lua", -- modifier name
		{
			duration = duration,
		} -- kv
	)

end