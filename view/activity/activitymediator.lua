local var0_0 = class("ActivityMediator", import("..base.ContextMediator"))

var0_0.EVENT_GO_SCENE = "event go scene"
var0_0.EVENT_OPERATION = "event operation"
var0_0.GO_SHOPS_LAYER = "event go shop layer"
var0_0.GO_SHOPS_LAYER_STEEET = "event go shop layer in shopstreet"
var0_0.BATTLE_OPERA = "event difficult sel"
var0_0.GO_BACKYARD = "event go backyard"
var0_0.GO_LOTTERY = "event go lottery"
var0_0.EVENT_COLORING_ACHIEVE = "event coloring achieve"
var0_0.ON_TASK_SUBMIT = "event on task submit"
var0_0.ON_TASK_SUBMIT_ONESTEP = "event on task submit one step"
var0_0.ON_TASK_GO = "event on task go"
var0_0.OPEN_LAYER = "event OPEN_LAYER"
var0_0.CLOSE_LAYER = "event CLOSE_LAYER"
var0_0.EVENT_PT_OPERATION = "event pt op"
var0_0.BLACKWHITEGRID = "black white grid"
var0_0.MEMORYBOOK = "memory book"
var0_0.RETURN_AWARD_OP = "event return award op"
var0_0.SHOW_AWARD_WINDOW = "event show award window"
var0_0.GO_DODGEM = "event go dodgem"
var0_0.GO_SUBMARINE_RUN = "event go sumbarine run"
var0_0.ON_SIMULATION_COMBAT = "event simulation combat"
var0_0.ON_AIRFIGHT_COMBAT = "event perform airfight combat"
var0_0.SPECIAL_BATTLE_OPERA = "special battle opera"
var0_0.NEXT_DISPLAY_AWARD = "next display awards"
var0_0.GO_PRAY_POOL = "go pray pool"
var0_0.SELECT_ACTIVITY = "event select activity"
var0_0.FETCH_INSTARGRAM = "fetch instagram"
var0_0.MUSIC_GAME_OPERATOR = "get music game final prize"
var0_0.SHOW_NEXT_ACTIVITY = "show next activity"
var0_0.OPEN_RED_PACKET_LAYER = "ActivityMediator:OPEN_RED_PACKET_LAYER"
var0_0.GO_MINI_GAME = "ActivityMediator.GO_MINI_GAME"
var0_0.GO_DECODE_MINI_GAME = "ActivityMediator:GO_DECODE_MINI_GAME"
var0_0.ON_BOBING_RESULT = "on bobing result"
var0_0.ACTIVITY_PERMANENT = "ActivityMediator.ACTIVITY_PERMANENT"
var0_0.FINISH_ACTIVITY_PERMANENT = "ActivityMediator.FINISH_ACTIVITY_PERMANENT"
var0_0.ON_SHAKE_BEADS_RESULT = "on shake beads result"
var0_0.GO_PERFORM_COMBAT = "ActivityMediator.GO_PERFORM_COMBAT"
var0_0.ON_AWARD_WINDOW = "ActivityMediator:ON_AWARD_WINDOW"
var0_0.GO_CARDPUZZLE_COMBAT = "ActivityMediator.GO_CARDPUZZLE_COMBAT"
var0_0.CHARGE = "ActivityMediator.CHARGE"
var0_0.BUY_ITEM = "ActivityMediator.BUY_ITEM"
var0_0.OPEN_CHARGE_ITEM_PANEL = "ActivityMediator.OPEN_CHARGE_ITEM_PANEL"
var0_0.OPEN_CHARGE_BIRTHDAY = "ActivityMediator.OPEN_CHARGE_BIRTHDAY"
var0_0.STORE_DATE = "ActivityMediator.STORE_DATE"
var0_0.ON_ACT_SHOPPING = "ActivityMediator.ON_ACT_SHOPPING"
var0_0.GO_MONOPOLY2024 = "ActivityMediator:GO_MONOPOLY2024"
var0_0.ON_ACTIVITY_TASK_SUBMIT = "ActivityMediator.ON_ACTIVITY_TASK_SUBMIT"

function var0_0.register(arg0_1)
	arg0_1.UIAvalibleCallbacks = {}

	arg0_1:bind(var0_0.GO_MONOPOLY2024, function(arg0_2, arg1_2, arg2_2)
		arg0_1:addSubLayers(Context.New({
			mediator = MonopolyCar2024Mediator,
			viewComponent = MonopolyCar2024Scene,
			data = {
				actId = arg1_2
			},
			onRemoved = arg2_2
		}))
	end)
	arg0_1:bind(var0_0.ON_AWARD_WINDOW, function(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_1.viewComponent:ShowAwardWindow(arg1_3, arg2_3, arg3_3)
	end)
	arg0_1:bind(var0_0.GO_DECODE_MINI_GAME, function(arg0_4)
		pg.m02:sendNotification(GAME.REQUEST_MINI_GAME, {
			type = MiniGameRequestCommand.REQUEST_HUB_DATA,
			callback = function()
				pg.m02:sendNotification(GAME.GO_MINI_GAME, 11)
			end
		})
	end)
	arg0_1:bind(var0_0.GO_MINI_GAME, function(arg0_6, arg1_6)
		pg.m02:sendNotification(GAME.GO_MINI_GAME, arg1_6)
	end)
	arg0_1:bind(var0_0.GO_SUBMARINE_RUN, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SUBMARINE_RUN,
			stageId = arg1_7
		})
	end)
	arg0_1:bind(var0_0.GO_DODGEM, function(arg0_8)
		local var0_8 = ys.Battle.BattleConfig.BATTLE_DODGEM_STAGES[math.random(#ys.Battle.BattleConfig.BATTLE_DODGEM_STAGES)]

		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_DODGEM,
			stageId = var0_8
		})
	end)
	arg0_1:bind(var0_0.ON_SIMULATION_COMBAT, function(arg0_9, arg1_9, arg2_9)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SIMULATION,
			stageId = arg1_9.stageId,
			warnMsg = arg1_9.warnMsg,
			exitCallback = arg2_9
		})
	end)
	arg0_1:bind(var0_0.ON_AIRFIGHT_COMBAT, function(arg0_10, arg1_10, arg2_10)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_AIRFIGHT,
			stageId = arg1_10.stageId,
			exitCallback = arg2_10
		})
	end)
	arg0_1:bind(var0_0.RETURN_AWARD_OP, function(arg0_11, arg1_11)
		if arg1_11.cmd == ActivityConst.RETURN_AWARD_OP_SHOW_AWARD_OVERVIEW then
			arg0_1.viewComponent:ShowWindow(ReturnerAwardWindow, arg1_11.arg1)
		elseif arg1_11.cmd == ActivityConst.RETURN_AWARD_OP_SHOW_RETURNER_AWARD_OVERVIEW then
			arg0_1.viewComponent:ShowWindow(TaskAwardWindow, arg1_11.arg1)
		else
			arg0_1:sendNotification(GAME.RETURN_AWARD_OP, arg1_11)
		end
	end)
	arg0_1:bind(var0_0.SHOW_AWARD_WINDOW, function(arg0_12, arg1_12, arg2_12)
		arg0_1.viewComponent:ShowWindow(arg1_12, arg2_12)
	end)
	arg0_1:bind(var0_0.EVENT_PT_OPERATION, function(arg0_13, arg1_13)
		arg0_1:sendNotification(GAME.ACT_NEW_PT, arg1_13)
	end)
	arg0_1:bind(var0_0.OPEN_LAYER, function(arg0_14, arg1_14)
		arg0_1:addSubLayers(arg1_14)
	end)
	arg0_1:bind(var0_0.OPEN_RED_PACKET_LAYER, function(arg0_15)
		arg0_1:addSubLayers(Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_LAYER, function(arg0_16, arg1_16)
		local var0_16 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg1_16)

		if var0_16 then
			arg0_1:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_16
			})
		end
	end)
	arg0_1:bind(var0_0.EVENT_OPERATION, function(arg0_17, arg1_17)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_17)
	end)
	arg0_1:bind(var0_0.EVENT_GO_SCENE, function(arg0_18, arg1_18, arg2_18)
		if arg1_18 == SCENE.SUMMER_FEAST then
			pg.NewStoryMgr.GetInstance():Play("TIANHOUYUYI1", function()
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SUMMER_FEAST)
			end)
		else
			arg0_1:sendNotification(GAME.GO_SCENE, arg1_18, arg2_18)
		end
	end)
	arg0_1:bind(var0_0.BLACKWHITEGRID, function()
		if not getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLACKWHITE) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_1:addSubLayers(Context.New({
			viewComponent = BlackWhiteGridLayer,
			mediator = BlackWhiteGridMediator
		}))
	end)
	arg0_1:bind(var0_0.MEMORYBOOK, function()
		if not getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_1:addSubLayers(Context.New({
			viewComponent = MemoryBookLayer,
			mediator = MemoryBookMediator
		}))
	end)
	arg0_1:bind(var0_0.GO_SHOPS_LAYER, function(arg0_22, arg1_22)
		if not getProxy(ActivityProxy):getActivityById(arg1_22.actId) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1_22 or {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0_1:bind(var0_0.GO_SHOPS_LAYER_STEEET, function(arg0_23, arg1_23)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1_23 or {
			warp = NewShopsScene.TYPE_SHOP_STREET
		})
	end)
	arg0_1:bind(var0_0.BATTLE_OPERA, function()
		local var0_24 = getProxy(ChapterProxy)
		local var1_24, var2_24 = var0_24:getLastMapForActivity()

		if not var1_24 or not var0_24:getMapById(var1_24):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_24,
				mapIdx = var1_24
			})
		end
	end)
	arg0_1:bind(var0_0.SPECIAL_BATTLE_OPERA, function()
		local var0_25 = getProxy(ChapterProxy)
		local var1_25, var2_25 = var0_25:getLastMapForActivity()

		if not var1_25 or not var0_25:getMapById(var1_25):isUnlock() then
			local var3_25 = getProxy(ChapterProxy)
			local var4_25 = var3_25:getActiveChapter()

			var1_25 = var4_25 and var4_25:getConfig("map")

			if not var4_25 then
				local var5_25 = Map.lastMap and var3_25:getMapById(Map.lastMap)

				if var5_25 and var5_25:isUnlock() then
					var1_25 = Map.lastMap
				else
					var1_25 = var3_25:getLastUnlockMap().id
				end
			end

			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var4_25 and var4_25.id,
				mapIdx = var1_25
			})
		else
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_25,
				mapIdx = var1_25
			})
		end
	end)
	arg0_1:bind(var0_0.GO_LOTTERY, function(arg0_26)
		local var0_26 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

		arg0_1:addSubLayers(Context.New({
			mediator = LotteryMediator,
			viewComponent = LotteryLayer,
			data = {
				activityId = var0_26.id
			}
		}))
	end)
	arg0_1:bind(var0_0.GO_BACKYARD, function(arg0_27)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD)
	end)
	arg0_1:bind(var0_0.EVENT_COLORING_ACHIEVE, function(arg0_28, arg1_28)
		arg0_1:sendNotification(GAME.COLORING_ACHIEVE, arg1_28)
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_29, arg1_29, arg2_29)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_29.id, arg2_29)
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT_ONESTEP, function(arg0_30, arg1_30)
		arg0_1:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg1_30
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_31, arg1_31)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_31
		})
	end)
	arg0_1:bind(var0_0.GO_PRAY_POOL, function(arg0_32)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT, {
			goToPray = true
		})
	end)
	arg0_1:bind(var0_0.FETCH_INSTARGRAM, function(arg0_33, ...)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_FETCH, ...)
	end)
	arg0_1:bind(var0_0.MUSIC_GAME_OPERATOR, function(arg0_34, ...)
		arg0_1:sendNotification(GAME.SEND_MINI_GAME_OP, ...)
	end)
	arg0_1:bind(var0_0.SELECT_ACTIVITY, function(arg0_35, arg1_35)
		arg0_1.viewComponent:verifyTabs(arg1_35)
	end)
	arg0_1:bind(var0_0.SHOW_NEXT_ACTIVITY, function(arg0_36)
		arg0_1:showNextActivity()
	end)
	arg0_1:bind(var0_0.ACTIVITY_PERMANENT, function(arg0_37, arg1_37)
		if PlayerPrefs.GetString("permanent_time", "") ~= pg.gameset.permanent_mark.description then
			PlayerPrefs.SetString("permanent_time", pg.gameset.permanent_mark.description)
			arg0_1.viewComponent:updateEntrances()
		end

		local var0_37 = getProxy(ActivityPermanentProxy):getDoingActivity()

		if var0_37 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("activity_permanent_tips3"))
			arg0_1.viewComponent:verifyTabs(var0_37.id)
		else
			arg0_1:addSubLayers(Context.New({
				mediator = ActivityPermanentMediator,
				viewComponent = ActivityPermanentLayer,
				data = {
					finishId = arg1_37
				}
			}))
		end
	end)
	arg0_1:bind(var0_0.FINISH_ACTIVITY_PERMANENT, function(arg0_38)
		local var0_38 = getProxy(ActivityPermanentProxy):getDoingActivity()

		assert(var0_38:canPermanentFinish(), "error permanent activity finish")
		arg0_1:sendNotification(GAME.ACTIVITY_PERMANENT_FINISH, {
			activity_id = var0_38.id
		})
	end)
	arg0_1:bind(var0_0.GO_PERFORM_COMBAT, function(arg0_39, arg1_39, arg2_39)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1_39.stageId,
			memory = arg1_39.memory
		})
	end)
	arg0_1:bind(var0_0.NEXT_DISPLAY_AWARD, function(arg0_40, arg1_40, arg2_40)
		arg0_1.nextDisplayAwards = arg1_40
	end)
	arg0_1:bind(var0_0.GO_CARDPUZZLE_COMBAT, function(arg0_41, arg1_41)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_CARDPUZZLE,
			combatID = arg1_41
		})
	end)
	arg0_1:bind(var0_0.CHARGE, function(arg0_42, arg1_42)
		arg0_1:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg1_42
		})
	end)
	arg0_1:bind(var0_0.BUY_ITEM, function(arg0_43, arg1_43, arg2_43)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_43,
			count = arg2_43
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_ITEM_PANEL, function(arg0_44, arg1_44)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1_44
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_BIRTHDAY, function(arg0_45, arg1_45)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
	arg0_1:bind(var0_0.STORE_DATE, function(arg0_46, arg1_46)
		arg0_1:sendNotification(GAME.ACTIVITY_STORE_DATE, {
			activity_id = arg1_46.actId,
			intValue = arg1_46.intValue or 0,
			strValue = arg1_46.strValue or "",
			callback = arg1_46.callback
		})
	end)
	arg0_1:bind(var0_0.ON_ACT_SHOPPING, function(arg0_47, arg1_47, arg2_47, arg3_47, arg4_47)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = arg1_47,
			cmd = arg2_47,
			arg1 = arg3_47,
			arg2 = arg4_47
		})
	end)
	arg0_1:bind(var0_0.ON_ACTIVITY_TASK_SUBMIT, function(arg0_48, arg1_48)
		arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_48.activityId,
			task_ids = {
				arg1_48.id
			}
		})
	end)

	local var0_1 = getProxy(ActivityProxy)

	arg0_1.viewComponent:setActivities(var0_1:getPanelActivities())

	local var1_1 = getProxy(PlayerProxy):getRawData()

	arg0_1.viewComponent:setPlayer(var1_1)

	local var2_1 = getProxy(BayProxy):getShipById(var1_1.character)

	arg0_1.viewComponent:setFlagShip(var2_1)
end

function var0_0.onUIAvalible(arg0_49)
	arg0_49.UIAvalible = true

	_.each(arg0_49.UIAvalibleCallbacks, function(arg0_50)
		arg0_50()
	end)
end

function var0_0.initNotificationHandleDic(arg0_51)
	arg0_51.handleDic = {
		[ActivityProxy.ACTIVITY_ADDED] = function(arg0_52, arg1_52)
			local var0_52 = arg1_52:getBody()

			if var0_52:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY then
				return
			end

			arg0_52.viewComponent:updateActivity(var0_52)

			if ActivityConst.AOERLIANG_TASK_ID == var0_52.id then
				arg0_52.viewComponent:update_task_list_auto_aoerliang(var0_52)
			end
		end,
		[ActivityProxy.ACTIVITY_UPDATED] = function(...)
			arg0_51.handleDic[ActivityProxy.ACTIVITY_ADDED](...)
		end,
		[ActivityProxy.ACTIVITY_DELETED] = function(arg0_54, arg1_54)
			local var0_54 = arg1_54:getBody()

			arg0_54.viewComponent:removeActivity(var0_54)
		end,
		[ActivityProxy.ACTIVITY_OPERATION_DONE] = function(arg0_55, arg1_55)
			local var0_55 = arg1_55:getBody()

			if ActivityConst.AOERLIANG_TASK_ID == var0_55 then
				return
			end

			if ActivityConst.HOLOLIVE_MORNING_ID == var0_55 then
				local var1_55 = arg0_55.viewComponent.pageDic[ActivityConst.HOLOLIVE_MORNING_ID]
			end

			arg0_55:showNextActivity()
		end,
		[ActivityProxy.ACTIVITY_SHOW_AWARDS] = function(arg0_56, arg1_56)
			local var0_56 = arg1_56:getBody()
			local var1_56 = var0_56.awards

			if arg0_56.nextDisplayAwards and #arg0_56.nextDisplayAwards > 0 then
				for iter0_56 = 1, #arg0_56.nextDisplayAwards do
					table.insert(var1_56, arg0_56.nextDisplayAwards[iter0_56])
				end
			end

			arg0_56.nextDisplayAwards = {}

			arg0_56.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_56, var0_56.callback)
		end,
		[ActivityProxy.ACTIVITY_SHOW_BB_RESULT] = function(arg0_57, arg1_57)
			local var0_57 = arg1_57:getBody()

			arg0_57.viewComponent:emit(ActivityMediator.ON_BOBING_RESULT, var0_57)
		end,
		[ActivityProxy.ACTIVITY_SHOW_LOTTERY_AWARD_RESULT] = function(arg0_58, arg1_58)
			local var0_58 = arg1_58:getBody()
			local var1_58 = var0_58.activityID

			arg0_58.viewComponent.pageDic[var1_58]:showLotteryAwardResult(var0_58.awards, var0_58.number, var0_58.callback)
		end,
		[ActivityProxy.ACTIVITY_SHOW_SHAKE_BEADS_RESULT] = function(arg0_59, arg1_59)
			local var0_59 = arg1_59:getBody()

			arg0_59.viewComponent:emit(ActivityMediator.ON_SHAKE_BEADS_RESULT, var0_59)
		end,
		[GAME.COLORING_ACHIEVE_DONE] = function(arg0_60, arg1_60)
			arg0_60.viewComponent:playBonusAnim(function()
				local var0_61 = arg1_60:getBody()

				arg0_60.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_61.drops, function()
					arg0_60.viewComponent:flush_coloring()
				end)
			end)
		end,
		[GAME.SUBMIT_TASK_DONE] = function(arg0_63, arg1_63)
			local var0_63 = arg1_63:getBody()

			arg0_63.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_63, function()
				arg0_63.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.SUBMIT_ACTIVITY_TASK_DONE] = function(arg0_65, arg1_65)
			local var0_65 = arg1_65:getBody()

			arg0_65.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_65.awards, function()
				arg0_65.viewComponent:checkAutoHideActivity()
				arg0_65.viewComponent:updateTaskLayers()
				existCall(var0_65.callback)
			end)
		end,
		[GAME.ACT_NEW_PT_DONE] = function(arg0_67, arg1_67)
			local var0_67 = arg1_67:getBody()

			arg0_67.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_67.awards, var0_67.callback)
		end,
		[GAME.BEGIN_STAGE_DONE] = function(arg0_68, arg1_68)
			local var0_68 = arg1_68:getBody()

			arg0_68:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var0_68)
		end,
		[GAME.RETURN_AWARD_OP_DONE] = function(arg0_69, arg1_69)
			local var0_69 = arg1_69:getBody()

			arg0_69.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_69.awards)
		end,
		[VoteProxy.VOTE_ORDER_BOOK_DELETE] = function(arg0_70, arg1_70)
			return
		end,
		[VoteProxy.VOTE_ORDER_BOOK_UPDATE] = function(...)
			arg0_51.handleDic[VoteProxy.VOTE_ORDER_BOOK_DELETE](...)
		end,
		[GAME.REMOVE_LAYERS] = function(arg0_72, arg1_72)
			if arg1_72:getBody().context.mediator == VoteFameHallMediator then
				arg0_72.viewComponent:updateEntrances()
			end

			arg0_72.viewComponent:removeLayers()
		end,
		[GAME.MONOPOLY_AWARD_DONE] = function(arg0_73, arg1_73)
			local var0_73 = arg1_73:getBody()
			local var1_73 = arg0_73.viewComponent.pageDic[arg0_73.viewComponent.activity.id]

			if var1_73 and var1_73.activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MONOPOLY and var1_73.onAward then
				var1_73:onAward(var0_73.awards, var0_73.callback)
			elseif var0_73.autoFlag then
				arg0_73.viewComponent:emit(BaseUI.ON_ACHIEVE_AUTO, var0_73.awards, 1, var0_73.callback)
			else
				arg0_73.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_73.awards, var0_73.callback)
			end
		end,
		[GAME.SEND_MINI_GAME_OP_DONE] = function(arg0_74, arg1_74)
			local var0_74 = arg1_74:getBody()
			local var1_74 = {
				function(arg0_75)
					local var0_75 = var0_74.awards

					if #var0_75 > 0 then
						if arg0_74.viewComponent then
							arg0_74.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_75, arg0_75)
						else
							arg0_74:emit(BaseUI.ON_ACHIEVE, var0_75, arg0_75)
						end
					else
						arg0_75()
					end
				end
			}

			seriesAsync(var1_74, function()
				arg0_74.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.ACTIVITY_PERMANENT_START_DONE] = function(arg0_77, arg1_77)
			local var0_77 = arg1_77:getBody()

			arg0_77.viewComponent:verifyTabs(var0_77.id)
		end,
		[GAME.ACTIVITY_PERMANENT_FINISH_DONE] = function(arg0_78, arg1_78)
			local var0_78 = arg1_78:getBody()

			arg0_78.viewComponent:emit(ActivityMediator.ACTIVITY_PERMANENT, var0_78.activity_id)
		end,
		[GAME.MEMORYBOOK_UNLOCK_AWARD_DONE] = function(arg0_79, arg1_79)
			local var0_79 = arg1_79:getBody()

			arg0_79.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_79.awards)
		end,
		[GAME.LOAD_LAYERS] = function(arg0_80, arg1_80)
			local var0_80 = arg1_80:getBody()

			arg0_80.viewComponent:loadLayers()
		end,
		[GAME.CHARGE_SUCCESS] = function(arg0_81, arg1_81)
			local var0_81 = arg1_81:getBody()

			arg0_81.viewComponent:updateTaskLayers()

			local var1_81 = Goods.Create({
				shop_id = var0_81.shopId
			}, Goods.TYPE_CHARGE)

			arg0_81.viewComponent:OnChargeSuccess(var1_81)
		end,
		[GAME.SHOPPING_DONE] = function(arg0_82, arg1_82)
			local var0_82 = arg1_82:getBody()

			arg0_82.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_82.awards, function()
				arg0_82.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.ACT_MANUAL_SIGN_DONE] = function(arg0_84, arg1_84)
			local var0_84 = arg1_84:getBody()

			arg0_84.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_84.awards)
		end,
		[ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS] = function(arg0_85, arg1_85)
			local var0_85 = arg1_85:getBody()

			arg0_85.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_85.awards, function()
				local var0_86 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE)

				if var0_86 and not var0_86:isShow() then
					arg0_85.viewComponent:removeActivity(var0_86.id)
				end

				arg0_85.viewComponent:updateTaskLayers()
				existCall(var0_85.callback)
			end)
		end
	}
end

function var0_0.showNextActivity(arg0_87)
	local var0_87 = getProxy(ActivityProxy)

	if not var0_87 then
		return
	end

	local var1_87 = var0_87:findNextAutoActivity()

	if var1_87 then
		if var1_87.id == ActivityConst.BLACK_FRIDAY_SIGNIN_ACT_ID then
			arg0_87.contextData.showByNextAct = true

			arg0_87.viewComponent:verifyTabs(ActivityConst.BLACK_FRIDAY_ACT_ID)
		else
			arg0_87.viewComponent:verifyTabs(var1_87.id)
		end

		local var2_87 = var1_87:getConfig("type")

		if var2_87 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
			arg0_87:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = var1_87.id
			})
		elseif var2_87 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
			local var3_87 = var1_87:getSpecialData("reMonthSignDay") ~= nil and 3 or 1

			arg0_87:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = var1_87.id,
				cmd = var3_87,
				arg1 = var1_87:getSpecialData("reMonthSignDay")
			})
		elseif var2_87 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
			arg0_87:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = var1_87.id,
				cmd = var1_87.data1 < 7 and 1 or 2
			})
		elseif var1_87.id == ActivityConst.SHADOW_PLAY_ID then
			var1_87.clientData1 = 1

			arg0_87:showNextActivity()
		end
	elseif not arg0_87.viewComponent.activity then
		local var4_87 = var0_87:getPanelActivities()
		local var5_87 = arg0_87.contextData.id or arg0_87.contextData.type and checkExist(_.detect(var4_87, function(arg0_88)
			return arg0_88:getConfig("type") == arg0_87.contextData.type
		end), {
			"id"
		}) or 0

		arg0_87.viewComponent:verifyTabs(var5_87)
	end
end

return var0_0
