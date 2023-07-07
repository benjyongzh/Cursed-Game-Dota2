modifier_tracker_snare_debuff_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tracker_snare_debuff_lua:IsHidden()
	return false
end

function modifier_tracker_snare_debuff_lua:IsDebuff()
	return true
end

function modifier_tracker_snare_debuff_lua:IsStunDebuff()
	return false
end

function modifier_tracker_snare_debuff_lua:IsPurgable()
	return true
end

function modifier_tracker_snare_debuff_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_tracker_snare_debuff_lua:GetTexture()
	return "meepo_earthbind"
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tracker_snare_debuff_lua:OnCreated( kv )

end

function modifier_tracker_snare_debuff_lua:OnRefresh( kv )
	
end

function modifier_tracker_snare_debuff_lua:OnRemoved()
end

function modifier_tracker_snare_debuff_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_tracker_snare_debuff_lua:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_tracker_snare_debuff_lua:GetEffectName()
	return "particles/units/heroes/hero_meepo/meepo_earthbind_model_catch.vpcf"
end

function modifier_tracker_snare_debuff_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end