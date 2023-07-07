--------------------------------------------------------------------------------
modifier_spawn_sheep_lua = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_spawn_sheep_lua:IsHidden()
	return true
end

function modifier_spawn_sheep_lua:IsDebuff()
	return false
end

function modifier_spawn_sheep_lua:IsPurgable()
	return false
end

function modifier_spawn_sheep_lua:DestroyOnDeath()
	return true
end

function modifier_spawn_sheep_lua:OnCreated()
	
	if IsServer() then
    -- references
		local caster = self:GetParent()
		local hPlayer = caster:GetPlayerOwner()
        self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("spawn_interval"))
    end
end

function modifier_spawn_sheep_lua:OnRefresh()
	-- references
    
	if IsServer() then
        self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("spawn_interval"))
    end
end

function modifier_spawn_sheep_lua:OnIntervalThink()
	if not self:GetParent():IsAlive() then return end
	if IsServer() then

		local caster = self:GetParent()
		local hPlayer = caster:GetPlayerOwner()
		local player_ID = caster:GetPlayerOwnerID()
		local sheep_limit = self:GetAbility():GetSpecialValueFor("sheep_limit")

		if Resources:HasEnoughSheepLimit( player_ID, 1 ) then
		
			local team_number = PlayerResource:GetTeam(player_ID)
			local hero = PlayerResource:GetSelectedHeroEntity(player_ID)
			local unit_name = nil
			local modifier = nil
			local abil = nil
			--------------------------different sheep------------------------------------------
			math.randomseed(GameRules:GetGameTime())
			local random_no = math.random()
			print(random_no)
			local gold_sheep_chance = self:GetAbility():GetSpecialValueFor("gold_sheep_chance_pct")/100
			
			if random_no < gold_sheep_chance then
				unit_name = "gold_sheep"
			else
				unit_name = "white_sheep"
			end    
			
			-- spawn sheep
			local sheep = CreateUnitByName(unit_name, caster:GetAbsOrigin()+(caster:GetForwardVector():Normalized()*150), true, hero, hPlayer, team_number)
			sheep:SetOwner(hero)
			sheep:SetControllableByPlayer(player_ID, true)
			EmitSoundOn( "Hero_ShadowShaman.SheepHex.Target", sheep)
			sheep:SetMana(0)
			InitAbilities( sheep )

			-- add sheep into table of units
			table.insert(hPlayer.Units, sheep)
			
			-- add player's sheep count
			Resources:ModifySheeps( player_ID, 1 )
		end
	end
end

