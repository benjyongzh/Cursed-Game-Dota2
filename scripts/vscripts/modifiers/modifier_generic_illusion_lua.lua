modifier_illusionist_conjure_image_illusion_lua = class({})

LinkLuaModifier("modifier_werewolf_day", "modifiers/modifier_werewolf_day", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_werewolf_night", "modifiers/modifier_werewolf_night", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Classifications
function modifier_illusionist_conjure_image_illusion_lua:IsHidden()
	return false
end

function modifier_illusionist_conjure_image_illusion_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_illusionist_conjure_image_illusion_lua:OnCreated( kv )
	-- references
	self.duration = kv.duration
	self.outgoing = kv.outgoing
	self.incoming = kv.incoming
	self.team = kv.team
	self.name = kv.name
	self.target_entindex = kv.target_unit_index
	self.isillusionist = kv.isillusionist
	print(self.isillusionist)
	if IsServer() then
		-- name label
		local teamID = self.team
		local color = ColorForTeam(teamID)
		local playername = self.name
		self:GetParent():SetCustomHealthLabel( playername, color[1], color[2], color[3] )

		if self.isillusionist then
			self:StartIntervalThink(0.1)
			self:OnIntervalThink()
		end
	end
end

function modifier_illusionist_conjure_image_illusion_lua:OnRefresh( kv )
	
end

function modifier_illusionist_conjure_image_illusion_lua:OnDestroy( kv )
	if IsServer() then
		-- sfx
		local effect_cast = ParticleManager:CreateParticle( "particles/generic_gameplay/illusion_killed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl(effect_cast, 0, self:GetParent():GetOrigin() + Vector(0,0,50))
		ParticleManager:ReleaseParticleIndex( effect_cast )

		self:GetParent():ForceKill( false )
		self:GetParent():SetModelScale(0.01)
	end
end

function modifier_illusionist_conjure_image_illusion_lua:OnIntervalThink()
	local caster = EntIndexToHScript(self.target_entindex)
	local illusion = self:GetParent()
	if IsInCursedForm(caster) then
		if caster:HasModifier("modifier_werewolf_day") then
			illusion:AddNewModifier(illusion, self:GetAbility(), "modifier_werewolf_day", {})
			illusion:SetCustomHealthLabel( "Werewolf", 200, 50, 50 )
		elseif caster:HasModifier("modifier_werewolf_night") then
			illusion:AddNewModifier(illusion, self:GetAbility(), "modifier_werewolf_night", {})
			illusion:SetCustomHealthLabel( "Werewolf", 200, 50, 50 )
		end

	else
		-- name label
		local teamID = self.team
		local color = ColorForTeam(teamID)
		local playername = self.name
		illusion:SetCustomHealthLabel( playername, color[1], color[2], color[3] )

		-- checking cursed modifiers
		local modifier1 = illusion:FindModifierByName("modifier_werewolf_day")
		local modifier2 = illusion:FindModifierByName("modifier_werewolf_night")
		if modifier1 then
			modifier1:Destroy()
		end
		if modifier2 then
			modifier2:Destroy()
		end
	end

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_illusionist_conjure_image_illusion_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE_ILLUSION,
		MODIFIER_PROPERTY_ILLUSION_LABEL,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_ILLUSION,
		MODIFIER_PROPERTY_IS_ILLUSION,

		MODIFIER_PROPERTY_LIFETIME_FRACTION,
	}

	return funcs
end

function modifier_illusionist_conjure_image_illusion_lua:GetModifierDamageOutgoing_Percentage_Illusion()
	return self.outgoing
end
function modifier_illusionist_conjure_image_illusion_lua:GetModifierIllusionLabel()
	return 1
end
function modifier_illusionist_conjure_image_illusion_lua:GetModifierIncomingDamage_Illusion()
	return self.incoming
end
function modifier_illusionist_conjure_image_illusion_lua:GetIsIllusion()
	return 1
end 

function modifier_illusionist_conjure_image_illusion_lua:GetUnitLifetimeFraction( params )
	return ( ( self:GetDieTime() - GameRules:GetGameTime() ) / self:GetDuration() )
end
--------------------------------------------------------------------------------
-- Graphics & Animations
-- function modifier_illusionist_conjure_image_illusion_lua:GetEffectName()
-- 	return "particles/string/here.vpcf"
-- end

-- function modifier_illusionist_conjure_image_illusion_lua:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end