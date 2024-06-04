local var0 = class("LoadContextCommand", pm.SimpleCommand)

var0.queue = {}

function var0.execute(arg0, arg1)
	arg0:load(arg1:getBody())
end

function var0.load(arg0, arg1)
	table.insert(var0.queue, arg1)

	if #var0.queue == 1 then
		arg0:loadNext()
	end
end

function var0.loadNext(arg0)
	if #var0.queue > 0 then
		local var0 = var0.queue[1]

		local function var1()
			if var0.callback then
				var0.callback()
			end

			table.remove(var0.queue, 1)
			arg0:loadNext()
		end

		if var0.type == LOAD_TYPE_SCENE then
			if var0.isReload then
				arg0:reloadScene(var0.context, var1)
			else
				arg0:loadScene(var0.context, var0.prevContext, var0.isBack, var1)
			end
		elseif var0.type == LOAD_TYPE_LAYER then
			arg0:loadLayer(var0.context, var0.parentContext, var0.removeContexts, var1)
		else
			assert(false, "context load type not support: " .. var0.type)
		end
	end
end

function var0.reloadScene(arg0, arg1, arg2)
	assert(isa(arg1, Context), "should be an instance of Context")

	local var0 = getProxy(ContextProxy)
	local var1 = pg.SceneMgr.GetInstance()
	local var2
	local var3
	local var4 = {}

	seriesAsync({
		function(arg0)
			pg.UIMgr.GetInstance():LoadingOn(arg1.data.showLoading)
			var1:removeLayerMediator(arg0.facade, arg1, function(arg0)
				var2 = arg0

				arg0()
			end)
		end,
		function(arg0)
			if var2 then
				table.SerialIpairsAsync(var2, function(arg0, arg1, arg2)
					var1:remove(arg1.mediator, function()
						if arg0 == #var2 then
							arg1.context:onContextRemoved()
						end

						arg2()
					end, false)
				end, arg0)
			else
				arg0()
			end
		end,
		function(arg0)
			if arg1.cleanStack then
				var0:cleanContext()
			end

			var0:pushContext(arg1)
			arg0()
		end,
		function(arg0)
			local var0 = arg1:GetHierarchy()

			_.each(var0, function(arg0)
				pg.PoolMgr.GetInstance():BuildUIPlural(arg0.viewComponent.getUIName())
			end)
			var1:prepare(arg0.facade, arg1, function(arg0)
				arg0:sendNotification(GAME.START_LOAD_SCENE, arg0)

				var3 = arg0

				arg0()
			end)
		end,
		function(arg0)
			var1:prepareLayer(arg0.facade, nil, arg1, function(arg0)
				arg0:sendNotification(GAME.WILL_LOAD_LAYERS, #arg0)

				var4 = arg0

				arg0()
			end)
		end,
		function(arg0)
			var1:enter({
				var3
			}, arg0)
		end,
		function(arg0)
			var1:enter(var4, arg0)
		end,
		function()
			if arg2 then
				arg2()
			end

			pg.UIMgr.GetInstance():LoadingOff()
			arg0:sendNotification(GAME.LOAD_SCENE_DONE, arg1.scene)
		end
	})
end

function var0.loadScene(arg0, arg1, arg2, arg3, arg4)
	assert(isa(arg1, Context), "should be an instance of Context")

	local var0 = getProxy(ContextProxy)
	local var1 = pg.SceneMgr.GetInstance()
	local var2
	local var3
	local var4 = {}
	local var5 = arg3 and arg2 or nil

	seriesAsync({
		function(arg0)
			pg.UIMgr.GetInstance():LoadingOn(arg1.data.showLoading)

			if arg2 ~= nil then
				arg1:extendData({
					fromMediatorName = arg2.mediator.__cname
				})
				var1:removeLayerMediator(arg0.facade, arg2, function(arg0)
					var2 = arg0

					arg0()
				end)
			else
				arg0()
			end
		end,
		function(arg0)
			if arg1.cleanStack then
				var0:cleanContext()
			end

			var0:pushContext(arg1)
			arg0()
		end,
		function(arg0)
			local var0 = arg1:GetHierarchy()

			_.each(var0, function(arg0)
				pg.PoolMgr.GetInstance():BuildUIPlural(arg0.viewComponent.getUIName())
			end)
			var1:prepare(arg0.facade, arg1, function(arg0)
				arg0:sendNotification(GAME.START_LOAD_SCENE, arg0)

				var3 = arg0

				arg0()
			end)
		end,
		function(arg0)
			var1:prepareLayer(arg0.facade, nil, arg1, function(arg0)
				arg0:sendNotification(GAME.WILL_LOAD_LAYERS, #arg0)

				var4 = arg0

				arg0()
			end)
		end,
		function(arg0)
			if var2 then
				table.SerialIpairsAsync(var2, function(arg0, arg1, arg2)
					local var0 = false

					if var5 then
						var0 = var5.mediator.__cname == arg1.mediator.__cname

						if var0 then
							var1:clearTempCache(arg1.mediator)
						end
					end

					var1:remove(arg1.mediator, function()
						if arg0 == #var2 then
							arg1.context:onContextRemoved()
						end

						arg2()
					end, var0)
				end, arg0)
			else
				arg0()
			end
		end,
		function(arg0)
			var1:enter({
				var3
			}, arg0)
		end,
		function(arg0)
			var1:enter(var4, arg0)
		end,
		function()
			if arg4 then
				arg4()
			end

			pg.UIMgr.GetInstance():LoadingOff()
			arg0:sendNotification(GAME.LOAD_SCENE_DONE, arg1.scene)
		end
	})
end

function var0.loadLayer(arg0, arg1, arg2, arg3, arg4)
	assert(isa(arg1, Context), "should be an instance of Context")

	local var0 = pg.SceneMgr.GetInstance()
	local var1 = {}
	local var2

	seriesAsync({
		function(arg0)
			pg.UIMgr.GetInstance():LoadingOn(arg1.data.showLoading)

			if arg3 ~= nil then
				table.ParallelIpairsAsync(arg3, function(arg0, arg1, arg2)
					var0:removeLayerMediator(arg0.facade, arg1, function(arg0)
						var2 = var2 or {}

						table.insertto(var2, arg0)
						arg2()
					end)
				end, arg0)
			else
				arg0()
			end
		end,
		function(arg0)
			local var0 = arg1:GetHierarchy()

			_.each(var0, function(arg0)
				pg.PoolMgr.GetInstance():BuildUIPlural(arg0.viewComponent.getUIName())
			end)
			var0:prepareLayer(arg0.facade, arg2, arg1, function(arg0)
				for iter0, iter1 in ipairs(arg0) do
					table.insert(var1, iter1)
				end

				arg0()
			end)
		end,
		function(arg0)
			if var2 then
				table.SerialIpairsAsync(var2, function(arg0, arg1, arg2)
					var0:remove(arg1.mediator, function()
						arg1.context:onContextRemoved()
						arg2()
					end)
				end, arg0)
			else
				arg0()
			end
		end,
		function(arg0)
			arg0:sendNotification(GAME.WILL_LOAD_LAYERS, #var1)
			var0:enter(var1, arg0)
		end,
		function()
			if arg4 then
				arg4()
			end

			pg.UIMgr.GetInstance():LoadingOff()
			arg0:sendNotification(GAME.LOAD_LAYER_DONE, arg1)
		end
	})
end

function var0.LoadLayerOnTopContext(arg0)
	local var0 = getProxy(ContextProxy):getCurrentContext()

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0,
		context = arg0
	})
end

function var0.RemoveLayerByMediator(arg0)
	local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0)

	if var0 then
		pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0
		})

		return true
	end
end

return var0
