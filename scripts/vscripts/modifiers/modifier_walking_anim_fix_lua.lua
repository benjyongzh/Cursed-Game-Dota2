modifier_walking_anim_fix_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_walking_anim_fix_lua:IsHidden()
	return true
end

function modifier_walking_anim_fix_lua:IsDebuff()
	return false
end

function modifier_walking_anim_fix_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_walking_anim_fix_lua:OnCreated()
end

function modifier_walking_anim_fix_lua:OnRefresh()
end

function modifier_walking_anim_fix_lua:OnDestroy()
end

function modifier_walking_anim_fix_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
	return funcs
end

function modifier_walking_anim_fix_lua:GetActivityTranslationModifiers()
	if IsServer() then
		return "run"
	end
end

function modifier_walking_anim_fix_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end