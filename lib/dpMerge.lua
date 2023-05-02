-- DiaPork's dpMerge API takes two tables and merges them together
local libMerge = {}

function libMerge.mProcess(tblKey, tblValue)
    local tblOut = {}
    for key, value in pairs(tblKey) do
        tblOut[value] = tblValue[key]
    end
    return tblOut
end

return libMerge