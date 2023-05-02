-- DiaPork's dpCont enables general movement and actions with greater control, while refuelling
local libCont = {}

-- For refuelling and selecting inventory items
package.path = "/apisDiaPork/lib/?.lua;" .. package.path
local dpInven = require("dpInven")

-- Moves the turtle forward by a specified distance or 1
function libCont.cMoveFo(intDist, boolDig)
    -- Defaulting to 1 and false
    intDist = intDist or 1
    if boolDig == nil then boolDig = false end
    for blocks = 1, intDist, 1 do
        -- Refuelling
        dpInven.iFuel()
        -- Digging if necessary
        if turtle.detect() and boolDig then
            turtle.dig()
        end
        -- Moving
        turtle.forward()
    end
end

-- Moves the turtle up by a specified distance or 1
function libCont.cMoveUp(intDist, boolDig)
    -- Defaulting to 1 and false
    intDist = intDist or 1
    if boolDig == nil then boolDig = false end
    for blocks = 1, intDist, 1 do
        -- Refuelling
        dpInven.iFuel()
        -- Digging if necessary
        if turtle.detectUp() and boolDig then
            turtle.digUp()
        end
        -- Moving
        turtle.up()
    end
end

-- Moves the turtle down by a specified distance or 1
function libCont.cMoveDo(intDist, boolDig)
    -- Defaulting to 1 and false
    intDist = intDist or 1
    if boolDig == nil then boolDig = false end
    for blocks = 1, intDist, 1 do
        -- Refuelling
        dpInven.iFuel()
        -- Digging if necessary
        if turtle.detectDown() and boolDig then
            turtle.digDown()
        end
        -- Moving
        turtle.down()
    end
end

-- Moves the turtle left by a specified distance or 1, ending with left orientation
function libCont.cMoveLe(intDist, boolDig)
    -- Defaulting to 1 and false
    intDist = intDist or 1
    if boolDig == nil then boolDig = false end
    -- Refuelling
    dpInven.iFuel()
    -- Moving
    turtle.turnLeft()
    -- Digging if necessary
    if turtle.detect() and boolDig then
        turtle.dig()
    end
    libCont.cMoveFo(intDist)
end

-- Moves the turtle right by a specified distance or 1, ending with right orientation
function libCont.cMoveRi(intDist, boolDig)
    -- Defaulting to 1 or false
    intDist = intDist or 1
    if boolDig == nil then boolDig = false end
    -- Refuelling
    dpInven.iFuel()
    -- Moving
    turtle.turnRight()
    -- Digging if necessary
    if turtle.detect() and boolDig then
        turtle.dig()
    end
    libCont.cMoveFo(intDist)
end

-- Moves the turtle back by a specified distance or 1, while defaulting to do 180 degree turn
function libCont.cMoveBa(intDist, boolTurn, boolDig)
    -- Defaulting to 1 distance, half turn, and no digging
    intDist = intDist or 1
    if boolTurn == nil then boolTurn = true end
    if boolDig == nil then boolDig = false end --! Yet to be implemented for backwards movement
    -- Refuelling
    dpInven.iFuel()

    if boolTurn then
        -- Moving
        turtle.turnLeft()
        turtle.turnLeft()
        libCont.cMoveFo(intDist)
    else
        for blocks = 1, intDist, 1 do
            turtle.back()
        end
    end
end

-- Has the turtle place forward, only if space allows
function libCont.cPlaceFo(selectPattern)
    if not turtle.detect() and dpInven.iSelect(selectPattern) then
        turtle.place()
    end
end

-- Has the turtle place up, only if space allows
function libCont.cPlaceUp(selectPattern)
    if not turtle.detectUp() and dpInven.iSelect(selectPattern) then
        turtle.placeUp()
    end
end

-- Has the turtle place down, only if space allows
function libCont.cPlaceDo(selectPattern)
    if not turtle.detectDown() and dpInven.iSelect(selectPattern) then
        turtle.placeDown()
    end
end

-- Has the turtle place left, only if space allows, ending with original orientation
function libCont.cPlaceLe(selectPattern)
    turtle.turnLeft()
    libCont.cPlaceFo(selectPattern)
    turtle.turnRight()
end

-- Has the turtle place right, only if space allows, ending with original orientation
function libCont.cPlaceRi(selectPattern)
    turtle.turnRight()
    libCont.cPlaceFo(selectPattern)
    turtle.turnLeft()
end

-- Has the turtle place back, only if space allows, ending with original orientation
function libCont.cPlaceBa(selectPattern, boolTurn)
    if boolTurn == nil then boolTurn = true end
    libCont.cMoveBa(0)
    libCont.cPlaceFo(selectPattern)
    if boolTurn then
        libCont.cMoveBa(0)
    end
end

return libCont