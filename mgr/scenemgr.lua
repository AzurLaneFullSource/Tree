pg = pg or {}

local var0_0 = pg

var0_0.SceneMgr = singletonClass("SceneMgr")

local var1_0 = var0_0.SceneMgr

function var1_0.Ctor(arg0_1)
	arg0_1._cacheUI = {}
	arg0_1._gcLimit = 7
	arg0_1._gcCounter = 0
end

local function var2_0(arg0_2, arg1_2)
	local var0_2

	if not noEmptyStr(var0_2) and arg0_2 then
		var0_2 = arg0_2.__cname
	end

	if not noEmptyStr(var0_2) and arg1_2 then
		var0_2 = arg1_2.scene or arg1_2.mediator and arg1_2.mediator.__cname or arg1_2.viewComponent and arg1_2.viewComponent.__cname
	end

	return tostring(var0_2 or "Unknown")
end

local function var3_0(arg0_3, arg1_3)
	local var0_3 = string.format("进入界面: %s", var2_0(arg0_3, arg1_3))

	print(var0_3)

	local var1_3, var2_3 = pcall(function()
		ReflectionHelp.RefCallMethod(typeof(ResourceMgr), "WriteMarkedShortPathLog", ResourceMgr.Inst, {
			typeof("System.String")
		}, {
			var0_3
		})
		ReflectionHelp.RefCallMethod(typeof(ResourceMgr), "WriteExtraShortPathFilterLog", ResourceMgr.Inst, {
			typeof("System.String")
		}, {
			var0_3
		})
	end)

	if not var1_3 then
		warning(string.format("Write ui load log failed: %s", tostring(var2_3)))
	end
end

function var1_0.prepare(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = arg2_5.mediator
	local var1_5 = arg2_5.viewComponent
	local var2_5
	local var3_5

	if arg0_5._cacheUI[var0_5.__cname] ~= nil then
		var3_5 = arg0_5._cacheUI[var0_5.__cname]
		arg0_5._cacheUI[var0_5.__cname] = nil

		if EDITOR_TOOL then
			var3_0(var3_5, arg2_5)
		end

		var2_5 = var0_5.New(var3_5)

		var2_5:setContextData(arg2_5.data)
		arg1_5:registerMediator(var2_5)
		arg3_5(var2_5)
	else
		var3_5 = var1_5.New()

		assert(isa(var3_5, BaseUI), "should be an instance of BaseUI: " .. var3_5.__cname)
		var3_5:setContextData(arg2_5.data)

		if EDITOR_TOOL then
			var3_0(var3_5, arg2_5)
		end

		local var4_5

		local function var5_5()
			var3_5.event:disconnect(BaseUI.LOADED, var5_5)

			var2_5 = var0_5.New(var3_5)

			var2_5:setContextData(arg2_5.data)
			arg1_5:registerMediator(var2_5)
			arg3_5(var2_5)
		end

		if var3_5:isLoaded() then
			var5_5()
		else
			var3_5.event:connect(BaseUI.LOADED, var5_5)
			var3_5:load()
		end
	end
end

function var1_0.prepareLayer(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	local var0_7 = {}
	local var1_7 = {}

	if arg2_7 ~= nil then
		if arg2_7:getContextByMediator(arg3_7.mediator) then
			originalPrint("mediator already exist: " .. arg3_7.mediator.__cname)
			arg4_7(var1_7)

			return
		end

		table.insert(var0_7, arg3_7)
		arg2_7:addChild(arg3_7)
	else
		table.insertto(var0_7, arg3_7.children)
	end

	local var2_7 = {}

	while #var0_7 > 0 do
		local var3_7 = table.remove(var0_7, 1)

		table.insert(var2_7, function(arg0_8)
			local var0_8 = var3_7.parent
			local var1_8 = arg1_7:retrieveMediator(var0_8.mediator.__cname):getViewComponent()

			arg0_7:prepare(arg1_7, var3_7, function(arg0_9)
				arg0_9.viewComponent:attach(var1_8)
				table.insert(var1_7, arg0_9)
				arg0_8()
			end)
		end)
		table.insertto(var0_7, var3_7.children)
	end

	seriesAsync(var2_7, function()
		arg4_7(var1_7)
	end)
end

function var1_0.enter(arg0_11, arg1_11, arg2_11)
	if #arg1_11 == 0 then
		arg2_11()
	end

	local var0_11 = #arg1_11

	for iter0_11, iter1_11 in ipairs(arg1_11) do
		local var1_11 = iter1_11.viewComponent

		if var1_11._isCachedView then
			var1_11:setVisible(true)
		end

		local var2_11

		local function var3_11()
			var1_11.event:disconnect(BaseUI.AVALIBLE, var3_11)

			var0_11 = var0_11 - 1

			if var0_11 == 0 then
				arg2_11()
			end
		end

		var1_11.event:connect(BaseUI.AVALIBLE, var3_11)
		var1_11:enter()
	end
end

function var1_0.removeLayer(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = {
		arg2_13
	}
	local var1_13 = {}

	while #var0_13 > 0 do
		local var2_13 = table.remove(var0_13, 1)

		if var2_13.mediator then
			table.insert(var1_13, var2_13)
		end

		table.insertto(var0_13, var2_13.children)
	end

	if arg2_13.parent == nil then
		table.remove(var1_13, 1)
	else
		arg2_13.parent:removeChild(arg2_13)
	end

	local var3_13 = {}

	for iter0_13 = #var1_13, 1, -1 do
		local var4_13 = var1_13[iter0_13]
		local var5_13 = arg1_13:removeMediator(var4_13.mediator.__cname)

		table.insert(var3_13, function(arg0_14)
			if var5_13 then
				arg0_13:remove(var5_13, function()
					var4_13:onContextRemoved()
					arg0_14()
				end)
			else
				arg0_14()
			end
		end)
	end

	seriesAsync(var3_13, arg3_13)
end

function var1_0.removeLayerMediator(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = {
		arg2_16
	}
	local var1_16 = {}
	local var2_16 = {}

	while #var0_16 > 0 do
		local var3_16 = table.remove(var0_16, 1)

		if var3_16.mediator then
			table.insert(var2_16, var3_16)
		end

		table.insertto(var0_16, var3_16.children)
	end

	if arg2_16.parent ~= nil then
		arg2_16.parent:removeChild(arg2_16)
	end

	local var4_16 = {}

	for iter0_16 = #var2_16, 1, -1 do
		local var5_16 = var2_16[iter0_16]
		local var6_16 = arg1_16:removeMediator(var5_16.mediator.__cname)

		if var6_16 then
			local var7_16 = var6_16:getViewComponent()

			if var7_16:CheckTempCache() then
				PoolMgr.GetInstance():KeepUICache(var7_16:getUIName(), false)
			end

			table.insert(var4_16, {
				mediator = var6_16,
				context = var5_16
			})
		end
	end

	arg3_16(var4_16)
end

function var1_0.remove(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg1_17:getViewComponent()

	if var0_17 == nil then
		arg2_17()
	end

	if var0_17:needCache() and not arg0_17._cacheUI[arg1_17.__cname] then
		var0_17:setVisible(false)

		arg0_17._cacheUI[arg1_17.__cname] = var0_17
		var0_17._isCachedView = true

		arg2_17()
	else
		var0_17._isCachedView = false

		arg0_17:removeView(var0_17, arg2_17)
	end
end

function var1_0.removeView(arg0_18, arg1_18, arg2_18)
	arg1_18._isCachedView = false

	arg1_18.event:connect(BaseUI.DID_EXIT, function()
		arg1_18.event:clear()
		arg0_18:gc(arg1_18)
		arg2_18()
	end)
	arg1_18:exit()
end

function var1_0.clearCacheUI(arg0_20)
	parallelAsync(underscore(arg0_20._cacheUI):chain():values():map(function(arg0_21)
		return function(arg0_22)
			arg0_20:removeView(arg0_21, arg0_22)
		end
	end):value(), function()
		arg0_20._cacheUI = {}
	end)
end

function var1_0.gc(arg0_24, arg1_24)
	local var0_24 = arg1_24:forceGC()

	table.clear(arg1_24)

	arg1_24.exited = true

	if arg1_24:DontGC() then
		return
	end

	if var0_24 or arg0_24._gcCounter >= arg0_24._gcLimit then
		arg0_24._gcCounter = 0

		gcAll(false)
	else
		arg0_24._gcCounter = arg0_24._gcCounter + 1

		GCThread.GetInstance():LuaGC(false)
	end
end
