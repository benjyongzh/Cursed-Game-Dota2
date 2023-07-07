illusionist_real_tornado_lua = class({})
LinkLuaModifier( "modifier_illusionist_real_tornado_lua", "modifiers/modifier_illusionist_real_tornado_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function illusionist_real_tornado_lua:GetAOERadius()
	return self:GetSpecialValueFor( "tornado_radius" )
end

function illusionist_real_tornado_lua:GetCastRange(vLocation, hTarget)
	local add = 0
	local abil = self:GetCaster():FindAbilityByName("illusionist_upgrade_1")
	if abil then
		if abil:GetLevel() > 0 then
			add = self:GetSpecialValueFor( "upgrade_cast_range" )
		end
	end

	return 150 + add
end

--------------------------------------------------------------------------------
-- Ability Start
function illusionist_real_tornado_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	
	-- load data

    --create trap
	local trap = CreateUnitByName(
		"fly_unit",
		self:GetCursorPosition(),
		true,
		caster,
		caster:GetOwner(),
		caster:GetTeamNumber()
	)

	--add effect modifier
	trap:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_illusionist_real_tornado_lua", -- modifier name
		{
			duration = self:GetSpecialValueFor("tornado_duration"),
			
			cycloneradius = self:GetSpecialValueFor("tornado_radius"),

			cycloneminheight = self:GetSpecialValueFor("cyclone_min_height"),
			cycloneinitialheight = self:GetSpecialValueFor("cyclone_initial_height"),
			cyclonemaxheight = self:GetSpecialValueFor("cyclone_max_height"),

			cycloneflytime = self:GetSpecialValueFor("tornado_lift_duration"),
			
			cycloneimmunetime = self:GetSpecialValueFor("tornado_immune_duration")
		} -- kv
	)
	
	--find fake ability and give cooldown

	local ability = caster:FindAbilityByName("illusionist_illusion_tornado_lua")
	if ability then
		ability:StartCooldown(self:GetSpecialValueFor("fake_tornado_cooldown"))
	end
end
