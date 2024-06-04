local var0 = class("SixthAnniversaryIslandMediator", import("..base.ContextMediator"))

var0.TRIGGER_NODE_EVENT = "SixthAnniversaryIslandMediator.TRIGGER_NODE_EVENT"
var0.OPEN_QTE_GAME = "SixthAnniversaryIslandMediator.OPEN_QTE_GAME"
var0.INTO_ENTRANCE = "SixthAnniversaryIslandMediator.INTO_ENTRANCE"
var0.MARK_NODE_AFTER_NEW = "SixthAnniversaryIslandMediator.MARK_NODE_AFTER_NEW"
var0.GO_SHOP = "SixthAnniversaryIslandMediator.GO_SHOP"
var0.OPEN_NOTE = "SixthAnniversaryIslandMediator.OPEN_NOTE"
var0.OPEN_RES = "SixthAnniversaryIslandMediator.OPEN_RES"
var0.DISPLAY_NODES = "SixthAnniversaryIslandMediator.DISPLAY_NODES"
var0.DISPLAY_SHOP = "SixthAnniversaryIslandMediator.DISPLAY_SHOP"

function var0.register(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND)

	arg0.viewComponent:setActivity(var0)
	arg0.viewComponent:setNodeIds(getProxy(IslandProxy):GetNodeIds())
	arg0.viewComponent:setPlayer(getProxy(PlayerProxy):getData())

	local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.ISLAND_GAME_ID):getConfig("config_id")

	arg0.viewComponent:setResDrop({
		type = 2,
		id = getProxy(ActivityProxy):getActivityById(ActivityConst.ISLAND_GAME_ID):getConfig("config_client").item_id,
		count = getProxy(MiniGameProxy):GetHubByHubId(var1).count
	}, pg.mini_game_hub[var1].reborn_times)
	arg0:bind(var0.TRIGGER_NODE_EVENT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.ISLAND_EVENT_TRIGGER, {
			act_id = var0.id,
			node_id = arg1,
			op = arg2
		})
	end)
	arg0:bind(var0.OPEN_QTE_GAME, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			mediator = IslandQTEMiniGameMediator,
			viewComponent = IslandQTEMiniGameLayer,
			data = {
				mark = arg1,
				finishCallback = arg2
			}
		}))
	end)
	arg0:bind(var0.OPEN_NOTE, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = IslandTaskMediator,
			viewComponent = IslandTaskScene,
			data = {}
		}))
	end)
	arg0:bind(var0.OPEN_RES, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			mediator = SixthAnniversaryIslandItemWindowMediator,
			viewComponent = SixthAnniversaryIslandItemWindowLayer,
			data = {
				drop = arg1,
				text = arg2
			}
		}))
	end)
	arg0:bind(var0.INTO_ENTRANCE, function(arg0, arg1)
		switch(arg1, {
			flowerfield = function()
				arg0:addSubLayers(Context.New({
					mediator = IslandFlowerFieldMediator,
					viewComponent = IslandFlowerFieldLayer,
					data = {}
				}))
			end,
			minigame1 = function()
				arg0:sendNotification(GAME.GO_MINI_GAME, 52)
			end,
			minigame2 = function()
				arg0:sendNotification(GAME.GO_MINI_GAME, 53)
			end,
			minigame3 = function()
				arg0:sendNotification(GAME.GO_MINI_GAME, 54)
			end,
			island = function()
				arg0.viewComponent:closeView()
			end,
			hotspringtask = function()
				arg0:sendNotification(GAME.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SPRING_TASK)
			end,
			hotspring = function()
				arg0:sendNotification(GAME.GO_SCENE, SCENE.ANNIVERSARY_ISLAND_SPRING)
			end
		})
	end)
	arg0:bind(var0.MARK_NODE_AFTER_NEW, function(arg0, arg1)
		arg0:sendNotification(GAME.ISLAND_NODE_MARK, {
			act_id = var0.id,
			node_id = arg1
		})
	end)
	arg0:bind(var0.GO_SHOP, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = SixthAnniversaryIslandShopMediator,
			viewComponent = SixthAnniversaryIslandShopLayer
		}))
	end)
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {
		[GAME.ISLAND_EVENT_TRIGGER_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()
			local var1 = {}

			if #var0.awards > 0 then
				table.insert(var1, function(arg0)
					arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0.awards, arg0)
				end)
			end

			seriesAsync(var1, function()
				arg0.viewComponent:afterTriggerEvent(var0.node_id)
			end)
		end,
		[GAME.ISLAND_NODE_MARK_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:refreshNode(var0.node_id)
		end,
		[GAME.ZERO_HOUR_OP_DONE] = function(arg0, arg1)
			getProxy(IslandProxy):CheckAndRequest(function()
				arg0.viewComponent.nodeItemList:align(#arg0.viewComponent.ids)
				arg0.viewComponent:refreshDailyPanel()
			end)
		end,
		[PlayerProxy.UPDATED] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:setPlayer(var0)
		end,
		[MiniGameProxy.ON_HUB_DATA_UPDATE] = function(arg0, arg1)
			local var0 = arg1:getBody()
			local var1 = getProxy(ActivityProxy):getActivityById(ActivityConst.ISLAND_GAME_ID):getConfig("config_id")

			if var0.id == var1 then
				arg0.viewComponent:setResDrop({
					type = 2,
					id = getProxy(ActivityProxy):getActivityById(ActivityConst.ISLAND_GAME_ID):getConfig("config_client").item_id,
					count = getProxy(MiniGameProxy):GetHubByHubId(var1).count
				}, pg.mini_game_hub[var1].reborn_times)
			end
		end,
		[var0.DISPLAY_NODES] = function(arg0, arg1)
			local var0 = arg1:getBody()

			if var0 and #var0 > 0 and not arg0.viewComponent:focusList(var0, LeanTweenType.easeInOutSine) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("islandnode_tips8"))
			end
		end,
		[var0.DISPLAY_SHOP] = function(arg0, arg1)
			arg0:addSubLayers(Context.New({
				mediator = SixthAnniversaryIslandShopMediator,
				viewComponent = SixthAnniversaryIslandShopLayer
			}))
		end,
		[GAME.ISLAND_FLOWER_GET_DONE] = function(arg0, arg1)
			for iter0, iter1 in pairs(getProxy(IslandProxy):GetNodeDic()) do
				if iter1:getConfig("type") == 5 and iter1:getConfig("params")[1] == "flowerfield" then
					arg0.viewComponent:refreshNode(iter0)
				end
			end
		end,
		[ActivityProxy.ACTIVITY_UPDATED] = function(arg0, arg1)
			if arg1:getBody().id == ActivityConst.ISLAND_TASK_ID then
				arg0.viewComponent:updateTaskTip()
			end
		end
	}
end

return var0
