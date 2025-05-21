EventManager = {
    listeners = {}
}

function EventManager.on(event_name, callback)
    if not EventManager.listeners[event_name] then
        EventManager.listeners[event_name] = {}
    end
    table.insert(EventManager.listeners[event_name], callback)
end

function EventManager.emit(event_name, data)
    local listeners = EventManager.listeners[event_name]
    if not listeners then return end
    for _, callback in ipairs(listeners) do
        callback(data)
    end
end

function EventManager.off(event_name, callback)
    local list = EventManager.listeners[event_name]
    if not list then return end
    for i, cb in ipairs(list) do
        if cb == callback then
            table.remove(list, i)
            break
        end
    end
end

BatchedEventManger = {
    queued_events = {},
    listeners = {}
}

function BatchedEventManger.queue(event_name, data)
    if not BatchedEventManger.queued_events[event_name] then
        BatchedEventManger.queued_events[event_name] = {}
    end
    table.insert(BatchedEventManger.queued_events[event_name], data)
end

function BatchedEventManger.on(event_name, callback)
    if not BatchedEventManger.listeners[event_name] then
        BatchedEventManger.listeners[event_name] = {}
    end
    table.insert(BatchedEventManger.listeners[event_name], callback)
end

function BatchedEventManger.flush()
    for event_name, events in pairs(BatchedEventManger.queued_events) do
        local listeners = BatchedEventManger.listeners[event_name]
        if listeners then
            for _, data in ipairs(events) do
                for _, callback in ipairs(listeners) do
                    callback(data)
                end
            end
        end
    end
    BatchedEventManger.queued_events = {} -- clear for next turn
end
