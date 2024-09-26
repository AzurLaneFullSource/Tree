pg = pg or {}

local var0_0 = pg

var0_0.SceneMgr = singletonClass("SceneMgr")

local var1_0 = var0_0.SceneMgr

function var1_0.Ctor(arg0_1)
	arg0_1._cacheUI = {}
	arg0_1._gcLimit = 3
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

	local var2_4 = {
		{
			depth = 1,
			count = #var0_4,
			list = {}
		}
	}

	while #var0_4 > 0 do
		local var3_4 = table.remove(var0_4, 1)
		local var4_4 = underscore.detect(var2_4, function(arg0_5)
			return arg0_5.count > 0
		end).depth

		var2_4[var4_4].count = var2_4[var4_4].count - 1

		local var5_4 = var2_4[var4_4].list

		table.insert(var5_4, function(arg0_6)
			local var0_6 = var3_4.parent
			local var1_6 = arg1_4:retrieveMediator(var0_6.mediator.__cname):getViewComponent()

			arg0_4:prepare(arg1_4, var3_4, function(arg0_7)
				arg0_7.viewComponent:attach(var1_6)
				table.insert(var1_4, arg0_7)
				arg0_6()
			end)
		end)

		for iter2_4, iter3_4 in ipairs(var3_4.children) do
			var2_4[var4_4 + 1] = var2_4[var4_4 + 1] or {
				count = 0,
				depth = var4_4 + 1,
				list = {}
			}
			var2_4[var4_4 + 1].count = var2_4[var4_4 + 1].count + 1

			table.insert(var0_4, iter3_4)
		end
	end

	seriesAsync(underscore.map(var2_4, function(arg0_8)
		return function(arg0_9)
			parallelAsync(arg0_8.list, arg0_9)
		end
	end), function()
		arg4_4(var1_4)
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

		for iter0_13, iter1_13 in ipairs(var2_13.children) do
			table.insert(var0_13, iter1_13)
		end
	end

	if arg2_13.parent == nil then
		table.remove(var1_13, 1)
	else
		arg2_13.parent:removeChild(arg2_13)
	end

	local var3_13 = {}

	for iter2_13 = #var1_13, 1, -1 do
		local var4_13 = var1_13[iter2_13]
		local var5_13 = arg1_13:removeMediator(var4_13.mediator.__cname)

		table.insert(var3_13, function(arg0_14)
			if var5_13 then
				arg0_13:clearTempCache(var5_13)
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

	while #var0_16 > 0 do
		local var2_16 = table.remove(var0_16, 1)

		if var2_16.mediator then
			table.insert(var1_16, var2_16)
		end

		for iter0_16, iter1_16 in ipairs(var2_16.children) do
			table.insert(var0_16, iter1_16)
		end
	end

	if arg2_16.parent ~= nil then
		arg2_16.parent:removeChild(arg2_16)
	end

	local var3_16 = {}

	for iter2_16 = #var1_16, 1, -1 do
		local var4_16 = var1_16[iter2_16]
		local var5_16 = arg1_16:removeMediator(var4_16.mediator.__cname)

		if var5_16 then
			table.insert(var3_16, {
				mediator = var5_16,
				context = var4_16
			})
		end
	end

	arg3_16(var3_16)
end

function var1_0.clearTempCache(arg0_17, arg1_17)
	local var0_17 = arg1_17:getViewComponent()

	if var0_17:tempCache() then
		var0_17:RemoveTempCache()
	end
end

function var1_0.remove(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg1_18:getViewComponent()
	local var1_18 = arg0_18._cacheUI[arg1_18.__cname]

	if var1_18 ~= nil and var1_18 ~= var0_18 then
		var1_18.event:clear()
		arg0_18:gc(var1_18)
	end

	if var0_18 == nil then
		arg2_18()
	elseif var0_18:needCache() and not arg3_18 then
		var0_18:setVisible(false)

		arg0_18._cacheUI[arg1_18.__cname] = var0_18
		var0_18._isCachedView = true

		arg2_18()
	else
		var0_18._isCachedView = false

		var0_18.event:connect(BaseUI.DID_EXIT, function()
			var0_18.event:clear()
			arg0_18:gc(var0_18)
			arg2_18()
		end)
		var0_18:exit()
	end
end

function var1_0.gc(arg0_20, arg1_20)
	local var0_20 = arg1_20:forceGC()

	table.clear(arg1_20)

	arg1_20.exited = true

	if not GCThread.GetInstance().running then
		arg0_20._gcCounter = arg0_20._gcCounter + 1

		if arg0_20._gcCounter >= arg0_20._gcLimit or var0_20 then
			arg0_20._gcCounter = 0

			gcAll(false)
		else
			GCThread.GetInstance():LuaGC(false)
		end
	end
end
