local selectTarget, exceptBlock = ...
if not selectTarget then
    error("ERROR:\nMissing target!")
end
selectTarget = {selectTarget}
-- Defaulting to no exceptions
local exceptBlocks = {exceptBlock} or {"no_exception"}

-- For smart resource extraction
local dpExtract = require("apisDiaPork.dpExtract")

dpExtract.eSurface(selectTarget, exceptBlocks)