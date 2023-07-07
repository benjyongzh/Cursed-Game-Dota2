modifier_illusionist_real_tornado_lua = class({})
LinkLuaModifier( "modifier_illusionist_fly_lua", "modifiers/modifier_illusionist_fly_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Classifications
function modifier_illusionist_real_tornado_lua:IsHidden()
	return true
end

function modifier_illusionist_real_tornado_lua:IsDebuff()
	return false
end

function modifier_illusionist_real_tornado_lua:IsStunDebuff()
	return false
end

function modifier_illusionist_real_tornado_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_illusionist_real_tornado_lua:OnCreated(kv)
	if IsServer() then
		
		self.ability = kv.ability
		
		self.cycloneminheight = kv.cycloneminheight
		self.cyclonemaxheight = kv.cyclonemaxheight
		self.cycloneinitialheight = kv.cycloneinitialheight
		self.cycloneflytime = kv.cycloneflytime
		self.cycloneimmunetime = kv.cycloneimmunetime
		self.cycloneradius = kv.cycloneradius
	end
	self:StartIntervalThink(0.1)
	self:OnIntervalThink()

	local sound_cast = "n_creep_Wildkin.Tornado"
	EmitSoundOn( sound_cast, self:GetParent() )
end


function modifier_illusionist_real_tornado_lua:OnRefresh(kv)
	if IsServer() then

		self.ability = kv.ability

		self.cycloneminheight = kv.cycloneminheight
		self.cyclonemaxheight = kv.cyclonemaxheight
		self.cycloneinitialheight = kv.cycloneinitialheight
		self.cycloneflytime = kv.cycloneflytime
		self.cycloneimmunetime = kv.cycloneimmunetime
		self.cycloneradius = kv.cycloneradius
	end

	self:StartIntervalThink(0.1)
	self:OnIntervalThink()
end


function modifier_illusionist_real_tornado_lua:OnIntervalThink()
	if IsServer() then
		
		local caster = self:GetCaster()
		local tornado = self:GetParent()
		local tornado_origin = tornado:GetOrigin()

		----find enemies for actual catching
		units = FindUnitsInRadius(
		caster:GetTeam(),	-- int, your team number
		tornado_origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.cycloneradius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
		)

		if #units > 0 then
			for _,enemy in pairs(units) do
				if not enemy:HasModifier("modifier_illusionist_flown_lua") and not IsBuildingOrSpire(enemy) then
					enemy:AddNewModifier(
						caster, -- player source
						self.ability, -- ability source
						"modifier_illusionist_fly_lua", -- modifier name
						{ duration = self.cycloneflytime,
						CycloneInitialHeight = self.cycloneinitialheight,
						CycloneMinHeight = self.cycloneminheight,
						CycloneMaxHeight = self.cyclonemaxheight,

						Flyduration = self.cycloneflytime,
						Cycloneimmunetime = self.cycloneimmunetime
						} -- kv
						)
					local sound_cast = "Hero_Invoker.Tornado.Target"
					EmitSoundOn( sound_cast, tornado )	
				end					
			end		
		end
	end
end


--------------------------------------------------------------------------------
-- Status Effects
function modifier_illusionist_real_tornado_lua:CheckState()
	local state = {
	    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED]           = true,		
		[MODIFIER_STATE_ROOTED]            = true,				
		[MODIFIER_STATE_DISARMED]          = true,			
		[MODIFIER_STATE_INVULNERABLE]      = true,		
		[MODIFIER_STATE_NO_HEALTH_BAR]     = true		
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations n death
function modifier_illusionist_real_tornado_lua:GetEffectName()
	return "particles/units/heroes/hero_invoker/invoker_tornado.vpcf"
end

function modifier_illusionist_real_tornado_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_illusionist_real_tornado_lua:DestroyOnExpire()
    return true
  end
  
function modifier_illusionist_real_tornado_lua:IsPurgable()
    return false
end

function modifier_illusionist_real_tornado_lua:OnDestroy()
    if IsServer() then
            --delete the damn summon
        self:GetParent():ForceKill(false)
	
		local sound_cast = "n_creep_Wildkin.Tornado"
		StopSoundOn(sound_cast, self:GetParent())	
	end
end

