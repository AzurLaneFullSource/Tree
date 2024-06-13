local var0 = class("ActivityMediator", import("..base.ContextMediator"))

var0.EVENT_GO_SCENE = "event go scene"
var0.EVENT_OPERATION = "event operation"
var0.GO_SHOPS_LAYER = "event go shop layer"
var0.GO_SHOPS_LAYER_STEEET = "event go shop layer in shopstreet"
var0.BATTLE_OPERA = "event difficult sel"
var0.GO_BACKYARD = "event go backyard"
var0.GO_LOTTERY = "event go lottery"
var0.EVENT_COLORING_ACHIEVE = "event coloring achieve"
var0.ON_TASK_SUBMIT = "event on task submit"
var0.ON_TASK_SUBMIT_ONESTEP = "event on task submit one step"
var0.ON_TASK_GO = "event on task go"
var0.OPEN_LAYER = "event OPEN_LAYER"
var0.CLOSE_LAYER = "event CLOSE_LAYER"
var0.EVENT_PT_OPERATION = "event pt op"
var0.BLACKWHITEGRID = "black white grid"
var0.MEMORYBOOK = "memory book"
var0.RETURN_AWARD_OP = "event return award op"
var0.SHOW_AWARD_WINDOW = "event show award window"
var0.GO_DODGEM = "event go dodgem"
var0.GO_SUBMARINE_RUN = "event go sumbarine run"
var0.ON_SIMULATION_COMBAT = "event simulation combat"
var0.ON_AIRFIGHT_COMBAT = "event perform airfight combat"
var0.SPECIAL_BATTLE_OPERA = "special battle opera"
var0.NEXT_DISPLAY_AWARD = "next display awards"
var0.GO_PRAY_POOL = "go pray pool"
var0.SELECT_ACTIVITY = "event select activity"
var0.FETCH_INSTARGRAM = "fetch instagram"
var0.MUSIC_GAME_OPERATOR = "get music game final prize"
var0.SHOW_NEXT_ACTIVITY = "show next activity"
var0.OPEN_RED_PACKET_LAYER = "ActivityMediator:OPEN_RED_PACKET_LAYER"
var0.GO_MINI_GAME = "ActivityMediator.GO_MINI_GAME"
var0.GO_DECODE_MINI_GAME = "ActivityMediator:GO_DECODE_MINI_GAME"
var0.ON_BOBING_RESULT = "on bobing result"
var0.ACTIVITY_PERMANENT = "ActivityMediator.ACTIVITY_PERMANENT"
var0.FINISH_ACTIVITY_PERMANENT = "ActivityMediator.FINISH_ACTIVITY_PERMANENT"
var0.ON_SHAKE_BEADS_RESULT = "on shake beads result"
var0.GO_PERFORM_COMBAT = "ActivityMediator.GO_PERFORM_COMBAT"
var0.ON_AWARD_WINDOW = "ActivityMediator:ON_AWARD_WINDOW"
var0.GO_CARDPUZZLE_COMBAT = "ActivityMediator.GO_CARDPUZZLE_COMBAT"
var0.CHARGE = "ActivityMediator.CHARGE"
var0.BUY_ITEM = "ActivityMediator.BUY_ITEM"
var0.OPEN_CHARGE_ITEM_PANEL = "ActivityMediator.OPEN_CHARGE_ITEM_PANEL"
var0.OPEN_CHARGE_BIRTHDAY = "ActivityMediator.OPEN_CHARGE_BIRTHDAY"
var0.STORE_DATE = "ActivityMediator.STORE_DATE"
var0.ON_ACT_SHOPPING = "ActivityMediator.ON_ACT_SHOPPING"

function var0.register(arg0)
	arg0.UIAvalibleCallbacks = {}

	arg0:bind(var0.ON_AWARD_WINDOW, function(arg0, arg1, arg2, arg3)
		arg0.viewComponent:ShowAwardWindow(arg1, arg2, arg3)
	end)
	arg0:bind(var0.GO_DECODE_MINI_GAME, function(arg0)
		pg.m02:sendNotification(GAME.REQUEST_MINI_GAME, {
			type = MiniGameRequestCommand.REQUEST_HUB_DATA,
			callback = function()
				pg.m02:sendNotification(GAME.GO_MINI_GAME, 11)
			end
		})
	end)
	arg0:bind(var0.GO_MINI_GAME, function(arg0, arg1)
		pg.m02:sendNotification(GAME.GO_MINI_GAME, arg1)
	end)
	arg0:bind(var0.GO_SUBMARINE_RUN, function(arg0, arg1)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SUBMARINE_RUN,
			stageId = arg1
		})
	end)
	arg0:bind(var0.GO_DODGEM, function(arg0)
		local var0 = ys.Battle.BattleConfig.BATTLE_DODGEM_STAGES[math.random(#ys.Battle.BattleConfig.BATTLE_DODGEM_STAGES)]

		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_DODGEM,
			stageId = var0
		})
	end)
	arg0:bind(var0.ON_SIMULATION_COMBAT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SIMULATION,
			stageId = arg1.stageId,
			warnMsg = arg1.warnMsg,
			exitCallback = arg2
		})
	end)
	arg0:bind(var0.ON_AIRFIGHT_COMBAT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_AIRFIGHT,
			stageId = arg1.stageId,
			exitCallback = arg2
		})
	end)
	arg0:bind(var0.RETURN_AWARD_OP, function(arg0, arg1)
		if arg1.cmd == ActivityConst.RETURN_AWARD_OP_SHOW_AWARD_OVERVIEW then
			arg0.viewComponent:ShowWindow(ReturnerAwardWindow, arg1.arg1)
		elseif arg1.cmd == ActivityConst.RETURN_AWARD_OP_SHOW_RETURNER_AWARD_OVERVIEW then
			arg0.viewComponent:ShowWindow(TaskAwardWindow, arg1.arg1)
		else
			arg0:sendNotification(GAME.RETURN_AWARD_OP, arg1)
		end
	end)
	arg0:bind(var0.SHOW_AWARD_WINDOW, function(arg0, arg1, arg2)
		arg0.viewComponent:ShowWindow(arg1, arg2)
	end)
	arg0:bind(var0.EVENT_PT_OPERATION, function(arg0, arg1)
		arg0:sendNotification(GAME.ACT_NEW_PT, arg1)
	end)
	arg0:bind(var0.OPEN_LAYER, function(arg0, arg1)
		arg0:addSubLayers(arg1)
	end)
	arg0:bind(var0.OPEN_RED_PACKET_LAYER, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer
		}))
	end)
	arg0:bind(var0.CLOSE_LAYER, function(arg0, arg1)
		local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg1)

		if var0 then
			arg0:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0
			})
		end
	end)
	arg0:bind(var0.EVENT_OPERATION, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, arg1)
	end)
	arg0:bind(var0.EVENT_GO_SCENE, function(arg0, arg1, arg2)
		if arg1 == SCENE.SUMMER_FEAST then
			pg.NewStoryMgr.GetInstance():Play("TIANHOUYUYI1", function()
				arg0:sendNotification(GAME.GO_SCENE, SCENE.SUMMER_FEAST)
			end)
		else
			arg0:sendNotification(GAME.GO_SCENE, arg1, arg2)
		end
	end)
	arg0:bind(var0.BLACKWHITEGRID, function()
		if not getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLACKWHITE) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0:addSubLayers(Context.New({
			viewComponent = BlackWhiteGridLayer,
			mediator = BlackWhiteGridMediator
		}))
	end)
	arg0:bind(var0.MEMORYBOOK, function()
		if not getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0:addSubLayers(Context.New({
			viewComponent = MemoryBookLayer,
			mediator = MemoryBookMediator
		}))
	end)
	arg0:bind(var0.GO_SHOPS_LAYER, function(arg0, arg1)
		if not getProxy(ActivityProxy):getActivityById(arg1.actId) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1 or {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0:bind(var0.GO_SHOPS_LAYER_STEEET, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1 or {
			warp = NewShopsScene.TYPE_SHOP_STREET
		})
	end)
	arg0:bind(var0.BATTLE_OPERA, function()
		local var0 = getProxy(ChapterProxy)
		local var1, var2 = var0:getLastMapForActivity()

		if not var1 or not var0:getMapById(var1):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2,
				mapIdx = var1
			})
		end
	end)
	arg0:bind(var0.SPECIAL_BATTLE_OPERA, function()
		local var0 = getProxy(ChapterProxy)
		local var1, var2 = var0:getLastMapForActivity()

		if not var1 or not var0:getMapById(var1):isUnlock() then
			local var3 = getProxy(ChapterProxy)
			local var4 = var3:getActiveChapter()

			var1 = var4 and var4:getConfig("map")

			if not var4 then
				local var5 = Map.lastMap and var3:getMapById(Map.lastMap)

				if var5 and var5:isUnlock() then
					var1 = Map.lastMap
				else
					var1 = var3:getLastUnlockMap().id
				end
			end

			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var4 and var4.id,
				mapIdx = var1
			})
		else
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2,
				mapIdx = var1
			})
		end
	end)
	arg0:bind(var0.GO_LOTTERY, function(arg0)
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

		arg0:addSubLayers(Context.New({
			mediator = LotteryMediator,
			viewComponent = LotteryLayer,
			data = {
				activityId = var0.id
			}
		}))
	end)
	arg0:bind(var0.GO_BACKYARD, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD)
	end)
	arg0:bind(var0.EVENT_COLORING_ACHIEVE, function(arg0, arg1)
		arg0:sendNotification(GAME.COLORING_ACHIEVE, arg1)
	end)
	arg0:bind(var0.ON_TASK_SUBMIT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SUBMIT_TASK, arg1.id, arg2)
	end)
	arg0:bind(var0.ON_TASK_SUBMIT_ONESTEP, function(arg0, arg1)
		arg0:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg1
		})
	end)
	arg0:bind(var0.ON_TASK_GO, function(arg0, arg1)
		arg0:sendNotification(GAME.TASK_GO, {
			taskVO = arg1
		})
	end)
	arg0:bind(var0.GO_PRAY_POOL, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT, {
			goToPray = true
		})
	end)
	arg0:bind(var0.FETCH_INSTARGRAM, function(arg0, ...)
		arg0:sendNotification(GAME.ACT_INSTAGRAM_FETCH, ...)
	end)
	arg0:bind(var0.MUSIC_GAME_OPERATOR, function(arg0, ...)
		arg0:sendNotification(GAME.SEND_MINI_GAME_OP, ...)
	end)
	arg0:bind(var0.SELECT_ACTIVITY, function(arg0, arg1)
		arg0.viewComponent:verifyTabs(arg1)
	end)
	arg0:bind(var0.SHOW_NEXT_ACTIVITY, function(arg0)
		arg0:showNextActivity()
	end)
	arg0:bind(var0.ACTIVITY_PERMANENT, function(arg0, arg1)
		if PlayerPrefs.GetString("permanent_time", "") ~= pg.gameset.permanent_mark.description then
			PlayerPrefs.SetString("permanent_time", pg.gameset.permanent_mark.description)
			arg0.viewComponent:updateEntrances()
		end

		local var0 = getProxy(ActivityPermanentProxy):getDoingActivity()

		if var0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("activity_permanent_tips3"))
			arg0.viewComponent:verifyTabs(var0.id)
		else
			arg0:addSubLayers(Context.New({
				mediator = ActivityPermanentMediator,
				viewComponent = ActivityPermanentLayer,
				data = {
					finishId = arg1
				}
			}))
		end
	end)
	arg0:bind(var0.FINISH_ACTIVITY_PERMANENT, function(arg0)
		local var0 = getProxy(ActivityPermanentProxy):getDoingActivity()

		assert(var0:canPermanentFinish(), "error permanent activity finish")
		arg0:sendNotification(GAME.ACTIVITY_PERMANENT_FINISH, {
			activity_id = var0.id
		})
	end)
	arg0:bind(var0.GO_PERFORM_COMBAT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1.stageId,
			memory = arg1.memory
		})
	end)
	arg0:bind(var0.NEXT_DISPLAY_AWARD, function(arg0, arg1, arg2)
		arg0.nextDisplayAwards = arg1
	end)
	arg0:bind(var0.GO_CARDPUZZLE_COMBAT, function(arg0, arg1)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_CARDPUZZLE,
			combatID = arg1
		})
	end)
	arg0:bind(var0.CHARGE, function(arg0, arg1)
		arg0:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg1
		})
	end)
	arg0:bind(var0.BUY_ITEM, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SHOPPING, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.OPEN_CHARGE_ITEM_PANEL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1
			}
		}))
	end)
	arg0:bind(var0.OPEN_CHARGE_BIRTHDAY, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
	arg0:bind(var0.STORE_DATE, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_STORE_DATE, {
			activity_id = arg1.actId,
			intValue = arg1.intValue or 0,
			strValue = arg1.strValue or "",
			callback = arg1.callback
		})
	end)
	arg0:bind(var0.ON_ACT_SHOPPING, function(arg0, arg1, arg2, arg3, arg4)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = arg1,
			cmd = arg2,
			arg1 = arg3,
			arg2 = arg4
		})
	end)

	local var0 = getProxy(ActivityProxy)

	arg0.viewComponent:setActivities(var0:getPanelActivities())

	local var1 = getProxy(PlayerProxy):getRawData()

	arg0.viewComponent:setPlayer(var1)

	local var2 = getProxy(BayProxy):getShipById(var1.character)

	arg0.viewComponent:setFlagShip(var2)
end

function var0.onUIAvalible(arg0)
	arg0.UIAvalible = true

	_.each(arg0.UIAvalibleCallbacks, function(arg0)
		arg0()
	end)
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {
		[ActivityProxy.ACTIVITY_ADDED] = function(arg0, arg1)
			local var0 = arg1:getBody()

			if var0:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY then
				return
			end

			arg0.viewComponent:updateActivity(var0)

			if ActivityConst.AOERLIANG_TASK_ID == var0.id then
				arg0.viewComponent:update_task_list_auto_aoerliang(var0)
			end
		end,
		[ActivityProxy.ACTIVITY_UPDATED] = function(...)
			arg0.handleDic[ActivityProxy.ACTIVITY_ADDED](...)
		end,
		[ActivityProxy.ACTIVITY_DELETED] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:removeActivity(var0)
		end,
		[ActivityProxy.ACTIVITY_OPERATION_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			if ActivityConst.AOERLIANG_TASK_ID == var0 then
				return
			end

			if ActivityConst.HOLOLIVE_MORNING_ID == var0 then
				local var1 = arg0.viewComponent.pageDic[ActivityConst.HOLOLIVE_MORNING_ID]
			end

			arg0:showNextActivity()
		end,
		[ActivityProxy.ACTIVITY_SHOW_AWARDS] = function(arg0, arg1)
			local var0 = arg1:getBody()
			local var1 = var0.awards

			if arg0.nextDisplayAwards and #arg0.nextDisplayAwards > 0 then
				for iter0 = 1, #arg0.nextDisplayAwards do
					table.insert(var1, arg0.nextDisplayAwards[iter0])
				end
			end

			arg0.nextDisplayAwards = {}

			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, var0.callback)
		end,
		[ActivityProxy.ACTIVITY_SHOW_BB_RESULT] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:emit(ActivityMediator.ON_BOBING_RESULT, var0)
		end,
		[ActivityProxy.ACTIVITY_SHOW_LOTTERY_AWARD_RESULT] = function(arg0, arg1)
			local var0 = arg1:getBody()
			local var1 = var0.activityID

			arg0.viewComponent.pageDic[var1]:showLotteryAwardResult(var0.awards, var0.number, var0.callback)
		end,
		[ActivityProxy.ACTIVITY_SHOW_SHAKE_BEADS_RESULT] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:emit(ActivityMediator.ON_SHAKE_BEADS_RESULT, var0)
		end,
		[GAME.COLORING_ACHIEVE_DONE] = function(arg0, arg1)
			arg0.viewComponent:playBonusAnim(function()
				local var0 = arg1:getBody()

				arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0.drops, function()
					arg0.viewComponent:flush_coloring()
				end)
			end)
		end,
		[GAME.SUBMIT_TASK_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0, function()
				arg0.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.ACT_NEW_PT_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0.awards, var0.callback)
		end,
		[GAME.BEGIN_STAGE_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var0)
		end,
		[GAME.RETURN_AWARD_OP_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0.awards)
		end,
		[VoteProxy.VOTE_ORDER_BOOK_DELETE] = function(arg0, arg1)
			return
		end,
		[VoteProxy.VOTE_ORDER_BOOK_UPDATE] = function(...)
			arg0.handleDic[VoteProxy.VOTE_ORDER_BOOK_DELETE](...)
		end,
		[GAME.REMOVE_LAYERS] = function(arg0, arg1)
			if arg1:getBody().context.mediator == VoteFameHallMediator then
				arg0.viewComponent:updateEntrances()
			end

			arg0.viewComponent:removeLayers()
		end,
		[GAME.MONOPOLY_AWARD_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()
			local var1 = arg0.viewComponent.pageDic[arg0.viewComponent.activity.id]

			if var1 and var1.activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MONOPOLY and var1.onAward then
				var1:onAward(var0.awards, var0.callback)
			else
				arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0.awards, var0.callback)
			end
		end,
		[GAME.SEND_MINI_GAME_OP_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()
			local var1 = {
				function(arg0)
					local var0 = var0.awards

					if #var0 > 0 then
						if arg0.viewComponent then
							arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0, arg0)
						else
							arg0:emit(BaseUI.ON_ACHIEVE, var0, arg0)
						end
					else
						arg0()
					end
				end
			}

			seriesAsync(var1, function()
				arg0.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.ACTIVITY_PERMANENT_START_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:verifyTabs(var0.id)
		end,
		[GAME.ACTIVITY_PERMANENT_FINISH_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:emit(ActivityMediator.ACTIVITY_PERMANENT, var0.activity_id)
		end,
		[GAME.MEMORYBOOK_UNLOCK_AWARD_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0.awards)
		end,
		[GAME.LOAD_LAYERS] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:loadLayers()
		end,
		[GAME.CHARGE_SUCCESS] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:updateTaskLayers()

			local var1 = Goods.Create({
				shop_id = var0.shopId
			}, Goods.TYPE_CHARGE)

			arg0.viewComponent:OnChargeSuccess(var1)
		end,
		[GAME.SHOPPING_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0.awards, function()
				arg0.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.ACT_MANUAL_SIGN_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0.awards)
		end,
		[ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0.awards, function()
				local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE)

				if var0 and not var0:isShow() then
					arg0.viewComponent:removeActivity(var0.id)
				end

				arg0.viewComponent:updateTaskLayers()
				var0.callback()
			end)
		end
	}
end

function var0.showNextActivity(arg0)
	local var0 = getProxy(ActivityProxy)

	if not var0 then
		return
	end

	local var1 = var0:findNextAutoActivity()

	if var1 then
		if var1.id == ActivityConst.BLACK_FRIDAY_SIGNIN_ACT_ID then
			arg0.contextData.showByNextAct = true

			arg0.viewComponent:verifyTabs(ActivityConst.BLACK_FRIDAY_ACT_ID)
		else
			arg0.viewComponent:verifyTabs(var1.id)
		end

		local var2 = var1:getConfig("type")

		if var2 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
			arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = var1.id
			})
		elseif var2 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
			local var3 = var1:getSpecialData("reMonthSignDay") ~= nil and 3 or 1

			arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = var1.id,
				cmd = var3,
				arg1 = var1:getSpecialData("reMonthSignDay")
			})
		elseif var2 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
			arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = var1.id,
				cmd = var1.data1 < 7 and 1 or 2
			})
		elseif var1.id == ActivityConst.SHADOW_PLAY_ID then
			var1.clientData1 = 1

			arg0:showNextActivity()
		end
	elseif not arg0.viewComponent.activity then
		local var4 = var0:getPanelActivities()
		local var5 = arg0.contextData.id or arg0.contextData.type and checkExist(_.detect(var4, function(arg0)
			return arg0:getConfig("type") == arg0.contextData.type
		end), {
			"id"
		}) or 0

		arg0.viewComponent:verifyTabs(var5)
	end
end

return var0
