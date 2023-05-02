-- DiaPork's dpExtract API extracts categorised materials with situational awareness
local libExtract = {}

package.path = "/apisDiaPork/lib/?.lua;" .. package.path
-- For digging while accounting for blocks that fall
local dpFall = require("dpFall")
-- For moving with greater control
local dpCont = require("dpCont")
-- For easy inspections against dynamic lookup tables
local dpInspect = require("dpInspect")

-- Defining ore table
local tableOre = {"Ore", "Coal", "Dust", "Shard", "Resource", "Raw", "Gem", "Diamond", "Redstone", "Lapis", "Emerald"}

-- Defining slot variables
local selectCobble = {"Cobblestone", "Dirt", "Tuff", "Andesite", "Granite", "Diorite", "Soapstone"}

-- Defining variables for mapping movements
libExtract.varSteps = 1
libExtract.arrMap = {}
libExtract.eleMapStart = 0
libExtract.arrMap[0] = libExtract.eleMapStart
libExtract.eleMapF = 1
libExtract.eleMapL = 2
libExtract.eleMapB = 3
libExtract.eleMapR = 4
libExtract.eleMapU = 5
libExtract.eleMapD = 6

-- Smart digging, with extensive ore inspection and path mapping to retrace steps
function libExtract.eOre()
    local exceptOres = {}
    libExtract.exceptCount = 0

    -- Starting at first step
    libExtract.varSteps = 1
    -- Maintaining loop while steps are yet to be retraced
    while libExtract.varSteps >= 1 do
        -- Plugging up liquids above and in front
        os.sleep(0.2)
        dpFall.fPlugUp()
        -- Looping through all sides (1: front, 2: left, 3: back, 4: right, 5: up, 6: down)
        for side = 1, 6, 1 do
            dpFall.fPlugFoFull()
            libExtract.boolFound = false
            -- Checking for longitude directions
            if side <= 4 then
                -- Checking for match of desired ore
                if dpInspect.iCompareFo(tableOre, exceptOres) then
                    dpFall.fDigFo("standard", true)
                    -- Recording side
                    if side == 1 then -- IS FORWARD
                        libExtract.arrMap[libExtract.varSteps] = libExtract.eleMapF
                        libExtract.varSteps = libExtract.varSteps + 1

                    elseif side == 2 then -- IS LEFT
                        libExtract.arrMap[libExtract.varSteps] = libExtract.eleMapL
                        libExtract.varSteps = libExtract.varSteps + 1

                    elseif side == 3 then -- IS BACK
                        libExtract.arrMap[libExtract.varSteps] = libExtract.eleMapB
                        libExtract.varSteps = libExtract.varSteps + 1

                    elseif side == 4 then -- IS RIGHT
                        libExtract.arrMap[libExtract.varSteps] = libExtract.eleMapR
                        libExtract.varSteps = libExtract.varSteps + 1
                    end
                    -- Recording detection
                    libExtract.boolFound = true
                end
                if not libExtract.boolFound then
                    if libExtract.varSteps == 1 then
                        if side == 2 or side == 4 then
                            dpCont.cPlaceFo(selectCobble)
                        end
                    end
                    -- Turning around while inspecting first 4 sides
                    turtle.turnLeft()

                end
            elseif side == 5 then -- IS UP
                -- Checking for match
                if dpInspect.iCompareUp(tableOre, exceptOres) then
                    dpFall.fDigUp()
                    -- Recording direction first
                    libExtract.arrMap[libExtract.varSteps] = libExtract.eleMapU
                    -- Recording detection second
                    libExtract.varSteps = libExtract.varSteps + 1
                    libExtract.boolFound = true
                end
            elseif side == 6 then -- IS DOWN
                -- Checking for match
                if dpInspect.iCompareDo(tableOre, exceptOres) then
                    turtle.digDown()
                    dpCont.cMoveDo()
                    -- Recording direction FIRST
                    libExtract.arrMap[libExtract.varSteps] = libExtract.eleMapD
                    -- Recording detection SECOND
                    libExtract.varSteps = libExtract.varSteps + 1
                    libExtract.boolFound = true
                end
            end
            -- Breaking out of for loop after finding desired item
            if libExtract.boolFound then
                break
            end
        end

        -- If no desireble materials are found, follow recorded mapping map back to strip
        if not libExtract.boolFound then
            libExtract.varSteps = libExtract.varSteps - 1
            if libExtract.arrMap[libExtract.varSteps] == libExtract.eleMapF then -- WAS FORWARD
                -- Moving back without turning to counteract forward
                dpCont.cMoveBa(1, false)

            elseif libExtract.arrMap[libExtract.varSteps] == libExtract.eleMapL then -- WAS LEFT
                -- Moving back and right to counteract left
                dpCont.cMoveBa(1, false)
                turtle.turnRight()

            elseif libExtract.arrMap[libExtract.varSteps] == libExtract.eleMapB then -- WAS BACK
                -- Turning back and moving forward to counteract initial turning back
                dpCont.cMoveBa()

            elseif libExtract.arrMap[libExtract.varSteps] == libExtract.eleMapR then -- WAS RIGHT
                -- Moving back and turning left to counteract right
                dpCont.cMoveBa(1, false)
                turtle.turnLeft()

            elseif libExtract.arrMap[libExtract.varSteps] == libExtract.eleMapU then -- WAS UP
                -- Moving down to counteract up
                dpCont.cMoveDo()

            elseif libExtract.arrMap[libExtract.varSteps] == libExtract.eleMapD then -- WAS DOWN
                -- Moving up to counteract down
                dpCont.cMoveUp()
            end
        end
    end
end

function libExtract.eSurface(selectTarget, exceptBlocks)
    -- Starting at first step
    libExtract.varSteps = 1
    -- Maintaining loop while steps are yet to be retraced
    while libExtract.varSteps >= 1 do
        -- Looping through all sides (1: front, 2: left, 3: back, 4: right, 5: up, 6: down)
        for side = 1, 6, 1 do
            libExtract.boolFound = false
            -- Checking for longitude directions
            if side <= 4 then
                -- Checking for match of desired ore
                if dpInspect.iCompareFo(selectTarget, exceptBlocks) then
                    dpFall.fDigFo("standard", true)
                    -- Recording side
                    if side == 1 then -- IS FORWARD
                        libExtract.arrMap[libExtract.varSteps] = libExtract.eleMapF
                        libExtract.varSteps = libExtract.varSteps + 1

                    elseif side == 2 then -- IS LEFT
                        libExtract.arrMap[libExtract.varSteps] = libExtract.eleMapL
                        libExtract.varSteps = libExtract.varSteps + 1

                    elseif side == 3 then -- IS BACK
                        libExtract.arrMap[libExtract.varSteps] = libExtract.eleMapB
                        libExtract.varSteps = libExtract.varSteps + 1

                    elseif side == 4 then -- IS RIGHT
                        libExtract.arrMap[libExtract.varSteps] = libExtract.eleMapR
                        libExtract.varSteps = libExtract.varSteps + 1
                    end
                    -- Recording detection
                    libExtract.boolFound = true
                end
                if not libExtract.boolFound then
                    -- Turning around while inspecting first 4 sides
                    turtle.turnLeft()
                end
            elseif side == 5 then -- IS UP
                -- Checking for match
                if dpInspect.iCompareUp(selectTarget, exceptBlocks) then
                    dpFall.fDigUp()
                    -- Recording direction first
                    libExtract.arrMap[libExtract.varSteps] = libExtract.eleMapU
                    -- Recording detection second
                    libExtract.varSteps = libExtract.varSteps + 1
                    libExtract.boolFound = true
                end
            elseif side == 6 then -- IS DOWN
                -- Checking for match
                if dpInspect.iCompareDo(selectTarget, exceptBlocks) then
                    turtle.digDown()
                    dpCont.cMoveDo()
                    -- Recording direction FIRST
                    libExtract.arrMap[libExtract.varSteps] = libExtract.eleMapD
                    -- Recording detection SECOND
                    libExtract.varSteps = libExtract.varSteps + 1
                    libExtract.boolFound = true
                end
            end
            -- Breaking out of for loop after finding desired item
            if libExtract.boolFound then
                break
            end
        end

        -- If no desireble materials are found, follow recorded mapping map back to strip
        if not libExtract.boolFound then
            libExtract.varSteps = libExtract.varSteps - 1
            if libExtract.arrMap[libExtract.varSteps] == libExtract.eleMapF then -- WAS FORWARD
                -- Moving back without turning to counteract forward
                dpCont.cMoveBa(1, false)

            elseif libExtract.arrMap[libExtract.varSteps] == libExtract.eleMapL then -- WAS LEFT
                -- Moving back and right to counteract left
                dpCont.cMoveBa(1, false)
                turtle.turnRight()

            elseif libExtract.arrMap[libExtract.varSteps] == libExtract.eleMapB then -- WAS BACK
                -- Turning back and moving forward to counteract initial turning back
                dpCont.cMoveBa()

            elseif libExtract.arrMap[libExtract.varSteps] == libExtract.eleMapR then -- WAS RIGHT
                -- Moving back and turning left to counteract right
                dpCont.cMoveBa(1, false)
                turtle.turnLeft()

            elseif libExtract.arrMap[libExtract.varSteps] == libExtract.eleMapU then -- WAS UP
                -- Moving down to counteract up
                dpCont.cMoveDo()

            elseif libExtract.arrMap[libExtract.varSteps] == libExtract.eleMapD then -- WAS DOWN
                -- Moving up to counteract down
                dpCont.cMoveUp()
            end
        end
    end
end

return libExtract