modifier_illusionist_flown_lua = class({})

--------------------------------------------------------------------------------

-- Classifications
function modifier_illusionist_flown_lua:IsHidden()
	return true
end

function modifier_illusionist_flown_lua:IsDebuff()
	return false
end

function modifier_illusionist_flown_lua:IsStunDebuff()
	return false
end

function modifier_illusionist_flown_lua:IsPurgable()
	return false
end