ranger_swap_arrow_lua = class({})
ranger_swap_arrow_teleport_lua = class({})

ranger_swap_arrow_lua.projectiles = {}

--------------------------------------------------------------------------------
-- Ability Start
function ranger_swap_arrow_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	
	local projectile_name = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf"
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
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
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
	local sound_cast = "Ability.Powershot"
	EmitSoundOn( sound_cast, caster )

	-- register projectile
	local extraData = {}
	extraData.location = caster:GetOrigin()
	extraData.time = GameRules:GetGameTime()
	self.projectiles[projectile] = extraData
end

--------------------------------------------------------------------------------
-- Projectile
function ranger_swap_arrow_lua:OnProjectileHitHandle( hTarget, vLocation, proj )
    local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	local vision_duration = self:GetSpecialValueFor( "vision_duration" )
	if not hTarget then --max range of arrow
		-- create Vision
        AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation, vision_radius, vision_duration, false )
		--destroy arrow
		self.projectiles[proj] = nil
		return true
	end
	
	local hCaster = self:GetCaster()

	if hCaster == nil or hTarget:TriggerSpellAbsorb( this ) then
		--destroy arrow
		self.projectiles[proj] = nil
		return true
	end

	if IsBuildingOrSpire(hTarget) then
		return false
	end

	local vPos1 = hCaster:GetOrigin()
	local vPos2 = hTarget:GetOrigin()

	--GridNav:DestroyTreesAroundPoint( vPos1, 300, false )
	--GridNav:DestroyTreesAroundPoint( vPos2, 300, false )

	hCaster:SetOrigin( vPos2 )
	hTarget:SetOrigin( vPos1 )

	FindClearSpaceForUnit( hCaster, vPos2, true )
	FindClearSpaceForUnit( hTarget, vPos1, true )
	
	hTarget:Interrupt()

	--hCaster:StartGesture( ACT_DOTA_CHANNEL_END_ABILITY_4 )

	-- create Vision
	AddFOWViewer( self:GetCaster():GetTeamNumber(), vPos1, vision_radius, vision_duration, false )
	-- Play effects
	EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hCaster )
	EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hTarget )
	local nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
	ParticleManager:SetParticleControlEnt( nCasterFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nCasterFX )

	local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
	ParticleManager:SetParticleControlEnt( nTargetFX, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nTargetFX )

	self.projectiles[proj] = nil
	return true
end

function ranger_swap_arrow_lua:OnProjectileThinkHandle( proj )
	-- update location
	local location = ProjectileManager:GetLinearProjectileLocation( proj )
	self.projectiles[proj].location = location
end

function ranger_swap_arrow_lua:OnUpgrade()
	if not self.teleport then
		-- init
		self.teleport = self:GetCaster():FindAbilityByName( "ranger_swap_arrow_teleport_lua" )
		self.teleport.projectiles = self.projectiles
	end
end


function ranger_swap_arrow_teleport_lua:OnSpellStart()
	-- get first index projectile
	local first = false
	for k,v in pairs(self.projectiles) do
		first = k
		break
	end
	if not first then
		SendErrorMessage( self:GetCaster():GetPlayerOwnerID(), "No arrow to displace to" )
		return
	end

	-- find oldest projectile
	for idx,projectile in pairs(self.projectiles) do
		if projectile.time < self.projectiles[first].time then
			first = idx
		end
	end

	-- sfx at initial position
	local dummy = CreateUnitByName(
		"dummy_unit",
		self:GetCaster():GetAbsOrigin(),
		true,
		self:GetCaster(),
		self:GetCaster():GetOwner(),
		self:GetCaster():GetTeamNumber()
	)
	dummy:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_dummy_unit", -- modifier name
		{ duration = 2 } -- kv
	)
	dummy:SetForwardVector((ProjectileManager:GetLinearProjectileLocation(first) - dummy:GetAbsOrigin()))
	local nCasterFX = ParticleManager:CreateParticle( "particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_channel_ti6_shock_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy )
	ParticleManager:SetParticleControlEnt( nCasterFX, 1, dummy, PATTACH_ABSORIGIN_FOLLOW, nil, dummy:GetOrigin(), false )

	--ParticleManager:SetParticleControlForward( nCasterFX, 1, (ProjectileManager:GetLinearProjectileLocation(first) - dummy:GetAbsOrigin()) )
	ParticleManager:ReleaseParticleIndex( nCasterFX )

	-- jump to oldest
	FindClearSpaceForUnit( self:GetCaster(), ProjectileManager:GetLinearProjectileLocation( first ), true )

	-- sfx
	EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", self:GetCaster() )
	nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nCasterFX, 1, dummy, PATTACH_ABSORIGIN_FOLLOW, nil, dummy:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nCasterFX )

	-- destroy trees nearby
	local radius = self:GetSpecialValueFor("tree_radius")
	GridNav:DestroyTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(first), radius, true)

	-- destroy the oldest
	self.projectiles[first] = nil
	ProjectileManager:DestroyLinearProjectile( first )
end