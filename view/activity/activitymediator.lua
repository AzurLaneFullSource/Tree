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
var0_0.ON_ACTIVITY_TASK_LIST_SUBMIT = "ActivityMediator.ON_ACTIVITY_TASK_LIST_SUBMIT"
var0_0.GO_CHANGE_SHOP = "go Change shop"
var0_0.GO_Activity_level = "go Activity level"
var0_0.ON_ADD_SUBLAYER = "ActivityMediator.ON_ADD_SUBLAYER"
var0_0.GO_SPECIAL_EXERCISE = "go Special exercise"
var0_0.GO_SINGLE_PRECOMBAT = "ActivityMediator.GO_SINGLE_PRECOMBAT"
var0_0.ON_BOSSRUSH_MAP = "ActivityMediator.ON_BOSSRUSH_MAP"
var0_0.SKIP_ACTIVITY_MAP = "ActivityMediator.SKIP_ACTIVITY_MAP"
var0_0.OPEN_MINI_PROGRAM = "ActivityMediator.OPEN_MINI_PROGRAM"

function var0_0.register(arg0_1)
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
	arg0_1:bind(var0_0.GO_CHANGE_SHOP, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0_1:bind(var0_0.GO_Activity_level, function(arg0_5)
		local var0_5 = getProxy(ChapterProxy)
		local var1_5, var2_5 = var0_5:getLastMapForActivity()

		if not var1_5 or not var0_5:getMapById(var1_5):isUnlock() then
			local var3_5 = getProxy(ChapterProxy)
			local var4_5 = var3_5:getActiveChapter()

			var1_5 = var4_5 and var4_5:getConfig("map")

			if not var4_5 then
				var1_5 = var3_5:GetLastNormalMap()
			end

			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var4_5 and var4_5.id,
				mapIdx = var1_5
			})
		else
			if not chapter then
				var1_5 = var0_5:GetLastNormalMap()
			end

			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_5,
				mapIdx = var1_5
			})
		end
	end)
	arg0_1:bind(var0_0.ON_BOSSRUSH_MAP, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)
	end)
	arg0_1:bind(var0_0.GO_DECODE_MINI_GAME, function(arg0_7)
		pg.m02:sendNotification(GAME.REQUEST_MINI_GAME, {
			type = MiniGameRequestCommand.REQUEST_HUB_DATA,
			callback = function()
				pg.m02:sendNotification(GAME.GO_MINI_GAME, 11)
			end
		})
	end)
	arg0_1:bind(var0_0.GO_MINI_GAME, function(arg0_9, arg1_9)
		pg.m02:sendNotification(GAME.GO_MINI_GAME, arg1_9)
	end)
	arg0_1:bind(var0_0.GO_SUBMARINE_RUN, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SUBMARINE_RUN,
			stageId = arg1_10
		})
	end)
	arg0_1:bind(var0_0.GO_DODGEM, function(arg0_11)
		local var0_11 = ys.Battle.BattleConfig.BATTLE_DODGEM_STAGES[math.random(#ys.Battle.BattleConfig.BATTLE_DODGEM_STAGES)]

		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_DODGEM,
			stageId = var0_11
		})
	end)
	arg0_1:bind(var0_0.ON_SIMULATION_COMBAT, function(arg0_12, arg1_12, arg2_12)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SIMULATION,
			stageId = arg1_12.stageId,
			warnMsg = arg1_12.warnMsg,
			exitCallback = arg2_12
		})
	end)
	arg0_1:bind(var0_0.ON_AIRFIGHT_COMBAT, function(arg0_13, arg1_13, arg2_13)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_AIRFIGHT,
			stageId = arg1_13.stageId,
			exitCallback = arg2_13
		})
	end)
	arg0_1:bind(var0_0.RETURN_AWARD_OP, function(arg0_14, arg1_14)
		if arg1_14.cmd == ActivityConst.RETURN_AWARD_OP_SHOW_AWARD_OVERVIEW then
			arg0_1.viewComponent:ShowWindow(ReturnerAwardWindow, arg1_14.arg1)
		elseif arg1_14.cmd == ActivityConst.RETURN_AWARD_OP_SHOW_RETURNER_AWARD_OVERVIEW then
			arg0_1.viewComponent:ShowWindow(TaskAwardWindow, arg1_14.arg1)
		else
			arg0_1:sendNotification(GAME.RETURN_AWARD_OP, arg1_14)
		end
	end)
	arg0_1:bind(var0_0.SHOW_AWARD_WINDOW, function(arg0_15, arg1_15, arg2_15)
		arg0_1.viewComponent:ShowWindow(arg1_15, arg2_15)
	end)
	arg0_1:bind(var0_0.EVENT_PT_OPERATION, function(arg0_16, arg1_16)
		arg0_1:sendNotification(GAME.ACT_NEW_PT, arg1_16)
	end)
	arg0_1:bind(var0_0.OPEN_LAYER, function(arg0_17, arg1_17)
		arg0_1:addSubLayers(arg1_17)
	end)
	arg0_1:bind(var0_0.OPEN_RED_PACKET_LAYER, function(arg0_18)
		arg0_1:addSubLayers(Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_LAYER, function(arg0_19, arg1_19)
		local var0_19 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg1_19)

		if var0_19 then
			arg0_1:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_19
			})
		end
	end)
	arg0_1:bind(var0_0.EVENT_OPERATION, function(arg0_20, arg1_20)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_20)
	end)
	arg0_1:bind(var0_0.EVENT_GO_SCENE, function(arg0_21, arg1_21, arg2_21)
		if arg1_21 == SCENE.SUMMER_FEAST then
			pg.NewStoryMgr.GetInstance():Play("TIANHOUYUYI1", function()
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SUMMER_FEAST)
			end)
		else
			arg0_1:sendNotification(GAME.GO_SCENE, arg1_21, arg2_21)
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
	arg0_1:bind(var0_0.GO_SHOPS_LAYER, function(arg0_25, arg1_25)
		if not getProxy(ActivityProxy):getActivityById(arg1_25.actId) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1_25 or {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0_1:bind(var0_0.GO_SHOPS_LAYER_STEEET, function(arg0_26, arg1_26)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1_26 or {
			warp = NewShopsScene.TYPE_SHOP_STREET
		})
	end)
	arg0_1:bind(var0_0.BATTLE_OPERA, function()
		local var0_27 = getProxy(ChapterProxy)
		local var1_27, var2_27 = var0_27:getLastMapForActivity()

		if not var1_27 or not var0_27:getMapById(var1_27):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_27,
				mapIdx = var1_27
			})
		end
	end)
	arg0_1:bind(var0_0.SKIP_ACTIVITY_MAP, function(arg0_28, arg1_28)
		local var0_28 = getProxy(ChapterProxy)
		local var1_28, var2_28 = var0_28:getLastMapForActivity(arg1_28)

		if not var1_28 or not var0_28:getMapById(var1_28):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_28,
				mapIdx = var1_28
			})
		end
	end)
	arg0_1:bind(var0_0.OPEN_MINI_PROGRAM, function(arg0_29)
		pg.SdkMgr.GetInstance():OpenMiniProgram()
	end)
	arg0_1:bind(var0_0.GO_SPECIAL_EXERCISE, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACT_BOSS_BATTLE)
	end)
	arg0_1:bind(var0_0.SPECIAL_BATTLE_OPERA, function()
		local var0_31 = getProxy(ChapterProxy)
		local var1_31, var2_31 = var0_31:getLastMapForActivity()

		if not var1_31 or not var0_31:getMapById(var1_31):isUnlock() then
			local var3_31 = getProxy(ChapterProxy)
			local var4_31 = var3_31:getActiveChapter()

			var1_31 = var4_31 and var4_31:getConfig("map")

			if not var4_31 then
				var1_31 = var3_31:GetLastNormalMap()
			end

			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var4_31 and var4_31.id,
				mapIdx = var1_31
			})
		else
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_31,
				mapIdx = var1_31
			})
		end
	end)
	arg0_1:bind(var0_0.ON_ADD_SUBLAYER, function(arg0_32, arg1_32)
		arg0_1:addSubLayers(arg1_32)
	end)
	arg0_1:bind(var0_0.GO_LOTTERY, function(arg0_33)
		local var0_33 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

		arg0_1:addSubLayers(Context.New({
			mediator = LotteryMediator,
			viewComponent = LotteryLayer,
			data = {
				activityId = var0_33.id
			}
		}))
	end)
	arg0_1:bind(var0_0.GO_BACKYARD, function(arg0_34)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD)
	end)
	arg0_1:bind(var0_0.EVENT_COLORING_ACHIEVE, function(arg0_35, arg1_35)
		arg0_1:sendNotification(GAME.COLORING_ACHIEVE, arg1_35)
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_36, arg1_36, arg2_36)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_36.id, arg2_36)
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT_ONESTEP, function(arg0_37, arg1_37)
		arg0_1:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg1_37
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_38, arg1_38)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_38
		})
	end)
	arg0_1:bind(var0_0.GO_PRAY_POOL, function(arg0_39)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT, {
			goToPray = true
		})
	end)
	arg0_1:bind(var0_0.FETCH_INSTARGRAM, function(arg0_40, ...)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_FETCH, ...)
	end)
	arg0_1:bind(var0_0.MUSIC_GAME_OPERATOR, function(arg0_41, ...)
		arg0_1:sendNotification(GAME.SEND_MINI_GAME_OP, ...)
	end)
	arg0_1:bind(var0_0.SELECT_ACTIVITY, function(arg0_42, arg1_42)
		arg0_1.viewComponent:verifyTabs(arg1_42)
	end)
	arg0_1:bind(var0_0.SHOW_NEXT_ACTIVITY, function(arg0_43, arg1_43)
		arg0_1:showNextActivity(arg1_43)
	end)
	arg0_1:bind(var0_0.ACTIVITY_PERMANENT, function(arg0_44, arg1_44)
		if PlayerPrefs.GetString("permanent_time", "") ~= pg.gameset.permanent_mark.description then
			PlayerPrefs.SetString("permanent_time", pg.gameset.permanent_mark.description)
			arg0_1.viewComponent:updateEntrances()
		end

		local var0_44 = getProxy(ActivityPermanentProxy):getDoingActivity()

		if var0_44 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("activity_permanent_tips3"))
			arg0_1.viewComponent:verifyTabs(var0_44.id)
		else
			arg0_1:addSubLayers(Context.New({
				mediator = ActivityPermanentMediator,
				viewComponent = ActivityPermanentLayer,
				data = {
					finishId = arg1_44
				}
			}))
		end
	end)
	arg0_1:bind(var0_0.FINISH_ACTIVITY_PERMANENT, function(arg0_45)
		local var0_45 = getProxy(ActivityPermanentProxy):getDoingActivity()

		assert(var0_45:canPermanentFinish(), "error permanent activity finish")
		arg0_1:sendNotification(GAME.ACTIVITY_PERMANENT_FINISH, {
			activity_id = var0_45.id
		})
	end)
	arg0_1:bind(var0_0.GO_PERFORM_COMBAT, function(arg0_46, arg1_46, arg2_46)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1_46.stageId,
			memory = arg1_46.memory
		})
	end)
	arg0_1:bind(var0_0.NEXT_DISPLAY_AWARD, function(arg0_47, arg1_47, arg2_47)
		arg0_1.nextDisplayAwards = arg1_47
	end)
	arg0_1:bind(var0_0.GO_CARDPUZZLE_COMBAT, function(arg0_48, arg1_48)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_CARDPUZZLE,
			combatID = arg1_48
		})
	end)
	arg0_1:bind(var0_0.CHARGE, function(arg0_49, arg1_49)
		arg0_1:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg1_49
		})
	end)
	arg0_1:bind(var0_0.BUY_ITEM, function(arg0_50, arg1_50, arg2_50)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_50,
			count = arg2_50
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_ITEM_PANEL, function(arg0_51, arg1_51)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1_51
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_BIRTHDAY, function(arg0_52, arg1_52)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
	arg0_1:bind(var0_0.STORE_DATE, function(arg0_53, arg1_53)
		arg0_1:sendNotification(GAME.ACTIVITY_STORE_DATE, {
			activity_id = arg1_53.actId,
			intValue = arg1_53.intValue or 0,
			strValue = arg1_53.strValue or "",
			callback = arg1_53.callback
		})
	end)
	arg0_1:bind(var0_0.ON_ACT_SHOPPING, function(arg0_54, arg1_54, arg2_54, arg3_54, arg4_54)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = arg1_54,
			cmd = arg2_54,
			arg1 = arg3_54,
			arg2 = arg4_54
		})
	end)
	arg0_1:bind(var0_0.ON_ACTIVITY_TASK_SUBMIT, function(arg0_55, arg1_55)
		arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_55.activityId,
			task_ids = {
				arg1_55.id
			}
		})
	end)
	arg0_1:bind(var0_0.ON_ACTIVITY_TASK_LIST_SUBMIT, function(arg0_56, arg1_56)
		arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_56.activityId,
			task_ids = arg1_56.ids
		})
	end)
	arg0_1:bind(var0_0.GO_SINGLE_PRECOMBAT, function(arg0_57, arg1_57)
		arg0_1:addSubLayers(Context.New({
			mediator = BossSinglePreCombatLiteMediator,
			viewComponent = BossSinglePreCombatLiteLayer,
			data = {
				system = arg1_57.system,
				stageId = arg1_57.stageId,
				actId = arg1_57.activityID,
				fleets = arg1_57.fleets
			}
		}))
	end)
	arg0_1.viewComponent:setActivities(arg0_1:getDisplayActivity())

	local var0_1 = getProxy(PlayerProxy):getRawData()

	arg0_1.viewComponent:setPlayer(var0_1)

	local var1_1 = getProxy(BayProxy):getShipById(var0_1.character)

	arg0_1.viewComponent:setFlagShip(var1_1)
end

function var0_0.getDisplayActivity(arg0_58)
	return getProxy(ActivityProxy):getPanelActivities()
end

function var0_0.initNotificationHandleDic(arg0_59)
	arg0_59.handleDic = {
		[ActivityProxy.ACTIVITY_ADDED] = function(arg0_60, arg1_60)
			local var0_60 = arg1_60:getBody()

			if var0_60:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY then
				return
			end

			arg0_60.viewComponent:updateActivity(var0_60)

			if ActivityConst.AOERLIANG_TASK_ID == var0_60.id then
				arg0_60.viewComponent:update_task_list_auto_aoerliang(var0_60)
			end
		end,
		[ActivityProxy.ACTIVITY_UPDATED] = function(...)
			arg0_59.handleDic[ActivityProxy.ACTIVITY_ADDED](...)
		end,
		[ActivityProxy.ACTIVITY_DELETED] = function(arg0_62, arg1_62)
			local var0_62 = arg1_62:getBody()

			arg0_62.viewComponent:removeActivity(var0_62)
		end,
		[ActivityProxy.ACTIVITY_OPERATION_DONE] = function(arg0_63, arg1_63)
			local var0_63 = arg1_63:getBody()

			if ActivityConst.AOERLIANG_TASK_ID == var0_63 then
				return
			end

			local var1_63 = getProxy(ActivityProxy):getActivityById(var0_63)

			arg0_63:showNextActivity(var1_63:getConfig("page_core"))
		end,
		[ActivityProxy.ACTIVITY_SHOW_AWARDS] = function(arg0_64, arg1_64)
			local var0_64 = arg1_64:getBody()
			local var1_64 = var0_64.awards

			if arg0_64.nextDisplayAwards and #arg0_64.nextDisplayAwards > 0 then
				for iter0_64 = 1, #arg0_64.nextDisplayAwards do
					table.insert(var1_64, arg0_64.nextDisplayAwards[iter0_64])
				end
			end

			arg0_64.nextDisplayAwards = {}

			arg0_64.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_64, var0_64.callback)
		end,
		[ActivityProxy.ACTIVITY_SHOW_BB_RESULT] = function(arg0_65, arg1_65)
			local var0_65 = arg1_65:getBody()

			arg0_65.viewComponent:emit(ActivityMediator.ON_BOBING_RESULT, var0_65)
		end,
		[ActivityProxy.ACTIVITY_SHOW_LOTTERY_AWARD_RESULT] = function(arg0_66, arg1_66)
			local var0_66 = arg1_66:getBody()
			local var1_66 = var0_66.activityID

			arg0_66.viewComponent.pageDic[var1_66]:showLotteryAwardResult(var0_66.awards, var0_66.number, var0_66.callback)
		end,
		[ActivityProxy.ACTIVITY_SHOW_SHAKE_BEADS_RESULT] = function(arg0_67, arg1_67)
			local var0_67 = arg1_67:getBody()

			arg0_67.viewComponent:emit(ActivityMediator.ON_SHAKE_BEADS_RESULT, var0_67)
		end,
		[GAME.COLORING_ACHIEVE_DONE] = function(arg0_68, arg1_68)
			arg0_68.viewComponent:playBonusAnim(function()
				local var0_69 = arg1_68:getBody()

				arg0_68.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_69.drops, function()
					arg0_68.viewComponent:flush_coloring()
				end)
			end)
		end,
		[GAME.SUBMIT_TASK_DONE] = function(arg0_71, arg1_71)
			local var0_71 = arg1_71:getBody()

			arg0_71.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_71, function()
				arg0_71.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.SUBMIT_ACTIVITY_TASK_DONE] = function(arg0_73, arg1_73)
			local var0_73 = arg1_73:getBody()

			arg0_73.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_73.awards, function()
				arg0_73.viewComponent:checkAutoHideActivity()
				arg0_73.viewComponent:updateTaskLayers()
				existCall(var0_73.callback)
			end)
		end,
		[GAME.ACT_NEW_PT_DONE] = function(arg0_75, arg1_75)
			local var0_75 = arg1_75:getBody()

			arg0_75.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_75.awards, var0_75.callback)
		end,
		[GAME.BEGIN_STAGE_DONE] = function(arg0_76, arg1_76)
			local var0_76 = arg1_76:getBody()

			arg0_76:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var0_76)
		end,
		[GAME.RETURN_AWARD_OP_DONE] = function(arg0_77, arg1_77)
			local var0_77 = arg1_77:getBody()

			arg0_77.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_77.awards)
		end,
		[VoteProxy.VOTE_ORDER_BOOK_DELETE] = function(arg0_78, arg1_78)
			return
		end,
		[VoteProxy.VOTE_ORDER_BOOK_UPDATE] = function(...)
			arg0_59.handleDic[VoteProxy.VOTE_ORDER_BOOK_DELETE](...)
		end,
		[GAME.REMOVE_LAYERS] = function(arg0_80, arg1_80)
			if arg1_80:getBody().context.mediator == VoteFameHallMediator then
				arg0_80.viewComponent:updateEntrances()
			end

			arg0_80.viewComponent:removeLayers()
		end,
		[GAME.MONOPOLY_AWARD_DONE] = function(arg0_81, arg1_81)
			local var0_81 = arg1_81:getBody()
			local var1_81 = arg0_81.viewComponent.pageDic[arg0_81.viewComponent.activity.id]

			if var1_81 and var1_81.activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MONOPOLY and var1_81.onAward then
				var1_81:onAward(var0_81.awards, var0_81.callback)
			elseif var0_81.autoFlag then
				arg0_81.viewComponent:emit(BaseUI.ON_ACHIEVE_AUTO, var0_81.awards, 1, var0_81.callback)
			else
				arg0_81.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_81.awards, var0_81.callback)
			end
		end,
		[GAME.SEND_MINI_GAME_OP_DONE] = function(arg0_82, arg1_82)
			local var0_82 = arg1_82:getBody()
			local var1_82 = {
				function(arg0_83)
					local var0_83 = var0_82.awards

					if #var0_83 > 0 then
						if arg0_82.viewComponent then
							arg0_82.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_83, arg0_83)
						else
							arg0_82:emit(BaseUI.ON_ACHIEVE, var0_83, arg0_83)
						end
					else
						arg0_83()
					end
				end
			}

			seriesAsync(var1_82, function()
				arg0_82.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.ACTIVITY_PERMANENT_START_DONE] = function(arg0_85, arg1_85)
			local var0_85 = arg1_85:getBody()

			arg0_85.viewComponent:verifyTabs(var0_85.id)
		end,
		[GAME.ACTIVITY_PERMANENT_FINISH_DONE] = function(arg0_86, arg1_86)
			local var0_86 = arg1_86:getBody()

			arg0_86.viewComponent:emit(ActivityMediator.ACTIVITY_PERMANENT, var0_86.activity_id)
		end,
		[GAME.MEMORYBOOK_UNLOCK_AWARD_DONE] = function(arg0_87, arg1_87)
			local var0_87 = arg1_87:getBody()

			arg0_87.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_87.awards)
		end,
		[GAME.LOAD_LAYERS] = function(arg0_88, arg1_88)
			local var0_88 = arg1_88:getBody()

			arg0_88.viewComponent:loadLayers()
		end,
		[GAME.CHARGE_SUCCESS] = function(arg0_89, arg1_89)
			local var0_89 = arg1_89:getBody()

			arg0_89.viewComponent:updateTaskLayers()

			local var1_89 = Goods.Create({
				shop_id = var0_89.shopId
			}, Goods.TYPE_CHARGE)

			arg0_89.viewComponent:OnChargeSuccess(var1_89)
		end,
		[GAME.SHOPPING_DONE] = function(arg0_90, arg1_90)
			local var0_90 = arg1_90:getBody()

			arg0_90.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_90.awards, function()
				arg0_90.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.ACT_MANUAL_SIGN_DONE] = function(arg0_92, arg1_92)
			local var0_92 = arg1_92:getBody()

			arg0_92.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_92.awards)
		end,
		[ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS] = function(arg0_93, arg1_93)
			local var0_93 = arg1_93:getBody()

			arg0_93.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_93.awards, function()
				local var0_94 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE)

				if var0_94 and not var0_94:isShow() and var0_94:isCorePage(arg0_93.contextData.coreName) then
					arg0_93.viewComponent:removeActivity(var0_94.id)
				end

				arg0_93.viewComponent:updateTaskLayers()
				existCall(var0_93.callback)
			end)
		end
	}
end

function var0_0.showNextActivity(arg0_95, arg1_95)
	local var0_95 = getProxy(ActivityProxy)

	if not var0_95 then
		return
	end

	local var1_95 = var0_95:findNextAutoActivity(arg1_95)

	if var1_95 then
		if var1_95.id == ActivityConst.BLACK_FRIDAY_SIGNIN_ACT_ID then
			arg0_95.contextData.showByNextAct = true

			arg0_95.viewComponent:verifyTabs(ActivityConst.BLACK_FRIDAY_ACT_ID)
		else
			arg0_95.viewComponent:verifyTabs(var1_95.id)
		end

		local var2_95 = var1_95:getConfig("type")

		if var2_95 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
			arg0_95:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = var1_95.id
			})
		elseif var2_95 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
			local var3_95 = var1_95:getSpecialData("reMonthSignDay") ~= nil and 3 or 1

			arg0_95:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = var1_95.id,
				cmd = var3_95,
				arg1 = var1_95:getSpecialData("reMonthSignDay")
			})
		elseif var2_95 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
			arg0_95:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = var1_95.id,
				cmd = var1_95.data1 < 7 and 1 or 2
			})
		elseif var1_95.id == ActivityConst.SHADOW_PLAY_ID then
			var1_95.clientData1 = 1

			arg0_95:showNextActivity(arg1_95)
		end
	elseif not arg0_95.viewComponent.activity then
		local var4_95 = arg0_95:getDisplayActivity()
		local var5_95 = arg0_95.contextData.id or arg0_95.contextData.type and checkExist(_.detect(var4_95, function(arg0_96)
			return arg0_96:getConfig("type") == arg0_95.contextData.type
		end), {
			"id"
		}) or 0

		arg0_95.viewComponent:verifyTabs(var5_95)
	end
end

return var0_0
