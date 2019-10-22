local argv = {...}

local usage = "Usage:\n" .. shell.getRunningProgram() .. "dl <url> <filename> [%-%-overwrite]"

if #argv < 2 then
	error(usage)
end

local options = {}

for i = 1, #argv do
	if (string.sub(argv[i], 1, 1) == '-') then
		options[#options + 1] = string.sub(argv[i], 2, #argv[i])
		argv.remove(i)
		i = i + 1
	end
end

local overwrite = false

for i = 1, #options do
	if string.sub(options[i], 1, 1) == '-' then
		local option = string.lower(string.sub(options[i], 2, #options[i]))

		if option == "overwrite" then
			overwrite = true
		else
			error(usage)
		end
	elseif string.sub(option, 2, 2) == 'o' then
		overwrite = true
	else
		error(usage)
	end
end

local http_handle = http.get(argv[1])

if not http_handle then
	error("dl: Could not get file")
end

if fs.exists(argv[2]) and (not overwrite) then
	write("dl: File with this name already exists. Overwrite \"" .. argv[2] .. "\"? ")
	local input = string.lower(read())
	if input ~= 'y' and input ~= "yes" then
		http_handle.close()
		error("")
	end
end

local sw = fs.open(argv[2], "w")
sw.write(http_handle.readAll())
sw.close()