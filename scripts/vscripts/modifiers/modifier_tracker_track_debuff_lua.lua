-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_tracker_track_debuff_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tracker_track_debuff_lua:IsHidden()
	return false
end

function modifier_tracker_track_debuff_lua:IsDebuff()
	return true
end

function modifier_tracker_track_debuff_lua:IsPurgable()
	return false
end

function modifier_tracker_track_debuff_lua:GetTexture()
	return "kunkka_x_marks_the_spot"
end

