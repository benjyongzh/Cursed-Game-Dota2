-- THIS FILE IS FOR RESOURCE CONTROL AND MANAGEMENT

if Resources == nil then
    Resources = class({})
end

function Resources:InitializePlayer(playerID)
    Resources:SetGold( playerID, STARTING_GOLD )
    --Resources:SetLumber( playerID, STARTING_LUMBER )
    --Resources:SetFoodLimit( playerID, STARTING_FOOD_LIMIT )
    --Resources:SetFoodUsed( playerID, 0 )
    --Resources:SetSheepLimit( playerID, STARTING_SHEEP_LIMIT )
    --Resources:SetSheeps( playerID, 0 )
end

function Resources:GetGold( playerID )
    return PlayerResource:GetGold(playerID)
end

function Resources:GetLumber( playerID )
    local hPlayer = PlayerResource:GetPlayer(playerID)
    return hPlayer.lumber
end

function Resources:GetFoodUsed( playerID )
    local hPlayer = PlayerResource:GetPlayer(playerID)
    return hPlayer.food_used
end

function Resources:GetFoodLimit( playerID )
    local hPlayer = PlayerResource:GetPlayer(playerID)
    return hPlayer.food_limit
end

function Resources:GetSheeps( playerID )
    local hPlayer = PlayerResource:GetPlayer(playerID)
    return hPlayer.sheeps
end

function Resources:GetSheepLimit( playerID )
    local hPlayer = PlayerResource:GetPlayer(playerID)
    return hPlayer.sheep_limit
end

---------------------------------------------------------------

function Resources:SetGold( playerID, value )
    local player = PlayerResource:GetPlayer(playerID)
    PlayerResource:SetGold(playerID, value, false)
    --CustomGameEventManager:Send_ServerToPlayer(player, "player_gold_changed", { gold = math.floor(hero.gold) })
end

function Resources:SetLumber( playerID, value )
    local hPlayer = PlayerResource:GetPlayer(playerID)
    hPlayer.lumber = value

    CustomGameEventManager:Send_ServerToPlayer(hPlayer, "player_lumber_changed", { lumber = math.floor(hPlayer.lumber) })
end

function Resources:SetFoodLimit( playerID, value )
    local hPlayer = PlayerResource:GetPlayer(playerID)
    
    hPlayer.food_limit = value
    CustomGameEventManager:Send_ServerToPlayer(hPlayer, 'player_food_changed', { food_used = hPlayer.food_used, food_limit = hPlayer.food_limit }) 
end

function Resources:SetFoodUsed( playerID, value )
    local hPlayer = PlayerResource:GetPlayer(playerID)

    hPlayer.food_used = value
    CustomGameEventManager:Send_ServerToPlayer(hPlayer, 'player_food_changed', { food_used = hPlayer.food_used, food_limit = hPlayer.food_limit }) 
end

function Resources:SetSheepLimit( playerID, value )
    local hPlayer = PlayerResource:GetPlayer(playerID)
    
    hPlayer.sheep_limit = value
    CustomGameEventManager:Send_ServerToPlayer(hPlayer, 'player_sheep_changed', { sheeps = hPlayer.sheeps, sheep_limit = hPlayer.sheep_limit }) 
end

function Resources:SetSheeps( playerID, value )
    local hPlayer = PlayerResource:GetPlayer(playerID)

    hPlayer.sheeps = value
    CustomGameEventManager:Send_ServerToPlayer(hPlayer, 'player_sheep_changed', { sheeps = hPlayer.sheeps, sheep_limit = hPlayer.sheep_limit }) 
end

-- Modifies the gold of this player, accepts negative values
function Resources:ModifyGold( playerID, gold_value )
    PlayerResource:ModifyGold(playerID, gold_value, false, 0)
end

-- Modifies the lumber of this player, accepts negative values
function Resources:ModifyLumber( playerID, lumber_value )
    if lumber_value == 0 then return end

    local current_lumber = Resources:GetLumber( playerID )
    local new_lumber = current_lumber + lumber_value

    if lumber_value > 0 then
        Resources:SetLumber( playerID, new_lumber )
    else
        if Resources:HasEnoughLumber( playerID, math.abs(lumber_value) ) then
            Resources:SetLumber( playerID, new_lumber )
        end
    end
end

-- Modifies the food limit of this player, accepts negative values
-- Can't go over the limit unless pointbreak cheat is enabled
function Resources:ModifyFoodLimit( playerID, food_limit_value )
    local food_limit = Resources:GetFoodLimit(playerID) + food_limit_value

    if food_limit > 100 and not GameRules.PointBreak then
        food_limit = 100
    end

    Resources:SetFoodLimit(playerID, food_limit)
end

-- Modifies the food used of this player, accepts negative values
-- Can go over the limit if a build is destroyed while the unit is already spawned/training
function Resources:ModifyFoodUsed( playerID, food_used_value )
    local food_used = Resources:GetFoodUsed(playerID) + food_used_value

    Resources:SetFoodUsed(playerID, food_used)
end

function Resources:ModifySheepLimit( playerID, sheep_limit_value )
    local sheep_limit = Resources:GetSheepLimit(playerID) + sheep_limit_value

    if sheep_limit > 50 and not GameRules.PointBreak then
        sheep_limit = 50
    end

    Resources:SetSheepLimit(playerID, sheep_limit)
end

-- Modifies the food used of this player, accepts negative values
-- Can go over the limit if a build is destroyed while the unit is already spawned/training
function Resources:ModifySheeps( playerID, sheep_value )
    local sheeps = Resources:GetSheeps(playerID) + sheep_value

    Resources:SetSheeps(playerID, sheeps)
end

-- Returns bool
function Resources:HasEnoughGold( playerID, gold_cost )
    local gold = Resources:GetGold( playerID )

    if not gold_cost or gold >= gold_cost then 
        return true
    else
        SendErrorMessage(playerID, "Not enough Gold!")
        return false
    end
end


-- Returns bool
function Resources:HasEnoughLumber( playerID, lumber_cost )
    local lumber = Resources:GetLumber(playerID)

    if not lumber_cost or lumber >= lumber_cost then 
        return true 
    else
        SendErrorMessage(playerID, "Not enough Lumber!")
        return false
    end
end

-- Return bool
function Resources:HasEnoughFood( playerID, food_cost )
    local food_used = Resources:GetFoodUsed(playerID)
    local food_limit = Resources:GetFoodLimit(playerID)

    return (food_used + food_cost <= food_limit)
end

-- Return bool
function Resources:HasEnoughSheepLimit( playerID, sheep_value )
    local sheeps = Resources:GetSheeps(playerID)
    local sheep_limit = Resources:GetSheepLimit(playerID)

    return (sheeps + sheep_value <= sheep_limit)
end