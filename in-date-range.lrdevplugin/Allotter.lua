local fraction = require('fraction')

local Allotter = {}
function Allotter:allot(parts, slots)
    if not Allotter:validateParts(parts) and not Allotter:validateSlots(slots) then
        error 'Input invalid, should be positive, non-zero integer.'
    end

    local partsPerSlotLimit = fraction.new(parts, slots)
    local partsPerSlot = {}
    local partsRemainder = fraction.new(0, slots);

    -- loop over all slots
    for i=1,slots do
        local oneAsFraction = fraction.new(1,1)
        partsPerSlot[i] = 0

        -- keep track of the parts that did not
        -- 'fit' in the slot as a remainder
        partsRemainder = fraction.add(partsRemainder, partsPerSlotLimit)

        -- if the remainder is larger than one,
        -- put a part in the slot
        while fraction.approx(fraction.subtract(partsRemainder, oneAsFraction)) >= 0 do
            partsPerSlot[i] = partsPerSlot[i] + 1

            -- since we put a part in the slot,
            -- remove the part (1) from the remainder
            partsRemainder = fraction.subtract(partsRemainder, oneAsFraction)
        end
    end

    return partsPerSlot
end

function Allotter:validateParts(input)
    if not (input % 1 == 0) then
        return false
    end

    if input < 0 then 
        return false
    end

    return true
end

function Allotter:validateSlots(input)
    if not (input % 1 == 0) then
        return false
    end

    if input < 1 then 
        return false
    end

    return true
end

return Allotter
