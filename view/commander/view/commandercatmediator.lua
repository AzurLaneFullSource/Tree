local var0_0 = class("CommanderCatMediator", import("view.base.ContextMediator"))

var0_0.RESERVE_BOX = "CommanderCatMediator:RESERVE_BOX"
var0_0.OPEN_HOME = "CommanderCatMediator:OPEN_HOME"
var0_0.ON_SELECT = "CommanderCatMediator:ON_SELECT"
var0_0.UPGRADE = "CommanderCatMediator:UPGRADE"
var0_0.LOCK = "CommanderCatMediator:LOCK"
var0_0.SKILL_INFO = "CommanderCatMediator:SKILL_INFO"
var0_0.RENAME = "CommanderCatMediator:RENAME"
var0_0.FETCH_NOT_LEARNED_TALENT = "CommanderCatMediator:FETCH_NOT_LEARNED_TALENT"
var0_0.LEARN_TALENT = "CommanderCatMediator:LEARN_TALENT"
var0_0.RESET_TALENT = "CommanderCatMediator:RESET_TALENT"
var0_0.BATCH_GET = "CommanderCatMediator:BATCH_GET"
var0_0.ONE_KEY = "CommanderCatMediator:ONE_KEY"
var0_0.BATCH_BUILD = "CommanderCatMediator:BATCH_BUILD"
var0_0.BUILD = "CommanderCatMediator:BUILD"
var0_0.GET = "CommanderCatMediator:GET"
var0_0.USE_QUICKLY_TOOL = "CommanderCatMediator:USE_QUICKLY_TOOL"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.USE_QUICKLY_TOOL, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.USE_ITEM, {
			id = arg1_2,
			count = arg2_2,
			arg = {
				arg3_2
			}
		})
	end)
	arg0_1:bind(var0_0.GET, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.COMMANDER_ON_OPEN_BOX, {
			id = arg1_3,
			callback = arg2_3
		})
	end)
	arg0_1:bind(var0_0.BUILD, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.COMMANDER_ON_BUILD, {
			tip = true,
			id = arg1_4,
			callback = arg2_4
		})
	end)
	arg0_1:bind(var0_0.BATCH_BUILD, function(arg0_5, arg1_5)
		local var0_5 = {}

		for iter0_5 = 1, #arg1_5 do
			local var1_5 = arg1_5[iter0_5]

			table.insert(var0_5, function(arg0_6)
				arg0_1:sendNotification(GAME.COMMANDER_ON_BUILD, {
					tip = false,
					id = var1_5,
					callback = arg0_6
				})
			end)
		end

		seriesAsync(var0_5, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_build_done"))
		end)
	end)
	arg0_1:bind(var0_0.ONE_KEY, function(arg0_8, arg1_8, arg2_8, arg3_8)
		arg0_1:sendNotification(GAME.COMMANDER_QUICKLY_FINISH_BOXES, {
			itemCnt = arg1_8,
			affectCnt = arg2_8,
			finishCnt = arg3_8
		})
	end)
	arg0_1:bind(var0_0.BATCH_GET, function(arg0_9, arg1_9)
		local var0_9 = {}

		for iter0_9, iter1_9 in pairs(arg1_9) do
			if iter1_9:getState() == CommanderBox.STATE_FINISHED then
				table.insert(var0_9, iter1_9.id)
			end
		end

		arg0_1:sendNotification(GAME.COMMANDER_ON_BATCH, {
			boxIds = var0_9
		})
	end)
	arg0_1:bind(var0_0.RESET_TALENT, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.COMMANDER_RESET_TALENTS, {
			id = arg1_10
		})
	end)
	arg0_1:bind(var0_0.LEARN_TALENT, function(arg0_11, arg1_11, arg2_11, arg3_11)
		arg0_1:sendNotification(GAME.COMMANDER_LEARN_TALENTS, {
			id = arg1_11,
			talentId = arg2_11,
			replaceid = arg3_11
		})
	end)
	arg0_1:bind(var0_0.FETCH_NOT_LEARNED_TALENT, function(arg0_12, arg1_12)
		arg0_1:sendNotification(GAME.COMMANDER_FETCH_NOT_LEARNED_TALENT, {
			id = arg1_12
		})
	end)
	arg0_1:bind(var0_0.RENAME, function(arg0_13, arg1_13, arg2_13)
		arg0_1:sendNotification(GAME.COMMANDER_RENAME, {
			commanderId = arg1_13,
			name = arg2_13
		})
	end)
	arg0_1:bind(var0_0.SKILL_INFO, function(arg0_14, arg1_14)
		arg0_1:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = NewCommanderSkillLayer,
			data = {
				skill = arg1_14
			}
		}))
	end)
	arg0_1:bind(var0_0.LOCK, function(arg0_15, arg1_15, arg2_15)
		arg0_1:sendNotification(GAME.COMMANDER_LOCK, {
			commanderId = arg1_15,
			flag = arg2_15
		})
	end)
	arg0_1:bind(var0_0.UPGRADE, function(arg0_16, arg1_16, arg2_16, arg3_16)
		arg0_1:sendNotification(GAME.COMMANDER_UPGRADE, {
			id = arg1_16,
			materialIds = arg2_16,
			skillId = arg3_16
		})
	end)
	arg0_1:bind(var0_0.ON_SELECT, function(arg0_17, arg1_17)
		arg0_1:addSubLayers(Context.New({
			mediator = ContextMediator,
			viewComponent = SelectCommanderCatForPlayScene,
			data = arg1_17
		}))
	end)
	arg0_1:bind(var0_0.RESERVE_BOX, function(arg0_18, arg1_18)
		arg0_1:sendNotification(GAME.COMMANDER_RESERVE_BOX, {
			count = arg1_18
		})
	end)
	arg0_1:bind(var0_0.OPEN_HOME, function(arg0_19)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CommanderHomeLayer,
			mediator = CommanderHomeMediator
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_20)
	return {
		GAME.COMMANDER_RESERVE_BOX_DONE,
		GAME.COMMANDER_QUICKLY_FINISH_BOXES_ERROR,
		GAME.COMMANDER_UPGRADE_DONE,
		GAME.COMMANDER_FETCH_NOT_LEARNED_TALENT_DONE,
		GAME.COMMANDER_LEARN_TALENTS_DONE,
		GAME.COMMANDER_LOCK_DONE,
		CommanderProxy.COMMANDER_UPDATED,
		CommanderProxy.COMMANDER_ADDED,
		CommanderProxy.COMMANDER_DELETED,
		GAME.COMMANDER_CATTERY_OP_DONE,
		GAME.ZERO_HOUR_OP_DONE,
		GAME.PUT_COMMANDER_IN_CATTERY_DONE,
		GAME.COMMANDER_ON_BUILD_DONE,
		GAME.REFRESH_COMMANDER_BOXES_DONE,
		GAME.COMMANDER_ON_OPEN_BOX_DONE,
		GAME.COMMANDER_ON_BATCH_DONE,
		PlayerProxy.UPDATED
	}
end

function var0_0.handleNotification(arg0_21, arg1_21)
	local var0_21 = arg1_21:getName()
	local var1_21 = arg1_21:getBody()

	if var0_21 == GAME.COMMANDER_RESERVE_BOX_DONE then
		arg0_21.viewComponent:emit(CommanderCatScene.MSG_RESERVE_BOX, var1_21.awards)
	elseif var0_21 == PlayerProxy.UPDATED then
		arg0_21.viewComponent:emit(CommanderCatScene.MSG_RES_UPDATE)
	elseif var0_21 == GAME.COMMANDER_QUICKLY_FINISH_BOXES_ERROR then
		arg0_21.viewComponent:emit(CommanderCatScene.MSG_QUICKLY_FINISH_TOOL_ERROR)
	elseif var0_21 == GAME.COMMANDER_UPGRADE_DONE then
		arg0_21.viewComponent:emit(CommanderCatScene.MSG_UPGRADE, var1_21.oldCommander, var1_21.commander)
	elseif var0_21 == GAME.COMMANDER_LOCK_DONE then
		if var1_21.flag == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_lock_done"))
		elseif var1_21.flag == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_unlock_done"))
		end
	elseif var0_21 == GAME.COMMANDER_RENAME_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_rename_success_tip"))
	elseif var0_21 == GAME.COMMANDER_FETCH_NOT_LEARNED_TALENT_DONE then
		arg0_21.viewComponent:emit(CommanderCatScene.MSG_FETCH_TALENT_LIST)
	elseif var0_21 == GAME.COMMANDER_LEARN_TALENTS_DONE then
		arg0_21.viewComponent:emit(CommanderCatScene.MSG_LEARN_TALENT)
	elseif var0_21 == CommanderProxy.COMMANDER_UPDATED or var0_21 == CommanderProxy.COMMANDER_ADDED or var0_21 == CommanderProxy.COMMANDER_DELETED then
		arg0_21.viewComponent:emit(CommanderCatScene.MSG_UPDATE)
	elseif var0_21 == GAME.COMMANDER_CATTERY_OP_DONE or var0_21 == GAME.ZERO_HOUR_OP_DONE or var0_21 == GAME.PUT_COMMANDER_IN_CATTERY_DONE then
		arg0_21.viewComponent:emit(CommanderCatScene.MSG_HOME_TIP)
	elseif var0_21 == GAME.COMMANDER_ON_BUILD_DONE or var0_21 == GAME.REFRESH_COMMANDER_BOXES_DONE then
		arg0_21.viewComponent:emit(CommanderCatScene.MSG_BUILD)
	elseif var0_21 == GAME.COMMANDER_ON_OPEN_BOX_DONE then
		pg.UIMgr.GetInstance():LoadingOn(false)
		seriesAsync({
			function(arg0_22)
				arg0_21.viewComponent:emit(CommanderCatScene.MSG_OPEN_BOX, var1_21.boxId, arg0_22)
			end,
			function(arg0_23)
				pg.UIMgr.GetInstance():LoadingOff()
				arg0_21:DisplayNewCommander(var1_21.commander, arg0_23)
			end,
			function()
				arg0_21.viewComponent:emit(CommanderCatScene.MSG_BUILD)
			end
		}, var1_21.callback)
	elseif var0_21 == GAME.COMMANDER_ON_BATCH_DONE then
		arg0_21:BatchDisplayCommander(var1_21.boxIds, var1_21.commanders)
	end
end

function var0_0.BatchDisplayCommander(arg0_25, arg1_25, arg2_25)
	local var0_25 = {}

	for iter0_25, iter1_25 in ipairs(arg1_25) do
		table.insert(var0_25, function(arg0_26)
			arg0_25.viewComponent:emit(CommanderCatScene.MSG_OPEN_BOX, iter1_25, arg0_26)
		end)
	end

	getProxy(CommanderProxy).hasSkipFlag = false

	pg.UIMgr.GetInstance():LoadingOn(false)
	parallelAsync(var0_25, function()
		pg.UIMgr.GetInstance():LoadingOff()

		local var0_27 = {}

		for iter0_27, iter1_27 in ipairs(arg2_25) do
			table.insert(var0_27, function(arg0_28)
				if getProxy(CommanderProxy).hasSkipFlag and not iter1_27:ShouldTipLock() then
					arg0_28()
				else
					arg0_25:DisplayNewCommander(iter1_27, arg0_28)
				end
			end)
		end

		seriesAsync(var0_27, function()
			arg0_25.viewComponent:emit(CommanderCatScene.MSG_BUILD)

			getProxy(CommanderProxy).hasSkipFlag = false

			arg0_25.viewComponent:emit(CommanderCatScene.MSG_BATCH_BUILD, arg2_25)
		end)
	end)
end

function var0_0.DisplayNewCommander(arg0_30, arg1_30, arg2_30)
	arg0_30:addSubLayers(Context.New({
		viewComponent = NewCommanderScene,
		mediator = NewCommanderMediator,
		data = {
			commander = arg1_30,
			onExit = arg2_30
		}
	}))
end

function var0_0.remove(arg0_31)
	if pg.ConnectionMgr.GetInstance():isConnected() then
		arg0_31:sendNotification(GAME.OPEN_OR_CLOSE_CATTERY, {
			open = false
		})
	end
end

return var0_0
