illusionist_illusion_tornado_lua = class({})
LinkLuaModifier( "modifier_illusionist_illusion_tornado_lua", "modifiers/modifier_illusionist_illusion_tornado_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function illusionist_illusion_tornado_lua:GetAOERadius()
	return self:GetSpecialValueFor( "tornado_radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function illusionist_illusion_tornado_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	
	-- load data
	local spell_duration = self:GetSpecialValueFor("duration")

    --create trap
	self.trap = CreateUnitByName(
		"fly_unit",
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
		"modifier_illusionist_illusion_tornado_lua", -- modifier name
		{
			duration = spell_duration
		} -- kv
	)
	
	--find fake ability and give cooldown
	local ability = caster:FindAbilityByName("illusionist_real_tornado_lua")
	ability:StartCooldown(self:GetSpecialValueFor("real_tornado_cooldown"))
end
