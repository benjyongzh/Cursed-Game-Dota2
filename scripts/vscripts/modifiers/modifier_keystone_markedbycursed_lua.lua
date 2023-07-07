modifier_keystone_markedbycursed_lua = class({})

--------------------------------------------------------------------------------

function modifier_keystone_markedbycursed_lua:IsDebuff()
	return true
end

function modifier_keystone_markedbycursed_lua:IsHidden()
	return true
end

function modifier_keystone_markedbycursed_lua:IsPurgable()
	return false
end