modifier_sheep_basket_expire_lua = class({})

function modifier_sheep_basket_expire_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_sheep_basket_expire_lua:IsPurgable()
	return false
end

function modifier_sheep_basket_expire_lua:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_BLIND] = true
    }

    return state
end

--------------------------------------------------------------------------------

function modifier_sheep_basket_expire_lua:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------

function modifier_sheep_basket_expire_lua:OnDestroy()
    if IsServer() then
        --delete the item
        self:GetParent():ForceKill(false)

        -- sfx
        local particle = "particles/items_fx/item_sheepstick.vpcf"
        local effect = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( effect, 0, self:GetParent():GetAbsOrigin() )
        ParticleManager:ReleaseParticleIndex( effect )
    end
end