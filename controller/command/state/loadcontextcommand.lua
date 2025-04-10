local var0_0 = class("LoadContextCommand", pm.SimpleCommand)

var0_0.queue = {}

function var0_0.execute(arg0_1, arg1_1)
	arg0_1:load(arg1_1:getBody())
end

function var0_0.load(arg0_2, arg1_2)
	table.insert(var0_0.queue, arg1_2)

	if #var0_0.queue == 1 then
		arg0_2:loadNext()
	end
end

function var0_0.loadNext(arg0_3)
	if #var0_0.queue > 0 then
		local var0_3 = var0_0.queue[1]

		local function var1_3()
			if var0_3.callback then
				var0_3.callback()
			end

			table.remove(var0_0.queue, 1)
			arg0_3:loadNext()
		end

		if var0_3.type == LOAD_TYPE_SCENE then
			arg0_3:loadScene(var0_3.context, var0_3.prevContext, var0_3.isBack, var1_3)
		elseif var0_3.type == LOAD_TYPE_LAYER then
			arg0_3:loadLayer(var0_3.context, var0_3.parentContext, var0_3.removeContexts, var1_3)
		else
			assert(false, "context load type not support: " .. var0_3.type)
		end
	end
end

function var0_0.loadScene(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	assert(isa(arg1_5, Context), "should be an instance of Context")

	local var0_5 = getProxy(ContextProxy)
	local var1_5 = pg.SceneMgr.GetInstance()
	local var2_5
	local var3_5
	local var4_5 = {}
	local var5_5 = arg3_5 and arg2_5 or nil
	local var6_5 = {
		function(arg0_6)
			if arg2_5 ~= nil then
				arg1_5:extendData({
					fromMediatorName = arg2_5.mediator.__cname
				})
				var1_5:removeLayerMediator(arg0_5.facade, arg2_5, function(arg0_7)
					var2_5 = arg0_7

					arg0_6()
				end)
			else
				arg0_6()
			end
		end,
		function(arg0_8)
			if var2_5 then
				table.SerialIpairsAsync(var2_5, function(arg0_9, arg1_9, arg2_9)
					local var0_9 = false

					if var5_5 then
						var0_9 = var5_5.mediator.__cname == arg1_9.mediator.__cname

						if var0_9 then
							var1_5:clearTempCache(arg1_9.mediator)
						end
					end

					var1_5:remove(arg1_9.mediator, function()
						if arg0_9 == #var2_5 then
							arg1_9.context:onContextRemoved()
						end

						arg2_9()
					end, var0_9)
				end, arg0_8)
			else
				arg0_8()
			end
		end,
		function(arg0_11)
			if arg1_5.cleanStack then
				var0_5:cleanContext()
			end

			var0_5:pushContext(arg1_5)
			arg0_11()
		end,
		function(arg0_12)
			if arg1_5 and arg1_5.cleanChild then
				arg1_5.children = {}
				arg1_5.cleanChild = false
			end

			local var0_12 = {
				function(arg0_13)
					local var0_13 = {}

					for iter0_13, iter1_13 in ipairs(arg1_5:GetHierarchy()) do
						local var1_13 = iter1_13.viewComponent.New()

						table.insertto(var0_13, var1_13:preloadUIList())
					end

					parallelAsync(underscore.map(var0_13, function(arg0_14)
						return function(arg0_15)
							PoolMgr.GetInstance():PreloadUI(arg0_14, arg0_15)
						end
					end), arg0_13)
				end,
				function(arg0_16)
					var1_5:prepare(arg0_5.facade, arg1_5, function(arg0_17)
						arg0_5:sendNotification(GAME.START_LOAD_SCENE, arg0_17)

						var3_5 = arg0_17

						arg0_16()
					end)
				end,
				function(arg0_18)
					var1_5:prepareLayer(arg0_5.facade, nil, arg1_5, function(arg0_19)
						arg0_5:sendNotification(GAME.WILL_LOAD_LAYERS, #arg0_19)

						var4_5 = arg0_19

						arg0_18()
					end)
				end
			}

			seriesAsync(var0_12, arg0_12)
		end,
		function(arg0_20)
			var1_5:enter(table.mergeArray({
				var3_5
			}, var4_5), arg0_20)
		end
	}

	pg.UIMgr.GetInstance():LoadingOn()

	local var7_5 = underscore.map(arg1_5.irregularSequence and {
		1,
		2,
		3,
		4,
		5
	} or {
		1,
		3,
		4,
		2,
		5
	}, function(arg0_21)
		return var6_5[arg0_21]
	end)

	seriesAsync(var7_5, function()
		existCall(arg4_5)
		pg.UIMgr.GetInstance():LoadingOff()
		arg0_5:sendNotification(GAME.LOAD_SCENE_DONE, arg1_5.scene)
	end)
end

function var0_0.loadLayer(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	assert(isa(arg1_23, Context), "should be an instance of Context")

	local var0_23 = pg.SceneMgr.GetInstance()
	local var1_23 = {}
	local var2_23

	seriesAsync({
		function(arg0_24)
			pg.UIMgr.GetInstance():LoadingOn()

			if arg3_23 ~= nil then
				table.ParallelIpairsAsync(arg3_23, function(arg0_25, arg1_25, arg2_25)
					var0_23:removeLayerMediator(arg0_23.facade, arg1_25, function(arg0_26)
						var2_23 = var2_23 or {}

						table.insertto(var2_23, arg0_26)
						arg2_25()
					end)
				end, arg0_24)
			else
				arg0_24()
			end
		end,
		function(arg0_27)
			var0_23:prepareLayer(arg0_23.facade, arg2_23, arg1_23, function(arg0_28)
				for iter0_28, iter1_28 in ipairs(arg0_28) do
					table.insert(var1_23, iter1_28)
				end

				arg0_27()
			end)
		end,
		function(arg0_29)
			if var2_23 then
				table.SerialIpairsAsync(var2_23, function(arg0_30, arg1_30, arg2_30)
					var0_23:remove(arg1_30.mediator, function()
						arg1_30.context:onContextRemoved()
						arg2_30()
					end)
				end, arg0_29)
			else
				arg0_29()
			end
		end,
		function(arg0_32)
			arg0_23:sendNotification(GAME.WILL_LOAD_LAYERS, #var1_23)
			var0_23:enter(var1_23, arg0_32)
		end,
		function()
			if arg4_23 then
				arg4_23()
			end

			pg.UIMgr.GetInstance():LoadingOff()
			arg0_23:sendNotification(GAME.LOAD_LAYER_DONE, arg1_23)
		end
	})
end

function var0_0.LoadLayerOnTopContext(arg0_34)
	local var0_34 = getProxy(ContextProxy):getCurrentContext()

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_34,
		context = arg0_34
	})
end

function var0_0.RemoveLayerByMediator(arg0_35)
	local var0_35 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0_35)

	if var0_35 then
		pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0_35
		})

		return true
	end
end

return var0_0
