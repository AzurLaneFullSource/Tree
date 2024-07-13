local var0_0 = LuaProfiler
local var1_0 = jit and require("jit.vmdef")
local var2_0 = {
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
local var3_0 = {
	ipairs_aux = 1,
	["_xpcall.__call"] = 1,
	unknow = 1
}
local var4_0 = {
	mark = 1,
	cache = 1
}
local var5_0 = {}

function var4_0.scan(arg0_1, arg1_1, arg2_1)
	if arg0_1.mark[arg1_1] then
		return
	end

	arg0_1.mark[arg1_1] = true

	for iter0_1, iter1_1 in pairs(arg1_1) do
		if type(iter0_1) == "string" then
			if type(iter1_1) == "function" then
				local var0_1 = iter0_1

				if arg2_1 then
					var0_1 = arg2_1 .. "." .. var0_1
				end

				if not var3_0[var0_1] and iter0_1 ~= "__index" and iter0_1 ~= "__newindex" then
					arg0_1.cache[iter1_1] = {
						id = -1,
						name = var0_1
					}
				end
			elseif type(iter1_1) == "table" and not arg0_1.mark[iter1_1] then
				arg0_1:scan(iter1_1, iter0_1)
			end
		elseif arg2_1 and iter0_1 == tolua.gettag or iter0_1 == tolua.settag then
			arg0_1:scan(iter1_1, arg2_1)
		end
	end
end

function var4_0.scanlibs(arg0_2)
	local var0_2 = package.loaded

	arg0_2.mark[var0_2] = true

	for iter0_2, iter1_2 in pairs(var0_2) do
		if type(iter0_2) == "string" and type(iter1_2) == "table" then
			arg0_2:scan(iter1_2, iter0_2)

			local var1_2 = getmetatable(iter1_2)

			if var1_2 then
				arg0_2:scan(var1_2, iter0_2)
			end
		end
	end
end

local function var6_0(arg0_3)
	local var0_3 = #var5_0 + 1

	for iter0_3, iter1_3 in ipairs(var5_0) do
		if iter1_3 == arg0_3 then
			var0_3 = iter0_3
		end
	end

	return var0_3
end

local function var7_0(arg0_4)
	local var0_4 = #var5_0

	if var0_4 > 0 then
		local var1_4 = debug.getinfo(5, "f")

		if var1_4 then
			local var2_4 = var1_4.func
			local var3_4 = var6_0(var2_4)

			if var0_4 < var3_4 then
				local var4_4 = debug.getinfo(6, "f")

				if var4_4 then
					local var5_4 = var4_4.func

					var3_4 = var6_0(var5_4) or var3_4
				end
			end

			for iter0_4 = var3_4 + 1, var0_4 do
				table.remove(var5_0)
				var0_0.EndSample()
			end
		end
	end
end

local function var8_0(arg0_5, arg1_5, arg2_5)
	var7_0()
	table.insert(var5_0, arg1_5)

	if arg2_5.id == -1 then
		arg2_5.name = arg0_5
		arg2_5.id = var0_0.GetID(arg0_5)
	end

	var0_0.BeginSample(arg2_5.id)
end

local function var9_0(arg0_6, arg1_6, arg2_6)
	var7_0()
	table.insert(var5_0, arg1_6)

	local var0_6 = -1

	if arg2_6.nick == nil then
		arg2_6.nick = {}
	end

	local var1_6 = arg2_6.nick[arg0_6]

	if not var1_6 then
		var1_6 = var0_0.GetID(arg0_6)
		arg2_6.nick[arg0_6] = var1_6
	end

	var0_0.BeginSample(var1_6)
end

function profiler_hook(arg0_7, arg1_7)
	if arg0_7 == "call" then
		local var0_7
		local var1_7 = debug.getinfo(2, "f").func
		local var2_7 = var4_0.cache[var1_7]

		if var2_7 then
			var0_7 = var2_7.name
		end

		if var3_0[var0_7] then
			return
		end

		if var0_7 == "event.__call" then
			local var3_7 = debug.getinfo(2, "n")

			var9_0(var3_7.name or var0_7, var1_7, var2_7)
		elseif var0_7 then
			var8_0(var0_7, var1_7, var2_7)
		else
			local var4_7 = debug.getinfo(2, "Sn")
			local var5_7 = var4_7.name
			local var6_7 = var4_7.linedefined

			if not var2_7 then
				var2_7 = {
					id = -1,
					name = "unknow"
				}
				var4_0.cache[var1_7] = var2_7
			end

			if var4_7.short_src == "[C]" then
				if var5_7 == "__index" or var5_7 == "__newindex" then
					return
				end

				local var7_7 = tostring(var1_7):match("function: builtin#(%d+)")

				if not var7_7 then
					if var5_7 then
						local var8_7 = var5_7

						var8_0(var5_7, var1_7, var2_7)
					elseif var6_7 ~= -1 then
						local var9_7 = var4_7.short_src .. var6_7

						var8_0(var9_7, var1_7, var2_7)
					end
				else
					local var10_7 = var1_0.ffnames[tonumber(var7_7)]

					if not var3_0[var10_7] then
						var8_0(var10_7, var1_7, var2_7)
					end
				end
			elseif var6_7 ~= -1 or var5_7 then
				local var11_7 = var4_7.short_src

				var5_7 = var5_7 or var6_7

				local var12_7
				local var13_7 = var11_7:match("([^/\\]+)%.%w+$") or var11_7:match("([^/\\]+)$")
				local var14_7 = var2_0[var13_7]

				if var14_7 then
					var13_7 = var14_7[var6_7]
				else
					var13_7 = var13_7 .. "." .. var5_7
				end

				var13_7 = var13_7 or var11_7 .. "." .. var5_7

				var8_0(var13_7, var1_7, var2_7)
			else
				var8_0(var0_7, var1_7, var2_7)
			end
		end
	elseif arg0_7 == "return" then
		local var15_7 = #var5_0

		if var15_7 == 0 then
			return
		end

		local var16_7 = debug.getinfo(2, "f")

		if var16_7.func == var5_0[var15_7] then
			table.remove(var5_0)
			var0_0.EndSample()
		else
			local var17_7 = var6_0(var16_7.func)

			if var15_7 < var17_7 then
				return
			end

			for iter0_7 = var17_7, var15_7 do
				table.remove(var5_0)
				var0_0.EndSample()
			end
		end
	end
end

function var4_0.start(arg0_8)
	arg0_8.mark = {}
	arg0_8.cache = {
		__mode = "k"
	}

	arg0_8:scan(_G, nil)
	arg0_8:scanlibs()

	arg0_8.mark = nil

	debug.sethook(profiler_hook, "cr", 0)
end

function var4_0.print(arg0_9)
	for iter0_9, iter1_9 in pairs(arg0_9.cache) do
		print(iter1_9.name)
	end
end

function var4_0.stop(arg0_10)
	debug.sethook(nil)

	arg0_10.cache = nil
end

return var4_0
