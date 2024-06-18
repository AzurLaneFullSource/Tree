local var0_0 = {}

function var0_0.FailNotify(...)
	if var0_0.NotifyFunc then
		var0_0.NotifyFunc(...)
	end
end

function var0_0.DebugNofity(...)
	if var0_0.DebugNofityFunc then
		var0_0.DebugNofityFunc(...)
	end
end

local function var1_0()
	return FileTool.GetCurrentDirectiory() .. "\\"
end

local function var2_0(arg0_4)
	arg0_4 = arg0_4:gsub("/", "\\")

	if arg0_4:find(":") == nil then
		arg0_4 = var1_0() .. arg0_4
	end

	local var0_4 = #arg0_4

	if arg0_4:sub(var0_4, var0_4) == "\\" then
		arg0_4 = arg0_4:sub(1, var0_4 - 1)
	end

	local var1_4 = {}

	for iter0_4 in arg0_4:gmatch("[^\\]+") do
		if iter0_4 == ".." and #var1_4 ~= 0 then
			table.remove(var1_4)
		elseif iter0_4 ~= "." then
			table.insert(var1_4, iter0_4)
		end
	end

	return table.concat(var1_4, "\\")
end

function var0_0.InitFileMap(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5) do
		iter1_5 = var2_0(iter1_5)

		var0_0.NotifyFunc("root path: " .. iter1_5)

		local var0_5 = FileTool.GetAllFiles(iter1_5)

		print("count " .. var0_5.Count)

		for iter2_5 = 0, var0_5.Count - 1 do
			local var1_5 = var0_5:get_Item(iter2_5)
			local var2_5 = string.match(var1_5, ".*\\(.[_a-zA-Z][_a-zA-Z0-9]*)%.lua")

			if var2_5 ~= nil then
				if var0_0.FileMap[var2_5] == nil then
					var0_0.FileMap[var2_5] = {}
				end

				local var3_5 = string.sub(var1_5, #iter1_5 + 2, #var1_5 - 4)
				local var4_5 = string.gsub(var3_5, "\\", ".")

				var0_0.LuaPathToSysPath[var4_5] = SysPath

				table.insert(var0_0.FileMap[var2_5], {
					SysPath = var1_5,
					LuaPath = var4_5
				})
			end
		end

		var0_0.NotifyFunc("load module count: " .. table.getn(var0_0.FileMap))
	end
end

function var0_0.InitFakeTable()
	local var0_6 = {}

	var0_0.Meta = var0_6

	local function var1_6()
		return setmetatable({}, var0_6)
	end

	local function var2_6()
		return
	end

	local function var3_6()
		return var2_6
	end

	local function var4_6(arg0_10, arg1_10)
		var0_0.MetaMap[arg0_10] = arg1_10

		return arg0_10
	end

	local function var5_6(arg0_11)
		if not var0_0.RequireMap[arg0_11] then
			local var0_11 = var1_6()

			var0_0.RequireMap[arg0_11] = var0_11
		end

		return var0_0.RequireMap[arg0_11]
	end

	function var0_6.__index(arg0_12, arg1_12)
		if arg1_12 == "setmetatable" then
			return var4_6
		elseif arg1_12 == "pairs" or arg1_12 == "ipairs" then
			return var3_6
		elseif arg1_12 == "next" then
			return var2_6
		elseif arg1_12 == "require" then
			return var5_6
		else
			local var0_12 = var1_6()

			rawset(arg0_12, arg1_12, var0_12)

			return var0_12
		end
	end

	function var0_6.__newindex(arg0_13, arg1_13, arg2_13)
		rawset(arg0_13, arg1_13, arg2_13)
	end

	function var0_6.__call()
		return var1_6(), var1_6(), var1_6()
	end

	function var0_6.__add()
		return var0_6.__call()
	end

	function var0_6.__sub()
		return var0_6.__call()
	end

	function var0_6.__mul()
		return var0_6.__call()
	end

	function var0_6.__div()
		return var0_6.__call()
	end

	function var0_6.__mod()
		return var0_6.__call()
	end

	function var0_6.__pow()
		return var0_6.__call()
	end

	function var0_6.__unm()
		return var0_6.__call()
	end

	function var0_6.__concat()
		return var0_6.__call()
	end

	function var0_6.__eq()
		return var0_6.__call()
	end

	function var0_6.__lt()
		return var0_6.__call()
	end

	function var0_6.__le()
		return var0_6.__call()
	end

	function var0_6.__len()
		return var0_6.__call()
	end

	return var1_6
end

function var0_0.InitProtection()
	var0_0.Protection = {}
	var0_0.Protection[setmetatable] = true
	var0_0.Protection[pairs] = true
	var0_0.Protection[ipairs] = true
	var0_0.Protection[next] = true
	var0_0.Protection[require] = true
	var0_0.Protection[var0_0] = true
	var0_0.Protection[var0_0.Meta] = true
	var0_0.Protection[math] = true
	var0_0.Protection[string] = true
	var0_0.Protection[table] = true
end

function var0_0.AddFileFromHUList()
	package.loaded[var0_0.UpdateListFile] = nil

	local var0_28 = require(var0_0.UpdateListFile)

	var0_0.ALL = false
	var0_0.HUMap = {}

	for iter0_28, iter1_28 in pairs(var0_28) do
		if iter1_28 == "_ALL_" then
			var0_0.ALL = true

			for iter2_28, iter3_28 in pairs(var0_0.FileMap) do
				for iter4_28, iter5_28 in pairs(iter3_28) do
					var0_0.HUMap[iter5_28.LuaPath] = iter5_28.SysPath
				end
			end

			return
		end

		if var0_0.FileMap[iter1_28] then
			for iter6_28, iter7_28 in pairs(var0_0.FileMap[iter1_28]) do
				var0_0.HUMap[iter7_28.LuaPath] = iter7_28.SysPath
			end
		else
			var0_0.FailNotify("HotUpdate can't not find " .. iter1_28)
		end
	end
end

function var0_0.ErrorHandle(arg0_29)
	var0_0.FailNotify("HotUpdate Error\n" .. tostring(arg0_29))

	var0_0.ErrorHappen = true
end

function var0_0.BuildNewCode(arg0_30, arg1_30)
	io.input(arg0_30)

	local var0_30 = io.read("*all")

	if var0_0.ALL and var0_0.OldCode[arg0_30] == nil then
		var0_0.OldCode[arg0_30] = var0_30

		io.input():close()

		return
	end

	if var0_0.OldCode[arg0_30] == var0_30 then
		io.input():close()

		return false
	end

	io.input():close()
	io.input(arg0_30)

	local var1_30 = ("--[[" .. arg1_30 .. "]] ") .. var0_30

	io.input():close()

	local var2_30 = loadstring(var1_30)

	if not var2_30 then
		var0_0.FailNotify(arg0_30 .. " has syntax error.")
		collectgarbage("collect")

		return false
	else
		var0_0.FakeENV = var0_0.FakeT()
		var0_0.MetaMap = {}
		var0_0.RequireMap = {}

		setfenv(var2_30, var0_0.FakeENV)

		local var3_30

		var0_0.ErrorHappen = false

		xpcall(function()
			var3_30 = var2_30()
		end, var0_0.ErrorHandle)

		if not var0_0.ErrorHappen then
			var0_0.OldCode[arg0_30] = var0_30

			return true, var3_30
		else
			collectgarbage("collect")

			return false
		end
	end
end

function var0_0.Travel_G()
	local var0_32 = {
		[var0_0] = true
	}

	local function var1_32(arg0_33)
		if type(arg0_33) ~= "function" and type(arg0_33) ~= "table" or var0_32[arg0_33] or var0_0.Protection[arg0_33] then
			return
		end

		var0_32[arg0_33] = true

		if type(arg0_33) == "function" then
			for iter0_33 = 1, math.huge do
				local var0_33, var1_33 = debug.getupvalue(arg0_33, iter0_33)

				if not var0_33 then
					break
				end

				if type(var1_33) == "function" then
					for iter1_33, iter2_33 in ipairs(var0_0.ChangedFuncList) do
						if var1_33 == iter2_33[1] then
							debug.setupvalue(arg0_33, iter0_33, iter2_33[2])
						end
					end
				end

				var1_32(var1_33)
			end
		elseif type(arg0_33) == "table" then
			var1_32(debug.getmetatable(arg0_33))

			local var2_33 = {}

			for iter3_33, iter4_33 in pairs(arg0_33) do
				var1_32(iter3_33)
				var1_32(iter4_33)

				if type(iter4_33) == "function" then
					for iter5_33, iter6_33 in ipairs(var0_0.ChangedFuncList) do
						if iter4_33 == iter6_33[1] then
							arg0_33[iter3_33] = iter6_33[2]
						end
					end
				end

				if type(iter3_33) == "function" then
					for iter7_33, iter8_33 in ipairs(var0_0.ChangedFuncList) do
						if iter3_33 == iter8_33[1] then
							var2_33[#var2_33 + 1] = iter7_33
						end
					end
				end
			end

			for iter9_33, iter10_33 in ipairs(var2_33) do
				local var3_33 = var0_0.ChangedFuncList[iter10_33]

				arg0_33[var3_33[2]] = arg0_33[var3_33[1]]
				arg0_33[var3_33[1]] = nil
			end
		end
	end

	var1_32(_G)

	local var2_32 = debug.getregistry()

	for iter0_32, iter1_32 in ipairs(var0_0.ChangedFuncList) do
		for iter2_32, iter3_32 in pairs(var2_32) do
			if iter3_32 == iter1_32[1] then
				var2_32[iter2_32] = iter1_32[2]
			end
		end
	end

	for iter4_32, iter5_32 in ipairs(var0_0.ChangedFuncList) do
		if iter5_32[3] == "HUDebug" then
			iter5_32[4]:HUDebug()
		end
	end
end

function var0_0.ReplaceOld(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	if type(arg0_34) == type(arg1_34) then
		if type(arg1_34) == "table" then
			var0_0.UpdateAllFunction(arg0_34, arg1_34, arg2_34, arg3_34, "")
		elseif type(arg1_34) == "function" then
			var0_0.UpdateOneFunction(arg0_34, arg1_34, arg2_34, nil, arg3_34, "")
		end
	end
end

function var0_0.HotUpdateCode(arg0_35, arg1_35)
	local var0_35 = package.loaded[arg0_35]

	if var0_35 ~= nil then
		var0_0.VisitedSig = {}
		var0_0.ChangedFuncList = {}

		local var1_35, var2_35 = var0_0.BuildNewCode(arg1_35, arg0_35)

		if var1_35 then
			var0_0.NotifyFunc("update module " .. arg0_35)
			var0_0.ReplaceOld(var0_35, var2_35, arg0_35, "Main", "")

			for iter0_35, iter1_35 in pairs(var0_0.RequireMap) do
				local var3_35 = package.loaded[iter0_35]

				var0_0.ReplaceOld(var3_35, iter1_35, iter0_35, "Main_require", "")
			end

			setmetatable(var0_0.FakeENV, nil)
			var0_0.UpdateAllFunction(var0_0.ENV, var0_0.FakeENV, " ENV ", "Main", "")

			if #var0_0.ChangedFuncList > 0 then
				var0_0.Travel_G()
			end

			collectgarbage("collect")
		end
	elseif var0_0.OldCode[arg1_35] == nil then
		io.input(arg1_35)

		var0_0.OldCode[arg1_35] = io.read("*all")

		io.input():close()
	end
end

function var0_0.ResetENV(arg0_36, arg1_36, arg2_36, arg3_36)
	local var0_36 = {}

	local function var1_36(arg0_37, arg1_37)
		if not arg0_37 or var0_36[arg0_37] then
			return
		end

		var0_36[arg0_37] = true

		if type(arg0_37) == "function" then
			var0_0.DebugNofity(arg3_36 .. "HU.ResetENV", arg1_37, "  from:" .. arg2_36)
			xpcall(function()
				setfenv(arg0_37, var0_0.ENV)
			end, var0_0.FailNotify)
		elseif type(arg0_37) == "table" then
			var0_0.DebugNofity(arg3_36 .. "HU.ResetENV", arg1_37, "  from:" .. arg2_36)

			for iter0_37, iter1_37 in pairs(arg0_37) do
				var1_36(iter0_37, tostring(iter0_37) .. "__key", " HU.ResetENV ", arg3_36 .. "    ")
				var1_36(iter1_37, tostring(iter0_37), " HU.ResetENV ", arg3_36 .. "    ")
			end
		end
	end

	var1_36(arg0_36, arg1_36)
end

function var0_0.UpdateUpvalue(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39)
	var0_0.DebugNofity(arg4_39 .. "HU.UpdateUpvalue", arg2_39, "  from:" .. arg3_39)

	local var0_39 = {}
	local var1_39 = {}

	for iter0_39 = 1, math.huge do
		local var2_39, var3_39 = debug.getupvalue(arg0_39, iter0_39)

		if not var2_39 then
			break
		end

		var0_39[var2_39] = var3_39
		var1_39[var2_39] = true
	end

	for iter1_39 = 1, math.huge do
		local var4_39, var5_39 = debug.getupvalue(arg1_39, iter1_39)

		if not var4_39 then
			break
		end

		if var1_39[var4_39] then
			local var6_39 = var0_39[var4_39]

			if type(var6_39) ~= type(var5_39) then
				debug.setupvalue(arg1_39, iter1_39, var6_39)
			elseif type(var6_39) == "function" then
				var0_0.UpdateOneFunction(var6_39, var5_39, var4_39, nil, "HU.UpdateUpvalue", arg4_39 .. "    ")
			elseif type(var6_39) == "table" then
				var0_0.UpdateAllFunction(var6_39, var5_39, var4_39, "HU.UpdateUpvalue", arg4_39 .. "    ")
				debug.setupvalue(arg1_39, iter1_39, var6_39)
			else
				debug.setupvalue(arg1_39, iter1_39, var6_39)
			end
		else
			var0_0.ResetENV(var5_39, var4_39, "HU.UpdateUpvalue", arg4_39 .. "    ")
		end
	end
end

function var0_0.UpdateOneFunction(arg0_40, arg1_40, arg2_40, arg3_40, arg4_40, arg5_40)
	if var0_0.Protection[arg0_40] or var0_0.Protection[arg1_40] then
		return
	end

	if arg0_40 == arg1_40 then
		return
	end

	local var0_40 = tostring(arg0_40) .. tostring(arg1_40)

	if var0_0.VisitedSig[var0_40] then
		return
	end

	var0_0.VisitedSig[var0_40] = true

	var0_0.DebugNofity(arg5_40 .. "HU.UpdateOneFunction " .. arg2_40 .. "  from:" .. arg4_40)

	if pcall(debug.setfenv, arg1_40, getfenv(arg0_40)) then
		var0_0.UpdateUpvalue(arg0_40, arg1_40, arg2_40, "HU.UpdateOneFunction", arg5_40 .. "    ")

		var0_0.ChangedFuncList[#var0_0.ChangedFuncList + 1] = {
			arg0_40,
			arg1_40,
			arg2_40,
			arg3_40
		}
	end
end

function var0_0.UpdateAllFunction(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41)
	if var0_0.Protection[arg0_41] or var0_0.Protection[arg1_41] then
		return
	end

	if arg0_41 == arg1_41 then
		return
	end

	local var0_41 = tostring(arg0_41) .. tostring(arg1_41)

	if var0_0.VisitedSig[var0_41] then
		return
	end

	var0_0.VisitedSig[var0_41] = true

	var0_0.DebugNofity(arg4_41 .. "HU.UpdateAllFunction " .. arg2_41 .. "  from:" .. arg3_41)

	for iter0_41, iter1_41 in pairs(arg1_41) do
		local var1_41 = arg0_41[iter0_41]

		if type(iter1_41) == type(var1_41) then
			if type(iter1_41) == "function" then
				var0_0.UpdateOneFunction(var1_41, iter1_41, iter0_41, arg0_41, "HU.UpdateAllFunction", arg4_41 .. "    ")
			elseif type(iter1_41) == "table" then
				var0_0.UpdateAllFunction(var1_41, iter1_41, iter0_41, "HU.UpdateAllFunction", arg4_41 .. "    ")
			end
		elseif var1_41 == nil and type(iter1_41) == "function" and pcall(setfenv, iter1_41, var0_0.ENV) then
			arg0_41[iter0_41] = iter1_41
		end
	end

	local var2_41 = debug.getmetatable(arg0_41)
	local var3_41 = var0_0.MetaMap[arg1_41]

	if type(var2_41) == "table" and type(var3_41) == "table" then
		var0_0.UpdateAllFunction(var2_41, var3_41, arg2_41 .. "'s Meta", "HU.UpdateAllFunction", arg4_41 .. "    ")
	end
end

function var0_0.Init(arg0_42, arg1_42, arg2_42, arg3_42)
	var0_0.UpdateListFile = arg0_42
	var0_0.HUMap = {}
	var0_0.FileMap = {}
	var0_0.NotifyFunc = arg2_42
	var0_0.OldCode = {}
	var0_0.ChangedFuncList = {}
	var0_0.VisitedSig = {}
	var0_0.FakeENV = nil
	var0_0.ENV = arg3_42 or _G
	var0_0.LuaPathToSysPath = {}

	var0_0.InitFileMap(arg1_42)

	var0_0.FakeT = var0_0.InitFakeTable()

	var0_0.InitProtection()

	var0_0.ALL = false
end

function var0_0.Update()
	var0_0.AddFileFromHUList()

	for iter0_43, iter1_43 in pairs(var0_0.HUMap) do
		var0_0.HotUpdateCode(iter0_43, iter1_43)
	end
end

return var0_0
