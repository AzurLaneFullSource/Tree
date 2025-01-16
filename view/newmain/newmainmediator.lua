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

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_SINGLE_ACTIVITY, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			mediator = ActivitySingleMediator,
			viewComponent = ActivitySingleScene,
			data = {
				id = arg1_2
			}
		}))
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
	arg0_1:bind(var0_0.SKIP_ACTIVITY_MAP, function(arg0_6)
		local var0_6 = getProxy(ChapterProxy)
		local var1_6, var2_6 = var0_6:getLastMapForActivity()

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
		local var1_12 = var0_12.skinId
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
			mediator = NotificationMediator,
			viewComponent = NotificationLayer,
			data = {
				form = NotificationLayer.FORM_MAIN
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_DORM_SELECT_LAYER, function(arg0_18)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DORM3DSELECT)
	end)
	arg0_1:bind(var0_0.OPEN_KINK_BUTTON_LAYER, function(arg0_19, arg1_19)
		arg0_1:addSubLayers(arg1_19)
	end)
	arg0_1:bind(var0_0.CHANGE_SKIN_TOGGLE, function(arg0_20, arg1_20)
		local var0_20 = ShipGroup.GetChangeSkinGroupId(arg1_20.skin_id)
		local var1_20 = ShipGroup.GetChangeSkinNextId(arg1_20.ship_id)

		arg0_1:sendNotification(GAME.CHANGE_SKIN_AB, arg1_20)
	end)
end

function var0_0.listNotificationInterests(arg0_21)
	local var0_21 = {
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

	for iter0_21, iter1_21 in pairs(pg.redDotHelper:GetNotifyType()) do
		for iter2_21, iter3_21 in pairs(iter1_21) do
			if not table.contains(var0_21, iter3_21) then
				table.insert(var0_21, iter3_21)
			end
		end
	end

	return var0_21
end

function var0_0.handleNotification(arg0_22, arg1_22)
	local var0_22 = arg1_22:getName()
	local var1_22 = arg1_22:getBody()

	pg.redDotHelper:Notify(var0_22)

	if var0_22 == GAME.ON_OPEN_INS_LAYER then
		arg0_22.viewComponent:emit(var0_0.SKIP_INS)
	elseif var0_22 == NotificationProxy.FRIEND_REQUEST_ADDED or var0_22 == NotificationProxy.FRIEND_REQUEST_REMOVED or var0_22 == FriendProxy.FRIEND_NEW_MSG or var0_22 == FriendProxy.FRIEND_UPDATED or var0_22 == ChatProxy.NEW_MSG or var0_22 == GuildProxy.NEW_MSG_ADDED or var0_22 == GAME.GET_GUILD_INFO_DONE or var0_22 == GAME.GET_GUILD_CHAT_LIST_DONE then
		arg0_22.viewComponent:emit(GAME.ANY_CHAT_MSG_UPDATE)
	elseif var0_22 == GAME.BEGIN_STAGE_DONE then
		arg0_22:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_22)
	elseif var0_22 == ChapterProxy.CHAPTER_TIMESUP then
		MainChapterTimeUpSequence.New():Execute()
	elseif var0_22 == TechnologyConst.UPDATE_REDPOINT_ON_TOP then
		MainTechnologySequence.New():Execute(function()
			return
		end)
	elseif var0_22 == GAME.FETCH_NPC_SHIP_DONE then
		arg0_22.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_22.items, var1_22.callback)
	elseif var0_22 == var0_0.REFRESH_VIEW then
		arg0_22.viewComponent:setVisible(false)
		arg0_22.viewComponent:setVisible(true)
	elseif var0_22 == GAME.CONFIRM_GET_SHIP then
		arg0_22:addSubLayers(Context.New({
			mediator = BuildShipRemindMediator,
			viewComponent = BuildShipRemindLayer,
			data = {
				ships = var1_22.ships
			},
			onRemoved = var1_22.callback
		}))
	elseif var0_22 == GAME.CHANGE_LIVINGAREA_COVER_DONE then
		arg0_22.viewComponent:emit(NewMainScene.UPDATE_COVER)
	elseif var0_22 == GAME.ACT_INSTAGRAM_CHAT_DONE and var1_22.operation == ActivityConst.INSTAGRAM_CHAT_ACTIVATE_TOPIC then
		local var2_22 = arg0_22.viewComponent:GetFlagShip()

		if arg0_22.viewComponent.theme then
			arg0_22.viewComponent.theme:Refresh(var2_22)
		end
	elseif var0_22 == NewMainMediator.ON_DROP then
		arg0_22.viewComponent:emit(BaseUI.ON_DROP, var1_22)
	elseif var0_22 == NewMainMediator.ON_AWRADS then
		arg0_22.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_22.items, var1_22.callback)
	elseif var0_22 == GAME.PLAY_CHANGE_SKIN_OUT then
		arg0_22.viewComponent:FoldPanels(true)
		arg0_22.viewComponent:SetEffectPanelVisible(false)
		arg0_22.viewComponent:PlayChangeSkinActionOut(var1_22)
	elseif var0_22 == GAME.PLAY_CHANGE_SKIN_IN then
		arg0_22.viewComponent:PlayChangeSkinActionIn(var1_22)
	elseif var0_22 == GAME.PLAY_CHANGE_SKIN_FINISH then
		arg0_22.viewComponent:SetEffectPanelVisible(true)
		arg0_22.viewComponent:FoldPanels(false)
	elseif var0_22 == GAME.CHANGE_SKIN_EXCHANGE then
		local var3_22 = arg0_22.viewComponent:GetFlagShip()

		if arg0_22.viewComponent then
			arg0_22.viewComponent:UpdateFlagShip(var3_22, var1_22)
		end
	end

	arg0_22.viewComponent:emit(var0_22, var1_22)
end

return var0_0
