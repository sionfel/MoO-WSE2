-- Making saving and loading a mile easier, lol
--
--
Serializer = {}

function Serializer.save(obj)
    local result = {}
    local transient = obj.__transient or {}

    for k, v in pairs(obj) do
        if type(k) == "string" and type(v) ~= "function" and not transient[k] then
            result[k] = v
        end
    end

    return result
end

function Serializer.load(obj, data)
    for k, v in pairs(data) do
        if v ~= "null" then
            obj[k] = v
        end
    end
    return obj
end
