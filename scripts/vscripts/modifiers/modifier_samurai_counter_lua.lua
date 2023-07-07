modifier_samurai_counter_lua = class({})
--------------------------------------------------------------------------------

function modifier_samurai_counter_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_samurai_counter_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_samurai_counter_lua:IsPurgable()
	return true
end

-------------------------------------------------------------------------------

function modifier_samurai_counter_lua:DestroyOnExpire()
    return true
end

-------------------------------------------------------------------------------

function modifier_samurai_counter_lua:GetTexture()
    return "juggernaut_blade_dance"
end

--------------------------------------------------------------------------------

function modifier_samurai_counter_lua:OnDestroy()
    if IsServer() then
        --stop animation
        self:GetParent():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
    end
end

--------------------------------------------------------------------------------

--Use this if you want to achieve a "time walk" effect for heroes other than faceless
function modifier_samurai_counter_lua:GetEffectName()
    return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"
end

function modifier_samurai_counter_lua:GetEffectAttachType()
    --"EffectAttachType"	"follow_origin"
    return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_samurai_counter_lua:OnCreated( kv )
	self.range = kv.range
	self.back_distance = kv.blink_distance

	if IsServer() then
        --sfx
		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_blade_fury.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true)
        self:AddParticle( self.nFXIndex, false, false, -1, false, false )
        self.nFXIndex_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        self:AddParticle(self.nFXIndex_2, false, false, -1, false, false)

        EmitSoundOn("Hero_Juggernaut.BladeDance.Layer", self:GetParent())
        local particle_cast = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_crit_tgt_model.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(effect_cast, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true)
        ParticleManager:ReleaseParticleIndex(effect_cast)

        --animation
        self:GetParent():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
    end
    self:StartIntervalThink( 0.15 )
	self:OnIntervalThink()
end

--------------------------------------------------------------------------------

function modifier_samurai_counter_lua:OnRefresh( kv )
	self.range = kv.range
	self.back_distance = kv.blink_distance

	if IsServer() then
        ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true)
    end
    self:StartIntervalThink( 0.15 )
	self:OnIntervalThink()
end

--------------------------------------------------------------------------------

function modifier_samurai_counter_lua:OnIntervalThink()
	EmitSoundOn("Hero_Juggernaut.PreAttack", self:GetParent())
end

--------------------------------------------------------------------------------

function modifier_samurai_counter_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_samurai_counter_lua:OnTakeDamage(keys)
    --for k,v in pairs(keys) do
    --    print(k,v)
    --end
    local attacker = keys.attacker
	local target = keys.unit
    local original_damage = keys.original_damage
	local damage_taken = keys.damage
	local damage_type = keys.damage_type
    local damage_flags = keys.damage_flags
    local vector = Vector(attacker:GetOrigin().x-target:GetOrigin().x, attacker:GetOrigin().y-target:GetOrigin().y, attacker:GetOrigin().z-target:GetOrigin().z)
    local distance_from_source = math.sqrt(vector.x * vector.x + vector.y * vector.y)--get absolute distance value

    if IsServer() then
        if keys.unit == self:GetParent() and not keys.attacker:IsBuilding() and keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then	
            if not keys.unit:IsOther() then
                if distance_from_source <= self.range and keys.attacker:IsAlive() and not IsBuildingOrSpire(keys.attacker) then

                    -- reflect original damage (before damage reductions)
                    local damageTable = {
                        victim			= attacker,
                        damage			= original_damage,
                        damage_type		= damage_type,
                        damage_flags	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                        attacker		= self:GetParent(),
                        ability			= self:GetAbility()
                    }
                    local reflectDamage = ApplyDamage(damageTable)

                    --reverse damage done to samurai
                    target:ModifyHealth((target:GetHealth()+damage_taken),self:GetAbility(),false,0)
                    
                    --sfx on samurai
                    EmitSoundOn("General.Illusion.Destroy", target)
                    --EmitSoundOn("Hero_BountyHunter.WindWalk", target)
                    local particle_cast = "particles/units/heroes/hero_phantom_lancer/phantomlancer_illusion_destroy.vpcf"
                    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, target )
                    ParticleManager:SetParticleControl(effect_cast, 0, target:GetOrigin())
                    ParticleManager:ReleaseParticleIndex(effect_cast)

                    --sfx on attacker
                    EmitSoundOn("Hero_BountyHunter.Jinada", attacker)
                    particle_cast = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_jinda_slow.vpcf"
                    effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, attacker )
                    ParticleManager:SetParticleControlEnt(effect_cast, 0, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true)
                    ParticleManager:ReleaseParticleIndex(effect_cast)

                    --teleport samurai to the back of attacker
                    local attacker_position = attacker:GetAbsOrigin()
                    local attacker_facing = attacker:GetForwardVector():Normalized()
                    FindClearSpaceForUnit(target, attacker_position-(attacker_facing * self.back_distance), true)

                    --samurai will now attack attacker
                    target:MoveToTargetToAttack(attacker)
                    target:PerformAttack(attacker, false, true, true, false, false, false, false)
                    

                    --sfx after teleporting samurai
                    EmitSoundOn("Hero_BountyHunter.WindWalk", target)
                    particle_cast = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf"
                    effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, target )
                    ParticleManager:ReleaseParticleIndex(effect_cast)
                    
                    --remove this modifier
                    self:Destroy()
                end
            end
        end
    end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------