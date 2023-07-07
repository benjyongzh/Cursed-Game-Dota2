modifier_rifleman_headshot_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_rifleman_headshot_lua:IsHidden()
	return true
end

function modifier_rifleman_headshot_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_rifleman_headshot_lua:OnCreated( kv )
	-- references
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" ) -- special value
	self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" ) -- special value
	if IsServer() then
		self.damage = self:GetAbility():GetAbilityDamage()
	end
end

function modifier_rifleman_headshot_lua:OnRefresh( kv )
	-- references
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" ) -- special value
	self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" ) -- special value
	if IsServer() then
		self.damage = self:GetAbility():GetAbilityDamage()
	end
end

function modifier_rifleman_headshot_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_rifleman_headshot_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}

	return funcs
end

function modifier_rifleman_headshot_lua:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then
		-- roll dice
		if RandomInt(1,100)<=self.proc_chance and not IsBuildingOrSpire(params.target) then
			params.target:AddNewModifier(
				self:GetParent(), -- player source
				self, -- ability source
				"modifier_generic_stunned_lua", -- modifier name
				{ 
					duration = self.stun_duration,
				} -- kv
            )
            
            --sfx
            EmitSoundOn("Hero_Sniper.AssassinateDamage", params.target)
            local particle = "particles/units/heroes/hero_sniper/sniper_assassinate_impact_blood.vpcf"
            local effect_cast = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, params.target )
            ParticleManager:SetParticleControlEnt(effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
            ParticleManager:SetParticleControlEnt(effect_cast, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetOrigin(), true)
            ParticleManager:ReleaseParticleIndex( effect_cast )
    
			return self.damage
		end
	end
end