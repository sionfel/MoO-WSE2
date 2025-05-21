local mooLog = io.open("logs/MooLog.txt", "a")

local curTime = os.date("%Y.%m.%d, %X")

function InitialLog()
	mooLog:write("Started playing at " .. curTime .. "\n")
	mooLog:flush()
end

function WriteLogLine(str, to_print)
	local to_print = to_print or false
	if to_print then
		print(str)
	end
	mooLog:write(curTime .. ": " .. str .. "\n")
	mooLog:flush()
end
