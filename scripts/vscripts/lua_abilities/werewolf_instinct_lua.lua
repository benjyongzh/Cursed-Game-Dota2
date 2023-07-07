werewolf_instinct_lua = class({})
LinkLuaModifier( "modifier_werewolf_instinct_lua", "modifiers/modifier_werewolf_instinct_lua", LUA_MODIFIER_MOTION_NONE )


function werewolf_instinct_lua:OnSpellStart()
	-- Add buff modifier
	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_werewolf_instinct_lua",
		{ duration = self:GetSpecialValueFor("duration") }
    )
    -- sfx
    --EmitSoundOn( "hero_bloodseeker.bloodRage", self:GetCaster() )
    EmitSoundOn( "Hero_Grimstroke.InkCreature.Spawn", self:GetCaster() )
    EmitSoundOn( "Hero_Grimstroke.DarkArtistry.PreCastPoint", self:GetCaster() )
end