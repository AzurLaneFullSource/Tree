local var0 = class("ShipBluePrintMediator", import("..base.ContextMediator"))

var0.ON_CLICK_SPEEDUP_BTN = "ShipBluePrintMediator:ON_CLICK_SPEEDUP_BTN"
var0.ON_START = "ShipBluePrintMediator:ON_START"
var0.ON_FINISHED = "ShipBluePrintMediator:ON_FINISHED"
var0.ON_ITEM_UNLOCK = "ShipBluePrintMediator:ON_ITEM_UNLOCK"
var0.ON_FINISH_TASK = "ShipBluePrintMediator:ON_FINISH_TASK"
var0.ON_MOD = "ShipBluePrintMediator:ON_MOD"
var0.ON_PURSUING = "ShipBluePrintMediator:ON_PURSUING"
var0.ON_TASK_OPEN = "ShipBluePrintMediator:ON_TASK_OPEN"
var0.ON_CHECK_TAKES = "ShipBluePrintMediator:ON_CHECK_TAKES"
var0.SHOW_SKILL_INFO = "ShipBluePrintMediator:SHOW_SKILL_INFO"
var0.SET_TECHNOLOGY_VERSION = "ShipBluePrintMediator:SET_TECHNOLOGY_VERSION"
var0.SIMULATION_BATTLE = "ShipBluePrintMediator:SIMULATION_BATTLE"
var0.QUICK_EXCHAGE_BLUEPRINT = "ShipBluePrintMediator:QUICK_EXCHAGE_BLUEPRINT"

function var0.register(arg0)
	PlayerPrefs.SetString("technology_day_mark", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d", true))

	local var0 = getProxy(TechnologyProxy)

	if arg0.contextData.shipId then
		local var1 = getProxy(BayProxy):getShipById(arg0.contextData.shipId)
		local var2 = var0:getBluePrintById(var1.groupId)

		arg0.contextData.shipBluePrintVO = var2
	elseif arg0.contextData.shipGroupId then
		local var3 = var0:getBluePrintById(arg0.contextData.shipGroupId)

		arg0.contextData.shipBluePrintVO = var3
	end

	arg0:bind(var0.ON_CLICK_SPEEDUP_BTN, function()
		arg0:addSubLayers(Context.New({
			viewComponent = TecSpeedUpLayer,
			mediator = TecSpeedUpMediator
		}))
	end)
	arg0:bind(var0.ON_START, function(arg0, arg1)
		arg0:sendNotification(GAME.BUILD_SHIP_BLUEPRINT, {
			id = arg1
		})
	end)
	arg0:bind(var0.ON_FINISHED, function(arg0, arg1)
		arg0:sendNotification(GAME.FINISH_SHIP_BLUEPRINT, {
			id = arg1
		})
	end)
	arg0:bind(var0.ON_ITEM_UNLOCK, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.ITEM_LOCK_SHIP_BLUPRINT, {
			id = arg1,
			itemId = arg2
		})
	end)
	arg0:bind(var0.ON_FINISH_TASK, function(arg0, arg1)
		local var0 = Task.New({
			id = arg1
		})

		if var0:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
			local var1 = getDropInfo({
				{
					DROP_TYPE_ITEM,
					tonumber(var0:getConfig("target_id")),
					var0:getConfig("target_num")
				}
			})

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_commit_tip", var1),
				onYes = function()
					arg0:sendNotification(GAME.SUBMIT_TASK, arg1)
				end
			})
		elseif var0:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
			local var2 = getDropInfo({
				{
					DROP_TYPE_RESOURCE,
					tonumber(var0:getConfig("target_id")),
					var0:getConfig("target_num")
				}
			})

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_commit_tip", var2),
				onYes = function()
					arg0:sendNotification(GAME.SUBMIT_TASK, arg1)
				end
			})
		else
			arg0:sendNotification(GAME.SUBMIT_TASK, arg1)
		end
	end)
	arg0:bind(var0.ON_MOD, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.MOD_BLUEPRINT, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.ON_PURSUING, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.PURSUING_BLUEPRINT, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.ON_TASK_OPEN, function(arg0, arg1)
		if not getProxy(TaskProxy):isFinishPrevTasks(arg1) then
			return
		end

		arg0:sendNotification(GAME.TRIGGER_TASK, arg1)
	end)
	arg0:bind(var0.ON_CHECK_TAKES, function(arg0, arg1)
		local var0 = getProxy(TechnologyProxy)
		local var1 = var0:getBluePrintById(arg1)

		if var1:isFinishedAllTasks() then
			var1:finish()
			var0:updateBluePrint(var1)
		end
	end)
	arg0:bind(var0.SHOW_SKILL_INFO, function(arg0, arg1, arg2, arg3)
		arg0:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = SkillInfoLayer,
			data = {
				skillOnShip = arg2,
				skillId = arg1,
				onExit = arg3
			}
		}))
	end)
	arg0:bind(var0.SET_TECHNOLOGY_VERSION, function(arg0, arg1)
		var0:setVersion(arg1)
	end)
	arg0:bind(var0.SIMULATION_BATTLE, function(arg0, arg1)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SIMULATION,
			stageId = arg1
		})
	end)
	arg0:bind(var0.QUICK_EXCHAGE_BLUEPRINT, function(arg0, arg1)
		arg0:sendNotification(GAME.QUICK_EXCHANGE_BLUEPRINT, arg1)
	end)

	local var4 = var0:getBluePrints()

	arg0.viewComponent:setShipBluePrints(var4)

	local var5 = getProxy(BayProxy)

	arg0.viewComponent:setShipVOs(var5:getRawData())
	arg0.viewComponent:setVersion(var0:getVersion())
	arg0.viewComponent:setTaskVOs(getProxy(TaskProxy):getTasksForBluePrint())
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.BUILD_SHIP_BLUEPRINT_DONE,
		TechnologyProxy.BLUEPRINT_UPDATED,
		TaskProxy.TASK_ADDED,
		TaskProxy.TASK_UPDATED,
		TaskProxy.TASK_REMOVED,
		GAME.SUBMIT_TASK_DONE,
		GAME.FINISH_SHIP_BLUEPRINT_DONE,
		GAME.ITEM_LOCK_SHIP_BLUPRINT_DONE,
		GAME.STOP_BLUEPRINT_DONE,
		GAME.MOD_BLUEPRINT_DONE,
		BayProxy.SHIP_ADDED,
		BayProxy.SHIP_UPDATED,
		GAME.BEGIN_STAGE_DONE,
		GAME.MOD_BLUEPRINT_ANIM_LOCK,
		GAME.PURSUING_RESET_DONE,
		GAME.QUICK_EXCHANGE_BLUEPRINT_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == TechnologyProxy.BLUEPRINT_UPDATED then
		arg0.viewComponent:updateShipBluePrintVO(var1)
	elseif var0 == GAME.EXCHANG_BLUEPRINT_DONE then
		arg0.viewComponent:clearSelected()
		arg0.viewComponent:updateExchangeItems()
		arg0.viewComponent:updateBuildInfo()
	elseif var0 == TaskProxy.TASK_ADDED or TaskProxy.TASK_UPDATED == var0 or TaskProxy.TASK_REMOVED == var0 then
		arg0.viewComponent:setTaskVOs(getProxy(TaskProxy):getTasksForBluePrint())
		arg0.viewComponent:updateTaskList()
		arg0.viewComponent:updateTasksProgress()
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		local var2 = arg0.contextData.shipBluePrintVO

		if var2 and var2:isDeving() and var2:isFinishedAllTasks() then
			local var3 = getProxy(TechnologyProxy)
			local var4 = var3:getBluePrintById(var2.id)

			var4:finish()
			var3:updateBluePrint(var4)
		end
	elseif var0 == GAME.FINISH_SHIP_BLUEPRINT_DONE or var0 == GAME.ITEM_LOCK_SHIP_BLUPRINT_DONE then
		arg0:addSubLayers(Context.New({
			mediator = NewShipMediator,
			viewComponent = NewShipLayer,
			data = {
				ship = var1.ship,
				canSkipBatch = var1.canSkipBatch
			},
			onRemoved = function()
				pg.NewStoryMgr.GetInstance():Play("FANGAN2")
			end
		}))
	elseif GAME.STOP_BLUEPRINT_DONE == var0 then
		arg0.viewComponent:clearTimers(var1.id)
	elseif GAME.MOD_BLUEPRINT_DONE == var0 then
		arg0.viewComponent:doModAnim(var1.oldBluePrint, var1.newBluePrint)
		arg0.viewComponent:updateAllPursuingCostTip()
	elseif var0 == BayProxy.SHIP_ADDED or BayProxy.SHIP_UPDATED == var0 then
		local var5 = getProxy(BayProxy)

		arg0.viewComponent:setShipVOs(var5:getRawData())
	elseif GAME.BUILD_SHIP_BLUEPRINT_DONE == var0 then
		arg0.viewComponent:buildStartAni("researchStartWindow")
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == GAME.MOD_BLUEPRINT_ANIM_LOCK then
		arg0.viewComponent.noUpdateMod = true
	elseif var0 == GAME.PURSUING_RESET_DONE then
		-- block empty
	elseif var0 == GAME.QUICK_EXCHANGE_BLUEPRINT_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, function()
			arg0.viewComponent:updateShipBluePrintVO()
		end)
	end
end

return var0
