# pesde_cpu_info

Gets info about the CPU.

# Example
```lua
    local cpu_info = require("@pkg/cpu_info")
    print(cpu_info())
    --[[ 
        {
            vendor: ...,
	        name: ...,
	        threads: ...,
	        cores: ...,
        }
    ]]