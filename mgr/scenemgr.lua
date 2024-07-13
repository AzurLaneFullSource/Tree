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

	local var2_4

	local function var3_4()
		if #var0_4 > 0 then
			local var0_5 = table.remove(var0_4, 1)

			for iter0_5, iter1_5 in ipairs(var0_5.children) do
				table.insert(var0_4, iter1_5)
			end

			local var1_5 = var0_5.parent
			local var2_5 = arg1_4:retrieveMediator(var1_5.mediator.__cname):getViewComponent()

			arg0_4:prepare(arg1_4, var0_5, function(arg0_6)
				arg0_6.viewComponent:attach(var2_5)
				table.insert(var1_4, arg0_6)
				var3_4()
			end)
		else
			arg4_4(var1_4)
		end
	end

	var3_4()
end

function var1_0.enter(arg0_7, arg1_7, arg2_7)
	if #arg1_7 == 0 then
		arg2_7()
	end

	local var0_7 = #arg1_7

	for iter0_7, iter1_7 in ipairs(arg1_7) do
		local var1_7 = iter1_7.viewComponent

		if var1_7._isCachedView then
			var1_7:setVisible(true)
		end

		local var2_7

		local function var3_7()
			var1_7.event:disconnect(BaseUI.AVALIBLE, var3_7)

			var0_7 = var0_7 - 1

			if var0_7 == 0 then
				arg2_7()
			end
		end

		var1_7.event:connect(BaseUI.AVALIBLE, var3_7)
		var1_7:enter()
	end
end

function var1_0.removeLayer(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = {
		arg2_9
	}
	local var1_9 = {}

	while #var0_9 > 0 do
		local var2_9 = table.remove(var0_9, 1)

		if var2_9.mediator then
			table.insert(var1_9, var2_9)
		end

		for iter0_9, iter1_9 in ipairs(var2_9.children) do
			table.insert(var0_9, iter1_9)
		end
	end

	if arg2_9.parent == nil then
		table.remove(var1_9, 1)
	else
		arg2_9.parent:removeChild(arg2_9)
	end

	local var3_9 = {}

	for iter2_9 = #var1_9, 1, -1 do
		local var4_9 = var1_9[iter2_9]
		local var5_9 = arg1_9:removeMediator(var4_9.mediator.__cname)

		table.insert(var3_9, function(arg0_10)
			if var5_9 then
				arg0_9:clearTempCache(var5_9)
				arg0_9:remove(var5_9, function()
					var4_9:onContextRemoved()
					arg0_10()
				end)
			else
				arg0_10()
			end
		end)
	end

	seriesAsync(var3_9, arg3_9)
end

function var1_0.removeLayerMediator(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = {
		arg2_12
	}
	local var1_12 = {}

	while #var0_12 > 0 do
		local var2_12 = table.remove(var0_12, 1)

		if var2_12.mediator then
			table.insert(var1_12, var2_12)
		end

		for iter0_12, iter1_12 in ipairs(var2_12.children) do
			table.insert(var0_12, iter1_12)
		end
	end

	if arg2_12.parent ~= nil then
		arg2_12.parent:removeChild(arg2_12)
	end

	local var3_12 = {}

	for iter2_12 = #var1_12, 1, -1 do
		local var4_12 = var1_12[iter2_12]
		local var5_12 = arg1_12:removeMediator(var4_12.mediator.__cname)

		if var5_12 then
			table.insert(var3_12, {
				mediator = var5_12,
				context = var4_12
			})
		end
	end

	arg3_12(var3_12)
end

function var1_0.clearTempCache(arg0_13, arg1_13)
	local var0_13 = arg1_13:getViewComponent()

	if var0_13:tempCache() then
		var0_13:RemoveTempCache()
	end
end

function var1_0.remove(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14 = arg1_14:getViewComponent()
	local var1_14 = arg0_14._cacheUI[arg1_14.__cname]

	if var1_14 ~= nil and var1_14 ~= var0_14 then
		var1_14.event:clear()
		arg0_14:gc(var1_14)
	end

	if var0_14 == nil then
		arg2_14()
	elseif var0_14:needCache() and not arg3_14 then
		var0_14:setVisible(false)

		arg0_14._cacheUI[arg1_14.__cname] = var0_14
		var0_14._isCachedView = true

		arg2_14()
	else
		var0_14._isCachedView = false

		var0_14.event:connect(BaseUI.DID_EXIT, function()
			var0_14.event:clear()
			arg0_14:gc(var0_14)
			arg2_14()
		end)
		var0_14:exit()
	end
end

function var1_0.gc(arg0_16, arg1_16)
	local var0_16 = arg1_16:forceGC()

	table.clear(arg1_16)

	arg1_16.exited = true

	if not GCThread.GetInstance().running then
		arg0_16._gcCounter = arg0_16._gcCounter + 1

		if arg0_16._gcCounter >= arg0_16._gcLimit or var0_16 then
			arg0_16._gcCounter = 0

			gcAll(false)
		else
			GCThread.GetInstance():LuaGC(false)
		end
	end
end
