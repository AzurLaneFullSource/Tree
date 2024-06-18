local var0_0 = class("ShipBluePrintMediator", import("..base.ContextMediator"))

var0_0.ON_CLICK_SPEEDUP_BTN = "ShipBluePrintMediator:ON_CLICK_SPEEDUP_BTN"
var0_0.ON_START = "ShipBluePrintMediator:ON_START"
var0_0.ON_FINISHED = "ShipBluePrintMediator:ON_FINISHED"
var0_0.ON_ITEM_UNLOCK = "ShipBluePrintMediator:ON_ITEM_UNLOCK"
var0_0.ON_FINISH_TASK = "ShipBluePrintMediator:ON_FINISH_TASK"
var0_0.ON_MOD = "ShipBluePrintMediator:ON_MOD"
var0_0.ON_PURSUING = "ShipBluePrintMediator:ON_PURSUING"
var0_0.ON_TASK_OPEN = "ShipBluePrintMediator:ON_TASK_OPEN"
var0_0.ON_CHECK_TAKES = "ShipBluePrintMediator:ON_CHECK_TAKES"
var0_0.SHOW_SKILL_INFO = "ShipBluePrintMediator:SHOW_SKILL_INFO"
var0_0.SET_TECHNOLOGY_VERSION = "ShipBluePrintMediator:SET_TECHNOLOGY_VERSION"
var0_0.SIMULATION_BATTLE = "ShipBluePrintMediator:SIMULATION_BATTLE"
var0_0.QUICK_EXCHAGE_BLUEPRINT = "ShipBluePrintMediator:QUICK_EXCHAGE_BLUEPRINT"

function var0_0.register(arg0_1)
	PlayerPrefs.SetString("technology_day_mark", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d", true))

	local var0_1 = getProxy(TechnologyProxy)

	if arg0_1.contextData.shipId then
		local var1_1 = getProxy(BayProxy):getShipById(arg0_1.contextData.shipId)
		local var2_1 = var0_1:getBluePrintById(var1_1.groupId)

		arg0_1.contextData.shipBluePrintVO = var2_1
	elseif arg0_1.contextData.shipGroupId then
		local var3_1 = var0_1:getBluePrintById(arg0_1.contextData.shipGroupId)

		arg0_1.contextData.shipBluePrintVO = var3_1
	end

	arg0_1:bind(var0_0.ON_CLICK_SPEEDUP_BTN, function()
		arg0_1:addSubLayers(Context.New({
			viewComponent = TecSpeedUpLayer,
			mediator = TecSpeedUpMediator
		}))
	end)
	arg0_1:bind(var0_0.ON_START, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.BUILD_SHIP_BLUEPRINT, {
			id = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ON_FINISHED, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.FINISH_SHIP_BLUEPRINT, {
			id = arg1_4
		})
	end)
	arg0_1:bind(var0_0.ON_ITEM_UNLOCK, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.ITEM_LOCK_SHIP_BLUPRINT, {
			id = arg1_5,
			itemId = arg2_5
		})
	end)
	arg0_1:bind(var0_0.ON_FINISH_TASK, function(arg0_6, arg1_6)
		local var0_6 = Task.New({
			id = arg1_6
		})

		if var0_6:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
			local var1_6 = getDropInfo({
				{
					DROP_TYPE_ITEM,
					tonumber(var0_6:getConfig("target_id")),
					var0_6:getConfig("target_num")
				}
			})

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_commit_tip", var1_6),
				onYes = function()
					arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_6)
				end
			})
		elseif var0_6:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
			local var2_6 = getDropInfo({
				{
					DROP_TYPE_RESOURCE,
					tonumber(var0_6:getConfig("target_id")),
					var0_6:getConfig("target_num")
				}
			})

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_commit_tip", var2_6),
				onYes = function()
					arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_6)
				end
			})
		else
			arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_6)
		end
	end)
	arg0_1:bind(var0_0.ON_MOD, function(arg0_9, arg1_9, arg2_9)
		arg0_1:sendNotification(GAME.MOD_BLUEPRINT, {
			id = arg1_9,
			count = arg2_9
		})
	end)
	arg0_1:bind(var0_0.ON_PURSUING, function(arg0_10, arg1_10, arg2_10)
		arg0_1:sendNotification(GAME.PURSUING_BLUEPRINT, {
			id = arg1_10,
			count = arg2_10
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_OPEN, function(arg0_11, arg1_11)
		if not getProxy(TaskProxy):isFinishPrevTasks(arg1_11) then
			return
		end

		arg0_1:sendNotification(GAME.TRIGGER_TASK, arg1_11)
	end)
	arg0_1:bind(var0_0.ON_CHECK_TAKES, function(arg0_12, arg1_12)
		local var0_12 = getProxy(TechnologyProxy)
		local var1_12 = var0_12:getBluePrintById(arg1_12)

		if var1_12:isFinishedAllTasks() then
			var1_12:finish()
			var0_12:updateBluePrint(var1_12)
		end
	end)
	arg0_1:bind(var0_0.SHOW_SKILL_INFO, function(arg0_13, arg1_13, arg2_13, arg3_13)
		arg0_1:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = SkillInfoLayer,
			data = {
				skillOnShip = arg2_13,
				skillId = arg1_13,
				onExit = arg3_13
			}
		}))
	end)
	arg0_1:bind(var0_0.SET_TECHNOLOGY_VERSION, function(arg0_14, arg1_14)
		var0_1:setVersion(arg1_14)
	end)
	arg0_1:bind(var0_0.SIMULATION_BATTLE, function(arg0_15, arg1_15)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SIMULATION,
			stageId = arg1_15
		})
	end)
	arg0_1:bind(var0_0.QUICK_EXCHAGE_BLUEPRINT, function(arg0_16, arg1_16)
		arg0_1:sendNotification(GAME.QUICK_EXCHANGE_BLUEPRINT, arg1_16)
	end)

	local var4_1 = var0_1:getBluePrints()

	arg0_1.viewComponent:setShipBluePrints(var4_1)

	local var5_1 = getProxy(BayProxy)

	arg0_1.viewComponent:setShipVOs(var5_1:getRawData())
	arg0_1.viewComponent:setVersion(var0_1:getVersion())
	arg0_1.viewComponent:setTaskVOs(getProxy(TaskProxy):getTasksForBluePrint())
end

function var0_0.listNotificationInterests(arg0_17)
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

function var0_0.handleNotification(arg0_18, arg1_18)
	local var0_18 = arg1_18:getName()
	local var1_18 = arg1_18:getBody()

	if var0_18 == TechnologyProxy.BLUEPRINT_UPDATED then
		arg0_18.viewComponent:updateShipBluePrintVO(var1_18)
	elseif var0_18 == GAME.EXCHANG_BLUEPRINT_DONE then
		arg0_18.viewComponent:clearSelected()
		arg0_18.viewComponent:updateExchangeItems()
		arg0_18.viewComponent:updateBuildInfo()
	elseif var0_18 == TaskProxy.TASK_ADDED or TaskProxy.TASK_UPDATED == var0_18 or TaskProxy.TASK_REMOVED == var0_18 then
		arg0_18.viewComponent:setTaskVOs(getProxy(TaskProxy):getTasksForBluePrint())
		arg0_18.viewComponent:updateTaskList()
		arg0_18.viewComponent:updateTasksProgress()
	elseif var0_18 == GAME.SUBMIT_TASK_DONE then
		local var2_18 = arg0_18.contextData.shipBluePrintVO

		if var2_18 and var2_18:isDeving() and var2_18:isFinishedAllTasks() then
			local var3_18 = getProxy(TechnologyProxy)
			local var4_18 = var3_18:getBluePrintById(var2_18.id)

			var4_18:finish()
			var3_18:updateBluePrint(var4_18)
		end
	elseif var0_18 == GAME.FINISH_SHIP_BLUEPRINT_DONE or var0_18 == GAME.ITEM_LOCK_SHIP_BLUPRINT_DONE then
		arg0_18:addSubLayers(Context.New({
			mediator = NewShipMediator,
			viewComponent = NewShipLayer,
			data = {
				ship = var1_18.ship,
				canSkipBatch = var1_18.canSkipBatch
			},
			onRemoved = function()
				pg.NewStoryMgr.GetInstance():Play("FANGAN2")
			end
		}))
	elseif GAME.STOP_BLUEPRINT_DONE == var0_18 then
		arg0_18.viewComponent:clearTimers(var1_18.id)
	elseif GAME.MOD_BLUEPRINT_DONE == var0_18 then
		arg0_18.viewComponent:doModAnim(var1_18.oldBluePrint, var1_18.newBluePrint)
		arg0_18.viewComponent:updateAllPursuingCostTip()
	elseif var0_18 == BayProxy.SHIP_ADDED or BayProxy.SHIP_UPDATED == var0_18 then
		local var5_18 = getProxy(BayProxy)

		arg0_18.viewComponent:setShipVOs(var5_18:getRawData())
	elseif GAME.BUILD_SHIP_BLUEPRINT_DONE == var0_18 then
		arg0_18.viewComponent:buildStartAni("researchStartWindow")
	elseif var0_18 == GAME.BEGIN_STAGE_DONE then
		arg0_18:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_18)
	elseif var0_18 == GAME.MOD_BLUEPRINT_ANIM_LOCK then
		arg0_18.viewComponent.noUpdateMod = true
	elseif var0_18 == GAME.PURSUING_RESET_DONE then
		-- block empty
	elseif var0_18 == GAME.QUICK_EXCHANGE_BLUEPRINT_DONE then
		arg0_18.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_18, function()
			arg0_18.viewComponent:updateShipBluePrintVO()
		end)
	end
end

return var0_0
