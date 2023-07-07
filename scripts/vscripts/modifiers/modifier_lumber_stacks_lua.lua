modifier_lumber_stacks_lua = class({})
--------------------------------------------------------------------------------

function modifier_lumber_stacks_lua:IsHidden()
	return ( self:GetStackCount() == 0 )
end

--------------------------------------------------------------------------------

function modifier_lumber_stacks_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_lumber_stacks_lua:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_lumber_stacks_lua:OnCreated( kv )


	--[[
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
	]]
end

--------------------------------------------------------------------------------

function modifier_lumber_stacks_lua:OnRefresh( kv )

	--[[]
	if IsServer() then
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self:GetStackCount(), 0, 0 ) ) 
	end
	]]
end

--------------------------------------------------------------------------------

