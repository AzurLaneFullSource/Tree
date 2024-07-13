local var0_0 = class("WorldPortMediator", import("..base.ContextMediator"))

var0_0.OnOpenBay = "WorldPortMediator.OnOpenBay"
var0_0.OnTaskGoto = "WorldPortMediator.OnTaskGoto"
var0_0.OnAccepetTask = "WorldPortMediator.OnAccepetTask"
var0_0.OnSubmitTask = "WorldPortMediator.OnSubmitTask"
var0_0.OnReqPort = "WorldPortMediator.OnReqPort"
var0_0.OnBuyGoods = "WorldPortMediator.OnBuyGoods"
var0_0.OnBuyNShopGoods = "WorldPortMediator.OnBuyNShopGoods"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OnOpenBay, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			selectedMin = 0,
			mode = DockyardScene.MODE_WORLD,
			hideTagFlags = ShipStatus.TAG_HIDE_WORLD
		})
	end)
	arg0_1:bind(var0_0.OnTaskGoto, function(arg0_3, arg1_3)
		arg0_1.viewComponent:closeView()
		arg0_1:sendNotification(WorldMediator.OnTriggerTaskGo, {
			taskId = arg1_3
		})
	end)
	arg0_1:bind(var0_0.OnAccepetTask, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.WORLD_TRIGGER_TASK, {
			taskId = arg1_4.id,
			portId = arg2_4
		})
	end)
	arg0_1:bind(var0_0.OnSubmitTask, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.WORLD_SUMBMIT_TASK, {
			taskId = arg1_5.id
		})
	end)
	arg0_1:bind(var0_0.OnReqPort, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.WORLD_PORT_REQ, {
			mapId = arg1_6
		})
	end)
	arg0_1:bind(var0_0.OnBuyGoods, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.WORLD_PORT_SHOPPING, {
			goods = arg1_7
		})
	end)
	arg0_1:bind(var0_0.OnBuyNShopGoods, function(arg0_8, arg1_8, arg2_8)
		arg0_1:sendNotification(GAME.WORLD_PORT_NEW_SHOPPING, {
			goods = arg1_8,
			count = arg2_8
		})
	end)
	arg0_1.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())

	local var0_1 = nowWorld()

	arg0_1.viewComponent:SetAtlas(var0_1:GetAtlas())
	arg0_1.viewComponent:SetPort(var0_1:GetActiveMap():GetPort())
	arg0_1:CheckTaskNotify(var0_1:GetTaskProxy())
end

function var0_0.initNotificationHandleDic(arg0_9)
	arg0_9.handleDic = {
		[PlayerProxy.UPDATED] = function(arg0_10, arg1_10)
			arg0_10.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())
		end,
		[GAME.WORLD_PORT_SHOPPING_DONE] = function(arg0_11, arg1_11)
			local var0_11 = arg1_11:getBody()

			arg0_11.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_11.drops)
			arg0_11.viewComponent:UpdateCDTip()
		end,
		[GAME.WORLD_PORT_NEW_SHOPPING_DONE] = function(arg0_12, arg1_12)
			local var0_12 = arg1_12:getBody()

			arg0_12.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_12.drops)
		end
	}
end

function var0_0.CheckTaskNotify(arg0_13, arg1_13)
	local var0_13 = arg1_13:getTasks()

	for iter0_13, iter1_13 in pairs(var0_13) do
		if iter1_13:getState() == WorldTask.STATE_ONGOING and iter1_13.config.complete_condition == WorldConst.TaskTypeArrivePort then
			local var1_13 = WBank:Fetch(WorldMapOp)

			var1_13.op = WorldConst.OpReqTask

			arg0_13:sendNotification(GAME.WORLD_MAP_OP, var1_13)
		end
	end
end

return var0_0
