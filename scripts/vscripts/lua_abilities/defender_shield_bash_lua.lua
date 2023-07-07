defender_shield_bash_lua = class({})
LinkLuaModifier( "modifier_defender_shield_bash_lua", "modifiers/modifier_defender_shield_bash_lua" , LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function defender_shield_bash_lua:OnSpellStart()
	local info = {
			EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "shield_bash_speed" ),
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}
	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_DragonKnight.DragonTail.Target", self:GetCaster() )
end

--------------------------------------------------------------------------------

function defender_shield_bash_lua:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) and ( not hTarget:IsMagicImmune() ) then
		--EmitSoundOn( "Hero_DragonKnight.DragonTail.Cast", hTarget )
		local shield_bash_stun = self:GetSpecialValueFor( "shield_bash_stun" )
		local shield_bash_damage = self:GetSpecialValueFor( "shield_bash_damage" )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = shield_bash_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_defender_shield_bash_lua", { duration = shield_bash_stun } )
	end

	return true
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
