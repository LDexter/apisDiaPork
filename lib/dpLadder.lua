-- DiaPork's dpLadder API builds ladder access to a specified depth or height
local libLadder = {}

package.path = "/apisDiaPork/lib/?.lua;" .. package.path
-- For digging while accounting for blocks that fall
local dpFall = require("dpFall")
-- For moving with greater control
local dpCont = require("dpCont")

-- Declaring slot variables
local selectLadder = { "Ladder" }
local selectCobble = {"Cobblestone", "Dirt", "Tuff", "Andesite", "Granite", "Diorite", "Soapstone"}

function libLadder.lDown(ladDepth)
    -- Digging and plugging ladder side
    for level = 1, ladDepth, 1 do
        dpFall.fDigDoFull()
    end
    -- Moving to other side of hole
    dpCont.cMoveFo(1, true)
    dpCont.cMoveBa(0)
    -- Digging and plugging gap side
    for level = 1, ladDepth, 1 do
        for side = 1, 4, 1 do
            if side > 1 then
                dpCont.cPlaceFo(selectCobble)
            else
                dpCont.cPlaceFo(selectLadder)
            end
            turtle.turnLeft()
        end
        dpFall.fDigUp("none")
    end
    dpCont.cMoveDo(ladDepth)
    dpCont.cMoveBa(0)
end

return libLadder