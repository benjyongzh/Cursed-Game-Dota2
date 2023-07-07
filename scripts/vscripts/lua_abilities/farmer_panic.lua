function OnCast(keys)
    local caster = keys.caster
    local current_hp = caster:GetHealth()
    local original_dmg = keys.ability:GetSpecialValueFor("damage") --this is the variable to change for dmg
    if original_dmg > current_hp then
        original_dmg = current_hp -1
    end
    local damageTable = {
        victim = caster,
        attacker = caster,
        damage = original_dmg,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
        ability = self, --Optional.
    }
    
    ApplyDamage(damageTable)
end