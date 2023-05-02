-- DiaPork's dpMeta API reconfigures table indexing to be compatible with values as keys
local libMeta = {}

function libMeta.mTableAttach(tbl, nestDepth)
    -- Declaring metatable variable for 1D table
    local metatable1D = {
        -- Setting function to call when indexing
        __index = function(self, index)
            -- Allowing native key index, otherwise supporting value as key
            local raw = rawget(self, index)
            if raw then
                return raw
            else
                -- Swapping pairs
                local temp = {}
                for key, value in pairs(self) do
                    temp[value] = key
                end
                return temp[index]
            end
        end
    }

    -- Declaring metatable variable for 2D table
    local metatable2D = {
        --? Setting function to call when indexing
        ["__index"] = function(self, idx)
            local value = rawget(self, idx)
            -- Allowing native key index
            if value then return value end

            -- Otherwise loop through outer value while dropping outer key
            for _, vOuter in pairs(tbl) do
                local tmp = {}
                -- Supporting inner value as key
                for kInner, vInner in pairs(vOuter) do
                    tmp[vInner] = kInner
                end

                -- Outputting result
                local result = tmp[idx]
                if result then
                    return self[result]
                end
            end
        end
    }

    -- Attaching metatable to table, depending on depth of nesting
    if nestDepth == "1D" then
        for _, v in pairs(tbl) do
            setmetatable(v, metatable1D)
        end
    elseif nestDepth == "2D" then
        for _, v in pairs(tbl) do
            setmetatable(v, metatable2D)
        end
    end

    return tbl
end

return libMeta