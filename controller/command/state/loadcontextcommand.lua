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
			if var0_3.isReload then
				arg0_3:reloadScene(var0_3.context, var1_3)
			else
				arg0_3:loadScene(var0_3.context, var0_3.prevContext, var0_3.isBack, var1_3)
			end
		elseif var0_3.type == LOAD_TYPE_LAYER then
			arg0_3:loadLayer(var0_3.context, var0_3.parentContext, var0_3.removeContexts, var1_3)
		else
			assert(false, "context load type not support: " .. var0_3.type)
		end
	end
end

function var0_0.reloadScene(arg0_5, arg1_5, arg2_5)
	assert(isa(arg1_5, Context), "should be an instance of Context")

	local var0_5 = getProxy(ContextProxy)
	local var1_5 = pg.SceneMgr.GetInstance()
	local var2_5
	local var3_5
	local var4_5 = {}

	seriesAsync({
		function(arg0_6)
			pg.UIMgr.GetInstance():LoadingOn(arg1_5.data.showLoading)
			var1_5:removeLayerMediator(arg0_5.facade, arg1_5, function(arg0_7)
				var2_5 = arg0_7

				arg0_6()
			end)
		end,
		function(arg0_8)
			if var2_5 then
				table.SerialIpairsAsync(var2_5, function(arg0_9, arg1_9, arg2_9)
					var1_5:remove(arg1_9.mediator, function()
						if arg0_9 == #var2_5 then
							arg1_9.context:onContextRemoved()
						end

						arg2_9()
					end, false)
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
			local var0_12 = arg1_5:GetHierarchy()

			_.each(var0_12, function(arg0_13)
				pg.PoolMgr.GetInstance():BuildUIPlural(arg0_13.viewComponent.getUIName())
			end)
			var1_5:prepare(arg0_5.facade, arg1_5, function(arg0_14)
				arg0_5:sendNotification(GAME.START_LOAD_SCENE, arg0_14)

				var3_5 = arg0_14

				arg0_12()
			end)
		end,
		function(arg0_15)
			var1_5:prepareLayer(arg0_5.facade, nil, arg1_5, function(arg0_16)
				arg0_5:sendNotification(GAME.WILL_LOAD_LAYERS, #arg0_16)

				var4_5 = arg0_16

				arg0_15()
			end)
		end,
		function(arg0_17)
			var1_5:enter({
				var3_5
			}, arg0_17)
		end,
		function(arg0_18)
			var1_5:enter(var4_5, arg0_18)
		end,
		function()
			if arg2_5 then
				arg2_5()
			end

			pg.UIMgr.GetInstance():LoadingOff()
			arg0_5:sendNotification(GAME.LOAD_SCENE_DONE, arg1_5.scene)
		end
	})
end

function var0_0.loadScene(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	assert(isa(arg1_20, Context), "should be an instance of Context")

	local var0_20 = getProxy(ContextProxy)
	local var1_20 = pg.SceneMgr.GetInstance()
	local var2_20
	local var3_20
	local var4_20 = {}
	local var5_20 = arg3_20 and arg2_20 or nil

	seriesAsync({
		function(arg0_21)
			pg.UIMgr.GetInstance():LoadingOn(arg1_20.data.showLoading)

			if arg2_20 ~= nil then
				arg1_20:extendData({
					fromMediatorName = arg2_20.mediator.__cname
				})
				var1_20:removeLayerMediator(arg0_20.facade, arg2_20, function(arg0_22)
					var2_20 = arg0_22

					arg0_21()
				end)
			else
				arg0_21()
			end
		end,
		function(arg0_23)
			if arg1_20.cleanStack then
				var0_20:cleanContext()
			end

			var0_20:pushContext(arg1_20)
			arg0_23()
		end,
		function(arg0_24)
			local var0_24 = arg1_20:GetHierarchy()

			_.each(var0_24, function(arg0_25)
				pg.PoolMgr.GetInstance():BuildUIPlural(arg0_25.viewComponent.getUIName())
			end)
			var1_20:prepare(arg0_20.facade, arg1_20, function(arg0_26)
				arg0_20:sendNotification(GAME.START_LOAD_SCENE, arg0_26)

				var3_20 = arg0_26

				arg0_24()
			end)
		end,
		function(arg0_27)
			var1_20:prepareLayer(arg0_20.facade, nil, arg1_20, function(arg0_28)
				arg0_20:sendNotification(GAME.WILL_LOAD_LAYERS, #arg0_28)

				var4_20 = arg0_28

				arg0_27()
			end)
		end,
		function(arg0_29)
			if var2_20 then
				table.SerialIpairsAsync(var2_20, function(arg0_30, arg1_30, arg2_30)
					local var0_30 = false

					if var5_20 then
						var0_30 = var5_20.mediator.__cname == arg1_30.mediator.__cname

						if var0_30 then
							var1_20:clearTempCache(arg1_30.mediator)
						end
					end

					var1_20:remove(arg1_30.mediator, function()
						if arg0_30 == #var2_20 then
							arg1_30.context:onContextRemoved()
						end

						arg2_30()
					end, var0_30)
				end, arg0_29)
			else
				arg0_29()
			end
		end,
		function(arg0_32)
			var1_20:enter({
				var3_20
			}, arg0_32)
		end,
		function(arg0_33)
			var1_20:enter(var4_20, arg0_33)
		end,
		function()
			if arg4_20 then
				arg4_20()
			end

			pg.UIMgr.GetInstance():LoadingOff()
			arg0_20:sendNotification(GAME.LOAD_SCENE_DONE, arg1_20.scene)
		end
	})
end

function var0_0.loadLayer(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35)
	assert(isa(arg1_35, Context), "should be an instance of Context")

	local var0_35 = pg.SceneMgr.GetInstance()
	local var1_35 = {}
	local var2_35

	seriesAsync({
		function(arg0_36)
			pg.UIMgr.GetInstance():LoadingOn(arg1_35.data.showLoading)

			if arg3_35 ~= nil then
				table.ParallelIpairsAsync(arg3_35, function(arg0_37, arg1_37, arg2_37)
					var0_35:removeLayerMediator(arg0_35.facade, arg1_37, function(arg0_38)
						var2_35 = var2_35 or {}

						table.insertto(var2_35, arg0_38)
						arg2_37()
					end)
				end, arg0_36)
			else
				arg0_36()
			end
		end,
		function(arg0_39)
			local var0_39 = arg1_35:GetHierarchy()

			_.each(var0_39, function(arg0_40)
				pg.PoolMgr.GetInstance():BuildUIPlural(arg0_40.viewComponent.getUIName())
			end)
			var0_35:prepareLayer(arg0_35.facade, arg2_35, arg1_35, function(arg0_41)
				for iter0_41, iter1_41 in ipairs(arg0_41) do
					table.insert(var1_35, iter1_41)
				end

				arg0_39()
			end)
		end,
		function(arg0_42)
			if var2_35 then
				table.SerialIpairsAsync(var2_35, function(arg0_43, arg1_43, arg2_43)
					var0_35:remove(arg1_43.mediator, function()
						arg1_43.context:onContextRemoved()
						arg2_43()
					end)
				end, arg0_42)
			else
				arg0_42()
			end
		end,
		function(arg0_45)
			arg0_35:sendNotification(GAME.WILL_LOAD_LAYERS, #var1_35)
			var0_35:enter(var1_35, arg0_45)
		end,
		function()
			if arg4_35 then
				arg4_35()
			end

			pg.UIMgr.GetInstance():LoadingOff()
			arg0_35:sendNotification(GAME.LOAD_LAYER_DONE, arg1_35)
		end
	})
end

function var0_0.LoadLayerOnTopContext(arg0_47)
	local var0_47 = getProxy(ContextProxy):getCurrentContext()

	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_47,
		context = arg0_47
	})
end

function var0_0.RemoveLayerByMediator(arg0_48)
	local var0_48 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0_48)

	if var0_48 then
		pg.m02:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0_48
		})

		return true
	end
end

return var0_0
