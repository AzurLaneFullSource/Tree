pg = pg or {}

local var0 = pg

var0.SceneMgr = singletonClass("SceneMgr")

local var1 = var0.SceneMgr

function var1.Ctor(arg0)
	arg0._cacheUI = {}
	arg0._gcLimit = 3
	arg0._gcCounter = 0
end

function var1.prepare(arg0, arg1, arg2, arg3)
	local var0 = arg2.mediator
	local var1 = arg2.viewComponent
	local var2
	local var3

	if arg0._cacheUI[var0.__cname] ~= nil then
		var3 = arg0._cacheUI[var0.__cname]
		arg0._cacheUI[var0.__cname] = nil
		var2 = var0.New(var3)

		var2:setContextData(arg2.data)
		arg1:registerMediator(var2)
		arg3(var2)
	else
		var3 = var1.New()

		assert(isa(var3, BaseUI), "should be an instance of BaseUI: " .. var3.__cname)
		var3:setContextData(arg2.data)

		local var4

		local function var5()
			var3.event:disconnect(BaseUI.LOADED, var5)

			var2 = var0.New(var3)

			var2:setContextData(arg2.data)
			arg1:registerMediator(var2)
			arg3(var2)
		end

		if var3:isLoaded() then
			var5()
		else
			var3.event:connect(BaseUI.LOADED, var5)
			var3:load()
		end
	end
end

function var1.prepareLayer(arg0, arg1, arg2, arg3, arg4)
	local var0 = {}
	local var1 = {}

	if arg2 ~= nil then
		if arg2:getContextByMediator(arg3.mediator) then
			originalPrint("mediator already exist: " .. arg3.mediator.__cname)
			arg4(var1)

			return
		end

		table.insert(var0, arg3)
		arg2:addChild(arg3)
	else
		for iter0, iter1 in ipairs(arg3.children) do
			table.insert(var0, iter1)
		end
	end

	local var2

	local function var3()
		if #var0 > 0 then
			local var0 = table.remove(var0, 1)

			for iter0, iter1 in ipairs(var0.children) do
				table.insert(var0, iter1)
			end

			local var1 = var0.parent
			local var2 = arg1:retrieveMediator(var1.mediator.__cname):getViewComponent()

			arg0:prepare(arg1, var0, function(arg0)
				arg0.viewComponent:attach(var2)
				table.insert(var1, arg0)
				var3()
			end)
		else
			arg4(var1)
		end
	end

	var3()
end

function var1.enter(arg0, arg1, arg2)
	if #arg1 == 0 then
		arg2()
	end

	local var0 = #arg1

	for iter0, iter1 in ipairs(arg1) do
		local var1 = iter1.viewComponent

		if var1._isCachedView then
			var1:setVisible(true)
		end

		local var2

		local function var3()
			var1.event:disconnect(BaseUI.AVALIBLE, var3)

			var0 = var0 - 1

			if var0 == 0 then
				arg2()
			end
		end

		var1.event:connect(BaseUI.AVALIBLE, var3)
		var1:enter()
	end
end

function var1.removeLayer(arg0, arg1, arg2, arg3)
	local var0 = {
		arg2
	}
	local var1 = {}

	while #var0 > 0 do
		local var2 = table.remove(var0, 1)

		if var2.mediator then
			table.insert(var1, var2)
		end

		for iter0, iter1 in ipairs(var2.children) do
			table.insert(var0, iter1)
		end
	end

	if arg2.parent == nil then
		table.remove(var1, 1)
	else
		arg2.parent:removeChild(arg2)
	end

	local var3 = {}

	for iter2 = #var1, 1, -1 do
		local var4 = var1[iter2]
		local var5 = arg1:removeMediator(var4.mediator.__cname)

		table.insert(var3, function(arg0)
			if var5 then
				arg0:clearTempCache(var5)
				arg0:remove(var5, function()
					var4:onContextRemoved()
					arg0()
				end)
			else
				arg0()
			end
		end)
	end

	seriesAsync(var3, arg3)
end

function var1.removeLayerMediator(arg0, arg1, arg2, arg3)
	local var0 = {
		arg2
	}
	local var1 = {}

	while #var0 > 0 do
		local var2 = table.remove(var0, 1)

		if var2.mediator then
			table.insert(var1, var2)
		end

		for iter0, iter1 in ipairs(var2.children) do
			table.insert(var0, iter1)
		end
	end

	if arg2.parent ~= nil then
		arg2.parent:removeChild(arg2)
	end

	local var3 = {}

	for iter2 = #var1, 1, -1 do
		local var4 = var1[iter2]
		local var5 = arg1:removeMediator(var4.mediator.__cname)

		if var5 then
			table.insert(var3, {
				mediator = var5,
				context = var4
			})
		end
	end

	arg3(var3)
end

function var1.clearTempCache(arg0, arg1)
	local var0 = arg1:getViewComponent()

	if var0:tempCache() then
		var0:RemoveTempCache()
	end
end

function var1.remove(arg0, arg1, arg2, arg3)
	local var0 = arg1:getViewComponent()
	local var1 = arg0._cacheUI[arg1.__cname]

	if var1 ~= nil and var1 ~= var0 then
		var1.event:clear()
		arg0:gc(var1)
	end

	if var0 == nil then
		arg2()
	elseif var0:needCache() and not arg3 then
		var0:setVisible(false)

		arg0._cacheUI[arg1.__cname] = var0
		var0._isCachedView = true

		arg2()
	else
		var0._isCachedView = false

		var0.event:connect(BaseUI.DID_EXIT, function()
			var0.event:clear()
			arg0:gc(var0)
			arg2()
		end)
		var0:exit()
	end
end

function var1.gc(arg0, arg1)
	local var0 = arg1:forceGC()

	table.clear(arg1)

	arg1.exited = true

	if not GCThread.GetInstance().running then
		arg0._gcCounter = arg0._gcCounter + 1

		if arg0._gcCounter >= arg0._gcLimit or var0 then
			arg0._gcCounter = 0

			gcAll(false)
		else
			GCThread.GetInstance():LuaGC(false)
		end
	end
end
