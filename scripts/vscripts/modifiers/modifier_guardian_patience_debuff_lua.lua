modifier_guardian_patience_debuff_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_guardian_patience_debuff_lua:IsHidden()
	return false
end

function modifier_guardian_patience_debuff_lua:IsDebuff()
	return true
end

function modifier_guardian_patience_debuff_lua:IsPurgable()
	return true
end

---------------------------------------------------------------------------------
-- Initializations
function modifier_guardian_patience_debuff_lua:OnCreated( kv )
	if IsServer() then
	end
end

function modifier_guardian_patience_debuff_lua:OnRefresh( kv )
	if IsServer() then
	end		
end

function modifier_guardian_patience_debuff_lua:OnDestroy( kv )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_guardian_patience_debuff_lua:CheckState()
    local state = {

        [MODIFIER_STATE_DISARMED] = true
    }

    return state
end

-- Graphics & Animations
function modifier_guardian_patience_debuff_lua:GetEffectName()
	return "particles/units/heroes/hero_pangolier/pangolier_luckyshot_disarm_debuff.vpcf"
end

function modifier_guardian_patience_debuff_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end