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

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SKIP_LOTTERY, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			viewComponent = LotteryLayer,
			mediator = LotteryMediator,
			data = {
				activityId = arg1_2
			}
		}))
	end)
	arg0_1:bind(var0_0.SKIP_INS, function(arg0_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = InstagramMainUI,
			mediator = InstagramMainMediator
		}))
	end)
	arg0_1:bind(var0_0.SKIP_ESCORT, function(arg0_4)
		local var0_4 = getProxy(ChapterProxy)
		local var1_4 = var0_4:getMapsByType(Map.ESCORT)[1]
		local var2_4 = var0_4:getActiveChapter()

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
			chapterId = var2_4 and var2_4:getConfig("map") == var1_4.id and var2_4.id or nil,
			mapIdx = var1_4.id
		})
	end)
	arg0_1:bind(var0_0.SKIP_ACTIVITY_MAP, function(arg0_5, arg1_5)
		local var0_5 = getProxy(ChapterProxy)
		local var1_5, var2_5 = var0_5:getLastMapForActivity(arg1_5)

		if not var1_5 or not var0_5:getMapById(var1_5):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_5,
				mapIdx = var1_5
			})
		end
	end)
	arg0_1:bind(var0_0.SKIP_SHOP, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = arg1_6 or NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0_1:bind(var0_0.SKIP_ACTIVITY, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg1_7
		})
	end)
	arg0_1:bind(var0_0.SKIP_CORE_ACTIVITY, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CORE_ACTIVITY, {
			coreName = arg1_8
		})
	end)
	arg0_1:bind(var0_0.SKIP_SCENE, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_9[1], arg1_9[2])
	end)
	arg0_1:bind(var0_0.GO_MINI_GAME, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.GO_MINI_GAME, arg1_10)
	end)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_11, arg1_11, arg2_11)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_11, arg2_11)
	end)
	arg0_1:bind(var0_0.GO_SNAPSHOT, function(arg0_12)
		local var0_12 = arg0_1.viewComponent.bgView.ship
		local var1_12 = var0_12:getSkinId()
		local var2_12 = arg0_1.viewComponent.paintingView:IsLive2DState()
		local var3_12

		if isa(var0_12, VirtualEducateCharShip) then
			var3_12 = var0_12.educateCharId
			var2_12 = false
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SNAPSHOT, {
			skinId = var1_12,
			live2d = var2_12,
			tbId = var3_12,
			propose = var0_12.propose
		})
	end)
	arg0_1:bind(var0_0.OPEN_MAIL, function(arg0_13)
		if BATTLE_DEBUG then
			arg0_1:sendNotification(GAME.BEGIN_STAGE, {
				system = SYSTEM_DEBUG
			})
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.MAIL)
		end
	end)
	arg0_1:bind(var0_0.OPEN_Compensate, function(arg0_14)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.Compensate)
	end)
	arg0_1:bind(var0_0.OPEN_NOTICE, function(arg0_15)
		arg0_1:addSubLayers(Context.New({
			mediator = NewBulletinBoardMediator,
			viewComponent = NewBulletinBoardLayer
		}))
	end)
	arg0_1:bind(var0_0.OPEN_COMMISION, function(arg0_16)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CommissionInfoLayer,
			mediator = CommissionInfoMediator
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CHATVIEW, function(arg0_17)
		arg0_1:addSubLayers(Context.New({
			viewComponent = NotificationLayer,
			mediator = NotificationMediator,
			data = {
				form = NotificationLayer.FORM_MAIN
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_KINK_BUTTON_LAYER, function(arg0_18, arg1_18)
		arg0_1:addSubLayers(arg1_18)
	end)
	arg0_1:bind(var0_0.CHANGE_SKIN_TOGGLE, function(arg0_19, arg1_19)
		arg0_1:sendNotification(GAME.CHANGE_SKIN_AB, arg1_19)
	end)
	arg0_1:bind(var0_0.DEBUG_BATTLE_LOOP, function(arg0_20, arg1_20)
		arg0_1:sendNotification(GAME.SEND_CMD, {
			cmd = "into",
			arg1 = arg1_20
		})
	end)
end

function var0_0.initNotificationHandleDic(arg0_21)
	arg0_21.handleDic = {
		[GAME.ON_OPEN_INS_LAYER] = function(arg0_22, arg1_22)
			arg0_22.viewComponent:emit(var0_0.SKIP_INS)
		end,
		[NotificationProxy.FRIEND_REQUEST_ADDED] = function(arg0_23, arg1_23)
			arg0_23.viewComponent:emit(GAME.ANY_CHAT_MSG_UPDATE)
		end,
		[NotificationProxy.FRIEND_REQUEST_REMOVED] = NotificationProxy.FRIEND_REQUEST_ADDED,
		[FriendProxy.FRIEND_NEW_MSG] = NotificationProxy.FRIEND_REQUEST_ADDED,
		[FriendProxy.FRIEND_UPDATED] = NotificationProxy.FRIEND_REQUEST_ADDED,
		[ChatProxy.NEW_MSG] = NotificationProxy.FRIEND_REQUEST_ADDED,
		[GuildProxy.NEW_MSG_ADDED] = NotificationProxy.FRIEND_REQUEST_ADDED,
		[GAME.GET_GUILD_INFO_DONE] = NotificationProxy.FRIEND_REQUEST_ADDED,
		[GAME.GET_GUILD_CHAT_LIST_DONE] = NotificationProxy.FRIEND_REQUEST_ADDED,
		[GAME.BEGIN_STAGE_DONE] = function(arg0_24, arg1_24)
			arg0_24:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, arg1_24:getBody())
		end,
		[ChapterProxy.CHAPTER_TIMESUP] = function(arg0_25, arg1_25)
			MainChapterTimeUpSequence.New():Execute()
		end,
		[TechnologyConst.UPDATE_REDPOINT_ON_TOP] = function(arg0_26, arg1_26)
			MainTechnologySequence.New():Execute(function()
				return
			end)
		end,
		[GAME.FETCH_NPC_SHIP_DONE] = function(arg0_28, arg1_28)
			local var0_28 = arg1_28:getBody()

			arg0_28.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_28.items, var0_28.callback)
		end,
		[GAME.FETCH_NPC_SHIP_ACTIVITY_DONE] = GAME.FETCH_NPC_SHIP_DONE,
		[var0_0.REFRESH_VIEW] = function(arg0_29, arg1_29)
			arg0_29.viewComponent:setVisible(false)
			arg0_29.viewComponent:setVisible(true)
		end,
		[GAME.CONFIRM_GET_SHIP] = function(arg0_30, arg1_30)
			local var0_30 = arg1_30:getBody()

			arg0_30:addSubLayers(Context.New({
				mediator = BuildShipRemindMediator,
				viewComponent = BuildShipRemindLayer,
				data = {
					ships = var0_30.ships
				},
				onRemoved = var0_30.callback
			}))
		end,
		[GAME.CHANGE_LIVINGAREA_COVER_DONE] = function(arg0_31, arg1_31)
			arg0_31.viewComponent:emit(NewMainScene.UPDATE_COVER)
		end,
		[GAME.ACT_INSTAGRAM_CHAT_DONE] = function(arg0_32, arg1_32)
			if arg1_32:getBody().operation == ActivityConst.INSTAGRAM_CHAT_ACTIVATE_TOPIC then
				local var0_32 = arg0_32.viewComponent:GetFlagShip()

				if arg0_32.viewComponent.theme then
					arg0_32.viewComponent.theme:Refresh(var0_32)
				end
			end
		end,
		[NewMainMediator.ON_DROP] = function(arg0_33, arg1_33)
			arg0_33.viewComponent:emit(BaseUI.ON_DROP, arg1_33:getBody())
		end,
		[NewMainMediator.ON_AWRADS] = function(arg0_34, arg1_34)
			local var0_34 = arg1_34:getBody()

			arg0_34.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_34.items, var0_34.callback)
		end,
		[GAME.PLAY_CHANGE_SKIN_OUT] = function(arg0_35, arg1_35)
			arg0_35.viewComponent:SetEffectPanelVisible(false)
			arg0_35.viewComponent:HidePanel(true)
			arg0_35.viewComponent:PlayChangeSkinActionOut(arg1_35:getBody())
		end,
		[GAME.PLAY_CHANGE_SKIN_IN] = function(arg0_36, arg1_36)
			arg0_36.viewComponent:PlayChangeSkinActionIn(arg1_36:getBody())
		end,
		[GAME.PLAY_CHANGE_SKIN_FINISH] = function(arg0_37, arg1_37)
			arg0_37.viewComponent:SetEffectPanelVisible(true)
			arg0_37.viewComponent:HidePanel(false)
		end,
		[GAME.CHANGE_SKIN_EXCHANGE] = function(arg0_38, arg1_38)
			local var0_38 = arg1_38:getBody()
			local var1_38 = var0_38.asmr and true or false
			local var2_38 = arg0_38.viewComponent:GetFlagShip()

			if arg0_38.viewComponent then
				arg0_38.viewComponent:UpdateFlagShip(var2_38, var0_38)
			end

			arg0_38.viewComponent:AsmrTurning(var1_38)
		end,
		[MusicPlayer.NO_PLAY_MUSIC_NOTIFICATION] = function(arg0_39, arg1_39)
			arg0_39.viewComponent:CheckAndReplayBgm()
		end,
		[NewMainMediator.FOLD_PANEL] = function(arg0_40, arg1_40)
			arg0_40.viewComponent:FoldPanels(arg1_40:getBody())
		end,
		[NewMainMediator.HIDE_PANEL] = function(arg0_41, arg1_41)
			arg0_41.viewComponent:HidePanel(arg1_41:getBody())
		end,
		[GAME.SERIES_GUIDE_END] = function(arg0_42, arg1_42)
			MainAwakeGuideSequence.New():Execute(function()
				return
			end)
		end,
		[var0_0.DEBUG_BATTLE_LOOP] = function(arg0_44, arg1_44)
			local var0_44 = arg1_44:getBody()

			arg0_44:BuildDebugBattleLoop(var0_44)
		end,
		[GAME.REMOVE_LAYERS] = function(arg0_45, arg1_45)
			local var0_45 = arg1_45:getBody().context

			arg0_45.viewComponent:emit(NewMainMediator.REMOVE_LAYERS, arg1_45:getBody())
		end,
		[PlayerProxy.UPDATED] = function(arg0_46, arg1_46)
			arg0_46.viewComponent:OnPlayerUpdated()
		end,
		[ActivityProxy.UPDATED_TIP] = function(arg0_47, arg1_47)
			arg0_47.viewComponent:emit(MainBaseActivityBtn.UPDATED_TIP)
		end
	}
end

function var0_0.BuildDebugBattleLoop(arg0_48, arg1_48)
	if not IsUnityEditor then
		return
	end

	local var0_48 = {}

	for iter0_48, iter1_48 in arg1_48:gmatch("%s+(%S+)") do
		table.insert(var0_48, iter0_48)
	end

	local var1_48 = {
		loopCount = tonumber(var0_48[2]),
		loopStages = underscore.rest(var0_48, 3),
		tempList = {}
	}

	_G.InDebugBattleLoop = var1_48

	arg0_48.viewComponent:CheckDebugBattleLoop()
end

return var0_0
