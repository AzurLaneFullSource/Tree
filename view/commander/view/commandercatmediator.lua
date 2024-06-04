local var0 = class("CommanderCatMediator", import("view.base.ContextMediator"))

var0.RESERVE_BOX = "CommanderCatMediator:RESERVE_BOX"
var0.OPEN_HOME = "CommanderCatMediator:OPEN_HOME"
var0.ON_SELECT = "CommanderCatMediator:ON_SELECT"
var0.UPGRADE = "CommanderCatMediator:UPGRADE"
var0.LOCK = "CommanderCatMediator:LOCK"
var0.SKILL_INFO = "CommanderCatMediator:SKILL_INFO"
var0.RENAME = "CommanderCatMediator:RENAME"
var0.FETCH_NOT_LEARNED_TALENT = "CommanderCatMediator:FETCH_NOT_LEARNED_TALENT"
var0.LEARN_TALENT = "CommanderCatMediator:LEARN_TALENT"
var0.RESET_TALENT = "CommanderCatMediator:RESET_TALENT"
var0.BATCH_GET = "CommanderCatMediator:BATCH_GET"
var0.ONE_KEY = "CommanderCatMediator:ONE_KEY"
var0.BATCH_BUILD = "CommanderCatMediator:BATCH_BUILD"
var0.BUILD = "CommanderCatMediator:BUILD"
var0.GET = "CommanderCatMediator:GET"
var0.USE_QUICKLY_TOOL = "CommanderCatMediator:USE_QUICKLY_TOOL"

function var0.register(arg0)
	arg0:bind(var0.USE_QUICKLY_TOOL, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.USE_ITEM, {
			id = arg1,
			count = arg2,
			arg = {
				arg3
			}
		})
	end)
	arg0:bind(var0.GET, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.COMMANDER_ON_OPEN_BOX, {
			id = arg1,
			callback = arg2
		})
	end)
	arg0:bind(var0.BUILD, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.COMMANDER_ON_BUILD, {
			tip = true,
			id = arg1,
			callback = arg2
		})
	end)
	arg0:bind(var0.BATCH_BUILD, function(arg0, arg1)
		local var0 = {}

		for iter0 = 1, #arg1 do
			local var1 = arg1[iter0]

			table.insert(var0, function(arg0)
				arg0:sendNotification(GAME.COMMANDER_ON_BUILD, {
					tip = false,
					id = var1,
					callback = arg0
				})
			end)
		end

		seriesAsync(var0, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_build_done"))
		end)
	end)
	arg0:bind(var0.ONE_KEY, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.COMMANDER_QUICKLY_FINISH_BOXES, {
			itemCnt = arg1,
			affectCnt = arg2,
			finishCnt = arg3
		})
	end)
	arg0:bind(var0.BATCH_GET, function(arg0, arg1)
		local var0 = {}

		for iter0, iter1 in pairs(arg1) do
			if iter1:getState() == CommanderBox.STATE_FINISHED then
				table.insert(var0, iter1.id)
			end
		end

		arg0:sendNotification(GAME.COMMANDER_ON_BATCH, {
			boxIds = var0
		})
	end)
	arg0:bind(var0.RESET_TALENT, function(arg0, arg1)
		arg0:sendNotification(GAME.COMMANDER_RESET_TALENTS, {
			id = arg1
		})
	end)
	arg0:bind(var0.LEARN_TALENT, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.COMMANDER_LEARN_TALENTS, {
			id = arg1,
			talentId = arg2,
			replaceid = arg3
		})
	end)
	arg0:bind(var0.FETCH_NOT_LEARNED_TALENT, function(arg0, arg1)
		arg0:sendNotification(GAME.COMMANDER_FETCH_NOT_LEARNED_TALENT, {
			id = arg1
		})
	end)
	arg0:bind(var0.RENAME, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.COMMANDER_RENAME, {
			commanderId = arg1,
			name = arg2
		})
	end)
	arg0:bind(var0.SKILL_INFO, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = NewCommanderSkillLayer,
			data = {
				skill = arg1
			}
		}))
	end)
	arg0:bind(var0.LOCK, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.COMMANDER_LOCK, {
			commanderId = arg1,
			flag = arg2
		})
	end)
	arg0:bind(var0.UPGRADE, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.COMMANDER_UPGRADE, {
			id = arg1,
			materialIds = arg2,
			skillId = arg3
		})
	end)
	arg0:bind(var0.ON_SELECT, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ContextMediator,
			viewComponent = SelectCommanderCatForPlayScene,
			data = arg1
		}))
	end)
	arg0:bind(var0.RESERVE_BOX, function(arg0, arg1)
		arg0:sendNotification(GAME.COMMANDER_RESERVE_BOX, {
			count = arg1
		})
	end)
	arg0:bind(var0.OPEN_HOME, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = CommanderHomeLayer,
			mediator = CommanderHomeMediator
		}))
	end)
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.COMMANDER_RESERVE_BOX_DONE then
		arg0.viewComponent:emit(CommanderCatScene.MSG_RESERVE_BOX, var1.awards)
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:emit(CommanderCatScene.MSG_RES_UPDATE)
	elseif var0 == GAME.COMMANDER_QUICKLY_FINISH_BOXES_ERROR then
		arg0.viewComponent:emit(CommanderCatScene.MSG_QUICKLY_FINISH_TOOL_ERROR)
	elseif var0 == GAME.COMMANDER_UPGRADE_DONE then
		arg0.viewComponent:emit(CommanderCatScene.MSG_UPGRADE, var1.oldCommander, var1.commander)
	elseif var0 == GAME.COMMANDER_LOCK_DONE then
		if var1.flag == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_lock_done"))
		elseif var1.flag == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_unlock_done"))
		end
	elseif var0 == GAME.COMMANDER_RENAME_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_rename_success_tip"))
	elseif var0 == GAME.COMMANDER_FETCH_NOT_LEARNED_TALENT_DONE then
		arg0.viewComponent:emit(CommanderCatScene.MSG_FETCH_TALENT_LIST)
	elseif var0 == GAME.COMMANDER_LEARN_TALENTS_DONE then
		arg0.viewComponent:emit(CommanderCatScene.MSG_LEARN_TALENT)
	elseif var0 == CommanderProxy.COMMANDER_UPDATED or var0 == CommanderProxy.COMMANDER_ADDED or var0 == CommanderProxy.COMMANDER_DELETED then
		arg0.viewComponent:emit(CommanderCatScene.MSG_UPDATE)
	elseif var0 == GAME.COMMANDER_CATTERY_OP_DONE or var0 == GAME.ZERO_HOUR_OP_DONE or var0 == GAME.PUT_COMMANDER_IN_CATTERY_DONE then
		arg0.viewComponent:emit(CommanderCatScene.MSG_HOME_TIP)
	elseif var0 == GAME.COMMANDER_ON_BUILD_DONE or var0 == GAME.REFRESH_COMMANDER_BOXES_DONE then
		arg0.viewComponent:emit(CommanderCatScene.MSG_BUILD)
	elseif var0 == GAME.COMMANDER_ON_OPEN_BOX_DONE then
		pg.UIMgr.GetInstance():LoadingOn(false)
		seriesAsync({
			function(arg0)
				arg0.viewComponent:emit(CommanderCatScene.MSG_OPEN_BOX, var1.boxId, arg0)
			end,
			function(arg0)
				pg.UIMgr.GetInstance():LoadingOff()
				arg0:DisplayNewCommander(var1.commander, arg0)
			end,
			function()
				arg0.viewComponent:emit(CommanderCatScene.MSG_BUILD)
			end
		}, var1.callback)
	elseif var0 == GAME.COMMANDER_ON_BATCH_DONE then
		arg0:BatchDisplayCommander(var1.boxIds, var1.commanders)
	end
end

function var0.BatchDisplayCommander(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		table.insert(var0, function(arg0)
			arg0.viewComponent:emit(CommanderCatScene.MSG_OPEN_BOX, iter1, arg0)
		end)
	end

	getProxy(CommanderProxy).hasSkipFlag = false

	pg.UIMgr.GetInstance():LoadingOn(false)
	parallelAsync(var0, function()
		pg.UIMgr.GetInstance():LoadingOff()

		local var0 = {}

		for iter0, iter1 in ipairs(arg2) do
			table.insert(var0, function(arg0)
				if getProxy(CommanderProxy).hasSkipFlag and not iter1:ShouldTipLock() then
					arg0()
				else
					arg0:DisplayNewCommander(iter1, arg0)
				end
			end)
		end

		seriesAsync(var0, function()
			arg0.viewComponent:emit(CommanderCatScene.MSG_BUILD)

			getProxy(CommanderProxy).hasSkipFlag = false

			arg0.viewComponent:emit(CommanderCatScene.MSG_BATCH_BUILD, arg2)
		end)
	end)
end

function var0.DisplayNewCommander(arg0, arg1, arg2)
	arg0:addSubLayers(Context.New({
		viewComponent = NewCommanderScene,
		mediator = NewCommanderMediator,
		data = {
			commander = arg1,
			onExit = arg2
		}
	}))
end

function var0.remove(arg0)
	if pg.ConnectionMgr.GetInstance():isConnected() then
		arg0:sendNotification(GAME.OPEN_OR_CLOSE_CATTERY, {
			open = false
		})
	end
end

return var0
