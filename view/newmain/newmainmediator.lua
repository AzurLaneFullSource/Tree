local var0 = class("NewMainMediator", import("..base.ContextMediator"))

var0.GO_SCENE = "NewMainMediator:GO_SCENE"
var0.OPEN_MAIL = "NewMainMediator:OPEN_MAIL"
var0.OPEN_NOTICE = "NewMainMediator:OPEN_NOTICE"
var0.GO_SNAPSHOT = "NewMainMediator:GO_SNAPSHOT"
var0.OPEN_COMMISION = "NewMainMediator:OPEN_COMMISION"
var0.OPEN_CHATVIEW = "NewMainMediator:OPEN_CHATVIEW"
var0.SKIP_SCENE = "NewMainMediator:SKIP_SCENE"
var0.SKIP_ACTIVITY = "NewMainMediator:SKIP_ACTIVITY"
var0.SKIP_SHOP = "NewMainMediator:SKIP_SHOP"
var0.GO_MINI_GAME = "NewMainMediator:GO_MINI_GAME"
var0.SKIP_ACTIVITY_MAP = "NewMainMediator:SKIP_ACTIVITY_MAP"
var0.SKIP_ESCORT = "NewMainMediator:SKIP_ESCORT"
var0.SKIP_INS = "NewMainMediator:SKIP_INS"
var0.SKIP_LOTTERY = "NewMainMediator:SKIP_LOTTERY"
var0.GO_SINGLE_ACTIVITY = "NewMainMediator:GO_SINGLE_ACTIVITY"
var0.REFRESH_VIEW = "NewMainMediator:REFRESH_VIEW"
var0.OPEN_DORM_SELECT_LAYER = "NewMainMediator.OPEN_DORM_SELECT_LAYER"

function var0.register(arg0)
	arg0:bind(var0.GO_SINGLE_ACTIVITY, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ActivitySingleMediator,
			viewComponent = ActivitySingleScene,
			data = {
				id = arg1
			}
		}))
	end)
	arg0:bind(var0.SKIP_LOTTERY, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = LotteryLayer,
			mediator = LotteryMediator,
			data = {
				activityId = arg1
			}
		}))
	end)
	arg0:bind(var0.SKIP_INS, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = InstagramLayer,
			mediator = InstagramMediator
		}))
	end)
	arg0:bind(var0.SKIP_ESCORT, function(arg0)
		local var0 = getProxy(ChapterProxy)
		local var1 = var0:getMapsByType(Map.ESCORT)[1]
		local var2 = var0:getActiveChapter()

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
			chapterId = var2 and var2:getConfig("map") == var1.id and var2.id or nil,
			mapIdx = var1.id
		})
	end)
	arg0:bind(var0.SKIP_ACTIVITY_MAP, function(arg0)
		local var0 = getProxy(ChapterProxy)
		local var1, var2 = var0:getLastMapForActivity()

		warning(var1)
		warning(var1 and var0:getMapById(var1):isUnlock())

		if not var1 or not var0:getMapById(var1):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			arg0:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
				chapterId = var2,
				mapIdx = var1
			})
		end
	end)
	arg0:bind(var0.SKIP_SHOP, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = arg1 or NewShopsScene.TYPE_ACTIVITY
		})
	end)
	arg0:bind(var0.SKIP_ACTIVITY, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg1
		})
	end)
	arg0:bind(var0.SKIP_SCENE, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, arg1[1], arg1[2])
	end)
	arg0:bind(var0.GO_MINI_GAME, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_MINI_GAME, arg1)
	end)
	arg0:bind(var0.GO_SCENE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GO_SCENE, arg1, arg2)
	end)
	arg0:bind(var0.GO_SNAPSHOT, function(arg0)
		local var0 = arg0.viewComponent.bgView.ship
		local var1 = var0.skinId
		local var2 = arg0.viewComponent.paintingView:IsLive2DState()
		local var3

		if isa(var0, VirtualEducateCharShip) then
			var3 = var0.educateCharId
			var2 = false
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.SNAPSHOT, {
			skinId = var1,
			live2d = var2,
			tbId = var3,
			propose = var0.propose
		})
	end)
	arg0:bind(var0.OPEN_MAIL, function(arg0)
		if BATTLE_DEBUG then
			arg0:sendNotification(GAME.BEGIN_STAGE, {
				system = SYSTEM_DEBUG
			})
		else
			arg0:sendNotification(GAME.GO_SCENE, SCENE.MAIL)
		end
	end)
	arg0:bind(var0.OPEN_NOTICE, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = NewBulletinBoardMediator,
			viewComponent = NewBulletinBoardLayer
		}))
	end)
	arg0:bind(var0.OPEN_COMMISION, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = CommissionInfoLayer,
			mediator = CommissionInfoMediator
		}))
	end)
	arg0:bind(var0.OPEN_CHATVIEW, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = NotificationMediator,
			viewComponent = NotificationLayer,
			data = {
				form = NotificationLayer.FORM_MAIN
			}
		}))
	end)
	arg0:bind(var0.OPEN_DORM_SELECT_LAYER, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.DORM3DSELECT)
	end)
end

function var0.listNotificationInterests(arg0)
	local var0 = {
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
		var0.REFRESH_VIEW
	}

	for iter0, iter1 in pairs(pg.redDotHelper:GetNotifyType()) do
		for iter2, iter3 in pairs(iter1) do
			if not table.contains(var0, iter3) then
				table.insert(var0, iter3)
			end
		end
	end

	return var0
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	pg.redDotHelper:Notify(var0)

	if var0 == GAME.ON_OPEN_INS_LAYER then
		arg0.viewComponent:emit(var0.SKIP_INS)
	elseif var0 == NotificationProxy.FRIEND_REQUEST_ADDED or var0 == NotificationProxy.FRIEND_REQUEST_REMOVED or var0 == FriendProxy.FRIEND_NEW_MSG or var0 == FriendProxy.FRIEND_UPDATED or var0 == ChatProxy.NEW_MSG or var0 == GuildProxy.NEW_MSG_ADDED or var0 == GAME.GET_GUILD_INFO_DONE or var0 == GAME.GET_GUILD_CHAT_LIST_DONE then
		arg0.viewComponent:emit(GAME.ANY_CHAT_MSG_UPDATE)
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == ChapterProxy.CHAPTER_TIMESUP then
		MainChapterTimeUpSequence.New():Execute()
	elseif var0 == TechnologyConst.UPDATE_REDPOINT_ON_TOP then
		MainTechnologySequence.New():Execute(function()
			return
		end)
	elseif var0 == GAME.FETCH_NPC_SHIP_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.items, var1.callback)
	elseif var0 == var0.REFRESH_VIEW then
		arg0.viewComponent:setVisible(false)
		arg0.viewComponent:setVisible(true)
	elseif var0 == GAME.CONFIRM_GET_SHIP then
		arg0:addSubLayers(Context.New({
			mediator = BuildShipRemindMediator,
			viewComponent = BuildShipRemindLayer,
			data = {
				ships = var1.ships
			},
			onRemoved = var1.callback
		}))
	end

	arg0.viewComponent:emit(var0, var1)
end

return var0
