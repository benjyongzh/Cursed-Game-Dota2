modifier_tracker_trap_lua = class({})

LinkLuaModifier( "modifier_tracker_trap_debuff_lua", "modifiers/modifier_tracker_trap_debuff_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Classifications
function modifier_tracker_trap_lua:IsHidden()
	return false
end

function modifier_tracker_trap_lua:IsDebuff()
	return false
end

function modifier_tracker_trap_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tracker_trap_lua:OnCreated( kv )
	if IsServer() then

	self.ability = self:GetAbility()
	self.effect_radius = self:GetAbility():GetSpecialValueFor("trap_effect_radius")
	self.sound_radius = self:GetAbility():GetSpecialValueFor("trap_sound_radius")

	self.tick_rate = self:GetAbility():GetSpecialValueFor("trap_effect_tick_rate")
	self.sound_rate = self:GetAbility():GetSpecialValueFor("trap_sound_tick_rate")
	self.tick_count = 0

	self.trap_duration = self:GetAbility():GetSpecialValueFor("trap_effect_duration")

	self:StartIntervalThink(self.tick_rate)
	self:OnIntervalThink()
	end
end

function modifier_tracker_trap_lua:OnIntervalThink()

	local trap_origin = self:GetParent():GetOrigin()
	local caster = self:GetParent():GetTeam()
	self.parent = self:GetParent()

	--================================= find enemies for actual catching ===========================
	units = FindUnitsInRadius(
	caster,	-- int, your team number
	trap_origin,	-- point, center point
	nil,	-- handle, cacheUnit. (not known)
	self.effect_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
	DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
	0,	-- int, flag filter
	FIND_CLOSEST,	-- int, order filter
	false	-- bool, can grow cache
	)
	if #units > 0 then
		for _,enemy in pairs(units) do
			if not IsBuildingOrSpire(enemy) and not IsInAir(enemy) then
				--data
				local sound_cast = "Hero_Techies.LandMine.Priming"
				EmitSoundOn( sound_cast, self.parent )
	
				enemy:AddNewModifier(
					self:GetParent(), -- player source
					self.ability, -- ability source
					"modifier_tracker_trap_debuff_lua", -- modifier name
					{ duration = self.trap_duration } -- kv
				)
					
				local sound_cast = "Conquest.SpikeTrap.Activate"
				EmitSoundOn( sound_cast, self.parent )	

				self:GetParent():ForceKill(true)	
			end
		end		
	end


	--================================== trap sounds =====================================
	self.tick_count = self.tick_count + 1

	if self.tick_count >= (self.sound_rate/self.tick_rate) then
		----find enemies to sound sound effects of land trap
		sound_units = FindUnitsInRadius(
			caster,	-- int, your team number
			trap_origin,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.sound_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
			)

		if #sound_units > 0 then
			local not_buildings = 0
			for _,unit in pairs(sound_units) do
				if not IsBuildingOrSpire(unit) then
					not_buildings = not_buildings + 1
				end
			end
			if not_buildings > 0 then
				local sound_cast = "Hero_Techies.LandMine.Priming"
				EmitSoundOn( sound_cast, self.parent )
			end
		end
		self.tick_count = 0
	end
end

function modifier_tracker_trap_lua:OnDestroy( kv )
	--sfx

end
--[[
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_tracker_trap_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}

	return funcs
end


function modifier_tracker_trap_lua:GetModifierInvisibilityLevel()
	return 1
end


--------------------------------------------------------------------------------
-- Status Effects


function modifier_tracker_trap_lua:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
	}

	return state
end
]]

--destroy dumm on expire
function modifier_tracker_trap_lua:DestroyOnExpire()
    return true
end

function modifier_tracker_trap_lua:IsPurgable()
    return false
end

function modifier_tracker_trap_lua:OnDestroy()
    if IsServer() then
            --delete the damn summon
        self:GetParent():ForceKill(false)
    end
end


