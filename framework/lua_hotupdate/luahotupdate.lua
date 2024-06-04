local var0 = {}

function var0.FailNotify(...)
	if var0.NotifyFunc then
		var0.NotifyFunc(...)
	end
end

function var0.DebugNofity(...)
	if var0.DebugNofityFunc then
		var0.DebugNofityFunc(...)
	end
end

local function var1()
	return FileTool.GetCurrentDirectiory() .. "\\"
end

local function var2(arg0)
	arg0 = arg0:gsub("/", "\\")

	if arg0:find(":") == nil then
		arg0 = var1() .. arg0
	end

	local var0 = #arg0

	if arg0:sub(var0, var0) == "\\" then
		arg0 = arg0:sub(1, var0 - 1)
	end

	local var1 = {}

	for iter0 in arg0:gmatch("[^\\]+") do
		if iter0 == ".." and #var1 ~= 0 then
			table.remove(var1)
		elseif iter0 ~= "." then
			table.insert(var1, iter0)
		end
	end

	return table.concat(var1, "\\")
end

function var0.InitFileMap(arg0)
	for iter0, iter1 in pairs(arg0) do
		iter1 = var2(iter1)

		var0.NotifyFunc("root path: " .. iter1)

		local var0 = FileTool.GetAllFiles(iter1)

		print("count " .. var0.Count)

		for iter2 = 0, var0.Count - 1 do
			local var1 = var0:get_Item(iter2)
			local var2 = string.match(var1, ".*\\(.[_a-zA-Z][_a-zA-Z0-9]*)%.lua")

			if var2 ~= nil then
				if var0.FileMap[var2] == nil then
					var0.FileMap[var2] = {}
				end

				local var3 = string.sub(var1, #iter1 + 2, #var1 - 4)
				local var4 = string.gsub(var3, "\\", ".")

				var0.LuaPathToSysPath[var4] = SysPath

				table.insert(var0.FileMap[var2], {
					SysPath = var1,
					LuaPath = var4
				})
			end
		end

		var0.NotifyFunc("load module count: " .. table.getn(var0.FileMap))
	end
end

function var0.InitFakeTable()
	local var0 = {}

	var0.Meta = var0

	local function var1()
		return setmetatable({}, var0)
	end

	local function var2()
		return
	end

	local function var3()
		return var2
	end

	local function var4(arg0, arg1)
		var0.MetaMap[arg0] = arg1

		return arg0
	end

	local function var5(arg0)
		if not var0.RequireMap[arg0] then
			local var0 = var1()

			var0.RequireMap[arg0] = var0
		end

		return var0.RequireMap[arg0]
	end

	function var0.__index(arg0, arg1)
		if arg1 == "setmetatable" then
			return var4
		elseif arg1 == "pairs" or arg1 == "ipairs" then
			return var3
		elseif arg1 == "next" then
			return var2
		elseif arg1 == "require" then
			return var5
		else
			local var0 = var1()

			rawset(arg0, arg1, var0)

			return var0
		end
	end

	function var0.__newindex(arg0, arg1, arg2)
		rawset(arg0, arg1, arg2)
	end

	function var0.__call()
		return var1(), var1(), var1()
	end

	function var0.__add()
		return var0.__call()
	end

	function var0.__sub()
		return var0.__call()
	end

	function var0.__mul()
		return var0.__call()
	end

	function var0.__div()
		return var0.__call()
	end

	function var0.__mod()
		return var0.__call()
	end

	function var0.__pow()
		return var0.__call()
	end

	function var0.__unm()
		return var0.__call()
	end

	function var0.__concat()
		return var0.__call()
	end

	function var0.__eq()
		return var0.__call()
	end

	function var0.__lt()
		return var0.__call()
	end

	function var0.__le()
		return var0.__call()
	end

	function var0.__len()
		return var0.__call()
	end

	return var1
end

function var0.InitProtection()
	var0.Protection = {}
	var0.Protection[setmetatable] = true
	var0.Protection[pairs] = true
	var0.Protection[ipairs] = true
	var0.Protection[next] = true
	var0.Protection[require] = true
	var0.Protection[var0] = true
	var0.Protection[var0.Meta] = true
	var0.Protection[math] = true
	var0.Protection[string] = true
	var0.Protection[table] = true
end

function var0.AddFileFromHUList()
	package.loaded[var0.UpdateListFile] = nil

	local var0 = require(var0.UpdateListFile)

	var0.ALL = false
	var0.HUMap = {}

	for iter0, iter1 in pairs(var0) do
		if iter1 == "_ALL_" then
			var0.ALL = true

			for iter2, iter3 in pairs(var0.FileMap) do
				for iter4, iter5 in pairs(iter3) do
					var0.HUMap[iter5.LuaPath] = iter5.SysPath
				end
			end

			return
		end

		if var0.FileMap[iter1] then
			for iter6, iter7 in pairs(var0.FileMap[iter1]) do
				var0.HUMap[iter7.LuaPath] = iter7.SysPath
			end
		else
			var0.FailNotify("HotUpdate can't not find " .. iter1)
		end
	end
end

function var0.ErrorHandle(arg0)
	var0.FailNotify("HotUpdate Error\n" .. tostring(arg0))

	var0.ErrorHappen = true
end

function var0.BuildNewCode(arg0, arg1)
	io.input(arg0)

	local var0 = io.read("*all")

	if var0.ALL and var0.OldCode[arg0] == nil then
		var0.OldCode[arg0] = var0

		io.input():close()

		return
	end

	if var0.OldCode[arg0] == var0 then
		io.input():close()

		return false
	end

	io.input():close()
	io.input(arg0)

	local var1 = ("--[[" .. arg1 .. "]] ") .. var0

	io.input():close()

	local var2 = loadstring(var1)

	if not var2 then
		var0.FailNotify(arg0 .. " has syntax error.")
		collectgarbage("collect")

		return false
	else
		var0.FakeENV = var0.FakeT()
		var0.MetaMap = {}
		var0.RequireMap = {}

		setfenv(var2, var0.FakeENV)

		local var3

		var0.ErrorHappen = false

		xpcall(function()
			var3 = var2()
		end, var0.ErrorHandle)

		if not var0.ErrorHappen then
			var0.OldCode[arg0] = var0

			return true, var3
		else
			collectgarbage("collect")

			return false
		end
	end
end

function var0.Travel_G()
	local var0 = {
		[var0] = true
	}

	local function var1(arg0)
		if type(arg0) ~= "function" and type(arg0) ~= "table" or var0[arg0] or var0.Protection[arg0] then
			return
		end

		var0[arg0] = true

		if type(arg0) == "function" then
			for iter0 = 1, math.huge do
				local var0, var1 = debug.getupvalue(arg0, iter0)

				if not var0 then
					break
				end

				if type(var1) == "function" then
					for iter1, iter2 in ipairs(var0.ChangedFuncList) do
						if var1 == iter2[1] then
							debug.setupvalue(arg0, iter0, iter2[2])
						end
					end
				end

				var1(var1)
			end
		elseif type(arg0) == "table" then
			var1(debug.getmetatable(arg0))

			local var2 = {}

			for iter3, iter4 in pairs(arg0) do
				var1(iter3)
				var1(iter4)

				if type(iter4) == "function" then
					for iter5, iter6 in ipairs(var0.ChangedFuncList) do
						if iter4 == iter6[1] then
							arg0[iter3] = iter6[2]
						end
					end
				end

				if type(iter3) == "function" then
					for iter7, iter8 in ipairs(var0.ChangedFuncList) do
						if iter3 == iter8[1] then
							var2[#var2 + 1] = iter7
						end
					end
				end
			end

			for iter9, iter10 in ipairs(var2) do
				local var3 = var0.ChangedFuncList[iter10]

				arg0[var3[2]] = arg0[var3[1]]
				arg0[var3[1]] = nil
			end
		end
	end

	var1(_G)

	local var2 = debug.getregistry()

	for iter0, iter1 in ipairs(var0.ChangedFuncList) do
		for iter2, iter3 in pairs(var2) do
			if iter3 == iter1[1] then
				var2[iter2] = iter1[2]
			end
		end
	end

	for iter4, iter5 in ipairs(var0.ChangedFuncList) do
		if iter5[3] == "HUDebug" then
			iter5[4]:HUDebug()
		end
	end
end

function var0.ReplaceOld(arg0, arg1, arg2, arg3, arg4)
	if type(arg0) == type(arg1) then
		if type(arg1) == "table" then
			var0.UpdateAllFunction(arg0, arg1, arg2, arg3, "")
		elseif type(arg1) == "function" then
			var0.UpdateOneFunction(arg0, arg1, arg2, nil, arg3, "")
		end
	end
end

function var0.HotUpdateCode(arg0, arg1)
	local var0 = package.loaded[arg0]

	if var0 ~= nil then
		var0.VisitedSig = {}
		var0.ChangedFuncList = {}

		local var1, var2 = var0.BuildNewCode(arg1, arg0)

		if var1 then
			var0.NotifyFunc("update module " .. arg0)
			var0.ReplaceOld(var0, var2, arg0, "Main", "")

			for iter0, iter1 in pairs(var0.RequireMap) do
				local var3 = package.loaded[iter0]

				var0.ReplaceOld(var3, iter1, iter0, "Main_require", "")
			end

			setmetatable(var0.FakeENV, nil)
			var0.UpdateAllFunction(var0.ENV, var0.FakeENV, " ENV ", "Main", "")

			if #var0.ChangedFuncList > 0 then
				var0.Travel_G()
			end

			collectgarbage("collect")
		end
	elseif var0.OldCode[arg1] == nil then
		io.input(arg1)

		var0.OldCode[arg1] = io.read("*all")

		io.input():close()
	end
end

function var0.ResetENV(arg0, arg1, arg2, arg3)
	local var0 = {}

	local function var1(arg0, arg1)
		if not arg0 or var0[arg0] then
			return
		end

		var0[arg0] = true

		if type(arg0) == "function" then
			var0.DebugNofity(arg3 .. "HU.ResetENV", arg1, "  from:" .. arg2)
			xpcall(function()
				setfenv(arg0, var0.ENV)
			end, var0.FailNotify)
		elseif type(arg0) == "table" then
			var0.DebugNofity(arg3 .. "HU.ResetENV", arg1, "  from:" .. arg2)

			for iter0, iter1 in pairs(arg0) do
				var1(iter0, tostring(iter0) .. "__key", " HU.ResetENV ", arg3 .. "    ")
				var1(iter1, tostring(iter0), " HU.ResetENV ", arg3 .. "    ")
			end
		end
	end

	var1(arg0, arg1)
end

function var0.UpdateUpvalue(arg0, arg1, arg2, arg3, arg4)
	var0.DebugNofity(arg4 .. "HU.UpdateUpvalue", arg2, "  from:" .. arg3)

	local var0 = {}
	local var1 = {}

	for iter0 = 1, math.huge do
		local var2, var3 = debug.getupvalue(arg0, iter0)

		if not var2 then
			break
		end

		var0[var2] = var3
		var1[var2] = true
	end

	for iter1 = 1, math.huge do
		local var4, var5 = debug.getupvalue(arg1, iter1)

		if not var4 then
			break
		end

		if var1[var4] then
			local var6 = var0[var4]

			if type(var6) ~= type(var5) then
				debug.setupvalue(arg1, iter1, var6)
			elseif type(var6) == "function" then
				var0.UpdateOneFunction(var6, var5, var4, nil, "HU.UpdateUpvalue", arg4 .. "    ")
			elseif type(var6) == "table" then
				var0.UpdateAllFunction(var6, var5, var4, "HU.UpdateUpvalue", arg4 .. "    ")
				debug.setupvalue(arg1, iter1, var6)
			else
				debug.setupvalue(arg1, iter1, var6)
			end
		else
			var0.ResetENV(var5, var4, "HU.UpdateUpvalue", arg4 .. "    ")
		end
	end
end

function var0.UpdateOneFunction(arg0, arg1, arg2, arg3, arg4, arg5)
	if var0.Protection[arg0] or var0.Protection[arg1] then
		return
	end

	if arg0 == arg1 then
		return
	end

	local var0 = tostring(arg0) .. tostring(arg1)

	if var0.VisitedSig[var0] then
		return
	end

	var0.VisitedSig[var0] = true

	var0.DebugNofity(arg5 .. "HU.UpdateOneFunction " .. arg2 .. "  from:" .. arg4)

	if pcall(debug.setfenv, arg1, getfenv(arg0)) then
		var0.UpdateUpvalue(arg0, arg1, arg2, "HU.UpdateOneFunction", arg5 .. "    ")

		var0.ChangedFuncList[#var0.ChangedFuncList + 1] = {
			arg0,
			arg1,
			arg2,
			arg3
		}
	end
end

function var0.UpdateAllFunction(arg0, arg1, arg2, arg3, arg4)
	if var0.Protection[arg0] or var0.Protection[arg1] then
		return
	end

	if arg0 == arg1 then
		return
	end

	local var0 = tostring(arg0) .. tostring(arg1)

	if var0.VisitedSig[var0] then
		return
	end

	var0.VisitedSig[var0] = true

	var0.DebugNofity(arg4 .. "HU.UpdateAllFunction " .. arg2 .. "  from:" .. arg3)

	for iter0, iter1 in pairs(arg1) do
		local var1 = arg0[iter0]

		if type(iter1) == type(var1) then
			if type(iter1) == "function" then
				var0.UpdateOneFunction(var1, iter1, iter0, arg0, "HU.UpdateAllFunction", arg4 .. "    ")
			elseif type(iter1) == "table" then
				var0.UpdateAllFunction(var1, iter1, iter0, "HU.UpdateAllFunction", arg4 .. "    ")
			end
		elseif var1 == nil and type(iter1) == "function" and pcall(setfenv, iter1, var0.ENV) then
			arg0[iter0] = iter1
		end
	end

	local var2 = debug.getmetatable(arg0)
	local var3 = var0.MetaMap[arg1]

	if type(var2) == "table" and type(var3) == "table" then
		var0.UpdateAllFunction(var2, var3, arg2 .. "'s Meta", "HU.UpdateAllFunction", arg4 .. "    ")
	end
end

function var0.Init(arg0, arg1, arg2, arg3)
	var0.UpdateListFile = arg0
	var0.HUMap = {}
	var0.FileMap = {}
	var0.NotifyFunc = arg2
	var0.OldCode = {}
	var0.ChangedFuncList = {}
	var0.VisitedSig = {}
	var0.FakeENV = nil
	var0.ENV = arg3 or _G
	var0.LuaPathToSysPath = {}

	var0.InitFileMap(arg1)

	var0.FakeT = var0.InitFakeTable()

	var0.InitProtection()

	var0.ALL = false
end

function var0.Update()
	var0.AddFileFromHUList()

	for iter0, iter1 in pairs(var0.HUMap) do
		var0.HotUpdateCode(iter0, iter1)
	end
end

return var0
