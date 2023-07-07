-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
illusionist_flicker_lua = class({})
--------------------------------------------------------------------------------
-- Ability Unit Filter Check

function illusionist_flicker_lua:CastFilterResultTarget( hTarget )
	if hTarget:IsBuilding() or hTarget:GetUnitName() == "spire" then
		return UF_FAIL_BUILDING
	end
	if hTarget:HasModifier("modifier_werewolf_day_lua") or hTarget:HasModifier("modifier_werewolf_night_lua") or hTarget:GetUnitName() == "zombie_main_unit" then
		return UF_FAIL_OTHER
	end
	return UF_SUCCESS
end

function illusionist_flicker_lua:GetCustomCastErrorTarget( hTarget )
	if hTarget:IsBuilding() or hTarget:GetUnitName() == "spire" then
		return "#dota_hud_error_cant_cast_on_building"
	elseif hTarget:HasModifier("modifier_werewolf_day_lua") or hTarget:HasModifier("modifier_werewolf_night_lua") or hTarget:GetUnitName() == "zombie_main_unit" then
		return "Cannot cast on Cursed Form"
	end
	return ""
end

function illusionist_flicker_lua:OnAbilityPhaseStart()
	EmitSoundOnLocationForAllies(self:GetCaster():GetAbsOrigin(), "Hero_ShadowShaman.Shackles.Cast", self:GetCaster())
	self.effect_precast1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_lich/lich_chain_frost_c_rubick.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(self.effect_precast1, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff", self:GetCaster():GetOrigin(), true)
	self.effect_precast2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_shadowshaman/shadow_shaman_ward_base_attack_trail_c_rubick.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(self.effect_precast2, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff", self:GetCaster():GetOrigin(), true)
	
	return true -- if success
end

function illusionist_flicker_lua:OnAbilityPhaseInterrupted()
	StopSoundOn( "Hero_ShadowShaman.Shackles.Cast", self:GetCaster() )
	ParticleManager:DestroyParticle( self.effect_precast1, true )
	ParticleManager:DestroyParticle( self.effect_precast2, true )
end

-- Ability Start
function illusionist_flicker_lua:OnSpellStart()
	-- get references
	local distance = self:GetSpecialValueFor("distance")
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local unit_name = target:GetUnitName()
	
	----player
	local playerid = caster:GetPlayerOwnerID()
	local player_hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()

	-- target temp remove unit collision
	target:AddNewModifier( caster, self, "modifier_phased", {duration = 0.1} )

	local times = 1
	-- create another illusion if upgrade 3 available
	local abil = caster:FindAbilityByName("illusionist_upgrade_3")
	if abil then
		if abil:GetLevel() > 0 then
			times = self:GetSpecialValueFor("upgrade_multiple")
		end
	end

	local illusion = {}
	local location = {}
	-- create illusion
	for i=1,times,1 do
		illusion[i] = self:CreateIllusion(target)

		-- find new location
		location[i] = target:GetAbsOrigin() + RandomVector(distance)
		local trees = GridNav:GetAllTreesAroundPoint(location[i], self:GetSpecialValueFor( "tree_check_radius" ), true)
		local counter = 0
		while (counter < 500) and (not GridNav:IsTraversable(location[i]) or #trees>0) do
			location[i] = target:GetAbsOrigin() + RandomVector(distance)
			trees = GridNav:GetAllTreesAroundPoint(location[i], self:GetSpecialValueFor( "tree_check_radius" ), true)
			counter = counter + 1
		end

		-- destroy trees
		--[[
		local trees = GridNav:GetAllTreesAroundPoint( location[i], self:GetSpecialValueFor( "tree_destroy_radius" ), true )
		for _,tree in pairs(trees) do
			if tree:IsStanding() then
				tree:CutDown(caster:GetTeam())
			end
		end
		]]
	end
	
	-- sfx
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/events/ti8/blink_dagger_ti8_start_lvl2.vpcf", PATTACH_ABSORIGIN, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Antimage.Blink_out", caster)

	-- set new table of possible units to move around
	local units = {}
	table.insert(units, target)
	for i=1,times,1 do
		table.insert(units, illusion[i])
	end

	-- movements
	local rndm = math.random(1,times + 1)
	if rndm < 2 then
		-- move target + illusion if upgraded
		for i=1,times,1 do
			FindClearSpaceForUnit(units[i], location[i], true)
			self:PlayEffects(units[i])
		end
		
	else
		-- move only illusions
		for i=1,times,1 do
			FindClearSpaceForUnit(units[i+1], location[i], true)
			self:PlayEffects(units[i+1])
		end
	end

	-- order illusions random movement
	Timers:CreateTimer(0.1,function()
		for _,unit in pairs(illusion) do
			local pt = unit:GetAbsOrigin() + (unit:GetForwardVector() * distance)
			unit:MoveToPosition(pt)
			--PlayerResource:AddToSelection(playerid, unit)
		end
	end)
	

	-- sfx for caster
	if self.effect_precast1 then
		ParticleManager:DestroyParticle( self.effect_precast1, true )
	end
	if self.effect_precast2 then
		ParticleManager:DestroyParticle( self.effect_precast2, true )
	end
end

function illusionist_flicker_lua:CreateIllusion(target)
	local caster = self:GetCaster()
	local unit_name = target:GetUnitName()
	local duration = self:GetSpecialValueFor("duration")
	
	----player
	local playerid = caster:GetPlayerOwnerID()
	local player_hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()

	local illusion = CreateUnitByName(unit_name, target:GetAbsOrigin(), true, player_hero, nil, caster:GetTeamNumber())
	illusion:SetControllableByPlayer(playerid, true)
	illusion:SetForwardVector(target:GetForwardVector())
	illusion:AddNewModifier( caster, self, "modifier_phased", {duration = 0.1} )
	
	-- abils
	local target_level = target:GetLevel()
	for i = 1, target_level - 1 do
		illusion:HeroLevelUp(false)
	end		

	-- items
	for item_slot = 0, 5 do
		local item = target:GetItemInSlot(item_slot) 
		if item then
			local item_name = item:GetName() 
			local new_item = CreateItem(item_name, illusion, illusion) 
			illusion:AddItem(new_item) 
		end
	end

	illusion:MakeIllusion()

	--name label
	if target:IsConsideredHero() then
		local teamID = target:GetTeam()
		local color = ColorForTeam(teamID)
		local playername = PlayerResource:GetPlayerName(target:GetPlayerOwnerID())
		illusion:SetCustomHealthLabel( playername, color[1], color[2], color[3] )
	end

	-- generic illusion modifier
	local abil = caster:FindAbilityByName("illusionist_conjure_image_lua")
	local outgoing = 0
	local incoming = 0
	if abil then
		outgoing = abil:GetSpecialValueFor("outgoing_damage_data")
		incoming = abil:GetSpecialValueFor("incoming_damage_total_pct_data")
	end
	illusion:AddNewModifier(caster, self, "modifier_illusion",
		{
			duration = duration,
			outgoing_damage = outgoing,
			incoming_damage = incoming,
		}
	)

	-- set stats
	Game_Events:MatchIllusionGenericUpgrades(illusion, target)
	illusion:SetHealth(target:GetHealth())

	return illusion
end

function illusionist_flicker_lua:PlayEffects(unit)
	-- particle
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/events/ti8/blink_dagger_ti8_end_lvl2.vpcf", PATTACH_ABSORIGIN, unit )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Hero_Antimage.Blink_in", self:GetCaster())
	EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Hero_Antimage.Blink_in", unit)
end