local var0_0 = class("SixthAnniversaryIslandMediator", import("..base.ContextMediator"))

var0_0.TRIGGER_NODE_EVENT = "SixthAnniversaryIslandMediator.TRIGGER_NODE_EVENT"
var0_0.OPEN_QTE_GAME = "SixthAnniversaryIslandMediator.OPEN_QTE_GAME"
var0_0.INTO_ENTRANCE = "SixthAnniversaryIslandMediator.INTO_ENTRANCE"
var0_0.MARK_NODE_AFTER_NEW = "SixthAnniversaryIslandMediator.MARK_NODE_AFTER_NEW"
var0_0.GO_SHOP = "SixthAnniversaryIslandMediator.GO_SHOP"
var0_0.OPEN_NOTE = "SixthAnniversaryIslandMediator.OPEN_NOTE"
var0_0.OPEN_RES = "SixthAnniversaryIslandMediator.OPEN_RES"
var0_0.DISPLAY_NODES = "SixthAnniversaryIslandMediator.DISPLAY_NODES"
var0_0.DISPLAY_SHOP = "SixthAnniversaryIslandMediator.DISPLAY_SHOP"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

	arg0_1.viewComponent:setActivity(var0_1)
	arg0_1.viewComponent:setNodeIds(getProxy(IslandProxy):GetNodeIds())
	arg0_1.viewComponent:setPlayer(getProxy(PlayerProxy):getData())

	local var1_1 = getProxy(ActivityProxy):getActivityById(ActivityConst.ISLAND_GAME_ID):getConfig("config_id")

	arg0_1.viewComponent:setResDrop({
		type = 2,
		id = getProxy(ActivityProxy):getActivityById(ActivityConst.ISLAND_GAME_ID):getConfig("config_client").item_id,
		count = getProxy(MiniGameProxy):GetHubByHubId(var1_1).count
	}, pg.mini_game_hub[var1_1].reborn_times)
	arg0_1:bind(var0_0.TRIGGER_NODE_EVENT, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.ISLAND_EVENT_TRIGGER, {
			act_id = var0_1.id,
			node_id = arg1_2,
			op = arg2_2
		})
	end)
	arg0_1:bind(var0_0.OPEN_QTE_GAME, function(arg0_3, arg1_3, arg2_3)
		arg0_1:addSubLayers(Context.New({
			mediator = IslandQTEMiniGameMediator,
			viewComponent = IslandQTEMiniGameLayer,
			data = {
				mark = arg1_3,
				finishCallback = arg2_3
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_NOTE, function(arg0_4)
		arg0_1:addSubLayers(Context.New({
			mediator = IslandTaskMediator,
			viewComponent = IslandTaskScene,
			data = {}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_RES, function(arg0_5, arg1_5, arg2_5)
		arg0_1:addSubLayers(Context.New({
			mediator = SixthAnniversaryIslandItemWindowMediator,
			viewComponent = SixthAnniversaryIslandItemWindowLayer,
			data = {
				drop = arg1_5,
				text = arg2_5
			}
		}))
	end)
	arg0_1:bind(var0_0.INTO_ENTRANCE, function(arg0_6, arg1_6)
		switch(arg1_6, {
			flowerfield = function()
				arg0_1:addSubLayers(Context.New({
					mediator = IslandFlowerFieldMediator,
					viewComponent = IslandFlowerFieldLayer,
					data = {}
				}))
			end,
			minigame1 = function()
				arg0_1:sendNotification(GAME.GO_MINI_GAME, 52)
			end,
			minigame2 = function()
				arg0_1:sendNotification(GAME.GO_MINI_GAME, 53)
			end,
			minigame3 = function()
				arg0_1:sendNotification(GAME.GO_MINI_GAME, 54)
			end,
			island = function()
				arg0_1.viewComponent:closeView()
			end,
			hotspringtask = function()
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SPRING_TASK)
			end,
			hotspring = function()
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SPRING)
			end
		})
	end)
	arg0_1:bind(var0_0.MARK_NODE_AFTER_NEW, function(arg0_14, arg1_14)
		arg0_1:sendNotification(GAME.ISLAND_NODE_MARK, {
			act_id = var0_1.id,
			node_id = arg1_14
		})
	end)
	arg0_1:bind(var0_0.GO_SHOP, function(arg0_15)
		arg0_1:addSubLayers(Context.New({
			mediator = SixthAnniversaryIslandShopMediator,
			viewComponent = SixthAnniversaryIslandShopLayer
		}))
	end)
end

function var0_0.initNotificationHandleDic(arg0_16)
	arg0_16.handleDic = {
		[GAME.ISLAND_EVENT_TRIGGER_DONE] = function(arg0_17, arg1_17)
			local var0_17 = arg1_17:getBody()
			local var1_17 = {}

			if #var0_17.awards > 0 then
				table.insert(var1_17, function(arg0_18)
					arg0_17.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_17.awards, arg0_18)
				end)
			end

			seriesAsync(var1_17, function()
				arg0_17.viewComponent:afterTriggerEvent(var0_17.node_id)
			end)
		end,
		[GAME.ISLAND_NODE_MARK_DONE] = function(arg0_20, arg1_20)
			local var0_20 = arg1_20:getBody()

			arg0_20.viewComponent:refreshNode(var0_20.node_id)
		end,
		[GAME.ZERO_HOUR_OP_DONE] = function(arg0_21, arg1_21)
			getProxy(IslandProxy):CheckAndRequest(function()
				arg0_21.viewComponent.nodeItemList:align(#arg0_21.viewComponent.ids)
				arg0_21.viewComponent:refreshDailyPanel()
			end)
		end,
		[PlayerProxy.UPDATED] = function(arg0_23, arg1_23)
			local var0_23 = arg1_23:getBody()

			arg0_23.viewComponent:setPlayer(var0_23)
		end,
		[MiniGameProxy.ON_HUB_DATA_UPDATE] = function(arg0_24, arg1_24)
			local var0_24 = arg1_24:getBody()
			local var1_24 = getProxy(ActivityProxy):getActivityById(ActivityConst.ISLAND_GAME_ID):getConfig("config_id")

			if var0_24.id == var1_24 then
				arg0_24.viewComponent:setResDrop({
					type = 2,
					id = getProxy(ActivityProxy):getActivityById(ActivityConst.ISLAND_GAME_ID):getConfig("config_client").item_id,
					count = getProxy(MiniGameProxy):GetHubByHubId(var1_24).count
				}, pg.mini_game_hub[var1_24].reborn_times)
			end
		end,
		[var0_0.DISPLAY_NODES] = function(arg0_25, arg1_25)
			local var0_25 = arg1_25:getBody()

			if var0_25 and #var0_25 > 0 and not arg0_25.viewComponent:focusList(var0_25, LeanTweenType.easeInOutSine) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("islandnode_tips8"))
			end
		end,
		[var0_0.DISPLAY_SHOP] = function(arg0_26, arg1_26)
			arg0_26:addSubLayers(Context.New({
				mediator = SixthAnniversaryIslandShopMediator,
				viewComponent = SixthAnniversaryIslandShopLayer
			}))
		end,
		[GAME.ISLAND_FLOWER_GET_DONE] = function(arg0_27, arg1_27)
			for iter0_27, iter1_27 in pairs(getProxy(IslandProxy):GetNodeDic()) do
				if iter1_27:getConfig("type") == 5 and iter1_27:getConfig("params")[1] == "flowerfield" then
					arg0_27.viewComponent:refreshNode(iter0_27)
				end
			end
		end,
		[ActivityProxy.ACTIVITY_UPDATED] = function(arg0_28, arg1_28)
			if arg1_28:getBody().id == ActivityConst.ISLAND_TASK_ID then
				arg0_28.viewComponent:updateTaskTip()
			end
		end
	}
end

return var0_0
