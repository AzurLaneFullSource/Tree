local var0_0 = class("NewMainMediator", import("..base.ContextMediator"))

var0_0.GO_SCENE = "NewMainMediator.GO_SCENE"
var0_0.OPEN_MAIL = "NewMainMediator.OPEN_MAIL"
var0_0.OPEN_NOTICE = "NewMainMediator.OPEN_NOTICE"
var0_0.GO_SNAPSHOT = "NewMainMediator.GO_SNAPSHOT"
var0_0.OPEN_COMMISION = "NewMainMediator.OPEN_COMMISION"
var0_0.OPEN_CHATVIEW = "NewMainMediator.OPEN_CHATVIEW"
var0_0.SKIP_SCENE = "NewMainMediator.SKIP_SCENE"
var0_0.SKIP_ACTIVITY = "NewMainMediator.SKIP_ACTIVITY"
var0_0.SKIP_CORE_ACTIVITY = "NewMainMediator.SKIP_CORE_ACTIVITY"
var0_0.SKIP_SHOP = "NewMainMediator.SKIP_SHOP"
var0_0.GO_MINI_GAME = "NewMainMediator.GO_MINI_GAME"
var0_0.SKIP_ACTIVITY_MAP = "NewMainMediator.SKIP_ACTIVITY_MAP"
var0_0.SKIP_ESCORT = "NewMainMediator.SKIP_ESCORT"
var0_0.SKIP_INS = "NewMainMediator.SKIP_INS"
var0_0.SKIP_LOTTERY = "NewMainMediator.SKIP_LOTTERY"
var0_0.GO_SINGLE_ACTIVITY = "NewMainMediator.GO_SINGLE_ACTIVITY"
var0_0.REFRESH_VIEW = "NewMainMediator.REFRESH_VIEW"
var0_0.OPEN_KINK_BUTTON_LAYER = "NewMainMediator.OPEN_KINK_BUTTON_LAYER"
var0_0.OPEN_Compensate = "NewMainMediator.OPEN_Compensate"
var0_0.ON_DROP = "NewMainMediator.ON_DROP"
var0_0.ON_AWRADS = "NewMainMediator.ON_AWRADS"
var0_0.CHANGE_SKIN_TOGGLE = "NewMainMediator.CHANGE_SKIN_TOGGLE"
var0_0.FOLD_PANEL = "NewMainMediator.FOLD_PANEL"
var0_0.HIDE_PANEL = "NewMainMediator.HIDE_PANEL"
var0_0.REMOVE_LAYERS = "NewMainMediator.REMOVE_LAYERS"
var0_0.DEBUG_BATTLE_LOOP = "NewMainMediator.DEBUG_BATTLE_LOOP"
var0_0.OPEN_ACT_REMASTER_SCENE = "NewMainMediator.OPEN_ACT_REMASTER_SCENE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_ACT_REMASTER_SCENE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ACTREMASTE)
	end)
	arg0_1:bind(var0_0.SKIP_LOTTERY, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = LotteryLayer,
			mediator = LotteryMediator,
			data = {
				activityId = arg1_3
			}
		}))
	end)
	arg0_1:bind(var0_0.SKIP_INS, function(arg0_4)
		arg0_1:addSubLayers(Context.New({
			viewComponent = InstagramMainUI,
			mediator = InstagramMainMediator
		}))
	end)
	arg0_1:bind(var0_0.SKIP_ESCORT, function(arg0_5)
		local var0_5 = getProxy(ChapterProxy)
		local var1_5 = var0_5:getMapsByType(Map.ESCORT)[1]
		local var2_5 = var0_5:getActiveChapter()

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
			chapterId = var2_5 and var2_5:getConfig("map") == var1_5.id and var2_5.id or nil,
			mapIdx = var1_5.id
		})
	end)
	arg0_1:bind(var0_0.SKIP_ACTIVITY_MAP, function(arg0_6, arg1_6)
		local var0_6 = getProxy(ChapterProxy)
		local var1_6, var2_6 = var0_6:getLastMapForActivity(arg1_6)

		if not var1_6 or not var0_6:getMapById(var1_6):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_6,
				mapIdx = var1_6
			})
		end
	end)
	arg0_1:bind(var0_0.SKIP_SHOP, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = arg1_7 or NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0_1:bind(var0_0.SKIP_ACTIVITY, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg1_8
		})
	end)
	arg0_1:bind(var0_0.SKIP_CORE_ACTIVITY, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CORE_ACTIVITY, {
			coreName = arg1_9
		})
	end)
	arg0_1:bind(var0_0.SKIP_SCENE, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_10[1], arg1_10[2])
	end)
	arg0_1:bind(var0_0.GO_MINI_GAME, function(arg0_11, arg1_11)
		arg0_1:sendNotification(GAME.GO_MINI_GAME, arg1_11)
	end)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_12, arg1_12, arg2_12)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_12, arg2_12)
	end)
	arg0_1:bind(var0_0.GO_SNAPSHOT, function(arg0_13)
		local var0_13 = arg0_1.viewComponent.bgView.ship
		local var1_13 = var0_13:getSkinId()
		local var2_13 = arg0_1.viewComponent.paintingView:IsLive2DState()
		local var3_13

		if isa(var0_13, VirtualEducateCharShip) then
			var3_13 = var0_13.educateCharId
			var2_13 = false
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SNAPSHOT, {
			skinId = var1_13,
			live2d = var2_13,
			tbId = var3_13,
			propose = var0_13.propose
		})
	end)
	arg0_1:bind(var0_0.OPEN_MAIL, function(arg0_14)
		if BATTLE_DEBUG then
			arg0_1:sendNotification(GAME.BEGIN_STAGE, {
				system = SYSTEM_DEBUG
			})
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.MAIL)
		end
	end)
	arg0_1:bind(var0_0.OPEN_Compensate, function(arg0_15)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.Compensate)
	end)
	arg0_1:bind(var0_0.OPEN_NOTICE, function(arg0_16)
		arg0_1:addSubLayers(Context.New({
			mediator = NewBulletinBoardMediator,
			viewComponent = NewBulletinBoardLayer
		}))
	end)
	arg0_1:bind(var0_0.OPEN_COMMISION, function(arg0_17)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CommissionInfoLayer,
			mediator = CommissionInfoMediator
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CHATVIEW, function(arg0_18)
		arg0_1:addSubLayers(Context.New({
			viewComponent = NotificationLayer,
			mediator = NotificationMediator,
			data = {
				form = NotificationLayer.FORM_MAIN
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_KINK_BUTTON_LAYER, function(arg0_19, arg1_19)
		arg0_1:addSubLayers(arg1_19)
	end)
	arg0_1:bind(var0_0.CHANGE_SKIN_TOGGLE, function(arg0_20, arg1_20)
		arg0_1:sendNotification(GAME.CHANGE_SKIN_AB, arg1_20)
	end)
	arg0_1:bind(var0_0.DEBUG_BATTLE_LOOP, function(arg0_21, arg1_21)
		arg0_1:sendNotification(GAME.SEND_CMD, {
			cmd = "into",
			arg1 = arg1_21
		})
	end)
end

function var0_0.initNotificationHandleDic(arg0_22)
	arg0_22.handleDic = {
		[GAME.ON_OPEN_INS_LAYER] = function(arg0_23, arg1_23)
			arg0_23.viewComponent:emit(var0_0.SKIP_INS)
		end,
		[NotificationProxy.FRIEND_REQUEST_ADDED] = function(arg0_24, arg1_24)
			arg0_24.viewComponent:emit(GAME.ANY_CHAT_MSG_UPDATE)
		end,
		[NotificationProxy.FRIEND_REQUEST_REMOVED] = NotificationProxy.FRIEND_REQUEST_ADDED,
		[FriendProxy.FRIEND_NEW_MSG] = NotificationProxy.FRIEND_REQUEST_ADDED,
		[FriendProxy.FRIEND_UPDATED] = NotificationProxy.FRIEND_REQUEST_ADDED,
		[ChatProxy.NEW_MSG] = NotificationProxy.FRIEND_REQUEST_ADDED,
		[GuildProxy.NEW_MSG_ADDED] = NotificationProxy.FRIEND_REQUEST_ADDED,
		[GAME.GET_GUILD_INFO_DONE] = NotificationProxy.FRIEND_REQUEST_ADDED,
		[GAME.GET_GUILD_CHAT_LIST_DONE] = NotificationProxy.FRIEND_REQUEST_ADDED,
		[GAME.BEGIN_STAGE_DONE] = function(arg0_25, arg1_25)
			arg0_25:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, arg1_25:getBody())
		end,
		[ChapterProxy.CHAPTER_TIMESUP] = function(arg0_26, arg1_26)
			MainChapterTimeUpSequence.New():Execute()
		end,
		[TechnologyConst.UPDATE_REDPOINT_ON_TOP] = function(arg0_27, arg1_27)
			MainTechnologySequence.New():Execute(function()
				return
			end)
		end,
		[GAME.FETCH_NPC_SHIP_DONE] = function(arg0_29, arg1_29)
			local var0_29 = arg1_29:getBody()

			arg0_29.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_29.items, var0_29.callback)
		end,
		[GAME.FETCH_NPC_SHIP_ACTIVITY_DONE] = GAME.FETCH_NPC_SHIP_DONE,
		[var0_0.REFRESH_VIEW] = function(arg0_30, arg1_30)
			arg0_30.viewComponent:setVisible(false)
			arg0_30.viewComponent:setVisible(true)
		end,
		[GAME.CONFIRM_GET_SHIP] = function(arg0_31, arg1_31)
			local var0_31 = arg1_31:getBody()

			arg0_31:addSubLayers(Context.New({
				mediator = BuildShipRemindMediator,
				viewComponent = BuildShipRemindLayer,
				data = {
					ships = var0_31.ships
				},
				onRemoved = var0_31.callback
			}))
		end,
		[GAME.CHANGE_LIVINGAREA_COVER_DONE] = function(arg0_32, arg1_32)
			arg0_32.viewComponent:emit(NewMainScene.UPDATE_COVER)
		end,
		[GAME.ACT_INSTAGRAM_CHAT_DONE] = function(arg0_33, arg1_33)
			if arg1_33:getBody().operation == ActivityConst.INSTAGRAM_CHAT_ACTIVATE_TOPIC then
				local var0_33 = arg0_33.viewComponent:GetFlagShip()

				if arg0_33.viewComponent.theme then
					arg0_33.viewComponent.theme:Refresh(var0_33)
				end
			end
		end,
		[NewMainMediator.ON_DROP] = function(arg0_34, arg1_34)
			arg0_34.viewComponent:emit(BaseUI.ON_DROP, arg1_34:getBody())
		end,
		[NewMainMediator.ON_AWRADS] = function(arg0_35, arg1_35)
			local var0_35 = arg1_35:getBody()

			arg0_35.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_35.items, var0_35.callback)
		end,
		[GAME.PLAY_CHANGE_SKIN_OUT] = function(arg0_36, arg1_36)
			arg0_36.viewComponent:SetEffectPanelVisible(false)
			arg0_36.viewComponent:HidePanel(true)
			arg0_36.viewComponent:PlayChangeSkinActionOut(arg1_36:getBody())
		end,
		[GAME.PLAY_CHANGE_SKIN_IN] = function(arg0_37, arg1_37)
			arg0_37.viewComponent:PlayChangeSkinActionIn(arg1_37:getBody())
		end,
		[GAME.PLAY_CHANGE_SKIN_FINISH] = function(arg0_38, arg1_38)
			arg0_38.viewComponent:SetEffectPanelVisible(true)
			arg0_38.viewComponent:HidePanel(false)
		end,
		[GAME.CHANGE_SKIN_EXCHANGE] = function(arg0_39, arg1_39)
			local var0_39 = arg1_39:getBody()
			local var1_39 = var0_39.asmr and true or false
			local var2_39 = arg0_39.viewComponent:GetFlagShip()

			if arg0_39.viewComponent then
				arg0_39.viewComponent:UpdateFlagShip(var2_39, var0_39)
			end

			arg0_39.viewComponent:AsmrTurning(var1_39)
		end,
		[MusicPlayer.NO_PLAY_MUSIC_NOTIFICATION] = function(arg0_40, arg1_40)
			arg0_40.viewComponent:CheckAndReplayBgm()
		end,
		[NewMainMediator.FOLD_PANEL] = function(arg0_41, arg1_41)
			arg0_41.viewComponent:FoldPanels(arg1_41:getBody())
		end,
		[NewMainMediator.HIDE_PANEL] = function(arg0_42, arg1_42)
			local var0_42 = arg1_42:getBody()

			arg0_42.viewComponent:HidePanel(var0_42.flag, var0_42.content)
		end,
		[GAME.SERIES_GUIDE_END] = function(arg0_43, arg1_43)
			MainAwakeGuideSequence.New():Execute(function()
				return
			end)
		end,
		[var0_0.DEBUG_BATTLE_LOOP] = function(arg0_45, arg1_45)
			local var0_45 = arg1_45:getBody()

			arg0_45:BuildDebugBattleLoop(var0_45)
		end,
		[GAME.REMOVE_LAYERS] = function(arg0_46, arg1_46)
			local var0_46 = arg1_46:getBody().context

			arg0_46.viewComponent:emit(NewMainMediator.REMOVE_LAYERS, arg1_46:getBody())
		end,
		[PlayerProxy.UPDATED] = function(arg0_47, arg1_47)
			arg0_47.viewComponent:OnPlayerUpdated()
		end,
		[GAME.END_REFLUX_CG] = function(arg0_48, arg1_48)
			arg0_48.viewComponent:ShowOrHideBtnEffect(true)
		end,
		[GAME.START_REFLUX_CG] = function(arg0_49, arg1_49)
			arg0_49.viewComponent:ShowOrHideBtnEffect(false)
		end,
		[ActivityProxy.UPDATED_TIP] = function(arg0_50, arg1_50)
			arg0_50.viewComponent:emit(MainBaseActivityBtn.UPDATED_TIP)
		end,
		[MiniGameProxy.ON_HUB_DATA_UPDATE] = function(arg0_51, arg1_51)
			local var0_51 = arg0_51.viewComponent:GetFlagShip()

			if arg0_51.viewComponent.theme and arg0_51.viewComponent.theme:IsLoaded() then
				arg0_51.viewComponent.theme:Refresh(var0_51)
			end
		end,
		[GAME.CRUSING_CMD_DONE] = function(arg0_52, arg1_52)
			local var0_52 = arg1_52:getBody()
			local var1_52 = var0_52.awards
			local var2_52 = var0_52.callback

			arg0_52.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_52, var2_52)
		end
	}
end

function var0_0.BuildDebugBattleLoop(arg0_53, arg1_53)
	if not IsUnityEditor then
		return
	end

	local var0_53 = {}

	for iter0_53, iter1_53 in arg1_53:gmatch("%s+(%S+)") do
		table.insert(var0_53, iter0_53)
	end

	local var1_53 = {
		loopCount = tonumber(var0_53[2]),
		loopStages = underscore.rest(var0_53, 3),
		tempList = {}
	}

	_G.InDebugBattleLoop = var1_53

	arg0_53.viewComponent:CheckDebugBattleLoop()
end

return var0_0
