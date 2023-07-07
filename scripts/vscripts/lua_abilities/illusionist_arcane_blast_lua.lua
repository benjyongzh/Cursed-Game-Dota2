illusionist_arcane_blast_lua = class({})

illusionist_arcane_blast_lua.projectiles = {}

--------------------------------------------------------------------------------
-- Ability Start

function illusionist_arcane_blast_lua:OnAbilityPhaseStart()
    local caster = self:GetCaster()

    -- sfx
    local sound_cast = "Hero_Terrorblade_Morphed.preAttack"
	EmitSoundOn( sound_cast, caster )
    local particle = "particles/units/heroes/hero_rubick/rubick_finger_of_death_core.vpcf"
    self.effect = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(self.effect, 0, caster, PATTACH_POINT_FOLLOW, "attach_staff", caster:GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.effect, 1, caster, PATTACH_POINT_FOLLOW, "attach_staff", caster:GetOrigin(), true)

    return true
end

function illusionist_arcane_blast_lua:OnAbilityPhaseInterrupted()
    local sound_cast = "Hero_Terrorblade_Morphed.preAttack"
	StopSoundOn( sound_cast, self:GetCaster() )
	ParticleManager:DestroyParticle( self.effect, true )
end

function illusionist_arcane_blast_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	
    --local projectile_name = "particles/units/heroes/hero_troll_warlord/troll_warlord_whirling_axe_ranged.vpcf"
    local projectile_name = ""
	local projectile_speed = self:GetSpecialValueFor( "arrow_speed" )
	local projectile_distance = self:GetSpecialValueFor( "arrow_range" )
	local projectile_radius = self:GetSpecialValueFor( "arrow_width" )
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    --iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    --iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_TREE,
	    iUnitTargetType = DOTA_UNIT_TARGET_NONE,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius = projectile_radius,
		vVelocity = projectile_direction * projectile_speed,
    
        --bDeleteOnHit = true,
		bProvidesVision = true,
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber(),
		--iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2 only for trackingprojectile
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)

	-- Play effects
	local sound_cast = "Hero_Mars.Spear.Cast"
    EmitSoundOn( sound_cast, caster )
    
    local dummy = CreateUnitByName(
		"dummy_unit",
		caster:GetAbsOrigin(),
		true,
		caster,
		caster:GetOwner(),
		caster:GetTeamNumber()
	) 

	dummy:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_dummy_unit", -- modifier name
		{} -- kv
    )
    
    local particle1 = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_arcana/rbck_arc_skeletonking_hellfireblast_trail_cubes.vpcf",PATTACH_WORLDORIGIN, dummy)
    ParticleManager:SetParticleControl(particle1,3,dummy:GetAbsOrigin() + Vector(0,0,100))
    local particle2 = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_arcana/rbck_arc_skeletonking_hellfireblast_trail_detail.vpcf",PATTACH_WORLDORIGIN, dummy)
    ParticleManager:SetParticleControl(particle2,3,dummy:GetAbsOrigin() + Vector(0,0,100))
    local particle3 = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_arcana/rbck_arc_skeletonking_hellfireblast_trail_detail_b.vpcf",PATTACH_WORLDORIGIN, dummy)
    ParticleManager:SetParticleControl(particle3,3,dummy:GetAbsOrigin() + Vector(0,0,100))
    local particle4 = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_arcana/rbck_arc_skeletonking_hellfireblast_trail_g.vpcf",PATTACH_WORLDORIGIN, dummy)
    ParticleManager:SetParticleControl(particle4,3,dummy:GetAbsOrigin() + Vector(0,0,100))
    local particle5 = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_arcana/rbck_arc_skeletonking_hellfireblast_trail_e.vpcf",PATTACH_WORLDORIGIN, dummy)
    ParticleManager:SetParticleControl(particle5,3,dummy:GetAbsOrigin() + Vector(0,0,100))
    local particle6 = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_arcana/rbck_arc_skeletonking_hellfireblast_sphere_glow.vpcf",PATTACH_WORLDORIGIN, dummy)
    ParticleManager:SetParticleControl(particle6,3,dummy:GetAbsOrigin() + Vector(0,0,100))

	-- register projectile
	local extraData = {}
	extraData.radius = projectile_radius
	extraData.location = caster:GetOrigin()
	extraData.time = GameRules:GetGameTime()
	extraData.distance = projectile_distance
	extraData.speed = projectile_speed
    extraData.direction = projectile_direction
    extraData.dummy = dummy
    extraData.thinkcounter = 0
    extraData.sfx1 = particle1
    extraData.sfx2 = particle2
    extraData.sfx3 = particle3
    extraData.sfx4 = particle4
    extraData.sfx5 = particle5
    extraData.sfx6 = particle6
    
    self.projectiles[projectile] = extraData

end

--------------------------------------------------------------------------------
-- Projectile
function illusionist_arcane_blast_lua:OnProjectileHitHandle( hTarget, vLocation, proj )
    local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	local vision_duration = self:GetSpecialValueFor( "vision_duration" )
    if not hTarget then --max range of arrow
        -- sfx
        EmitSoundOnLocationWithCaster(vLocation, "Hero_WitchDoctor.ProjectileImpact", self.projectiles[proj].dummy)
        local particle = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_ti8_immortal/rubick_ti8_immortal_fade_bolt_head.vpcf",PATTACH_WORLDORIGIN, self.projectiles[proj].dummy)
        ParticleManager:SetParticleControl(particle, 0, vLocation + Vector(0,0,100))
        ParticleManager:SetParticleControl(particle, 1, vLocation + Vector(0,0,100))
        ParticleManager:ReleaseParticleIndex(particle)

        -- destroy arrow
        self.projectiles[proj].dummy:ForceKill(false)
        ParticleManager:DestroyParticle(self.projectiles[proj].sfx1, true)
        ParticleManager:DestroyParticle(self.projectiles[proj].sfx2, true)
        ParticleManager:DestroyParticle(self.projectiles[proj].sfx3, true)
        ParticleManager:DestroyParticle(self.projectiles[proj].sfx4, true)
        ParticleManager:DestroyParticle(self.projectiles[proj].sfx5, true)
        ParticleManager:DestroyParticle(self.projectiles[proj].sfx6, true)
        self.projectiles[proj] = nil
		return true
	end

	return false
end

function illusionist_arcane_blast_lua:OnProjectileThinkHandle( proj )
    -- update location
    local old_location = self.projectiles[proj].location
    local new_location = ProjectileManager:GetLinearProjectileLocation( proj )
    self.projectiles[proj].location = new_location
    
    -- update distance travelled
    local vector = Vector(new_location.x-old_location.x, new_location.y-old_location.y, new_location.z-old_location.z)
    local distance = math.sqrt(vector.x * vector.x + vector.y * vector.y)
    self.projectiles[proj].distance = self.projectiles[proj].distance - distance

    -- update sfx dummy
    local dummy = self.projectiles[proj].dummy
    dummy:SetAbsOrigin(GetGroundPosition(new_location, nil))
    ParticleManager:SetParticleControl(self.projectiles[proj].sfx1,3,dummy:GetAbsOrigin() + Vector(0,0,100))
    ParticleManager:SetParticleControl(self.projectiles[proj].sfx2,3,dummy:GetAbsOrigin() + Vector(0,0,100))
    ParticleManager:SetParticleControl(self.projectiles[proj].sfx3,3,dummy:GetAbsOrigin() + Vector(0,0,100))
    ParticleManager:SetParticleControl(self.projectiles[proj].sfx4,3,dummy:GetAbsOrigin() + Vector(0,0,100))
    ParticleManager:SetParticleControl(self.projectiles[proj].sfx5,3,dummy:GetAbsOrigin() + Vector(0,0,100))
    ParticleManager:SetParticleControl(self.projectiles[proj].sfx6,3,dummy:GetAbsOrigin() + Vector(0,0,100))

    -- the think function runs once every 0.03seconds. this counter is a cooldown to ensure that the function does not check for collisions every time. might lead to problems.
    if self.projectiles[proj].thinkcounter < 3 then 
        self.projectiles[proj].thinkcounter = self.projectiles[proj].thinkcounter + 1
    else
        local hCaster = self:GetCaster()
        --local all_units_including_dummy = FindUnitsInRadius(
        local all_units = FindUnitsInRadius(
            hCaster:GetTeam(),
            self.projectiles[proj].location,
            nil,
            self.projectiles[proj].radius,
            DOTA_UNIT_TARGET_TEAM_BOTH,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_FARTHEST,
            false
        )
        
        if #all_units > 0 then
            for _,unit in pairs(all_units) do
                -- filters
                local filter_clear = false
                if unit:GetUnitName() == "fly_unit" or unit:GetUnitName() == "trap_unit" or unit:GetUnitName() == "ghost_loser_main_unit" then
                    filter_clear = false
                elseif unit:GetTeam() == hCaster:GetTeam() then
                    if unit:GetUnitName() == "dummy_unit" and unit:HasModifier("modifier_illusionist_invisible_wall_lua_dummy") then
                        filter_clear = true
                    else
                        filter_clear = false
                    end
                else
                    filter_clear = true
                end

                if filter_clear == true then
                    if (not unit:IsMagicImmune()) and (not IsBuildingOrSpire(unit)) then
                        if unit:GetUnitName() ~= "dummy_unit" then
                            local damageTable = {
                                victim = unit,
                                attacker = hCaster,
                                damage = self:GetAbilityDamage(), -- edit
                                damage_type = self:GetAbilityDamageType(), --edit
                                ability = self, --Optional.
                                --damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, --Optional.
                            }
                            ApplyDamage(damageTable)
                        end
                    end

                    -- bounce proj
                    local proj_loc = self.projectiles[proj].location
                    local t_loc = unit:GetAbsOrigin()
                    local old_dir = self.projectiles[proj].direction -- original proj direction vector
                    local proj_angle = VectorToAngles(old_dir) -- QAngle of proj direction vector
                    local vec_proj_to_t = Vector(t_loc.x-proj_loc.x, t_loc.y-proj_loc.y, t_loc.z-proj_loc.z):Normalized()

                    EmitSoundOn("high_five.impact", unit)
                    self:DeflectProjectile( proj, vec_proj_to_t )
                    self.projectiles[proj].thinkcounter = 0
                    return
                end
            end

        else
            local all_trees = GridNav:GetAllTreesAroundPoint(self.projectiles[proj].location, self.projectiles[proj].radius, false)
            if #all_trees > 0 then
                local main_tree = nil
                if #all_trees == 1 then
                    if all_trees[1]:IsStanding() then
                        main_tree = all_trees[1]
                    end
                    
                else
                    -- find standing trees only
                    local all_standing_trees = {}
                    for _,tree in pairs(all_trees) do
                        if tree:IsStanding() then
                            table.insert(all_standing_trees, tree)
                        end
                    end

                    if #all_standing_trees > 0 then
                        -- find furthest standing tree
                        local max_distance = 0
                        local tree_distances = {}
                        for _,tree in pairs(all_standing_trees) do
                            local tree_pos = tree:GetAbsOrigin()
                            local proj_pos = self.projectiles[proj].location
                            local vector = Vector( (tree_pos.x - proj_pos.x), (tree_pos.y - proj_pos.y), (tree_pos.z - proj_pos.z) )
                            local distance = math.sqrt( (vector.x * vector.x) + (vector.y * vector.y) )
                            if distance >= max_distance then
                                max_distance = distance
                            end
                            table.insert(tree_distances, distance)
                        end
                        local index = getIndexTable(tree_distances, max_distance)
                        main_tree = all_standing_trees[index]
                    end
                end

                if main_tree ~= nil then
                    -- deflecting off tree
                    local proj_loc = self.projectiles[proj].location
                    local t_loc = main_tree:GetAbsOrigin()
                    local old_dir = self.projectiles[proj].direction -- original proj direction vector
                    local proj_angle = VectorToAngles(old_dir) -- QAngle of proj direction vector
                    local vec_proj_to_t = Vector(t_loc.x-proj_loc.x, t_loc.y-proj_loc.y, t_loc.z-proj_loc.z):Normalized()
                    local vec_proj_to_t_angle = VectorToAngles(vec_proj_to_t).y -- rotation angle of QAngle of vector from proj to hTarget

                    if vec_proj_to_t_angle > 45 and vec_proj_to_t_angle <=135 then
                        -- tree is north
                        vec_proj_to_t = Vector(0,1,0)
                    elseif vec_proj_to_t_angle > 135 and vec_proj_to_t_angle <=225 then
                        -- tree is west
                        vec_proj_to_t = Vector(-1,0,0)
                    elseif vec_proj_to_t_angle > 225 and vec_proj_to_t_angle <=315 then
                        -- tree is south
                        vec_proj_to_t = Vector(0,-1,0)
                    else
                        -- tree is east
                        vec_proj_to_t = Vector(1,0,0)
                    end

                    self:DeflectProjectile( proj, vec_proj_to_t )            
                    self.projectiles[proj].thinkcounter = 0
                end
                return
            end
        end
    end
end


function illusionist_arcane_blast_lua:DeflectProjectile( proj, vec_proj_to_t )
    local proj_angle = VectorToAngles(self.projectiles[proj].direction) -- QAngle of proj direction vector

    local vec_proj_to_t_angle = VectorToAngles(vec_proj_to_t) -- QAngle of vector from proj to hTarget
    local incidence_angle = (RotationDelta(vec_proj_to_t_angle, proj_angle).y) -- rotation angle difference between proj vector and proximity vector
    
    local perp_vec_length = 2 * ( math.cos(ToRadians(incidence_angle)) * 1.0) -- length of vector necessary to change direction of proj
    local vec_t_to_proj_angle = VectorToAngles(-vec_proj_to_t).y -- use reverse of proximity vector. find its angle
    local final_vec = RotatePosition(Vector(0,0,0), QAngle(0,vec_t_to_proj_angle,0), Vector(perp_vec_length,0,0)) -- craete a vector out of the length and angle defined
    self.projectiles[proj].direction = (self.projectiles[proj].direction + final_vec):Normalized() -- add vector to proj vector, then normalize. this will be new proj vector
    
    ProjectileManager:UpdateLinearProjectileDirection(proj, self.projectiles[proj].direction * self.projectiles[proj].speed, self.projectiles[proj].distance )

    -- Play effects
    local dummy = self.projectiles[proj].dummy
    EmitSoundOn( "Hero_Puck.ProjectileImpact", dummy )
    local particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_base_attack_impact.vpcf",PATTACH_WORLDORIGIN, dummy)
    ParticleManager:SetParticleControl(particle1, 3, dummy:GetAbsOrigin() + (Vector(0,0,100) + (vec_proj_to_t * 30)))

    particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_finger_of_death_sparks_source.vpcf",PATTACH_WORLDORIGIN, dummy)
    ParticleManager:SetParticleControl(particle1, 0, dummy:GetAbsOrigin() + (Vector(0,0,100) + (vec_proj_to_t * 30)))
end