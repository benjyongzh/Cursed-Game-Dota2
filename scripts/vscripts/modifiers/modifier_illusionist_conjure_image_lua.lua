modifier_illusionist_conjure_image_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_illusionist_conjure_image_lua:IsHidden()
	return true
end

function modifier_illusionist_conjure_image_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_illusionist_conjure_image_lua:OnCreated( keys )
	
	if IsServer() then

		local caster = self:GetCaster() -- This is the caster of conjure image
		local target = self:GetParent()
		local target_location = target:GetAbsOrigin()
		local ability = self:GetAbility()
		local unit_name = target:GetUnitName()
		local illusion_origin = target_location + RandomVector(100)
	
		----player
		local player = caster:GetPlayerOwnerID()
		local player_hero = PlayerResource:GetPlayer(player):GetAssignedHero()

		local illusion = CreateUnitByName(unit_name, illusion_origin, true, player_hero, nil, caster:GetTeamNumber())
	
		--illusion:SetPlayerID(player)
		illusion:SetControllableByPlayer(player, true)
		
		local target_level = target:GetLevel()
		for i = 1, target_level - 1 do
			illusion:HeroLevelUp(false)
		
		end		

		for item_slot = 0, 5 do
			local item = target:GetItemInSlot(item_slot) 
			if item then
				local item_name = item:GetName() 
				local new_item = CreateItem(item_name, illusion, illusion) 
				illusion:AddItem(new_item) 
			end
		end
			
		illusion:MakeIllusion()

		-- generic illusion modifier
		illusion:AddNewModifier(
				caster,
				ability,
				"modifier_illusion",
				{
					duration = ability:GetSpecialValueFor("illusion_duration"),
					--outgoing_damage = ability:GetSpecialValueFor("outgoing_damage_data_cursed"),
					--incoming_damage = ability:GetSpecialValueFor("incoming_damage_total_pct_data"),
				}
			)

		-- additional modifier for illusion. check if target is illusionist himself. set name label. etc
		local targetiscaster = false
		if target == caster then
			targetiscaster = true
		end
		illusion:AddNewModifier(
			caster,
			ability,
			"modifier_illusionist_conjure_image_illusion_lua",
			{
				--duration = ability:GetSpecialValueFor("illusion_duration"),
				--outgoing_damage = ability:GetSpecialValueFor("outgoing_damage_data"),
				--incoming_damage = ability:GetSpecialValueFor("incoming_damage_total_pct_data"),
				team = target:GetTeam(),
				name = PlayerResource:GetPlayerName(target:GetPlayerOwnerID()),
				target_unit_index = target:entindex(),
				isillusionist = targetiscaster,
			}
		)

		-- stats
		Game_Events:MatchIllusionGenericUpgrades(illusion, target)
		illusion:SetHealth(target:GetHealth())
	end
end

function modifier_illusionist_conjure_image_lua:OnRefresh( kv )
	
end

function modifier_illusionist_conjure_image_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_illusionist_conjure_image_lua:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end


---------------------------------------------------------------
	--[[Create unit
	local illusion = CreateUnitByNameAsync(
		unit_name, -- szUnitName
		location, -- vLocation,
		false, -- bFindClearSpace,
		caster, -- hNPCOwner,
		nil, -- hUnitOwner,
		caster:GetTeamNumber(), -- iTeamNumber
		modifyIllusion
	)

	return illusion
end]]