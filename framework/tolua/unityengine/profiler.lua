local var0 = LuaProfiler
local var1 = jit and require("jit.vmdef")
local var2 = {
	event = {
		[20] = "_xpcall.__call",
		[142] = "event.__call"
	},
	slot = {
		[11] = "slot.__call"
	},
	MainScene = {
		[250] = "MainScene.Update"
	}
}
local var3 = {
	ipairs_aux = 1,
	["_xpcall.__call"] = 1,
	unknow = 1
}
local var4 = {
	mark = 1,
	cache = 1
}
local var5 = {}

function var4.scan(arg0, arg1, arg2)
	if arg0.mark[arg1] then
		return
	end

	arg0.mark[arg1] = true

	for iter0, iter1 in pairs(arg1) do
		if type(iter0) == "string" then
			if type(iter1) == "function" then
				local var0 = iter0

				if arg2 then
					var0 = arg2 .. "." .. var0
				end

				if not var3[var0] and iter0 ~= "__index" and iter0 ~= "__newindex" then
					arg0.cache[iter1] = {
						id = -1,
						name = var0
					}
				end
			elseif type(iter1) == "table" and not arg0.mark[iter1] then
				arg0:scan(iter1, iter0)
			end
		elseif arg2 and iter0 == tolua.gettag or iter0 == tolua.settag then
			arg0:scan(iter1, arg2)
		end
	end
end

function var4.scanlibs(arg0)
	local var0 = package.loaded

	arg0.mark[var0] = true

	for iter0, iter1 in pairs(var0) do
		if type(iter0) == "string" and type(iter1) == "table" then
			arg0:scan(iter1, iter0)

			local var1 = getmetatable(iter1)

			if var1 then
				arg0:scan(var1, iter0)
			end
		end
	end
end

local function var6(arg0)
	local var0 = #var5 + 1

	for iter0, iter1 in ipairs(var5) do
		if iter1 == arg0 then
			var0 = iter0
		end
	end

	return var0
end

local function var7(arg0)
	local var0 = #var5

	if var0 > 0 then
		local var1 = debug.getinfo(5, "f")

		if var1 then
			local var2 = var1.func
			local var3 = var6(var2)

			if var0 < var3 then
				local var4 = debug.getinfo(6, "f")

				if var4 then
					local var5 = var4.func

					var3 = var6(var5) or var3
				end
			end

			for iter0 = var3 + 1, var0 do
				table.remove(var5)
				var0.EndSample()
			end
		end
	end
end

local function var8(arg0, arg1, arg2)
	var7()
	table.insert(var5, arg1)

	if arg2.id == -1 then
		arg2.name = arg0
		arg2.id = var0.GetID(arg0)
	end

	var0.BeginSample(arg2.id)
end

local function var9(arg0, arg1, arg2)
	var7()
	table.insert(var5, arg1)

	local var0 = -1

	if arg2.nick == nil then
		arg2.nick = {}
	end

	local var1 = arg2.nick[arg0]

	if not var1 then
		var1 = var0.GetID(arg0)
		arg2.nick[arg0] = var1
	end

	var0.BeginSample(var1)
end

function profiler_hook(arg0, arg1)
	if arg0 == "call" then
		local var0
		local var1 = debug.getinfo(2, "f").func
		local var2 = var4.cache[var1]

		if var2 then
			var0 = var2.name
		end

		if var3[var0] then
			return
		end

		if var0 == "event.__call" then
			local var3 = debug.getinfo(2, "n")

			var9(var3.name or var0, var1, var2)
		elseif var0 then
			var8(var0, var1, var2)
		else
			local var4 = debug.getinfo(2, "Sn")
			local var5 = var4.name
			local var6 = var4.linedefined

			if not var2 then
				var2 = {
					id = -1,
					name = "unknow"
				}
				var4.cache[var1] = var2
			end

			if var4.short_src == "[C]" then
				if var5 == "__index" or var5 == "__newindex" then
					return
				end

				local var7 = tostring(var1):match("function: builtin#(%d+)")

				if not var7 then
					if var5 then
						local var8 = var5

						var8(var5, var1, var2)
					elseif var6 ~= -1 then
						local var9 = var4.short_src .. var6

						var8(var9, var1, var2)
					end
				else
					local var10 = var1.ffnames[tonumber(var7)]

					if not var3[var10] then
						var8(var10, var1, var2)
					end
				end
			elseif var6 ~= -1 or var5 then
				local var11 = var4.short_src

				var5 = var5 or var6

				local var12
				local var13 = var11:match("([^/\\]+)%.%w+$") or var11:match("([^/\\]+)$")
				local var14 = var2[var13]

				if var14 then
					var13 = var14[var6]
				else
					var13 = var13 .. "." .. var5
				end

				var13 = var13 or var11 .. "." .. var5

				var8(var13, var1, var2)
			else
				var8(var0, var1, var2)
			end
		end
	elseif arg0 == "return" then
		local var15 = #var5

		if var15 == 0 then
			return
		end

		local var16 = debug.getinfo(2, "f")

		if var16.func == var5[var15] then
			table.remove(var5)
			var0.EndSample()
		else
			local var17 = var6(var16.func)

			if var15 < var17 then
				return
			end

			for iter0 = var17, var15 do
				table.remove(var5)
				var0.EndSample()
			end
		end
	end
end

function var4.start(arg0)
	arg0.mark = {}
	arg0.cache = {
		__mode = "k"
	}

	arg0:scan(_G, nil)
	arg0:scanlibs()

	arg0.mark = nil

	debug.sethook(profiler_hook, "cr", 0)
end

function var4.print(arg0)
	for iter0, iter1 in pairs(arg0.cache) do
		print(iter1.name)
	end
end

function var4.stop(arg0)
	debug.sethook(nil)

	arg0.cache = nil
end

return var4
