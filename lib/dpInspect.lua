-- DiaPork's dpInspect API analyses blocks using metamethod lookup tables
local libInspect = {}

-- Compares block infront with pattern list
function libInspect.iCompareFo(insPattern, tableExcept, matchMods)
    -- Defaulting to no exceptions
    tableExcept = tableExcept or { "no_exception" }
    -- Defaulting to matching modded
    if matchMods == nil then matchMods = true end
    
    -- Comparing inspection with dictionary lookup
    local _,ins = turtle.inspect()
    local boolTest = ins.name == "minecraft:" .. insPattern[1]
    return boolTest
end

-- Compares block above with pattern list
function libInspect.iCompareUp(insPattern, tableExcept, matchMods)
    -- Defaulting to no exceptions
    tableExcept = tableExcept or { "no_exception" }
    -- Defaulting to matching modded
    if matchMods == nil then matchMods = true end
    
    -- Comparing inspection with dictionary lookup
    local _,ins = turtle.inspectUp()
    local boolTest = ins.name == "minecraft:" .. insPattern[1]
    return boolTest
end

-- Compares block below with pattern list
function libInspect.iCompareDo(insPattern, tableExcept, matchMods)
    -- Defaulting to no exceptions
    tableExcept = tableExcept or { "no_exception" }
    -- Defaulting to matching modded
    if matchMods == nil then matchMods = true end
    
    -- Comparing inspection with dictionary lookup
    local _,ins = turtle.inspectDown()
    local boolTest = ins.name == "minecraft:" .. insPattern[1]
    return boolTest
end

-- Compares inventory item with pattern list
function libInspect.iCompareItem(insPattern, slotNum)
    -- Finding item data
    local item = turtle.getItemDetail(slotNum)
    local boolTest = item.name == "minecraft:" .. insPattern[1]
    return boolTest
end

-- Prints data from inspection
function libInspect.iReport(reportType)
    reportType = reportType:lower()
    local reportModded = true
    if reportType == "block" then
        local exists, ins = turtle.inspect()
        if ins.name:match("minecraft:") then reportModded = false end
        if exists then
            if not reportModded then
                print("Name:", ins.name)
                print("Type:", ins.state.variant)
                print("Metadata:", ins.metadata)
            else
                print("Name:", ins.name)
                print("Type:", ins.state.type)
                print("Metadata:", ins.metadata)
            end
        end
    elseif reportType == "item" then
        local det = turtle.getItemDetail()
        if det.name:match("minecraft:") then reportModded = false end
        if not reportModded then
            print("Name:", det.name)
            print("Metadata:", det.damage)
        elseif det.name then
            print("Name:", det.name)
            print("ID:", det.name)
            print("Metadata:", det.damage)
        end
    end
end

return libInspect