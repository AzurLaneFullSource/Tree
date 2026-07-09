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
var0_0.ON_COLLAB_BOSSRUSH_MAP = "ActivityMediator.ON_COLLAB_BOSSRUSH_MAP"
var0_0.OPEN_CULTIVATING_PLANT = "ActivityMediator.OPEN_CULTIVATING_PLANT"

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
	arg0_1:bind(var0_0.ON_COLLAB_BOSSRUSH_MAP, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_DAL_COLLAB)
	end)
	arg0_1:bind(var0_0.ON_BOSSRUSH_MAP, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BOSSRUSH_MAIN)
	end)
	arg0_1:bind(var0_0.GO_DECODE_MINI_GAME, function(arg0_8)
		pg.m02:sendNotification(GAME.REQUEST_MINI_GAME, {
			type = MiniGameRequestCommand.REQUEST_HUB_DATA,
			callback = function()
				pg.m02:sendNotification(GAME.GO_MINI_GAME, 11)
			end
		})
	end)
	arg0_1:bind(var0_0.GO_MINI_GAME, function(arg0_10, arg1_10)
		pg.m02:sendNotification(GAME.GO_MINI_GAME, arg1_10)
	end)
	arg0_1:bind(var0_0.GO_SUBMARINE_RUN, function(arg0_11, arg1_11)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SUBMARINE_RUN,
			stageId = arg1_11
		})
	end)
	arg0_1:bind(var0_0.GO_DODGEM, function(arg0_12)
		local var0_12 = ys.Battle.BattleConfig.BATTLE_DODGEM_STAGES[math.random(#ys.Battle.BattleConfig.BATTLE_DODGEM_STAGES)]

		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_DODGEM,
			stageId = var0_12
		})
	end)
	arg0_1:bind(var0_0.ON_SIMULATION_COMBAT, function(arg0_13, arg1_13, arg2_13)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SIMULATION,
			stageId = arg1_13.stageId,
			warnMsg = arg1_13.warnMsg,
			exitCallback = arg2_13
		})
	end)
	arg0_1:bind(var0_0.ON_AIRFIGHT_COMBAT, function(arg0_14, arg1_14, arg2_14)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_AIRFIGHT,
			stageId = arg1_14.stageId,
			exitCallback = arg2_14
		})
	end)
	arg0_1:bind(var0_0.RETURN_AWARD_OP, function(arg0_15, arg1_15)
		if arg1_15.cmd == ActivityConst.RETURN_AWARD_OP_SHOW_AWARD_OVERVIEW then
			arg0_1.viewComponent:ShowWindow(ReturnerAwardWindow, arg1_15.arg1)
		elseif arg1_15.cmd == ActivityConst.RETURN_AWARD_OP_SHOW_RETURNER_AWARD_OVERVIEW then
			arg0_1.viewComponent:ShowWindow(TaskAwardWindow, arg1_15.arg1)
		else
			arg0_1:sendNotification(GAME.RETURN_AWARD_OP, arg1_15)
		end
	end)
	arg0_1:bind(var0_0.SHOW_AWARD_WINDOW, function(arg0_16, arg1_16, arg2_16)
		arg0_1.viewComponent:ShowWindow(arg1_16, arg2_16)
	end)
	arg0_1:bind(var0_0.EVENT_PT_OPERATION, function(arg0_17, arg1_17)
		arg0_1:sendNotification(GAME.ACT_NEW_PT, arg1_17)
	end)
	arg0_1:bind(var0_0.OPEN_LAYER, function(arg0_18, arg1_18)
		arg0_1:addSubLayers(arg1_18)
	end)
	arg0_1:bind(var0_0.OPEN_RED_PACKET_LAYER, function(arg0_19)
		arg0_1:addSubLayers(Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_LAYER, function(arg0_20, arg1_20)
		local var0_20 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg1_20)

		if var0_20 then
			arg0_1:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_20
			})
		end
	end)
	arg0_1:bind(var0_0.EVENT_OPERATION, function(arg0_21, arg1_21)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_21)
	end)
	arg0_1:bind(var0_0.EVENT_GO_SCENE, function(arg0_22, arg1_22, arg2_22)
		if arg1_22 == SCENE.SUMMER_FEAST then
			pg.NewStoryMgr.GetInstance():Play("TIANHOUYUYI1", function()
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SUMMER_FEAST)
			end)
		else
			arg0_1:sendNotification(GAME.GO_SCENE, arg1_22, arg2_22)
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
	arg0_1:bind(var0_0.GO_SHOPS_LAYER, function(arg0_26, arg1_26)
		if not getProxy(ActivityProxy):getActivityById(arg1_26.actId) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1_26 or {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0_1:bind(var0_0.GO_SHOPS_LAYER_STEEET, function(arg0_27, arg1_27)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1_27 or {
			warp = NewShopsScene.TYPE_SHOP_STREET
		})
	end)
	arg0_1:bind(var0_0.BATTLE_OPERA, function()
		local var0_28 = getProxy(ChapterProxy)
		local var1_28, var2_28 = var0_28:getLastMapForActivity()

		if not var1_28 or not var0_28:getMapById(var1_28):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_28,
				mapIdx = var1_28
			})
		end
	end)
	arg0_1:bind(var0_0.SKIP_ACTIVITY_MAP, function(arg0_29, arg1_29)
		local var0_29 = getProxy(ChapterProxy)
		local var1_29, var2_29 = var0_29:getLastMapForActivity(arg1_29)

		if not var1_29 or not var0_29:getMapById(var1_29):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_29,
				mapIdx = var1_29
			})
		end
	end)
	arg0_1:bind(var0_0.OPEN_MINI_PROGRAM, function(arg0_30)
		pg.SdkMgr.GetInstance():OpenMiniProgram()
	end)
	arg0_1:bind(var0_0.OPEN_CULTIVATING_PLANT, function(arg0_31)
		arg0_1:addSubLayers(Context.New({
			mediator = CultivatingPlantMediator,
			viewComponent = CultivatingPlantScene
		}))
	end)
	arg0_1:bind(var0_0.GO_SPECIAL_EXERCISE, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACT_BOSS_BATTLE)
	end)
	arg0_1:bind(var0_0.SPECIAL_BATTLE_OPERA, function()
		local var0_33 = getProxy(ChapterProxy)
		local var1_33, var2_33 = var0_33:getLastMapForActivity()

		if not var1_33 or not var0_33:getMapById(var1_33):isUnlock() then
			local var3_33 = getProxy(ChapterProxy)
			local var4_33 = var3_33:getActiveChapter()

			var1_33 = var4_33 and var4_33:getConfig("map")

			if not var4_33 then
				var1_33 = var3_33:GetLastNormalMap()
			end

			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var4_33 and var4_33.id,
				mapIdx = var1_33
			})
		else
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_33,
				mapIdx = var1_33
			})
		end
	end)
	arg0_1:bind(var0_0.ON_ADD_SUBLAYER, function(arg0_34, arg1_34)
		arg0_1:addSubLayers(arg1_34)
	end)
	arg0_1:bind(var0_0.GO_LOTTERY, function(arg0_35)
		local var0_35 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY)

		arg0_1:addSubLayers(Context.New({
			mediator = LotteryMediator,
			viewComponent = LotteryLayer,
			data = {
				activityId = var0_35.id
			}
		}))
	end)
	arg0_1:bind(var0_0.GO_BACKYARD, function(arg0_36)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD)
	end)
	arg0_1:bind(var0_0.EVENT_COLORING_ACHIEVE, function(arg0_37, arg1_37)
		arg0_1:sendNotification(GAME.COLORING_ACHIEVE, arg1_37)
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_38, arg1_38, arg2_38)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_38.id, arg2_38)
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT_ONESTEP, function(arg0_39, arg1_39)
		arg0_1:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = arg1_39
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_40, arg1_40)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_40
		})
	end)
	arg0_1:bind(var0_0.GO_PRAY_POOL, function(arg0_41)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT, {
			goToPray = true
		})
	end)
	arg0_1:bind(var0_0.FETCH_INSTARGRAM, function(arg0_42, ...)
		arg0_1:sendNotification(GAME.ACT_INSTAGRAM_FETCH, ...)
	end)
	arg0_1:bind(var0_0.MUSIC_GAME_OPERATOR, function(arg0_43, ...)
		arg0_1:sendNotification(GAME.SEND_MINI_GAME_OP, ...)
	end)
	arg0_1:bind(var0_0.SELECT_ACTIVITY, function(arg0_44, arg1_44)
		arg0_1.viewComponent:verifyTabs(arg1_44)
	end)
	arg0_1:bind(var0_0.SHOW_NEXT_ACTIVITY, function(arg0_45, arg1_45)
		arg0_1:showNextActivity(arg1_45)
	end)
	arg0_1:bind(var0_0.ACTIVITY_PERMANENT, function(arg0_46, arg1_46)
		if PlayerPrefs.GetString("permanent_time", "") ~= pg.gameset.permanent_mark.description then
			PlayerPrefs.SetString("permanent_time", pg.gameset.permanent_mark.description)
			arg0_1.viewComponent:updateEntrances()
		end

		local var0_46 = getProxy(ActivityPermanentProxy):getDoingActivity(ActivityPermanentProxy.TYPE_NORMAL_ACTIVITY)

		if var0_46 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("activity_permanent_tips3"))
			arg0_1.viewComponent:verifyTabs(var0_46.id)
		else
			arg0_1:addSubLayers(Context.New({
				mediator = ActivityPermanentMediator,
				viewComponent = ActivityPermanentLayer,
				data = {
					finishId = arg1_46
				}
			}))
		end
	end)
	arg0_1:bind(var0_0.FINISH_ACTIVITY_PERMANENT, function(arg0_47)
		local var0_47 = getProxy(ActivityPermanentProxy):getDoingActivity(ActivityPermanentProxy.TYPE_NORMAL_ACTIVITY)

		assert(var0_47:canPermanentFinish(), "error permanent activity finish")
		arg0_1:sendNotification(GAME.ACTIVITY_PERMANENT_FINISH, {
			activity_id = var0_47.id
		})
	end)
	arg0_1:bind(var0_0.GO_PERFORM_COMBAT, function(arg0_48, arg1_48, arg2_48)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1_48.stageId,
			memory = arg1_48.memory
		})
	end)
	arg0_1:bind(var0_0.NEXT_DISPLAY_AWARD, function(arg0_49, arg1_49, arg2_49)
		arg0_1.nextDisplayAwards = arg1_49
	end)
	arg0_1:bind(var0_0.GO_CARDPUZZLE_COMBAT, function(arg0_50, arg1_50)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_CARDPUZZLE,
			combatID = arg1_50
		})
	end)
	arg0_1:bind(var0_0.CHARGE, function(arg0_51, arg1_51)
		arg0_1:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg1_51
		})
	end)
	arg0_1:bind(var0_0.BUY_ITEM, function(arg0_52, arg1_52, arg2_52)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_52,
			count = arg2_52
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_ITEM_PANEL, function(arg0_53, arg1_53)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeItemPanelMediator,
			viewComponent = ChargeItemPanelLayer,
			data = {
				panelConfig = arg1_53
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CHARGE_BIRTHDAY, function(arg0_54, arg1_54)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
	arg0_1:bind(var0_0.STORE_DATE, function(arg0_55, arg1_55)
		arg0_1:sendNotification(GAME.ACTIVITY_STORE_DATE, {
			activity_id = arg1_55.actId,
			intValue = arg1_55.intValue or 0,
			strValue = arg1_55.strValue or "",
			callback = arg1_55.callback
		})
	end)
	arg0_1:bind(var0_0.ON_ACT_SHOPPING, function(arg0_56, arg1_56, arg2_56, arg3_56, arg4_56, arg5_56)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = arg1_56,
			cmd = arg2_56,
			arg1 = arg3_56,
			arg2 = arg4_56,
			callback = arg5_56
		})
	end)
	arg0_1:bind(var0_0.ON_ACTIVITY_TASK_SUBMIT, function(arg0_57, arg1_57)
		arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_57.activityId,
			task_ids = {
				arg1_57.id
			}
		})
	end)
	arg0_1:bind(var0_0.ON_ACTIVITY_TASK_LIST_SUBMIT, function(arg0_58, arg1_58)
		arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_58.activityId,
			task_ids = arg1_58.ids
		})
	end)
	arg0_1:bind(var0_0.GO_SINGLE_PRECOMBAT, function(arg0_59, arg1_59)
		arg0_1:addSubLayers(Context.New({
			mediator = BossSinglePreCombatLiteMediator,
			viewComponent = BossSinglePreCombatLiteLayer,
			data = {
				system = arg1_59.system,
				stageId = arg1_59.stageId,
				actId = arg1_59.activityID,
				fleets = arg1_59.fleets
			}
		}))
	end)
	arg0_1.viewComponent:setActivities(arg0_1:getDisplayActivity())

	local var0_1 = getProxy(PlayerProxy):getRawData()

	arg0_1.viewComponent:setPlayer(var0_1)

	local var1_1 = getProxy(BayProxy):getShipById(var0_1.character)

	arg0_1.viewComponent:setFlagShip(var1_1)
end

function var0_0.getDisplayActivity(arg0_60)
	return getProxy(ActivityProxy):getPanelActivities()
end

function var0_0.initNotificationHandleDic(arg0_61)
	arg0_61.handleDic = {
		[GAME.SURVEY_DONE] = function(arg0_62, arg1_62)
			local var0_62 = arg1_62:getBody()

			arg0_62.viewComponent:removeActivity(var0_62.id)
		end,
		[ActivityProxy.ACTIVITY_ADDED] = function(arg0_63, arg1_63)
			local var0_63 = arg1_63:getBody()

			if var0_63:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY then
				return
			end

			arg0_63.viewComponent:updateActivity(var0_63)

			if ActivityConst.AOERLIANG_TASK_ID == var0_63.id then
				arg0_63.viewComponent:update_task_list_auto_aoerliang(var0_63)
			end
		end,
		[ActivityProxy.ACTIVITY_UPDATED] = function(...)
			arg0_61.handleDic[ActivityProxy.ACTIVITY_ADDED](...)
		end,
		[ActivityProxy.ACTIVITY_DELETED] = function(arg0_65, arg1_65)
			local var0_65 = arg1_65:getBody()

			arg0_65.viewComponent:removeActivity(var0_65)
		end,
		[ActivityProxy.ACTIVITY_OPERATION_DONE] = function(arg0_66, arg1_66)
			local var0_66 = arg1_66:getBody()
			local var1_66 = getProxy(ActivityProxy):getActivityById(var0_66)

			if var1_66:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
				arg0_66.viewComponent:updateActivity()
			end

			if MonthSignPage.ShouldPlaySpEffect(var1_66) then
				local var2_66 = arg0_66.viewComponent.pageDic[var1_66.id]

				if var2_66 then
					var2_66:ActionInvoke("TryShowSpEffect", function()
						arg0_66:showNextActivity(var1_66:getConfig("page_core"))
					end)

					return
				end
			end

			if ActivityConst.AOERLIANG_TASK_ID == var0_66 then
				return
			end

			arg0_66:showNextActivity(var1_66:getConfig("page_core"))
		end,
		[ActivityProxy.ACTIVITY_SHOW_AWARDS] = function(arg0_68, arg1_68)
			local var0_68 = arg1_68:getBody()
			local var1_68 = var0_68.awards

			if arg0_68.nextDisplayAwards and #arg0_68.nextDisplayAwards > 0 then
				for iter0_68 = 1, #arg0_68.nextDisplayAwards do
					table.insert(var1_68, arg0_68.nextDisplayAwards[iter0_68])
				end
			end

			arg0_68.nextDisplayAwards = {}

			arg0_68.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_68, var0_68.callback)
		end,
		[ActivityProxy.ACTIVITY_SHOW_BB_RESULT] = function(arg0_69, arg1_69)
			local var0_69 = arg1_69:getBody()

			arg0_69.viewComponent:emit(ActivityMediator.ON_BOBING_RESULT, var0_69)
		end,
		[ActivityProxy.ACTIVITY_SHOW_LOTTERY_AWARD_RESULT] = function(arg0_70, arg1_70)
			local var0_70 = arg1_70:getBody()
			local var1_70 = var0_70.activityID

			arg0_70.viewComponent.pageDic[var1_70]:showLotteryAwardResult(var0_70.awards, var0_70.number, var0_70.callback)
		end,
		[ActivityProxy.ACTIVITY_SHOW_SHAKE_BEADS_RESULT] = function(arg0_71, arg1_71)
			local var0_71 = arg1_71:getBody()

			arg0_71.viewComponent:emit(ActivityMediator.ON_SHAKE_BEADS_RESULT, var0_71)
		end,
		[GAME.SUBMIT_TASK_DONE] = function(arg0_72, arg1_72)
			local var0_72 = arg1_72:getBody()

			arg0_72.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_72, function()
				arg0_72.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.SUBMIT_ACTIVITY_TASK_DONE] = function(arg0_74, arg1_74)
			local var0_74 = arg1_74:getBody()

			arg0_74.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_74.awards, function()
				arg0_74.viewComponent:checkAutoHideActivity()
				arg0_74.viewComponent:updateTaskLayers()
				existCall(var0_74.callback)
			end)
		end,
		[GAME.ACT_NEW_PT_DONE] = function(arg0_76, arg1_76)
			local var0_76 = arg1_76:getBody()

			arg0_76.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_76.awards, function()
				arg0_76.viewComponent:updateTaskLayers()
				existCall(var0_76.callback)
			end)
		end,
		[GAME.BEGIN_STAGE_DONE] = function(arg0_78, arg1_78)
			local var0_78 = arg1_78:getBody()

			arg0_78:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var0_78)
		end,
		[GAME.RETURN_AWARD_OP_DONE] = function(arg0_79, arg1_79)
			local var0_79 = arg1_79:getBody()

			arg0_79.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_79.awards)
		end,
		[VoteProxy.VOTE_ORDER_BOOK_DELETE] = function(arg0_80, arg1_80)
			return
		end,
		[VoteProxy.VOTE_ORDER_BOOK_UPDATE] = function(...)
			arg0_61.handleDic[VoteProxy.VOTE_ORDER_BOOK_DELETE](...)
		end,
		[GAME.REMOVE_LAYERS] = function(arg0_82, arg1_82)
			if arg1_82:getBody().context.mediator == VoteFameHallMediator then
				arg0_82.viewComponent:updateEntrances()
			end
		end,
		[GAME.MONOPOLY_AWARD_DONE] = function(arg0_83, arg1_83)
			local var0_83 = arg1_83:getBody()
			local var1_83 = arg0_83.viewComponent.pageDic[arg0_83.viewComponent.activity.id]

			if var1_83 and var1_83.activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MONOPOLY and var1_83.onAward then
				var1_83:onAward(var0_83.awards, var0_83.callback)
			elseif var0_83.autoFlag then
				arg0_83.viewComponent:emit(BaseUI.ON_ACHIEVE_AUTO, var0_83.awards, 1, var0_83.callback)
			else
				arg0_83.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_83.awards, var0_83.callback)
			end
		end,
		[GAME.SEND_MINI_GAME_OP_DONE] = function(arg0_84, arg1_84)
			local var0_84 = arg1_84:getBody()
			local var1_84 = {
				function(arg0_85)
					local var0_85 = var0_84.awards

					if #var0_85 > 0 then
						if arg0_84.viewComponent then
							arg0_84.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_85, arg0_85)
						else
							arg0_84:emit(BaseUI.ON_ACHIEVE, var0_85, arg0_85)
						end
					else
						arg0_85()
					end
				end
			}

			seriesAsync(var1_84, function()
				arg0_84.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.ACTIVITY_PERMANENT_START_DONE] = function(arg0_87, arg1_87)
			local var0_87 = arg1_87:getBody()

			if not getProxy(ActivityPermanentProxy):IsNormalActivityId(var0_87.id) then
				return
			end

			arg0_87.viewComponent:verifyTabs(var0_87.id)
		end,
		[GAME.ACTIVITY_PERMANENT_FINISH_DONE] = function(arg0_88, arg1_88)
			local var0_88 = arg1_88:getBody()

			if not getProxy(ActivityPermanentProxy):IsNormalActivityId(var0_88.activity_id) then
				return
			end

			arg0_88.viewComponent:emit(ActivityMediator.ACTIVITY_PERMANENT, var0_88.activity_id)
		end,
		[GAME.MEMORYBOOK_UNLOCK_AWARD_DONE] = function(arg0_89, arg1_89)
			local var0_89 = arg1_89:getBody()

			arg0_89.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_89.awards)
		end,
		[GAME.CHARGE_SUCCESS] = function(arg0_90, arg1_90)
			local var0_90 = arg1_90:getBody()

			arg0_90.viewComponent:updateTaskLayers()

			local var1_90 = Goods.Create({
				shop_id = var0_90.shopId
			}, Goods.TYPE_CHARGE)

			arg0_90.viewComponent:OnChargeSuccess(var1_90)
		end,
		[GAME.SHOPPING_DONE] = function(arg0_91, arg1_91)
			local var0_91 = arg1_91:getBody()

			warning("yzh")
			arg0_91.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_91.awards, function()
				arg0_91.viewComponent:updateTaskLayers()
			end)
		end,
		[GAME.ACT_MANUAL_SIGN_DONE] = function(arg0_93, arg1_93)
			local var0_93 = arg1_93:getBody()

			arg0_93.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_93.awards)
		end,
		[ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS] = function(arg0_94, arg1_94)
			local var0_94 = arg1_94:getBody()

			arg0_94.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_94.awards, function()
				local var0_95 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_UR_EXCHANGE)

				if var0_95 and not var0_95:isShow() and var0_95:isCorePage(arg0_94.contextData.coreName) then
					arg0_94.viewComponent:removeActivity(var0_95.id)
				end

				arg0_94.viewComponent:updateTaskLayers()
				existCall(var0_94.callback)
			end)
		end
	}
end

function var0_0.showNextActivity(arg0_96, arg1_96)
	local var0_96 = getProxy(ActivityProxy)

	if not var0_96 then
		return
	end

	local var1_96 = var0_96:findNextAutoActivity(arg1_96)

	if var1_96 then
		if var1_96.id == ActivityConst.BLACK_FRIDAY_SIGNIN_ACT_ID then
			arg0_96.contextData.showByNextAct = true

			arg0_96.viewComponent:verifyTabs(ActivityConst.BLACK_FRIDAY_ACT_ID)
		else
			arg0_96.viewComponent:verifyTabs(var1_96.id)
		end

		local var2_96 = var1_96:getConfig("type")

		if var2_96 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
			arg0_96:sendNotification(GAME.ACTIVITY_OPERATION, {
				cmd = 1,
				activity_id = var1_96.id
			})
		elseif var2_96 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
			local var3_96 = var1_96:getSpecialData("reMonthSignDay") ~= nil and 3 or 1

			arg0_96:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = var1_96.id,
				cmd = var3_96,
				arg1 = var1_96:getSpecialData("reMonthSignDay")
			})
		elseif var2_96 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
			arg0_96:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = var1_96.id,
				cmd = var1_96.data1 < 7 and 1 or 2
			})
		elseif var1_96.id == ActivityConst.SHADOW_PLAY_ID then
			var1_96.clientData1 = 1

			arg0_96:showNextActivity(arg1_96)
		end
	elseif not arg0_96.viewComponent.activity then
		local var4_96 = arg0_96:getDisplayActivity()
		local var5_96 = arg0_96.contextData.id or arg0_96.contextData.type and checkExist(_.detect(var4_96, function(arg0_97)
			return arg0_97:getConfig("type") == arg0_96.contextData.type
		end), {
			"id"
		}) or 0

		arg0_96.viewComponent:verifyTabs(var5_96)
	end
end

return var0_0
