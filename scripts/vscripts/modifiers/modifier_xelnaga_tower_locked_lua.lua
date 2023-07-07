modifier_xelnaga_tower_locked_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_xelnaga_tower_locked_lua:IsHidden()
	return false
end

function modifier_xelnaga_tower_locked_lua:IsDebuff()
	return false
end

function modifier_xelnaga_tower_locked_lua:IsStunDebuff()
	return false
end

function modifier_xelnaga_tower_locked_lua:IsPurgable()
	return false
end

function modifier_xelnaga_tower_locked_lua:RemoveOnDeath()
	return true
end