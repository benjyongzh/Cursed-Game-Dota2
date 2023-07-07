samurai_counter_lua = class({})
LinkLuaModifier( "modifier_samurai_counter_lua", "modifiers/modifier_samurai_counter_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function samurai_counter_lua:OnSpellStart()
    local caster = self:GetCaster()
    local max_range = self:GetSpecialValueFor("max_range")
    local spell_duration = self:GetSpecialValueFor("duration")
    local distance = self:GetSpecialValueFor("distance_away")
    caster:AddNewModifier(caster, self, "modifier_samurai_counter_lua", {duration = spell_duration, range = max_range, blink_distance = distance})
end