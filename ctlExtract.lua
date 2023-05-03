local selectTarget, exceptBlock = ...
if not selectTarget then
    error("ERROR:\nMissing target!")
end
selectTarget = {selectTarget}
-- Defaulting to no exceptions
local exceptBlocks = {exceptBlock} or {"no_exception"}

package.path = "/apisDiaPork/lib/?.lua;" .. package.path
-- For smart resource extraction
local dpExtract = require("dpExtract")

dpExtract.eSurface(selectTarget, exceptBlocks)
