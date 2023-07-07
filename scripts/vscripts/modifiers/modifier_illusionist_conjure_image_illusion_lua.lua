modifier_illusionist_conjure_image_illusion_lua = class({})

LinkLuaModifier("modifier_werewolf_day", "modifiers/modifier_werewolf_day", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_werewolf_night", "modifiers/modifier_werewolf_night", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Classifications
function modifier_illusionist_conjure_image_illusion_lua:IsHidden()
	return true
end

function modifier_illusionist_conjure_image_illusion_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_illusionist_conjure_image_illusion_lua:OnCreated( kv )
	-- references
	--self.outgoing = kv.outgoing
    --self.incoming = kv.incoming
    
    self.outgoing = self:GetAbility():GetSpecialValueFor("outgoing_damage_data")
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming_damage_total_pct_data")
	self.team = kv.team
	self.name = kv.name
	self.target_entindex = kv.target_unit_index
	self.isillusionist = kv.isillusionist
	if IsServer() then
		if self:GetParent():IsConsideredHero() then
			-- name label
			local teamID = self.team
			local color = ColorForTeam(teamID)
			local playername = self.name
			self:GetParent():SetCustomHealthLabel( playername, color[1], color[2], color[3] )

			if self.isillusionist > 0 then
				self:StartIntervalThink(0.1)
				self:OnIntervalThink()
			end
		end
	end
end

function modifier_illusionist_conjure_image_illusion_lua:OnRefresh( kv )
	
end

function modifier_illusionist_conjure_image_illusion_lua:OnDestroy( kv )
end

function modifier_illusionist_conjure_image_illusion_lua:OnIntervalThink()
	local caster = EntIndexToHScript(self.target_entindex)
	local illusion = self:GetParent()
    if IsInCursedForm(caster) then
        -- damage data
        self.outgoing = self:GetAbility():GetSpecialValueFor("outgoing_damage_data_cursed")

        local modifier1 = illusion:FindModifierByName("modifier_werewolf_day")
        local modifier2 = illusion:FindModifierByName("modifier_werewolf_night")
        local modifier3 = illusion:FindModifierByName("modifier_vampire_day")
        local modifier4 = illusion:FindModifierByName("modifier_vampire_night")

        if caster:HasModifier("modifier_werewolf_day") then
            if not modifier1 and not modifier2 then
                illusion:AddNewModifier(illusion, self:GetAbility(), "modifier_werewolf_day", {})
            end
			illusion:SetCustomHealthLabel( "Werewolf", 200, 50, 50 )
        elseif caster:HasModifier("modifier_werewolf_night") then
            if not modifier1 and not modifier2 then
                illusion:AddNewModifier(illusion, self:GetAbility(), "modifier_werewolf_night", {})
            end
			illusion:SetCustomHealthLabel( "Werewolf", 200, 50, 50 )
        elseif caster:HasModifier("modifier_vampire_day") then
            if not modifier1 and not modifier2 then
                illusion:AddNewModifier(illusion, self:GetAbility(), "modifier_vampire_day", {})
            end
			illusion:SetCustomHealthLabel( "Vampire", 200, 50, 50 )
        elseif caster:HasModifier("modifier_vampire_night") then
            if not modifier1 and not modifier2 then
                illusion:AddNewModifier(illusion, self:GetAbility(), "modifier_vampire_night", {})
            end
			illusion:SetCustomHealthLabel( "Vampire", 200, 50, 50 )
        end

	else
        -- damage data
        self.outgoing = self:GetAbility():GetSpecialValueFor("outgoing_damage_data")

		-- name label
		local teamID = self.team
		local color = ColorForTeam(teamID)
		local playername = self.name
		illusion:SetCustomHealthLabel( playername, color[1], color[2], color[3] )

		-- checking cursed modifiers
		local modifier1 = illusion:FindModifierByName("modifier_werewolf_day")
		local modifier2 = illusion:FindModifierByName("modifier_werewolf_night")
		local modifier3 = illusion:FindModifierByName("modifier_vampire_day")
		local modifier4 = illusion:FindModifierByName("modifier_vampire_night")
		if modifier1 then
			modifier1:Destroy()
		end
		if modifier2 then
			modifier2:Destroy()
		end
		if modifier3 then
			modifier3:Destroy()
		end
		if modifier4 then
			modifier4:Destroy()
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