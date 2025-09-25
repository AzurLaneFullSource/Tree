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
			arg0_3:loadLayer(var0_3.context, var0_3.parentContext, var1_3)
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
	local var5_5 = {
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
					var1_5:remove(arg1_9.mediator, function()
						if arg0_9 == #var2_5 then
							arg1_9.context:onContextRemoved()
						end

						arg2_9()
					end)
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
			if arg1_5.cleanStack then
				var1_5:clearCacheUI()
			end

			var1_5:enter(table.insertto({
				var3_5
			}, var4_5), arg0_20)
		end
	}

	pg.UIMgr.GetInstance():LoadingOn()

	local var6_5 = underscore.map(arg1_5.irregularSequence and {
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
		return var5_5[arg0_21]
	end)

	seriesAsync(var6_5, function()
		existCall(arg4_5)
		pg.UIMgr.GetInstance():LoadingOff()
		arg0_5:sendNotification(GAME.LOAD_SCENE_DONE, arg1_5.scene)
	end)
end

function var0_0.loadLayer(arg0_23, arg1_23, arg2_23, arg3_23)
	assert(isa(arg1_23, Context), "should be an instance of Context")

	local var0_23 = pg.SceneMgr.GetInstance()
	local var1_23 = {}
	local var2_23 = {
		function(arg0_24)
			var0_23:prepareLayer(arg0_23.facade, arg2_23, arg1_23, function(arg0_25)
				arg0_23:sendNotification(GAME.WILL_LOAD_LAYERS, #arg0_25)

				var1_23 = arg0_25

				arg0_24()
			end)
		end,
		function(arg0_26)
			var0_23:enter(var1_23, arg0_26)
		end
	}

	pg.UIMgr.GetInstance():LoadingOn()
	seriesAsync(var2_23, function()
		existCall(arg3_23)
		pg.UIMgr.GetInstance():LoadingOff()
		arg0_23:sendNotification(GAME.LOAD_LAYER_DONE, arg1_23)
	end)
end

function var0_0.LoadLayerOnTopContext(arg0_28)
	local var0_28 = getProxy(ContextProxy):getCurrentContext()

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_28,
		context = arg0_28
	})
end

function var0_0.RemoveLayerByMediator(arg0_29)
	local var0_29 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0_29)

	if var0_29 then
		pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0_29
		})

		return true
	end
end

return var0_0
