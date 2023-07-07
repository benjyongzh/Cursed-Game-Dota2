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
modifier_defender_shield_taunt_debuff_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_defender_shield_taunt_debuff_lua:IsHidden()
	return false
end

function modifier_defender_shield_taunt_debuff_lua:IsDebuff()
	return true
end

function modifier_defender_shield_taunt_debuff_lua:IsStunDebuff()
	return false
end

function modifier_defender_shield_taunt_debuff_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_defender_shield_taunt_debuff_lua:OnCreated( kv )
	if IsServer() then
		-- two not working...?
		-- self:GetParent():SetAggroTarget( self:GetCaster() )
		-- self:GetParent():SetAttacking( self:GetCaster() )
		self:GetParent():SetForceAttackTarget( self:GetCaster() ) -- for creeps
		self:GetParent():MoveToTargetToAttack( self:GetCaster() ) -- for heroes
	end
end

function modifier_defender_shield_taunt_debuff_lua:OnRefresh( kv )
end

function modifier_defender_shield_taunt_debuff_lua:OnRemoved()
	if IsServer() then
		self:GetParent():SetForceAttackTarget( nil )
	end
end

function modifier_defender_shield_taunt_debuff_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_defender_shield_taunt_debuff_lua:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_defender_shield_taunt_debuff_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function modifier_defender_shield_taunt_debuff_lua:GetTexture()
	return "huskar_berserkers_blood"
end