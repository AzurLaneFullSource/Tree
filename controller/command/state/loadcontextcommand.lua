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
			if arg2_5 and arg2_5.cleanChild then
				arg2_5.children = {}
			end

			if arg1_5.cleanStack then
				var0_5:cleanContext()
			end

			var0_5:pushContext(arg1_5)
			arg0_11()
		end,
		function(arg0_12)
			seriesAsync({
				function(arg0_13)
					var1_5:prepare(arg0_5.facade, arg1_5, function(arg0_14)
						arg0_5:sendNotification(GAME.START_LOAD_SCENE, arg0_14)

						var3_5 = arg0_14

						arg0_13()
					end)
				end,
				function(arg0_15)
					var1_5:prepareLayer(arg0_5.facade, nil, arg1_5, function(arg0_16)
						arg0_5:sendNotification(GAME.WILL_LOAD_LAYERS, #arg0_16)

						var4_5 = arg0_16

						arg0_15()
					end)
				end
			}, arg0_12)
		end,
		function(arg0_17)
			var1_5:enter(table.mergeArray({
				var3_5
			}, var4_5), arg0_17)
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
	}, function(arg0_18)
		return var6_5[arg0_18]
	end)

	seriesAsync(var7_5, function()
		existCall(arg4_5)
		pg.UIMgr.GetInstance():LoadingOff()
		arg0_5:sendNotification(GAME.LOAD_SCENE_DONE, arg1_5.scene)
	end)
end

function var0_0.loadLayer(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	assert(isa(arg1_20, Context), "should be an instance of Context")

	local var0_20 = pg.SceneMgr.GetInstance()
	local var1_20 = {}
	local var2_20

	seriesAsync({
		function(arg0_21)
			pg.UIMgr.GetInstance():LoadingOn()

			if arg3_20 ~= nil then
				table.ParallelIpairsAsync(arg3_20, function(arg0_22, arg1_22, arg2_22)
					var0_20:removeLayerMediator(arg0_20.facade, arg1_22, function(arg0_23)
						var2_20 = var2_20 or {}

						table.insertto(var2_20, arg0_23)
						arg2_22()
					end)
				end, arg0_21)
			else
				arg0_21()
			end
		end,
		function(arg0_24)
			var0_20:prepareLayer(arg0_20.facade, arg2_20, arg1_20, function(arg0_25)
				for iter0_25, iter1_25 in ipairs(arg0_25) do
					table.insert(var1_20, iter1_25)
				end

				arg0_24()
			end)
		end,
		function(arg0_26)
			if var2_20 then
				table.SerialIpairsAsync(var2_20, function(arg0_27, arg1_27, arg2_27)
					var0_20:remove(arg1_27.mediator, function()
						arg1_27.context:onContextRemoved()
						arg2_27()
					end)
				end, arg0_26)
			else
				arg0_26()
			end
		end,
		function(arg0_29)
			arg0_20:sendNotification(GAME.WILL_LOAD_LAYERS, #var1_20)
			var0_20:enter(var1_20, arg0_29)
		end,
		function()
			if arg4_20 then
				arg4_20()
			end

			pg.UIMgr.GetInstance():LoadingOff()
			arg0_20:sendNotification(GAME.LOAD_LAYER_DONE, arg1_20)
		end
	})
end

function var0_0.LoadLayerOnTopContext(arg0_31)
	local var0_31 = getProxy(ContextProxy):getCurrentContext()

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_31,
		context = arg0_31
	})
end

function var0_0.RemoveLayerByMediator(arg0_32)
	local var0_32 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0_32)

	if var0_32 then
		pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0_32
		})

		return true
	end
end

return var0_0
