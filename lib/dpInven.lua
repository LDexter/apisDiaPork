-- DiaPork's dpInven API handles inventory management
local libInven = {}

package.path = "/apisDiaPork/lib/?.lua;" .. package.path
-- For merging tables into dictionary
local dpMerge = require("dpMerge")
-- For easy inspections against dynamic lookup tables
local dpInspect = require("dpInspect")

-- Selects 
function libInven.iSelect(selectPattern)
    for slot = 16, 1, -1 do
        if turtle.getItemCount(slot) > 0 then
            -- Testing against lookups of listed items
            if dpInspect.iCompareItem(selectPattern, slot) then
                turtle.select(slot)
                return true
            end
        end
    end
end

-- Organises inventory
function libInven.iOrganise()
    -- Looping through all inventory slots
    for slot = 16, 1, -1 do
        -- Selecting slot based on index
        turtle.select(slot)
        local varOrg = 1
        -- Looping through entire stack within selected slot
        while varOrg < slot and turtle.getItemCount(slot) > 0 do
            -- Shifting items to be grouped together
            if turtle.compareTo(varOrg) or turtle.getItemCount(varOrg) < 1 then
                turtle.transferTo(varOrg)
            end
            varOrg = varOrg + 1
        end
    end
end

-- Searching inventory to drop all listed items
function libInven.iDrop(selectPattern)
    -- Converting to table if string
    if type(selectPattern) == "string" then
        selectPattern = {selectPattern}
    end
    local slotDrop = 9
    local stackCount = 0
    for _, pattern in pairs(selectPattern) do
        -- Checking for items in last row to determine if inventory is full
        if turtle.getItemCount(slotDrop) > 0 then
            for item = 16, 4, -1 do
                if turtle.getItemCount(item) > 0 then
                    if dpInspect.iCompareItem(pattern, item) then
                        turtle.select(item)
                        turtle.drop(64)
                        stackCount = stackCount + 1
                    end
                end
            end
        end
    end
end

-- Refuels only if low, with whatever items can be used
function libInven.iFuel()
    if turtle.getFuelLevel() < 42 then
        -- Declaring fuel counter
        local fuelCount = 0
        -- Looping through all inventroy slots
        for slot = 1, 16, 1 do
            -- Selecting slot based on index
            turtle.select(slot)
            -- Refuelling and counting
            if turtle.refuel() then
                fuelCount = fuelCount + 1
            end
        end
        -- Printing fuel stats
        print("Refuelled from ", fuelCount, " item(s),\nto reach ", turtle.getFuelLevel(), " fuel")
    end
end

-- Searches inventory for requirements and throws error report on missing items
function libInven.iRequire(tblRequired, tblCount)
    local itemCount
    local reqCount
    local isMatch
    local isEnough
    local isError
    local strError = "Requirements missing:"
    -- Merging tables for better indexing
    libInven.dictReq = dpMerge.mProcess(tblRequired, tblCount)
    -- local index = 0
    for name, count in pairs(libInven.dictReq) do
        -- if not name or not count then return end
        reqCount = count
        for slot = 1, 16, 1 do
            -- Update values
            turtle.select(slot)
            itemCount = turtle.getItemCount()
            isMatch = dpInspect.iCompareItem(name)
            isEnough = reqCount < 1

            -- If match, remove requirement
            if isMatch and isEnough then
                break
            end
            -- If matching count is not enough, subtract from target count
            if isMatch and not isEnough then
                reqCount = reqCount - itemCount
                isEnough = reqCount < 1
            end

            -- Concatonate missing items
            if not isEnough and slot == 16 then
                isError = true
                strError = strError .. "\n" .. reqCount .. " " .. name
            end
        end
    end
    -- Throw error to warn of requirements
    if isError then
        error(strError, 0)
    end
    print("All requirements available")
end

-- Packs items into any shulker-like invetory
function libInven.iPack(tblPack)
    -- Converting to table if string 
    if type(tblPack) == "string" then
        tblPack = {tblPack}
    end

    -- Placing inventory
    local tblShulker = { "Shulker", "mekanism:machineblock" }
    libInven.iSelect(tblShulker)
    turtle.place()

    -- Searching for items to pack
    for slot = 16, 1, -1 do
        if turtle.getItemCount(slot) > 0 then
            -- Testing against lookups of listed items
            local isPack = dpInspect.iCompareItem(tblPack, slot)
            if isPack then
                turtle.select(slot)
                turtle.drop()
            end
        end
    end
    turtle.dig()
end

return libInven