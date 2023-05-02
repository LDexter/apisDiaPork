-- DiaPork's dpFall API accounts for blocks or liquids that fall while mining
local libFall = {}

package.path = "/apisDiaPork/lib/?.lua;" .. package.path
-- For moving with greater control
local dpCont = require("dpCont")
-- For easy inspections against dynamic lookup tables
local dpInspect = require("dpInspect")

-- Waiting time to account for falling blocks
local waitFall = 0.6

-- Declaring slot variables
local selectCobble = {"Cobblestone", "Dirt", "Tuff", "Andesite", "Granite", "Diorite", "Soapstone"}
local selectLiquids = { "Flowing", "Water", "Lava", "Oil" }

-- Declaring type as local variable instead of Lua's type()
local type

-- Full plugging in forward direction
function libFall.fPlugFoFull()
    if dpInspect.iCompareFo(selectLiquids) then
        dpCont.cMoveFo()
        dpCont.cPlaceFo(selectCobble)
        dpCont.cPlaceUp(selectCobble)
        dpCont.cPlaceLe(selectCobble)
        dpCont.cPlaceRi(selectCobble)
        dpCont.cPlaceDo(selectCobble)
        dpCont.cMoveBa(1, false)
    end
end

-- Full plugging, moving downwards
function libFall.fDigDoFull()
    dpCont.cMoveDo(1, true)
    for i = 1, 4, 1 do
        dpCont.cPlaceFo(selectCobble)
        turtle.turnLeft()
    end
end

-- Plugging upwards
function libFall.fPlugUp()
    if dpInspect.iCompareUp(selectLiquids) then 
        dpCont.cPlaceUp(selectCobble)
    end
end

-- Full plugging in upwards direction
function libFall.fPlugUpFull()
    if dpInspect.iCompareUp(selectLiquids) then
        dpCont.cMoveUp()
        dpCont.cPlaceUp(selectCobble)
        for i = 1, 4, 1 do
            dpCont.cPlaceFo(selectCobble)
            turtle.turnLeft()
        end
        dpCont.cMoveDo()
    end
end

-- Digging to account for falling blocks, with optional plug mode as "none" to avoid auto-plugging
function libFall.fDigFo(plugMode, stayFo)
    plugMode = plugMode or "standard"
    if stayFo == nil then stayFo = false end
    -- Looping until blocks no longer fall
    while turtle.detect() do
        turtle.dig()
        -- Waiting for blocks to fall
        os.sleep(waitFall)
    end

    if plugMode ~= "none" then
        -- Moving to inspect for plugging
        dpCont.cMoveFo(1, true)

        -- Inspecting forward
        if dpInspect.iCompareFo(selectLiquids) then
            dpCont.cPlaceFo(selectCobble)
        end

        -- Inspecting up
        if dpInspect.iCompareUp(selectLiquids) then
            dpCont.cPlaceUp(selectCobble)
        end

        --Inspecting left
        if plugMode == "Le" then
            turtle.turnLeft()
            libFall.block,type = turtle.inspect()
            libFall.nameLe = type.name or "empty"
            if string.match(libFall.nameLe, "water") or string.match(libFall.nameLe, "lava") then
                dpCont.cPlaceFo(selectCobble)
            end
            turtle.turnRight()
        end

        if plugMode == "Ri" then
            -- Inspecting right
            turtle.turnRight()
            if dpInspect.iCompareFo(selectLiquids) then
                dpCont.cPlaceFo(selectCobble)
            end
            turtle.turnLeft()
        end

        -- Inspecting down
        if dpInspect.iCompareDo(selectLiquids) then
            dpCont.cPlaceDo(selectCobble)
        end
        -- Returning back from plugging
        if not stayFo then
            dpCont.cMoveBa(1, false)
        end
    end
end

function libFall.fDigUp(plugMode, stayUp)
    -- Looping until blocks no longer fall
    while turtle.detectUp() do
        turtle.digUp()
        -- Waiting for blocks to fall
        os.sleep(waitFall)
    end
    dpCont.cMoveUp()

    -- Plugging up
    if dpInspect.iCompareUp(selectLiquids) then
        dpCont.cPlaceUp(selectCobble)
    end
    -- Plugging forward
    if dpInspect.iCompareFo(selectLiquids) then
        dpCont.cPlaceFo(selectCobble)
    end
    --Inspecting left
    if plugMode == "Le" then
        turtle.turnLeft()
        if dpInspect.iCompareFo(selectLiquids) then
            dpCont.cPlaceFo(selectCobble)
        end
        turtle.turnRight()
    end

    if plugMode == "Ri" then
        -- Inspecting right
        turtle.turnRight()
        if dpInspect.iCompareFo(selectLiquids) then
            dpCont.cPlaceFo(selectCobble)
        end
        turtle.turnLeft()
    end
end

function libFall.fDigColumn(plugMode, colHeight)
    colHeight = colHeight - 1
    libFall.fDigFo(plugMode, true)
    for block = 1, colHeight, 1 do
        libFall.fDigUp(plugMode, true)
    end
    dpCont.cMoveDo(colHeight)
end

return libFall