local var0_0 = class("NewMainMediator", import("..base.ContextMediator"))

var0_0.GO_SCENE = "NewMainMediator:GO_SCENE"
var0_0.OPEN_MAIL = "NewMainMediator:OPEN_MAIL"
var0_0.OPEN_NOTICE = "NewMainMediator:OPEN_NOTICE"
var0_0.GO_SNAPSHOT = "NewMainMediator:GO_SNAPSHOT"
var0_0.OPEN_COMMISION = "NewMainMediator:OPEN_COMMISION"
var0_0.OPEN_CHATVIEW = "NewMainMediator:OPEN_CHATVIEW"
var0_0.SKIP_SCENE = "NewMainMediator:SKIP_SCENE"
var0_0.SKIP_ACTIVITY = "NewMainMediator:SKIP_ACTIVITY"
var0_0.SKIP_SHOP = "NewMainMediator:SKIP_SHOP"
var0_0.GO_MINI_GAME = "NewMainMediator:GO_MINI_GAME"
var0_0.SKIP_ACTIVITY_MAP = "NewMainMediator:SKIP_ACTIVITY_MAP"
var0_0.SKIP_ESCORT = "NewMainMediator:SKIP_ESCORT"
var0_0.SKIP_INS = "NewMainMediator:SKIP_INS"
var0_0.SKIP_LOTTERY = "NewMainMediator:SKIP_LOTTERY"
var0_0.GO_SINGLE_ACTIVITY = "NewMainMediator:GO_SINGLE_ACTIVITY"
var0_0.REFRESH_VIEW = "NewMainMediator:REFRESH_VIEW"
var0_0.OPEN_DORM_SELECT_LAYER = "NewMainMediator.OPEN_DORM_SELECT_LAYER"
var0_0.OPEN_KINK_BUTTON_LAYER = "NewMainMediator.OPEN_KINK_BUTTON_LAYER"
var0_0.OPEN_Compensate = "NewMainMediator:OPEN_Compensate"
var0_0.ON_DROP = "NewMainMediator:ON_DROP"
var0_0.ON_AWRADS = "NewMainMediator:ON_AWRADS"
var0_0.CHANGE_SKIN_TOGGLE = "NewMainMediator:CHANGE_SKIN_TOGGLE"
var0_0.GO_ISLAND = "NewMainMediator:GO_ISLAND"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_ISLAND, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ISLAND_ENTER, {
			id = arg1_2
		})
	end)
	arg0_1:bind(var0_0.GO_SINGLE_ACTIVITY, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			mediator = ActivitySingleMediator,
			viewComponent = ActivitySingleScene,
			data = {
				id = arg1_3
			}
		}))
	end)
	arg0_1:bind(var0_0.SKIP_LOTTERY, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			viewComponent = LotteryLayer,
			mediator = LotteryMediator,
			data = {
				activityId = arg1_4
			}
		}))
	end)
	arg0_1:bind(var0_0.SKIP_INS, function(arg0_5)
		arg0_1:addSubLayers(Context.New({
			viewComponent = InstagramMainUI,
			mediator = InstagramMainMediator
		}))
	end)
	arg0_1:bind(var0_0.SKIP_ESCORT, function(arg0_6)
		local var0_6 = getProxy(ChapterProxy)
		local var1_6 = var0_6:getMapsByType(Map.ESCORT)[1]
		local var2_6 = var0_6:getActiveChapter()

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
			chapterId = var2_6 and var2_6:getConfig("map") == var1_6.id and var2_6.id or nil,
			mapIdx = var1_6.id
		})
	end)
	arg0_1:bind(var0_0.SKIP_ACTIVITY_MAP, function(arg0_7)
		local var0_7 = getProxy(ChapterProxy)
		local var1_7, var2_7 = var0_7:getLastMapForActivity()

		if not var1_7 or not var0_7:getMapById(var1_7):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2_7,
				mapIdx = var1_7
			})
		end
	end)
	arg0_1:bind(var0_0.SKIP_SHOP, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = arg1_8 or NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0_1:bind(var0_0.SKIP_ACTIVITY, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg1_9
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
		local var1_13 = var0_13.skinId
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
			mediator = NotificationMediator,
			viewComponent = NotificationLayer,
			data = {
				form = NotificationLayer.FORM_MAIN
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_DORM_SELECT_LAYER, function(arg0_19)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DORM3DSELECT)
	end)
	arg0_1:bind(var0_0.OPEN_KINK_BUTTON_LAYER, function(arg0_20, arg1_20)
		arg0_1:addSubLayers(arg1_20)
	end)
	arg0_1:bind(var0_0.CHANGE_SKIN_TOGGLE, function(arg0_21, arg1_21)
		local var0_21 = ShipGroup.GetChangeSkinGroupId(arg1_21.skin_id)
		local var1_21 = ShipGroup.GetChangeSkinNextId(arg1_21.ship_id)

		arg0_1:sendNotification(GAME.CHANGE_SKIN_AB, arg1_21)
	end)
end

function var0_0.listNotificationInterests(arg0_22)
	local var0_22 = {
		GAME.REMOVE_LAYERS,
		GAME.GET_GUILD_INFO_DONE,
		GAME.GET_GUILD_CHAT_LIST_DONE,
		GAME.ON_OPEN_INS_LAYER,
		GAME.BEGIN_STAGE_DONE,
		GAME.SEND_MINI_GAME_OP_DONE,
		GAME.FETCH_NPC_SHIP_DONE,
		GAME.ZERO_HOUR_OP_DONE,
		GAME.CONFIRM_GET_SHIP,
		GAME.WILL_LOGOUT,
		GAME.GET_FEAST_DATA_DONE,
		GAME.FETCH_VOTE_INFO_DONE,
		GAME.ROTATE_PAINTING_INDEX,
		GAME.LOAD_LAYERS,
		GAME.GUILD_GET_USER_INFO_DONE,
		GAME.GET_PUBLIC_GUILD_USER_DATA_DONE,
		GAME.PLAY_CHANGE_SKIN_OUT,
		GAME.PLAY_CHANGE_SKIN_IN,
		GAME.PLAY_CHANGE_SKIN_FINISH,
		GAME.CHANGE_SKIN_EXCHANGE,
		NotificationProxy.FRIEND_REQUEST_ADDED,
		NotificationProxy.FRIEND_REQUEST_REMOVED,
		FriendProxy.FRIEND_NEW_MSG,
		FriendProxy.FRIEND_UPDATED,
		PlayerProxy.UPDATED,
		ChatProxy.NEW_MSG,
		GuildProxy.NEW_MSG_ADDED,
		ChapterProxy.CHAPTER_TIMESUP,
		TaskProxy.TASK_ADDED,
		TechnologyConst.UPDATE_REDPOINT_ON_TOP,
		MiniGameProxy.ON_HUB_DATA_UPDATE,
		var0_0.REFRESH_VIEW,
		GAME.CHANGE_LIVINGAREA_COVER_DONE,
		CompensateProxy.UPDATE_ATTACHMENT_COUNT,
		CompensateProxy.All_Compensate_Remove,
		GAME.ACT_INSTAGRAM_CHAT_DONE,
		NewMainMediator.ON_DROP,
		NewMainMediator.ON_AWRADS
	}

	for iter0_22, iter1_22 in pairs(pg.redDotHelper:GetNotifyType()) do
		for iter2_22, iter3_22 in pairs(iter1_22) do
			if not table.contains(var0_22, iter3_22) then
				table.insert(var0_22, iter3_22)
			end
		end
	end

	return var0_22
end

function var0_0.handleNotification(arg0_23, arg1_23)
	local var0_23 = arg1_23:getName()
	local var1_23 = arg1_23:getBody()

	pg.redDotHelper:Notify(var0_23)

	if var0_23 == GAME.ON_OPEN_INS_LAYER then
		arg0_23.viewComponent:emit(var0_0.SKIP_INS)
	elseif var0_23 == NotificationProxy.FRIEND_REQUEST_ADDED or var0_23 == NotificationProxy.FRIEND_REQUEST_REMOVED or var0_23 == FriendProxy.FRIEND_NEW_MSG or var0_23 == FriendProxy.FRIEND_UPDATED or var0_23 == ChatProxy.NEW_MSG or var0_23 == GuildProxy.NEW_MSG_ADDED or var0_23 == GAME.GET_GUILD_INFO_DONE or var0_23 == GAME.GET_GUILD_CHAT_LIST_DONE then
		arg0_23.viewComponent:emit(GAME.ANY_CHAT_MSG_UPDATE)
	elseif var0_23 == GAME.BEGIN_STAGE_DONE then
		arg0_23:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_23)
	elseif var0_23 == ChapterProxy.CHAPTER_TIMESUP then
		MainChapterTimeUpSequence.New():Execute()
	elseif var0_23 == TechnologyConst.UPDATE_REDPOINT_ON_TOP then
		MainTechnologySequence.New():Execute(function()
			return
		end)
	elseif var0_23 == GAME.FETCH_NPC_SHIP_DONE then
		arg0_23.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_23.items, var1_23.callback)
	elseif var0_23 == var0_0.REFRESH_VIEW then
		arg0_23.viewComponent:setVisible(false)
		arg0_23.viewComponent:setVisible(true)
	elseif var0_23 == GAME.CONFIRM_GET_SHIP then
		arg0_23:addSubLayers(Context.New({
			mediator = BuildShipRemindMediator,
			viewComponent = BuildShipRemindLayer,
			data = {
				ships = var1_23.ships
			},
			onRemoved = var1_23.callback
		}))
	elseif var0_23 == GAME.CHANGE_LIVINGAREA_COVER_DONE then
		arg0_23.viewComponent:emit(NewMainScene.UPDATE_COVER)
	elseif var0_23 == GAME.ACT_INSTAGRAM_CHAT_DONE and var1_23.operation == ActivityConst.INSTAGRAM_CHAT_ACTIVATE_TOPIC then
		local var2_23 = arg0_23.viewComponent:GetFlagShip()

		if arg0_23.viewComponent.theme then
			arg0_23.viewComponent.theme:Refresh(var2_23)
		end
	elseif var0_23 == NewMainMediator.ON_DROP then
		arg0_23.viewComponent:emit(BaseUI.ON_DROP, var1_23)
	elseif var0_23 == NewMainMediator.ON_AWRADS then
		arg0_23.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_23.items, var1_23.callback)
	elseif var0_23 == GAME.PLAY_CHANGE_SKIN_OUT then
		arg0_23.viewComponent:FoldPanels(true)
		arg0_23.viewComponent:SetEffectPanelVisible(false)
		arg0_23.viewComponent:PlayChangeSkinActionOut(var1_23)
	elseif var0_23 == GAME.PLAY_CHANGE_SKIN_IN then
		arg0_23.viewComponent:PlayChangeSkinActionIn(var1_23)
	elseif var0_23 == GAME.PLAY_CHANGE_SKIN_FINISH then
		arg0_23.viewComponent:SetEffectPanelVisible(true)
		arg0_23.viewComponent:FoldPanels(false)
	elseif var0_23 == GAME.CHANGE_SKIN_EXCHANGE then
		local var3_23 = arg0_23.viewComponent:GetFlagShip()

		if arg0_23.viewComponent then
			arg0_23.viewComponent:UpdateFlagShip(var3_23, var1_23)
		end
	end

	arg0_23.viewComponent:emit(var0_23, var1_23)
end

return var0_0
