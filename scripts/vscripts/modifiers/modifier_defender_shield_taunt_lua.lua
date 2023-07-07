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
modifier_defender_shield_taunt_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_defender_shield_taunt_lua:IsHidden()
	return false
end

function modifier_defender_shield_taunt_lua:IsDebuff()
	return false
end

function modifier_defender_shield_taunt_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_defender_shield_taunt_lua:OnCreated( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end

function modifier_defender_shield_taunt_lua:OnRefresh( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end

function modifier_defender_shield_taunt_lua:OnRemoved()
end

function modifier_defender_shield_taunt_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_defender_shield_taunt_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MIN_HEALTH,
	}

	return funcs
end

function modifier_defender_shield_taunt_lua:GetModifierPhysicalArmorBonus()
	return self.armor
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_defender_shield_taunt_lua:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_beserkers_call.vpcf"
end

function modifier_defender_shield_taunt_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_defender_shield_taunt_lua:GetTexture()
	return "huskar_berserkers_blood"
end

function modifier_defender_shield_taunt_lua:GetMinHealth()
	return 1
end