modifier_illusionist_invisible_wall_lua_dummy = class({})

function modifier_illusionist_invisible_wall_lua_dummy:CheckState()
  local state = {
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    [MODIFIER_STATE_ROOTED] = true,
    [MODIFIER_STATE_STUNNED] = true,
    --[MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_BLIND] = true,
    --[MODIFIER_STATE_INVISIBLE] = true,
    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    [MODIFIER_STATE_ATTACK_IMMUNE] = true,
  }

  return state
end

function modifier_illusionist_invisible_wall_lua_dummy:DestroyOnExpire()
  return true
end

function modifier_illusionist_invisible_wall_lua_dummy:IsPurgable()
  return false
end

function modifier_illusionist_invisible_wall_lua_dummy:OnCreated(kv)
  if IsServer() then
    
    local location = self:GetParent():GetAbsOrigin()
    local radius = kv.aoe

    self.blockers = {}
    local num_blockers = 4
    local angle_step = 360/num_blockers
    for i = 0, (num_blockers-1) do
      local angle = -120 + i * angle_step
      local direction = RotatePosition(Vector(0,0,0), QAngle(0,angle,0), Vector(1,0,0))
      local position = GetGroundPosition(location + direction * (radius/2),nil)
      self.blockers[i] = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = position, block_fow = true})
    end

    -- sfx
    EmitSoundOn("Hero_Wisp.Tether.Stun", self:GetParent())
    EmitSoundOn("Hero_Wisp.Spirits.Loop", self:GetParent())
    
    self.particle_1 = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash_sphere_rubick.vpcf",PATTACH_WORLDORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(self.particle_1,0,location + Vector(0,0,60))
    self.particle_2 = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_arcana/rbck_arc_skywrath_mage_mystic_flare_ambient_a.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(self.particle_2,0,location + Vector(0,0,60))
    self.particle_3 = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_tree_channel_leaves.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(self.particle_3,0,location + Vector(0,0,60))

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_static_field.vpcf",PATTACH_WORLDORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(particle,0,location + Vector(0,0,60))
    ParticleManager:ReleaseParticleIndex(particle)
  end
end

function modifier_illusionist_invisible_wall_lua_dummy:OnDestroy()
  if IsServer() then
    for i=0,3 do
      if self.blockers[i] then
        UTIL_Remove(self.blockers[i])
      end
    end
    self.blockers = nil

    --sfx
    StopSoundOn("Hero_Wisp.Spirits.Loop", self:GetParent())
    if self.particle_1 then
      ParticleManager:DestroyParticle(self.particle_1, true)
    end
    if self.particle_2 then
      ParticleManager:DestroyParticle(self.particle_2, true)
    end
    if self.particle_3 then
      ParticleManager:DestroyParticle(self.particle_3, true)
    end
    --delete the damn summon
    self:GetParent():ForceKill(false)
  end
end