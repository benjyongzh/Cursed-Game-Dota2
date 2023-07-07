modifier_werewolf_howl_disarm_lua = class({})

--------------------------------------------------------------------------------

function modifier_werewolf_howl_disarm_lua:IsHidden()
	return false
end

function modifier_werewolf_howl_disarm_lua:IsDebuff()
	return true
end

function modifier_werewolf_howl_disarm_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_werewolf_howl_disarm_lua:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_werewolf_howl_disarm_lua:GetEffectName()
	return "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_disarm_ti6_debuff.vpcf"
end

function modifier_werewolf_howl_disarm_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end