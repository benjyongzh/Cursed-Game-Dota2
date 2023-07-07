ghost_invis_lua = class({})
LinkLuaModifier( "modifier_ghost_invis_lua", "modifiers/modifier_ghost_invis_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ghost_invis_sfx_lua", "modifiers/modifier_ghost_invis_sfx_lua", LUA_MODIFIER_MOTION_NONE )

------------------------------------------------------------------

--function ghost_invis_lua:GetIntrinsicModifierName()
--	return "modifier_ghost_invis_sfx_lua"
--end

-- Toggle
function ghost_invis_lua:OnToggle()
	-- unit identifier
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName( "modifier_ghost_invis_lua" )

	if self:GetToggleState() then
		if not modifier then
			if caster:IsAlive() then
				caster:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_ghost_invis_lua", -- modifier name
					{delay= self:GetSpecialValueFor("fade_time")} -- kv
				)

				-- create dummy unit for SFX
				local entindex = caster:GetEntityIndex()
				self.sfx_unit = CreateUnitByName("ghost_sfx_dummy_unit", caster:GetAbsOrigin(), true, caster, caster:GetOwner(), caster:GetTeamNumber())
				self.sfx_unit:AddNewModifier(caster, self, "modifier_ghost_invis_sfx_lua", {duration = nil, ent_index = entindex, sfxinterval = self:GetSpecialValueFor("sfx_interval")})
			else
				self:ToggleAbility()
			end
		end
	else
		if modifier then
			--remove invis modifier
			modifier:Destroy()
		end
		-- sfx dummy unit gets removed in its modifier lua file
	end
end

function ghost_invis_lua:ProcsMagicStick()
	return false
end