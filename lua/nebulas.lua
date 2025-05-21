require "traits"

Nebula = {}
Nebula.__index = Nebula

function Nebula:new(party_id)
    local nebula = {
		party_id = party_id,
        position = {},
    }
    setmetatable(nebula, Nebula)
    return nebula
end
