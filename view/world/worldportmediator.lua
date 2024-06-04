local var0 = class("WorldPortMediator", import("..base.ContextMediator"))

var0.OnOpenBay = "WorldPortMediator.OnOpenBay"
var0.OnTaskGoto = "WorldPortMediator.OnTaskGoto"
var0.OnAccepetTask = "WorldPortMediator.OnAccepetTask"
var0.OnSubmitTask = "WorldPortMediator.OnSubmitTask"
var0.OnReqPort = "WorldPortMediator.OnReqPort"
var0.OnBuyGoods = "WorldPortMediator.OnBuyGoods"
var0.OnBuyNShopGoods = "WorldPortMediator.OnBuyNShopGoods"

function var0.register(arg0)
	arg0:bind(var0.OnOpenBay, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			selectedMin = 0,
			mode = DockyardScene.MODE_WORLD,
			hideTagFlags = ShipStatus.TAG_HIDE_WORLD
		})
	end)
	arg0:bind(var0.OnTaskGoto, function(arg0, arg1)
		arg0.viewComponent:closeView()
		arg0:sendNotification(WorldMediator.OnTriggerTaskGo, {
			taskId = arg1
		})
	end)
	arg0:bind(var0.OnAccepetTask, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.WORLD_TRIGGER_TASK, {
			taskId = arg1.id,
			portId = arg2
		})
	end)
	arg0:bind(var0.OnSubmitTask, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_SUMBMIT_TASK, {
			taskId = arg1.id
		})
	end)
	arg0:bind(var0.OnReqPort, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_PORT_REQ, {
			mapId = arg1
		})
	end)
	arg0:bind(var0.OnBuyGoods, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_PORT_SHOPPING, {
			goods = arg1
		})
	end)
	arg0:bind(var0.OnBuyNShopGoods, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.WORLD_PORT_NEW_SHOPPING, {
			goods = arg1,
			count = arg2
		})
	end)
	arg0.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())

	local var0 = nowWorld()

	arg0.viewComponent:SetAtlas(var0:GetAtlas())
	arg0.viewComponent:SetPort(var0:GetActiveMap():GetPort())
	arg0:CheckTaskNotify(var0:GetTaskProxy())
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {
		[PlayerProxy.UPDATED] = function(arg0, arg1)
			arg0.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())
		end,
		[GAME.WORLD_PORT_SHOPPING_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0.drops)
			arg0.viewComponent:UpdateCDTip()
		end,
		[GAME.WORLD_PORT_NEW_SHOPPING_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0.drops)
		end
	}
end

function var0.CheckTaskNotify(arg0, arg1)
	local var0 = arg1:getTasks()

	for iter0, iter1 in pairs(var0) do
		if iter1:getState() == WorldTask.STATE_ONGOING and iter1.config.complete_condition == WorldConst.TaskTypeArrivePort then
			local var1 = WBank:Fetch(WorldMapOp)

			var1.op = WorldConst.OpReqTask

			arg0:sendNotification(GAME.WORLD_MAP_OP, var1)
		end
	end
end

return var0
