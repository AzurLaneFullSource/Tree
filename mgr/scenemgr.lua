pg = pg or {}

local var0_0 = pg

var0_0.SceneMgr = singletonClass("SceneMgr")

local var1_0 = var0_0.SceneMgr

function var1_0.Ctor(arg0_1)
	arg0_1._cacheUI = {}
	arg0_1._gcLimit = 7
	arg0_1._gcCounter = 0
end

function var1_0.prepare(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = arg2_2.mediator
	local var1_2 = arg2_2.viewComponent
	local var2_2
	local var3_2

	if arg0_2._cacheUI[var0_2.__cname] ~= nil then
		var3_2 = arg0_2._cacheUI[var0_2.__cname]
		arg0_2._cacheUI[var0_2.__cname] = nil
		var2_2 = var0_2.New(var3_2)

		var2_2:setContextData(arg2_2.data)
		arg1_2:registerMediator(var2_2)
		arg3_2(var2_2)
	else
		var3_2 = var1_2.New()

		assert(isa(var3_2, BaseUI), "should be an instance of BaseUI: " .. var3_2.__cname)
		var3_2:setContextData(arg2_2.data)

		local var4_2

		local function var5_2()
			var3_2.event:disconnect(BaseUI.LOADED, var5_2)

			var2_2 = var0_2.New(var3_2)

			var2_2:setContextData(arg2_2.data)
			arg1_2:registerMediator(var2_2)
			arg3_2(var2_2)
		end

		if var3_2:isLoaded() then
			var5_2()
		else
			var3_2.event:connect(BaseUI.LOADED, var5_2)
			var3_2:load()
		end
	end
end

function var1_0.prepareLayer(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	local var0_4 = {}
	local var1_4 = {}

	if arg2_4 ~= nil then
		if arg2_4:getContextByMediator(arg3_4.mediator) then
			originalPrint("mediator already exist: " .. arg3_4.mediator.__cname)
			arg4_4(var1_4)

			return
		end

		table.insert(var0_4, arg3_4)
		arg2_4:addChild(arg3_4)
	else
		for iter0_4, iter1_4 in ipairs(arg3_4.children) do
			table.insert(var0_4, iter1_4)
		end
	end

	local var2_4 = {}

	while #var0_4 > 0 do
		local var3_4 = table.remove(var0_4, 1)

		table.insert(var2_4, function(arg0_5)
			local var0_5 = var3_4.parent
			local var1_5 = arg1_4:retrieveMediator(var0_5.mediator.__cname):getViewComponent()

			arg0_4:prepare(arg1_4, var3_4, function(arg0_6)
				arg0_6.viewComponent:attach(var1_5)
				table.insert(var1_4, arg0_6)
				arg0_5()
			end)
		end)

		for iter2_4, iter3_4 in ipairs(var3_4.children) do
			table.insert(var0_4, iter3_4)
		end
	end

	seriesAsync(var2_4, function()
		arg4_4(var1_4)
	end)
end

function var1_0.enter(arg0_8, arg1_8, arg2_8)
	if #arg1_8 == 0 then
		arg2_8()
	end

	local var0_8 = #arg1_8

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		local var1_8 = iter1_8.viewComponent

		if var1_8._isCachedView then
			var1_8:setVisible(true)
		end

		local var2_8

		local function var3_8()
			var1_8.event:disconnect(BaseUI.AVALIBLE, var3_8)

			var0_8 = var0_8 - 1

			if var0_8 == 0 then
				arg2_8()
			end
		end

		var1_8.event:connect(BaseUI.AVALIBLE, var3_8)
		var1_8:enter()
	end
end

function var1_0.removeLayer(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = {
		arg2_10
	}
	local var1_10 = {}

	while #var0_10 > 0 do
		local var2_10 = table.remove(var0_10, 1)

		if var2_10.mediator then
			table.insert(var1_10, var2_10)
		end

		for iter0_10, iter1_10 in ipairs(var2_10.children) do
			table.insert(var0_10, iter1_10)
		end
	end

	if arg2_10.parent == nil then
		table.remove(var1_10, 1)
	else
		arg2_10.parent:removeChild(arg2_10)
	end

	local var3_10 = {}

	for iter2_10 = #var1_10, 1, -1 do
		local var4_10 = var1_10[iter2_10]
		local var5_10 = arg1_10:removeMediator(var4_10.mediator.__cname)

		table.insert(var3_10, function(arg0_11)
			if var5_10 then
				arg0_10:clearTempCache(var5_10)
				arg0_10:remove(var5_10, function()
					var4_10:onContextRemoved()
					arg0_11()
				end)
			else
				arg0_11()
			end
		end)
	end

	seriesAsync(var3_10, arg3_10)
end

function var1_0.removeLayerMediator(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = {
		arg2_13
	}
	local var1_13 = {}

	while #var0_13 > 0 do
		local var2_13 = table.remove(var0_13, 1)

		if var2_13.mediator then
			table.insert(var1_13, var2_13)
		end

		for iter0_13, iter1_13 in ipairs(var2_13.children) do
			table.insert(var0_13, iter1_13)
		end
	end

	if arg2_13.parent ~= nil then
		arg2_13.parent:removeChild(arg2_13)
	end

	local var3_13 = {}

	for iter2_13 = #var1_13, 1, -1 do
		local var4_13 = var1_13[iter2_13]
		local var5_13 = arg1_13:removeMediator(var4_13.mediator.__cname)

		if var5_13 then
			table.insert(var3_13, {
				mediator = var5_13,
				context = var4_13
			})
		end
	end

	arg3_13(var3_13)
end

function var1_0.clearTempCache(arg0_14, arg1_14)
	local var0_14 = arg1_14:getViewComponent()

	if var0_14:tempCache() then
		var0_14:RemoveTempCache()
	end
end

function var1_0.remove(arg0_15, arg1_15, arg2_15, arg3_15)
	local var0_15 = arg1_15:getViewComponent()
	local var1_15 = arg0_15._cacheUI[arg1_15.__cname]

	if var1_15 ~= nil and var1_15 ~= var0_15 then
		var1_15.event:clear()
		arg0_15:gc(var1_15)
	end

	if var0_15 == nil then
		arg2_15()
	elseif var0_15:needCache() and not arg3_15 then
		var0_15:setVisible(false)

		arg0_15._cacheUI[arg1_15.__cname] = var0_15
		var0_15._isCachedView = true

		arg2_15()
	else
		var0_15._isCachedView = false

		var0_15.event:connect(BaseUI.DID_EXIT, function()
			var0_15.event:clear()
			arg0_15:gc(var0_15)
			arg2_15()
		end)
		var0_15:exit()
	end
end

function var1_0.gc(arg0_17, arg1_17)
	local var0_17 = arg1_17:forceGC()

	table.clear(arg1_17)

	arg1_17.exited = true

	if var0_17 or arg0_17._gcCounter >= arg0_17._gcLimit then
		arg0_17._gcCounter = 0

		gcAll(false)
	else
		arg0_17._gcCounter = arg0_17._gcCounter + 1

		GCThread.GetInstance():LuaGC(false)
	end
end
