assassin_invis_lua = class({})
LinkLuaModifier( "modifier_assassin_invis_lua", "modifiers/modifier_assassin_invis_lua", LUA_MODIFIER_MOTION_NONE )

------------------------------------------------------------------

-- Toggle
function assassin_invis_lua:OnToggle()
	-- unit identifier
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName( "modifier_assassin_invis_lua" )

	if self:GetToggleState() then
		if not modifier then
			if caster:IsAlive() then
				caster:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_assassin_invis_lua", -- modifier name
					{} -- kv
				)
				local sound_cast = "Hero_TemplarAssassin.Meld"
				EmitSoundOn( sound_cast, caster )
				--ParticleManager:DestroyParticle( self.effect_precast, true )
			else
				self:ToggleAbility()
			end
		end
	else
		if modifier then
			--remove invis modifier
			modifier:Destroy()
		end
	end
end


function assassin_invis_lua:ProcsMagicStick()
	return false
end