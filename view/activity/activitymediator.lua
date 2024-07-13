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

function var0_0.register(arg0_1)
	arg0_1.UIAvalibleCallbacks = {}

	arg0_1:bind(var0_0.ON_AWARD_WINDOW, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1.viewComponent:ShowAwardWindow(arg1_2, arg2_2, arg3_2)
	end)
	arg0_1:bind(var0_0.GO_DECODE_MINI_GAME, function(arg0_3)
		pg.m02:sendNotification(GAME.REQUEST_MINI_GAME, {
			type = MiniGameRequestCommand.REQUEST_HUB_DATA,
			callback = function()
				pg.m02:sendNotification(GAME.GO_MINI_GAME, 11)
			end
		})
	end)
	arg0_1:bind(var0_0.GO_MINI_GAME, function(arg0_5, arg1_5)
		pg.m02:sendNotification(GAME.GO_MINI_GAME, arg1_5)
	end)
	arg0_1:bind(var0_0.GO_SUBMARINE_RUN, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SUBMARINE_RUN,
			stageId = arg1_6
		})
	end)
	arg0_1:bind(var0_0.GO_DODGEM, function(arg0_7)
		local var0_7 = ys.Battle.BattleConfig.BATTLE_DODGEM_STAGES[math.random(#ys.Battle.BattleConfig.BATTLE_DODGEM_STAGES)]

		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_DODGEM,
			stageId = var0_7
		})
	end)
	arg0_1:bind(var0_0.ON_SIMULATION_COMBAT, function(arg0_8, arg1_8, arg2_8)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SIMULATION,
			stageId = arg1_8.stageId,
			warnMsg = arg1_8.warnMsg,
			exitCallback = arg2_8
		})
	end)
	arg0_1:bind(var0_0.ON_AIRFIGHT_COMBAT, function(arg0_9, arg1_9, arg2_9)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_AIRFIGHT,
			stageId = arg1_9.stageId,
			exitCallback = arg2_9
		})
	end)
	arg0_1:bind(var0_0.RETURN_AWARD_OP, function(arg0_10, arg1_10)
		if arg1_10.cmd == ActivityConst.RETURN_AWARD_OP_SHOW_AWARD_OVERVIEW then
			arg0_1.viewComponent:ShowWindow(ReturnerAwardWindow, arg1_10.arg1)
		elseif arg1_10.cmd == ActivityConst.RETURN_AWARD_OP_SHOW_RETURNER_AWARD_OVERVIEW then
			arg0_1.viewComponent:ShowWindow(TaskAwardWindow, arg1_10.arg1)
		else
			arg0_1:sendNotification(GAME.RETURN_AWARD_OP, arg1_10)
		end
	end)
	arg0_1:bind(var0_0.SHOW_AWARD_WINDOW, function(arg0_11, arg1_11, arg2_11)
		arg0_1.viewComponent:ShowWindow(arg1_11, arg2_11)
	end)
	arg0_1:bind(var0_0.EVENT_PT_OPERATION, function(arg0_12, arg1_12)
		arg0_1:sendNotification(GAME.ACT_NEW_PT, arg1_12)
	end)
	arg0_1:bind(var0_0.OPEN_LAYER, function(arg0_13, arg1_13)
		arg0_1:addSubLayers(arg1_13)
	end)
	arg0_1:bind(var0_0.OPEN_RED_PACKET_LAYER, function(arg0_14)
		arg0_1:addSubLayers(Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_LAYER, function(arg0_15, arg1_15)
		local var0_15 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg1_15)

		if var0_15 then
			arg0_1:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_15
			})
		end
	end)
	arg0_1:bind(var0_0.EVENT_OPERATION, function(arg0_16, arg1_16)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_16)
	end)
	arg0_1:bind(var0_0.EVENT_GO_SCENE, function(arg0_17, arg1_17, arg2_17)
		if arg1_17 == SCENE.SUMMER_FEAST then
			pg.NewStoryMgr.GetInstance():Play("TIANHOUYUYI1", function()
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SUMMER_FEAST)
			end)
		else
			arg0_1:sendNotification(GAME.GO_SCENE, arg1_17, arg2_17)
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
	arg0_1:bind(var0_0.GO_SHOPS_LAYER, function(arg0_21, arg1_21)
		if not getProxy(ActivityProxy):getActivityById(arg1_21.actId) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1_21 or {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0_1:bind(var0_0.GO_SHOPS_LAYER_STEEET, function(arg0_22, arg1_22)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1_22 or {
			warp = NewShopsScene.TYPE_SHOP_STREET
		})
	end)
	arg0_1:bind(var0_0.BATTLE_OPERA, function()
		local var0_23 = getProxy(ChapterProxy)
		local var1_23, var2_23 = var0_23:getLastMapForActivity()

		if not var1_23 or not var0_23:getMapById(var1_23):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_23,
				mapIdx = var1_23
			})
		end
	end)
	arg0_1:bind(var0_0.SPECIAL_BATTLE_OPERA, function()
		local var0_24 = getProxy(ChapterProxy)
		local var1_24, var2_24 = var0_24:getLastMapForActivity()

		if not var1_24 or not var0_24:getMapById(var1_24):isUnlock() then
			local var3_24 = getProxy(ChapterProxy)
			local var4_24 = var3_24:getActiveChapter()

			var1_24 = var4_24 and var4_24:getConfig("map")

			if not var4_24 then
				local var5_24 = Map.lastMap and var3_24:getMapById(Map.lastMap)

				if var5_24 and var5_24:isUnlock() then
					var1_24 = Map.lastMap
				else
					var1_24 = var3_24:getLastUnlockMap().id
				end
			end

			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var4_24 and var4_24.id,
				mapIdx = var1_24
			})
		else
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_24,
				mapIdx = var1_24
			})
		end
	end)
	arg0_1:bind(var0_0.GO_LOTTERY, function(arg0_25)
		local var0_25 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

		arg0_1:addSubLayers(Context.New({
			mediator = LotteryMediator,
			viewComponent = LotteryLayer,
			data = {
				activityId = var0_25.id
			}
		}))
	end)
	arg0_1:bind(var0_0.GO_BACKYARD, function(arg0_26)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD)
	end)
	arg0_1:bind(var0_0.EVENT_COLORING_ACHIEVE, function(arg0_27, arg1_27)
		arg0_1:sendNotification(GAME.COLORING_ACHIEVE, arg1_27)
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_28, arg1_28, arg2_28)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_28.id, arg2_28)
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT_ONESTEP, function(arg0_29, arg1_29)
		arg0_1:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg1_29
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_30, arg1_30)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_30
		})
	end)
	arg0_1:bind(var0_0.GO_PRAY_POOL, function(arg0_31)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT, {
			goToPray = true
		})
	end)
	arg0_1:bind(var0_0.FETCH_INSTARGRAM, function(arg0_32, ...)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_FETCH, ...)
	end)
	arg0_1:bind(var0_0.MUSIC_GAME_OPERATOR, function(arg0_33, ...)
		arg0_1:sendNotification(GAME.SEND_MINI_GAME_OP, ...)
	end)
	arg0_1:bind(var0_0.SELECT_ACTIVITY, function(arg0_34, arg1_34)
		arg0_1.viewComponent:verifyTabs(arg1_34)
	end)
	arg0_1:bind(var0_0.SHOW_NEXT_ACTIVITY, function(arg0_35)
		arg0_1:showNextActivity()
	end)
	arg0_1:bind(var0_0.ACTIVITY_PERMANENT, function(arg0_36, arg1_36)
		if PlayerPrefs.GetString("permanent_time", "") ~= pg.gameset.permanent_mark.description then
			PlayerPrefs.SetString("permanent_time", pg.gameset.permanent_mark.description)
			arg0_1.viewComponent:updateEntrances()
		end

		local var0_36 = getProxy(ActivityPermanentProxy):getDoingActivity()

		if var0_36 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("activity_permanent_tips3"))
			arg0_1.viewComponent:verifyTabs(var0_36.id)
		else
			arg0_1:addSubLayers(Context.New({
				mediator = ActivityPermanentMediator,
				viewComponent = ActivityPermanentLayer,
				data = {
					finishId = arg1_36
				}
			}))
		end
	end)
	arg0_1:bind(var0_0.FINISH_ACTIVITY_PERMANENT, function(arg0_37)
		local var0_37 = getProxy(ActivityPermanentProxy):getDoingActivity()

		assert(var0_37:canPermanentFinish(), "error permanent activity finish")
		arg0_1:sendNotification(GAME.ACTIVITY_PERMANENT_FINISH, {
			activity_id = var0_37.id
		})
	end)
	arg0_1:bind(var0_0.GO_PERFORM_COMBAT, function(arg0_38, arg1_38, arg2_38)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1_38.stageId,
			memory = arg1_38.memory
		})
	end)
	arg0_1:bind(var0_0.NEXT_DISPLAY_AWARD, function(arg0_39, arg1_39, arg2_39)
		arg0_1.nextDisplayAwards = arg1_39
	end)
	arg0_1:bind(var0_0.GO_CARDPUZZLE_COMBAT, function(arg0_40, arg1_40)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_CARDPUZZLE,
			combatID = arg1_40
		})
	end)
	arg0_1:bind(var0_0.CHARGE, function(arg0_41, arg1_41)
		arg0_1:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg1_41
		})
	end)
	arg0_1:bind(var0_0.BUY_ITEM, function(arg0_42, arg1_42, arg2_42)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_42,
			count = arg2_42
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_ITEM_PANEL, function(arg0_43, arg1_43)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1_43
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_BIRTHDAY, function(arg0_44, arg1_44)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
	arg0_1:bind(var0_0.STORE_DATE, function(arg0_45, arg1_45)
		arg0_1:sendNotification(GAME.ACTIVITY_STORE_DATE, {
			activity_id = arg1_45.actId,
			intValue = arg1_45.intValue or 0,
			strValue = arg1_45.strValue or "",
			callback = arg1_45.callback
		})
	end)
	arg0_1:bind(var0_0.ON_ACT_SHOPPING, function(arg0_46, arg1_46, arg2_46, arg3_46, arg4_46)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = arg1_46,
			cmd = arg2_46,
			arg1 = arg3_46,
			arg2 = arg4_46
		})
	end)

	local var0_1 = getProxy(ActivityProxy)

	arg0_1.viewComponent:setActivities(var0_1:getPanelActivities())

	local var1_1 = getProxy(PlayerProxy):getRawData()

	arg0_1.viewComponent:setPlayer(var1_1)

	local var2_1 = getProxy(BayProxy):getShipById(var1_1.character)

	arg0_1.viewComponent:setFlagShip(var2_1)
end

function var0_0.onUIAvalible(arg0_47)
	arg0_47.UIAvalible = true

	_.each(arg0_47.UIAvalibleCallbacks, function(arg0_48)
		arg0_48()
	end)
end

function var0_0.initNotificationHandleDic(arg0_49)
	arg0_49.handleDic = {
		[ActivityProxy.ACTIVITY_ADDED] = function(arg0_50, arg1_50)
			local var0_50 = arg1_50:getBody()

			if var0_50:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY then
				return
			end

			arg0_50.viewComponent:updateActivity(var0_50)

			if ActivityConst.AOERLIANG_TASK_ID == var0_50.id then
				arg0_50.viewComponent:update_task_list_auto_aoerliang(var0_50)
			end
		end,
		[ActivityProxy.ACTIVITY_UPDATED] = function(...)
			arg0_49.handleDic[ActivityProxy.ACTIVITY_ADDED](...)
		end,
		[ActivityProxy.ACTIVITY_DELETED] = function(arg0_52, arg1_52)
			local var0_52 = arg1_52:getBody()

			arg0_52.viewComponent:removeActivity(var0_52)
		end,
		[ActivityProxy.ACTIVITY_OPERATION_DONE] = function(arg0_53, arg1_53)
			local var0_53 = arg1_53:getBody()

			if ActivityConst.AOERLIANG_TASK_ID == var0_53 then
				return
			end

			if ActivityConst.HOLOLIVE_MORNING_ID == var0_53 then
				local var1_53 = arg0_53.viewComponent.pageDic[ActivityConst.HOLOLIVE_MORNING_ID]
			end

			arg0_53:showNextActivity()
		end,
		[ActivityProxy.ACTIVITY_SHOW_AWARDS] = function(arg0_54, arg1_54)
			local var0_54 = arg1_54:getBody()
			local var1_54 = var0_54.awards

			if arg0_54.nextDisplayAwards and #arg0_54.nextDisplayAwards > 0 then
				for iter0_54 = 1, #arg0_54.nextDisplayAwards do
					table.insert(var1_54, arg0_54.nextDisplayAwards[iter0_54])
				end
			end

			arg0_54.nextDisplayAwards = {}

			arg0_54.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_54, var0_54.callback)
		end,
		[ActivityProxy.ACTIVITY_SHOW_BB_RESULT] = function(arg0_55, arg1_55)
			local var0_55 = arg1_55:getBody()

			arg0_55.viewComponent:emit(ActivityMediator.ON_BOBING_RESULT, var0_55)
		end,
		[ActivityProxy.ACTIVITY_SHOW_LOTTERY_AWARD_RESULT] = function(arg0_56, arg1_56)
			local var0_56 = arg1_56:getBody()
			local var1_56 = var0_56.activityID

			arg0_56.viewComponent.pageDic[var1_56]:showLotteryAwardResult(var0_56.awards, var0_56.number, var0_56.callback)
		end,
		[ActivityProxy.ACTIVITY_SHOW_SHAKE_BEADS_RESULT] = function(arg0_57, arg1_57)
			local var0_57 = arg1_57:getBody()

			arg0_57.viewComponent:emit(ActivityMediator.ON_SHAKE_BEADS_RESULT, var0_57)
		end,
		[GAME.COLORING_ACHIEVE_DONE] = function(arg0_58, arg1_58)
			arg0_58.viewComponent:playBonusAnim(function()
				local var0_59 = arg1_58:getBody()

				arg0_58.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_59.drops, function()
					arg0_58.viewComponent:flush_coloring()
				end)
			end)
		end,
		[GAME.SUBMIT_TASK_DONE] = function(arg0_61, arg1_61)
			local var0_61 = arg1_61:getBody()

			arg0_61.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_61, function()
				arg0_61.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.ACT_NEW_PT_DONE] = function(arg0_63, arg1_63)
			local var0_63 = arg1_63:getBody()

			arg0_63.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_63.awards, var0_63.callback)
		end,
		[GAME.BEGIN_STAGE_DONE] = function(arg0_64, arg1_64)
			local var0_64 = arg1_64:getBody()

			arg0_64:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var0_64)
		end,
		[GAME.RETURN_AWARD_OP_DONE] = function(arg0_65, arg1_65)
			local var0_65 = arg1_65:getBody()

			arg0_65.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_65.awards)
		end,
		[VoteProxy.VOTE_ORDER_BOOK_DELETE] = function(arg0_66, arg1_66)
			return
		end,
		[VoteProxy.VOTE_ORDER_BOOK_UPDATE] = function(...)
			arg0_49.handleDic[VoteProxy.VOTE_ORDER_BOOK_DELETE](...)
		end,
		[GAME.REMOVE_LAYERS] = function(arg0_68, arg1_68)
			if arg1_68:getBody().context.mediator == VoteFameHallMediator then
				arg0_68.viewComponent:updateEntrances()
			end

			arg0_68.viewComponent:removeLayers()
		end,
		[GAME.MONOPOLY_AWARD_DONE] = function(arg0_69, arg1_69)
			local var0_69 = arg1_69:getBody()
			local var1_69 = arg0_69.viewComponent.pageDic[arg0_69.viewComponent.activity.id]

			if var1_69 and var1_69.activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MONOPOLY and var1_69.onAward then
				var1_69:onAward(var0_69.awards, var0_69.callback)
			else
				arg0_69.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_69.awards, var0_69.callback)
			end
		end,
		[GAME.SEND_MINI_GAME_OP_DONE] = function(arg0_70, arg1_70)
			local var0_70 = arg1_70:getBody()
			local var1_70 = {
				function(arg0_71)
					local var0_71 = var0_70.awards

					if #var0_71 > 0 then
						if arg0_70.viewComponent then
							arg0_70.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_71, arg0_71)
						else
							arg0_70:emit(BaseUI.ON_ACHIEVE, var0_71, arg0_71)
						end
					else
						arg0_71()
					end
				end
			}

			seriesAsync(var1_70, function()
				arg0_70.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.ACTIVITY_PERMANENT_START_DONE] = function(arg0_73, arg1_73)
			local var0_73 = arg1_73:getBody()

			arg0_73.viewComponent:verifyTabs(var0_73.id)
		end,
		[GAME.ACTIVITY_PERMANENT_FINISH_DONE] = function(arg0_74, arg1_74)
			local var0_74 = arg1_74:getBody()

			arg0_74.viewComponent:emit(ActivityMediator.ACTIVITY_PERMANENT, var0_74.activity_id)
		end,
		[GAME.MEMORYBOOK_UNLOCK_AWARD_DONE] = function(arg0_75, arg1_75)
			local var0_75 = arg1_75:getBody()

			arg0_75.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_75.awards)
		end,
		[GAME.LOAD_LAYERS] = function(arg0_76, arg1_76)
			local var0_76 = arg1_76:getBody()

			arg0_76.viewComponent:loadLayers()
		end,
		[GAME.CHARGE_SUCCESS] = function(arg0_77, arg1_77)
			local var0_77 = arg1_77:getBody()

			arg0_77.viewComponent:updateTaskLayers()

			local var1_77 = Goods.Create({
				shop_id = var0_77.shopId
			}, Goods.TYPE_CHARGE)

			arg0_77.viewComponent:OnChargeSuccess(var1_77)
		end,
		[GAME.SHOPPING_DONE] = function(arg0_78, arg1_78)
			local var0_78 = arg1_78:getBody()

			arg0_78.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_78.awards, function()
				arg0_78.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.ACT_MANUAL_SIGN_DONE] = function(arg0_80, arg1_80)
			local var0_80 = arg1_80:getBody()

			arg0_80.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_80.awards)
		end,
		[ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS] = function(arg0_81, arg1_81)
			local var0_81 = arg1_81:getBody()

			arg0_81.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_81.awards, function()
				local var0_82 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE)

				if var0_82 and not var0_82:isShow() then
					arg0_81.viewComponent:removeActivity(var0_82.id)
				end

				arg0_81.viewComponent:updateTaskLayers()
				var0_81.callback()
			end)
		end
	}
end

function var0_0.showNextActivity(arg0_83)
	local var0_83 = getProxy(ActivityProxy)

	if not var0_83 then
		return
	end

	local var1_83 = var0_83:findNextAutoActivity()

	if var1_83 then
		if var1_83.id == ActivityConst.BLACK_FRIDAY_SIGNIN_ACT_ID then
			arg0_83.contextData.showByNextAct = true

			arg0_83.viewComponent:verifyTabs(ActivityConst.BLACK_FRIDAY_ACT_ID)
		else
			arg0_83.viewComponent:verifyTabs(var1_83.id)
		end

		local var2_83 = var1_83:getConfig("type")

		if var2_83 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
			arg0_83:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = var1_83.id
			})
		elseif var2_83 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
			local var3_83 = var1_83:getSpecialData("reMonthSignDay") ~= nil and 3 or 1

			arg0_83:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = var1_83.id,
				cmd = var3_83,
				arg1 = var1_83:getSpecialData("reMonthSignDay")
			})
		elseif var2_83 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
			arg0_83:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = var1_83.id,
				cmd = var1_83.data1 < 7 and 1 or 2
			})
		elseif var1_83.id == ActivityConst.SHADOW_PLAY_ID then
			var1_83.clientData1 = 1

			arg0_83:showNextActivity()
		end
	elseif not arg0_83.viewComponent.activity then
		local var4_83 = var0_83:getPanelActivities()
		local var5_83 = arg0_83.contextData.id or arg0_83.contextData.type and checkExist(_.detect(var4_83, function(arg0_84)
			return arg0_84:getConfig("type") == arg0_83.contextData.type
		end), {
			"id"
		}) or 0

		arg0_83.viewComponent:verifyTabs(var5_83)
	end
end

return var0_0
