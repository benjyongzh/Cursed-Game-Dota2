custom_blink = class({})

function custom_blink:OnSpellStart()
    print("hello world!")    
	if GameRules:IsDaytime() then
	    print("it is now day time")
	else
	    print("it is now night time")
	end
	return 1
end

