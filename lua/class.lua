function Class(base, name)
    local c = {}
    c.__name = name or "UnnamedClass"
    if base then
        setmetatable(c, { __index = base })
        c.super = base
    end
    c.__index = c

    function c:new(...)
        local instance = setmetatable({}, c)
        if instance.init then
            instance:init(...)
        end
        return instance
    end

    function c:is_a(class)
        local mt = getmetatable(self)
        while mt do
            if mt == class then
                return true
            end
            mt = mt.super
        end
        return false
    end

    function c:get_class_name()
        return rawget(c, "__name") or "Unknown"
    end

    return c
end

function set_transient(class, ...)
    class.__transient = class.__transient or {}
    for _, name in ipairs({...}) do
        class.__transient[name] = true
    end
end