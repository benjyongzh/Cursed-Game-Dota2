tracker_trap_lua = class({})
LinkLuaModifier( "modifier_tracker_trap_charges_lua", "modifiers/modifier_tracker_trap_charges_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tracker_trap_lua", "modifiers/modifier_tracker_trap_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tracker_snare_debuf_lua", "modifiers/modifier_tracker_snare_debuff_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_trap_unit", "modifiers/modifier_trap_unit", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
--Passive Modifier
function tracker_trap_lua:GetIntrinsicModifierName()
	return "modifier_tracker_trap_charges_lua"
end

function tracker_trap_lua:GetCastPoint()
	local reduction = 0
	local abil = self:GetCaster():FindAbilityByName("scout_upgrade_1")
	if abil then
		if abil:GetLevel() > 0 then
			reduction = self:GetSpecialValueFor( "upgrade_cast_point" )
		end
	end

	return 1.2 - reduction
end

--------------------------------------------------------------------------------
-- Ability Start
function tracker_trap_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor("duration")

    --create trap
	self.trap = CreateUnitByName(
		"trap_unit",
		self:GetCursorPosition(),
		true,
		caster,
		caster:GetOwner(),
		caster:GetTeamNumber()
	)

	--add effect modifier
	self.trap:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_tracker_trap_lua", -- modifier name
		{
			duration = duration,
		} -- kv
	)

end