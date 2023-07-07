modifier_illusionist_illusion_tornado_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_illusionist_illusion_tornado_lua:IsHidden()
	return true
end

function modifier_illusionist_illusion_tornado_lua:IsDebuff()
	return false
end

function modifier_illusionist_illusion_tornado_lua:IsStunDebuff()
	return false
end

function modifier_illusionist_illusion_tornado_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_illusionist_illusion_tornado_lua:OnCreated(kv)
	if IsServer() then

		local sound_cast = "n_creep_Wildkin.Tornado"
		EmitSoundOn( sound_cast, self:GetParent() )

	end
end


function modifier_illusionist_illusion_tornado_lua:OnRefresh(kv)
	if IsServer() then
	end

end

function modifier_illusionist_illusion_tornado_lua:OnIntervalThink()
	if IsServer() then

	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_illusionist_illusion_tornado_lua:CheckState()
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
function modifier_illusionist_illusion_tornado_lua:GetEffectName()
	return "particles/units/heroes/hero_invoker/invoker_tornado.vpcf"
end

function modifier_illusionist_illusion_tornado_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_illusionist_illusion_tornado_lua:DestroyOnExpire()
    return true
  end
  function modifier_illusionist_illusion_tornado_lua:IsPurgable()
    return false
  end
  function modifier_illusionist_illusion_tornado_lua:OnDestroy()
    if IsServer() then
            --delete the damn summon
        self:GetParent():ForceKill(false)
	
		local sound_cast = "n_creep_Wildkin.Tornado"
		StopSoundOn(sound_cast, self:GetParent())
	end
	
end
