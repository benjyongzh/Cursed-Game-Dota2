modifier_druid_summons_lua = class({})
--------------------------------------------------------------------------------

function modifier_druid_summons_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_druid_summons_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_druid_summons_lua:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_druid_summons_lua:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function modifier_druid_summons_lua:OnDestroy()
	if IsServer() then
			
		local unit = self:GetParent()
		--check the unit name of the summon
		if unit:GetUnitName() == "druid_boar_summon" then
			--sfx
			EmitSoundOn("Hero_Beastmaster_Boar.Death", unit)
			self:GetAbility():GetCaster().has_a_summoned_boar = false
		elseif unit:GetUnitName() == "druid_bird_summon" then
			--sfx
			EmitSoundOn("Hero_Beastmaster_Bird.Death", unit)
			self:GetAbility():GetCaster().has_a_summoned_bird = false
		end

		--give vision
		AddFOWViewer( unit:GetTeamNumber(), unit:GetOrigin(), 800, 2.0, true )

		--delete the damn summon
		unit:ForceKill(false)
	end
end

--------------------------------------------------------------------------------

function modifier_druid_summons_lua:OnCreated(kv)
	if IsServer() then
		local unit = self:GetParent()
		local caster = kv.spell_caster
	end
end
