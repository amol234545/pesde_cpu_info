local fs = require("@lune/fs")
local process = require("@lune/process")

type Processor = {
	vendor: string,
	name: string,
	threads: number,
	cores: number,
}

local function strip_end(s : string)
    
    if s == nil then
        return ""
    end

    -- remove leading whitespaces
    local _, pos = string.find(s, '^%s+')
    if pos then
        s = string.sub(s, pos + 1)
    end

    -- remove trailing whitespaces
    pos = string.find(s, '%s+$')
    if pos then
        return string.sub(s, 1, pos - 1)
    end

    return s
end

local function cpu_info(): Processor
	--TODO: MacOS support
	local cpu_info = {}
	if process.os == "linux" then
		local info = fs.readFile("/proc/cpuinfo")
		for _, line in info:split("\n") do
			local name, value = table.unpack(line:split(":"))
			cpu_info[strip_end(name)] = strip_end(value)
		end
	else
		if process.os == "windows" then
			local info = process.spawn("wmic",{"cpu", "get" ,"/format:list"},{shell = true}).stdout
			for _, line in info:split("\n") do
				local name, value = table.unpack(line:split("="))
				cpu_info[strip_end(name)] = strip_end(value)
			end
		end
	end
    return {
        vendor = cpu_info["vendor_id"] or cpu_info["Manufacturer"],
        name = cpu_info["model name"] or cpu_info["Name"],
        threads = tonumber(cpu_info["siblings"] or cpu_info["NumberOfLogicalProcessors"]),
        cores = tonumber(cpu_info["cpu cores"] or cpu_info["NumberOfCores"]),
    }
end

return cpu_info