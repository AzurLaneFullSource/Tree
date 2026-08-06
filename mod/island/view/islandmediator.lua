local var0_0 = class("IslandMediator", import(".base.IslandBaseMediator"))

var0_0.CHANGE_SCENE = "IslandMediator:CHANGE_SCENE"
var0_0.SHOPPING = "IslandMediator:SHOPPING"
var0_0.SET_NAME = "IslandMediator:SET_NAME"
var0_0.ON_EDIT_MANIFESTO = "IslandMediator:ON_EDIT_MANIFESTO"
var0_0.GET_PROSPERITY_AWARD = "IslandMediator:GET_PROSPERITY_AWARD"
var0_0.ON_UPGRADE_INVENTORY = "IslandMediator:ON_UPGRADE_INVENTORY"
var0_0.ON_REPLACE_ORDER = "IslandMediator:ON_REPLACE_ORDER"
var0_0.ON_SUBMIT_ORDER = "IslandMediator:ON_SUBMIT_ORDER"
var0_0.ON_GET_ORDER_EXP_AWARD = "IslandMediator:ON_GET_ORDER_EXP_AWARD"
var0_0.ON_GEN_NEW_ORDER = "IslandMediator:ON_GEN_NEW_ORDER"
var0_0.ON_USE_ITEM = "IslandMediator:ON_USE_ITEM"
var0_0.ON_ACCEPT_TASK = "IslandMediator.ON_ACCEPT_TASK"
var0_0.ON_SUBMIT_TASK = "IslandMediator.ON_SUBMIT_TASK"
var0_0.ON_SUBMIT_TASK_ONE_STEP = "IslandMediator.ON_SUBMIT_TASK_ONE_STEP"
var0_0.ON_CLIENT_UPDATE_TASK = "IslandMediator.ON_CLIENT_UPDATE_TASK"
var0_0.ON_SET_TRACE_ID = "IslandMediator.ON_SET_TRACE_ID"
var0_0.ON_RESET_SEASON = "IslandMediator.ON_RESET_SEASON"
var0_0.ON_GET_SEASON_RANK = "IslandMediator.ON_GET_SEASON_RANK"
var0_0.ON_CONVERT_SEASON_PT = "IslandMediator.ON_CONVERT_SEASON_PT"
var0_0.ON_CONVERT_SEASON_PT_4_OVERFLOW = "IslandMediator.ON_CONVERT_SEASON_PT_4_OVERFLOW"
var0_0.ON_GET_SEASON_PT_AWARD = "IslandMediator.ON_GET_SEASON_PT_AWARD"
var0_0.OPEN_RESTAURANT = "IslandMediator.OPEN_RESTAURANT"
var0_0.CLOSE_RESTAURANT = "IslandMediator.CLOSE_RESTAURANT"
var0_0.GET_ACHIEVEMENT_AWARD = "IslandMediator.GET_ACHIEVEMENT_AWARD"
var0_0.SET_SETTINGS_FLAG = "IslandMediator.SET_SETTINGS_FLAG"
var0_0.UPDATE_ILLUSTRATION = "IslandMediator.UPDATE_ILLUSTRATION"
var0_0.UNLOCK_ILLUSTRATION = "IslandMediator.UNLOCK_ILLUSTRATION"
var0_0.GET_COLLECT_POINT = "IslandMediator.GET_COLLECT_POINT"
var0_0.GET_POINT_AWARD = "IslandMediator.GET_POINT_AWARD"
var0_0.REMOVE_EXPIRED_TICKETS = "IslandMediator.REMOVE_EXPIRED_TICKETS"
var0_0.USE_TICKETS = "IslandMediator.USE_TICKETS"
var0_0.EXCHANGE_ITME = "IslandMediator.EXCHANGE_ITME"
var0_0.OPEN_SHIP_INDEX = "IslandMediator:OPEN_SHIP_INDEX"
var0_0.UPGRADE_SKILL = "IslandMediator:UPGRADE_SKILL"
var0_0.ON_GIVE_GIFT = "IslandMediator:ON_GIVE_GIFT"
var0_0.ON_KICK_PLAYER = "IslandMediator:ON_KICK_PLAYER"
var0_0.SAVE_AGORA = "IslandMediator:SAVE_AGORA"
var0_0.SAVE_AGORA_THEME = "IslandMediator:SAVE_AGORA_THEME"
var0_0.DEL_AGORA_THEME = "IslandMediator:DEL_AGORA_THEME"
var0_0.UPGRADE_AGORA = "IslandMediator:UPGRADE_AGORA"
var0_0.INVITE_SHIP = "IslandMediator:INVITE_SHIP"
var0_0.ONE_KEY = "IslandMediator:ONE_KEY"
var0_0.ON_UNLOCK_TECH = "IslandMediator:ON_UNLOCK_TECH"
var0_0.ON_FINISH_TECH_IMMD = "IslandMediator:ON_FINISH_TECH_IMMD"
var0_0.SET_ORDER_TENDENCY = "IslandMediator:SET_ORDER_TENDENCY"
var0_0.SUBMIT_SHIP_ORDER_ITME = "IslandMediator:SUBMIT_SHIP_ORDER_ITME"
var0_0.SUBMIT_SHIP_ORDER_ITME_ONEKEY = "IslandMediator:SUBMIT_SHIP_ORDER_ITME_ONEKEY"
var0_0.GET_SHIP_ORDER_AWARD = "IslandMediator:GET_SHIP_ORDER_AWARD"
var0_0.UNLOKC_SHIP_ORDER = "IslandMediator:UNLOKC_SHIP_ORDER"
var0_0.OPEN_PAGE = "IslandMediator:OPEN_PAGE"
var0_0.OPEN_SHOP = "IslandMediator:OPEN_SHOP"
var0_0.GET_SHOP_DATA = "IslandMediator:GET_SHOP_DATA"
var0_0.BUY_COMMODITY = "IslandMediator:BUY_COMMODITY"
var0_0.REFRESH_SHOP_BY_PLAYER = "IslandMediator:REFRESH_SHOP_BY_PLAYER"
var0_0.USE_SHIP_EXP_BOOK = "IslandMediator:USE_SHIP_EXP_BOOK"
var0_0.SHIP_BREAKOUT = "IslandMediator:SHIP_BREAKOUT"
var0_0.SHIP_ATTR_UPGRADE = "IslandMediator:SHIP_ATTR_UPGRADE"
var0_0.SHIP_ATTR_LIMIT_UNLOCK = "IslandMediator:SHIP_ATTR_LIMIT_UNLOCK"
var0_0.SHIP_SKILL_UPGRADE = "IslandMediator:SHIP_SKILL_UPGRADE"
var0_0.START_DELEGATION = "IslandMediator:START_DELEGATION"
var0_0.ADD_DELEGATION = "IslandMediator:ADD_DELEGATION"
var0_0.STOP_DELEGATION = "IslandMediator:STOP_DELEGATION"
var0_0.GET_DELEGATION_AWARD = "IslandMediator:GET_DELEGATION_AWARD"
var0_0.SIGNIN = "IslandMediator.SIGNIN"
var0_0.SELECT_GIFT = "IslandMediator.SELECT_GIFT"
var0_0.SIGN_IN_INVITATION = "IslandMediator.SIGN_IN_INVITATION"
var0_0.SHARE_SIGNIN = "IslandMediator:SHARE_SIGNIN"
var0_0.ENTER_ISLAND = "IslandMediator:ENTER_ISLAND"
var0_0.ENTER_ISLAND_BY_CODE = "IslandMediator:ENTER_ISLAND_BY_CODE"
var0_0.ADD_FRIEND = "IslandMediator:ADD_FRIEND"
var0_0.REMOVE_FRIEND = "IslandMediator:REMOVE_FRIEND"
var0_0.SEARCH_FRIEND = "IslandMediator:SEARCH_FRIEND"
var0_0.BATCH_GET_FRIEND = "IslandMediator:BATCH_GET_FRIEND"
var0_0.ADD_WHITE_LIST = "IslandMediator:ADD_WHITE_LIST"
var0_0.ADD_BLACK_LIST = "IslandMediator:ADD_BLACK_LIST"
var0_0.REMOVE_BLACK_LIST = "IslandMediator:REMOVE_BLACK_LIST"
var0_0.REMOVE_WHITE_LIST = "IslandMediator:REMOVE_WHITE_LIST"
var0_0.SET_ACCESS_FLAG = "IslandMediator:SET_ACCESS_FLAG"
var0_0.REFRESH_INVITECODE = "IslandMediator:REFRESH_INVITECODE"
var0_0.KICK_ALL_VISITOR = "IslandMediator:KICK_ALL_VISITOR"
var0_0.GET_RESUME = "IslandMediator:GET_RESUME"
var0_0.GET_GIFT_TAG = "IslandMediator:GET_GIFT_TAG"
var0_0.GET_THEMES = "IslandMediator:GET_THEMES"
var0_0.PREVIEW_FURNITURE = "IslandMediator:PREVIEW_FURNITURE"
var0_0.REFUSE_REQUEST = "IslandMediator:REFUSE_REQUEST"
var0_0.ACCEPT_REQUEST = "IslandMediator:ACCEPT_REQUEST"
var0_0.NPC_ACTION_AWARD = "IslandMediator:NPC_ACTION_AWARD"
var0_0.ADD_FOLLOWER = "IslandMediator:ADD_FOLLOWER"
var0_0.DEL_FOLLOWER = "IslandMediator:DEL_FOLLOWER"
var0_0.DRAW_AWARD_OPERATION = "IslandMediator.DRAW_AWARD_OPERATION"
var0_0.REFRESH_SHIP_ORDER = "IslandMediator:REFRESH_SHIP_ORDER"
var0_0.EXCHANGE_SHIP_ORDER = "IslandMediator:EXCHANGE_SHIP_ORDER"
var0_0.RESET_SHIP_ORDER = "IslandMediator:RESET_SHIP_ORDER"
var0_0.GET_AUTO_COLLECTION_DATA = "IslandMediator:GET_AUTO_COLLECTION_DATA"
var0_0.PLAY_ROOM_INVITE_AGREE = "IslandMediator:PLAY_ROOM_INVITE_AGREE"
var0_0.PLAY_ROOM_INVITE_REFUSE = "IslandMediator:PLAY_ROOM_INVITE_REFUSE"
var0_0.PLAY_ROOM_MATCH_STOP = "IslandMediator:PLAY_ROOM_MATCH_STOP"
var0_0.CHEATER_TAVERN_OPERATE = "IslandMediator:CHEATER_TAVERN_OPERATE"
var0_0.CHEATER_TAVERN_CANCEL_DELEGATE = "IslandMediator:CHEATER_TAVERN_CANCEL_DELEGATE"
var0_0.CHEATER_TAVERN_START_SOLO_GAME = "IslandMediator:CHEATER_TAVERN_START_SOLO_GAME"
var0_0.CHEATER_TAVERN_END_SOLO_GAME = "IslandMediator:CHEATER_TAVERN_END_SOLO_GAME"
var0_0.SHOW_MSG_BOX = "IslandMediator:SHOW_MSG_BOX"
var0_0.OPEN_MACHA_MODEL_PREVIEW = "IslandMediator:OPEN_MACHA_MODEL_PREVIEW"
var0_0.SKIP_MAP = "IslandMediator:SKIP_MAP"

function var0_0._register(arg0_1)
	arg0_1:bind(var0_0.RESET_SHIP_ORDER, function(arg0_2)
		arg0_1:sendNotification(GAME.ISLAND_RESET_SHIP_ORDER)
	end)
	arg0_1:bind(var0_0.EXCHANGE_SHIP_ORDER, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.ISLAND_EXCHANGE_SHIP_ORDER, {
			id = arg1_3,
			delegateId = arg2_3
		})
	end)
	arg0_1:bind(var0_0.REFRESH_SHIP_ORDER, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.ISLAND_REFRESH_SHIP_ORDER, {
			id = arg1_4
		})
	end)
	arg0_1:bind(var0_0.CHANGE_SCENE, function(arg0_5, arg1_5, ...)
		arg0_1:sendNotification(GAME.CHANGE_SCENE, arg1_5, ...)
	end)
	arg0_1:bind(var0_0.ADD_FOLLOWER, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.ISLAND_FOLLOWER_OP, {
			shipId = arg1_6,
			op = IslandConst.FOLLOWER_OP_ADD
		})
	end)
	arg0_1:bind(var0_0.DEL_FOLLOWER, function(arg0_7, arg1_7, arg2_7)
		arg0_1:sendNotification(GAME.ISLAND_FOLLOWER_OP, {
			shipId = arg1_7,
			op = IslandConst.FOLLOWER_OP_DEL,
			callback = arg2_7
		})
	end)
	arg0_1:bind(var0_0.NPC_ACTION_AWARD, function(arg0_8, arg1_8, arg2_8, arg3_8)
		arg0_1:sendNotification(GAME.ISLAND_GET_NPC_ACTION_AWARD, {
			npcId = arg1_8,
			shipId = arg2_8,
			actionId = arg3_8
		})
	end)
	arg0_1:bind(var0_0.ACCEPT_REQUEST, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.FRIEND_ACCEPT_REQUEST, arg1_9)
	end)
	arg0_1:bind(var0_0.REFUSE_REQUEST, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.FRIEND_REJECT_REQUEST, arg1_10)
	end)
	arg0_1:bind(var0_0.PREVIEW_FURNITURE, function(arg0_11, arg1_11)
		local var0_11 = arg0_1.viewComponent:GetIsland()
		local var1_11 = var0_11:GetMapId()
		local var2_11, var3_11 = _IslandCore:GetView().player:LastGroundedPosition()

		var0_11:SetMapId(IslandConst.AGORA_MAP_ID)
		arg0_1:UnloadScene()

		_IslandCore = IslandPreviewCore.New(arg0_1.viewComponent:GetPoolMgr(), var0_11, true, arg1_11, {
			mapId = var1_11,
			position = var2_11,
			rotation = var3_11
		})
	end)
	arg0_1:bind(var0_0.GET_THEMES, function(arg0_12, arg1_12)
		arg0_1:sendNotification(GAME.ISLAND_GET_AGORA_THEME, {
			callback = arg1_12
		})
	end)
	arg0_1:bind(var0_0.GET_GIFT_TAG, function(arg0_13, arg1_13, arg2_13)
		arg0_1:sendNotification(GAME.ISLAND_GET_GIFT_TAG, {
			list = arg1_13,
			callback = arg2_13
		})
	end)
	arg0_1:bind(var0_0.GET_RESUME, function(arg0_14, arg1_14, arg2_14)
		arg0_1:sendNotification(GAME.ISLAND_GET_FRIEND_RESUME, {
			id = arg1_14,
			callback = arg2_14
		})
	end)
	arg0_1:bind(var0_0.KICK_ALL_VISITOR, function(arg0_15, arg1_15)
		arg0_1:sendNotification(GAME.ISLAND_ACCESS_OP, {
			op = IslandConst.ACCESS_OP_KICK,
			list = arg1_15
		})
	end)
	arg0_1:bind(var0_0.ADD_BLACK_LIST, function(arg0_16, arg1_16)
		arg0_1:sendNotification(GAME.ISLAND_ACCESS_OP, {
			op = IslandConst.ACCESS_OP_ADD_BLACKLIST,
			list = {
				arg1_16
			}
		})
	end)
	arg0_1:bind(var0_0.REMOVE_BLACK_LIST, function(arg0_17, arg1_17)
		arg0_1:sendNotification(GAME.ISLAND_ACCESS_OP, {
			op = IslandConst.ACCESS_OP_DEL_BLACKLIST,
			list = {
				arg1_17
			}
		})
	end)
	arg0_1:bind(var0_0.ADD_WHITE_LIST, function(arg0_18, arg1_18)
		arg0_1:sendNotification(GAME.ISLAND_ACCESS_OP, {
			op = IslandConst.ACCESS_OP_ADD_WHITELIST,
			list = {
				arg1_18
			}
		})
	end)
	arg0_1:bind(var0_0.REMOVE_WHITE_LIST, function(arg0_19, arg1_19)
		arg0_1:sendNotification(GAME.ISLAND_ACCESS_OP, {
			op = IslandConst.ACCESS_OP_DEL_WHITELIST,
			list = {
				arg1_19
			}
		})
	end)
	arg0_1:bind(var0_0.REFRESH_INVITECODE, function(arg0_20, arg1_20)
		arg0_1:sendNotification(GAME.ISLAND_REFRESH_INVITECODE, {
			auto = arg1_20
		})
	end)
	arg0_1:bind(var0_0.SET_ACCESS_FLAG, function(arg0_21, arg1_21, arg2_21)
		arg0_1:sendNotification(GAME.ISLAND_SET_ACCESS_TYPE, {
			openList = arg1_21,
			closeList = arg2_21
		})
	end)
	arg0_1:bind(var0_0.BATCH_GET_FRIEND, function(arg0_22, arg1_22, arg2_22)
		arg0_1:sendNotification(GAME.BATCH_GET_FRIEND, {
			list = arg1_22,
			callback = arg2_22
		})
	end)
	arg0_1:bind(var0_0.SEARCH_FRIEND, function(arg0_23, arg1_23, arg2_23)
		arg0_1:sendNotification(GAME.FRIEND_SEARCH, {
			type = arg1_23,
			keyword = arg2_23
		})
	end)
	arg0_1:bind(var0_0.ADD_FRIEND, function(arg0_24, arg1_24, arg2_24)
		arg0_1:sendNotification(GAME.FRIEND_SEND_REQUEST, {
			id = arg1_24,
			msg = arg2_24
		})
	end)
	arg0_1:bind(var0_0.REMOVE_FRIEND, function(arg0_25, arg1_25)
		arg0_1:sendNotification(GAME.FRIEND_DELETE, arg1_25)
	end)
	arg0_1:bind(var0_0.ENTER_ISLAND, function(arg0_26, arg1_26)
		arg0_1:sendNotification(GAME.ISLAND_ENTER, {
			id = arg1_26
		})
	end)
	arg0_1:bind(var0_0.ENTER_ISLAND_BY_CODE, function(arg0_27, arg1_27)
		arg0_1:sendNotification(GAME.ISLAND_ENTER, {
			code = arg1_27
		})
	end)
	arg0_1:bind(var0_0.SHARE_SIGNIN, function(arg0_28)
		arg0_1:sendNotification(GAME.ISLAND_SIGN_SHARE_SIGNIN)
	end)
	arg0_1:bind(var0_0.SIGN_IN_INVITATION, function(arg0_29, arg1_29)
		arg0_1:sendNotification(GAME.ISLAND_SIGN_IN_INVITATION, {
			list = arg1_29
		})
	end)
	arg0_1:bind(var0_0.SELECT_GIFT, function(arg0_30, arg1_30, arg2_30)
		arg0_1:sendNotification(GAME.ISLAND_SELECT_GIFT, {
			islandId = arg1_30,
			pos = arg2_30
		})
	end)
	arg0_1:bind(var0_0.SIGNIN, function(arg0_31)
		arg0_1.viewComponent:PlayStory({
			name = "ISLANDSTORY100",
			callback = function()
				arg0_1:sendNotification(GAME.ISLAND_SIGN_IN)
			end
		})
	end)
	arg0_1:bind(var0_0.INVITE_SHIP, function(arg0_33, arg1_33)
		arg0_1:sendNotification(GAME.ISLAND_INVITE_SHIP, {
			id = arg1_33
		})
	end)
	arg0_1:bind(var0_0.SHIP_SKILL_UPGRADE, function(arg0_34, arg1_34)
		arg0_1:sendNotification(GAME.ISLAND_SHIP_SKILL_UPGRADE, {
			id = arg1_34
		})
	end)
	arg0_1:bind(var0_0.SHIP_ATTR_LIMIT_UNLOCK, function(arg0_35, arg1_35)
		arg0_1:sendNotification(GAME.ISLNAD_SHIP_ATTR_LIMIT_UNLOCK, {
			id = arg1_35
		})
	end)
	arg0_1:bind(var0_0.SHIP_ATTR_UPGRADE, function(arg0_36, arg1_36, arg2_36, arg3_36)
		arg0_1:sendNotification(GAME.ISLNAD_SHIP_ATTR_UPGRADE, {
			id = arg1_36,
			attrKy = arg2_36,
			list = arg3_36
		})
	end)
	arg0_1:bind(var0_0.SHIP_BREAKOUT, function(arg0_37, arg1_37)
		arg0_1:sendNotification(GAME.ISLAND_SHIP_BREAKOUT, {
			id = arg1_37
		})
	end)
	arg0_1:bind(var0_0.USE_SHIP_EXP_BOOK, function(arg0_38, arg1_38, arg2_38)
		arg0_1:sendNotification(GAME.ISLAND_USE_SHIP_EXP_BOOK, {
			id = arg1_38,
			list = arg2_38
		})
	end)
	arg0_1:bind(var0_0.OPEN_PAGE, function(arg0_39, arg1_39, arg2_39)
		arg0_1.viewComponent:OpenPage(_G[arg1_39], unpack(arg2_39 or {}))
	end)
	arg0_1:bind(var0_0.UNLOKC_SHIP_ORDER, function(arg0_40, arg1_40)
		arg0_1:sendNotification(GAME.ISLAND_SHIP_ORDER_OP, {
			op = IslandShipOrder.OP_TYPE_UNLOCK,
			slotId = arg1_40
		})
	end)
	arg0_1:bind(var0_0.GET_SHIP_ORDER_AWARD, function(arg0_41, arg1_41)
		arg0_1:sendNotification(GAME.ISLAND_SHIP_ORDER_OP, {
			op = IslandShipOrder.OP_TYPE_GET_AWARD,
			slotId = arg1_41
		})
	end)
	arg0_1:bind(var0_0.SUBMIT_SHIP_ORDER_ITME, function(arg0_42, arg1_42, arg2_42)
		arg0_1:sendNotification(GAME.ISLAND_SHIP_ORDER_OP, {
			op = IslandShipOrder.OP_TYPE_LOADUP,
			slotId = arg1_42,
			index = arg2_42
		})
	end)
	arg0_1:bind(var0_0.SUBMIT_SHIP_ORDER_ITME_ONEKEY, function(arg0_43, arg1_43)
		arg0_1:sendNotification(GAME.ISLAND_SHIP_ORDER_OP, {
			op = IslandShipOrder.OP_TYPE_LOADUP_ALL,
			slotId = arg1_43
		})
	end)
	arg0_1:bind(var0_0.SET_ORDER_TENDENCY, function(arg0_44, arg1_44)
		arg0_1:sendNotification(GAME.ISLAND_SET_ORDER_TENDENCY, {
			value = arg1_44
		})
	end)
	arg0_1:bind(var0_0.ONE_KEY, function(arg0_45)
		arg0_1:sendNotification(GAME.ISLAND_GET_OVERFLOW_ITEM)
	end)
	arg0_1:bind(var0_0.UPGRADE_AGORA, function(arg0_46)
		arg0_1:sendNotification(GAME.ISLAND_UPGRADE_AGORA)
	end)
	arg0_1:bind(var0_0.SAVE_AGORA, function(arg0_47, arg1_47, arg2_47, arg3_47)
		arg0_1:sendNotification(GAME.ISLAND_SAVE_AGORA, {
			list = arg1_47,
			floorList = arg2_47,
			tileList = arg3_47
		})
	end)
	arg0_1:bind(var0_0.SAVE_AGORA_THEME, function(arg0_48, arg1_48)
		arg0_1:sendNotification(GAME.ISLAND_SAVE_AGORA_THEME, {
			themeData = arg1_48
		})
	end)
	arg0_1:bind(var0_0.DEL_AGORA_THEME, function(arg0_49, arg1_49)
		arg0_1:sendNotification(GAME.ISLAND_DEL_AGORA_THEME, {
			id = arg1_49
		})
	end)
	arg0_1:bind(var0_0.ON_KICK_PLAYER, function(arg0_50, arg1_50, arg2_50)
		arg0_1:sendNotification(GAME.ISLAND_ACCESS_OP, {
			op = arg1_50,
			list = {
				arg2_50
			}
		})
	end)
	arg0_1:bind(var0_0.ON_GIVE_GIFT, function(arg0_51, arg1_51, arg2_51, arg3_51)
		arg0_1:sendNotification(GAME.ISLAND_GIVE_GIFT, {
			id = arg3_51,
			itemId = arg1_51
		})
	end)
	arg0_1:bind(var0_0.UPGRADE_SKILL, function(arg0_52, arg1_52)
		arg0_1:sendNotification(GAME.ISLAND_UPGRADE_SKILL, {
			id = arg1_52
		})
	end)
	arg0_1:bind(var0_0.OPEN_SHIP_INDEX, function(arg0_53, arg1_53)
		arg0_1:addSubLayers(Context.New({
			viewComponent = IslandShipIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_53
		}))
	end)
	arg0_1:bind(var0_0.ON_USE_ITEM, function(arg0_54, arg1_54, arg2_54)
		arg0_1:sendNotification(GAME.ISLAND_USE_ITEM, {
			id = arg1_54,
			count = arg2_54
		})
	end)
	arg0_1:bind(var0_0.ON_GEN_NEW_ORDER, function(arg0_55, arg1_55)
		arg0_1:sendNotification(GAME.ISLAND_GEN_NEW_ORDER, {
			slotId = arg1_55
		})
	end)
	arg0_1:bind(var0_0.ON_GET_ORDER_EXP_AWARD, function(arg0_56, arg1_56, arg2_56)
		arg0_1:sendNotification(GAME.ISLAND_GET_ORDER_EXP_AWARD, {
			level = arg1_56,
			callback = arg2_56
		})
	end)
	arg0_1:bind(var0_0.ON_REPLACE_ORDER, function(arg0_57, arg1_57)
		arg0_1:sendNotification(GAME.ISLAND_REPLACE_ORDER, {
			slotId = arg1_57
		})
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_ORDER, function(arg0_58, arg1_58)
		arg0_1:sendNotification(GAME.ISLAND_SUBMIT_ORDER, {
			slotId = arg1_58
		})
	end)
	arg0_1:bind(var0_0.ON_UPGRADE_INVENTORY, function(arg0_59)
		arg0_1:sendNotification(GAME.ISLAND_UPGRADE_INVENTORY)
	end)
	arg0_1:bind(var0_0.GET_PROSPERITY_AWARD, function(arg0_60, arg1_60)
		arg0_1:sendNotification(GAME.ISLAND_PROSPERITY_AWARD, {
			level = arg1_60
		})
	end)
	arg0_1:bind(var0_0.ON_EDIT_MANIFESTO, function(arg0_61, arg1_61)
		arg0_1:sendNotification(GAME.ISLAND_SET_MANIFESTO, {
			manifesto = arg1_61
		})
	end)
	arg0_1:bind(var0_0.SET_NAME, function(arg0_62, arg1_62, arg2_62)
		arg0_1:sendNotification(GAME.ISLAND_SET_NAME, {
			name = arg1_62,
			currency = arg2_62
		})
	end)
	arg0_1:bind(var0_0.ON_ACCEPT_TASK, function(arg0_63, arg1_63, arg2_63)
		arg0_1:sendNotification(GAME.ISLAND_ACCEPT_TASK, {
			taskIds = arg1_63,
			callback = arg2_63
		})
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_TASK, function(arg0_64, arg1_64, arg2_64)
		arg0_1:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
			taskId = arg1_64,
			callback = arg2_64
		})
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_TASK_ONE_STEP, function(arg0_65, arg1_65, arg2_65)
		arg0_1:sendNotification(GAME.ISLAND_SUBMIT_TASK_ONE_STEP, {
			taskIds = arg1_65,
			callback = arg2_65
		})
	end)
	arg0_1:bind(var0_0.ON_CLIENT_UPDATE_TASK, function(arg0_66, arg1_66)
		arg0_1:sendNotification(GAME.ISLAND_UPDATE_TASK, {
			taskId = arg1_66.taskId,
			targetId = arg1_66.targetId,
			progress = arg1_66.progress
		})
	end)
	arg0_1:bind(var0_0.ON_SET_TRACE_ID, function(arg0_67, arg1_67, arg2_67)
		arg0_1:sendNotification(GAME.ISLAND_SET_TRACE_TASK, {
			traceId = arg1_67,
			type = arg2_67
		})
	end)
	arg0_1:bind(var0_0.ON_RESET_SEASON, function(arg0_68, arg1_68)
		arg0_1:sendNotification(GAME.ISLAND_RESET_SEASON, {
			callback = arg1_68
		})
	end)
	arg0_1:bind(var0_0.ON_GET_SEASON_RANK, function(arg0_69, arg1_69, arg2_69)
		arg0_1:sendNotification(GAME.ISLAND_GET_SEASON_RANK, {
			type = arg1_69,
			seasonId = arg2_69
		})
	end)
	arg0_1:bind(var0_0.ON_CONVERT_SEASON_PT, function(arg0_70, arg1_70)
		arg0_1:sendNotification(GAME.ISLAND_CONVERT_SEASON_PT, {
			type = 1,
			list = arg1_70
		})
	end)
	arg0_1:bind(var0_0.ON_CONVERT_SEASON_PT_4_OVERFLOW, function(arg0_71, arg1_71)
		arg0_1:sendNotification(GAME.ISLAND_CONVERT_SEASON_PT, {
			type = 2,
			list = arg1_71
		})
	end)
	arg0_1:bind(var0_0.ON_GET_SEASON_PT_AWARD, function(arg0_72, arg1_72)
		arg0_1:sendNotification(GAME.ISLAND_GET_SEASON_PT_AWARD, {
			pt = arg1_72
		})
	end)
	arg0_1:bind(var0_0.OPEN_RESTAURANT, function(arg0_73, arg1_73)
		arg0_1:sendNotification(GAME.ISLAND_OPEN_RESTAURANT, {
			restId = arg1_73.restId,
			ships = arg1_73.ships,
			commodities = arg1_73.commodities,
			estimateData = arg1_73.estimateData
		})
	end)
	arg0_1:bind(var0_0.CLOSE_RESTAURANT, function(arg0_74, arg1_74, arg2_74)
		arg0_1:sendNotification(GAME.ISLAND_CLOSE_RESTAURANT, {
			restId = arg1_74,
			isPost = arg2_74
		})
	end)
	arg0_1:bind(var0_0.GET_ACHIEVEMENT_AWARD, function(arg0_75, arg1_75)
		arg0_1:sendNotification(GAME.ISLAND_GET_ACHV_AWARD, {
			ids = arg1_75
		})
	end)
	arg0_1:bind(var0_0.SET_SETTINGS_FLAG, function(arg0_76, arg1_76)
		arg0_1:sendNotification(GAME.ISLAND_SETTING_FLAG, {
			flags = arg1_76
		})
	end)
	arg0_1:bind(var0_0.UPDATE_ILLUSTRATION, function(arg0_77, arg1_77, arg2_77)
		arg0_1:sendNotification(GAME.ISLAND_UPDATE_ILLUSTRATION, {
			type = arg1_77,
			linkId = arg2_77
		})
	end)
	arg0_1:bind(var0_0.UNLOCK_ILLUSTRATION, function(arg0_78, arg1_78)
		arg0_1:sendNotification(GAME.ISLAND_UNLOCK_ILLUSTRATION, {
			ids = arg1_78
		})
	end)
	arg0_1:bind(var0_0.GET_COLLECT_POINT, function(arg0_79, arg1_79)
		arg0_1:sendNotification(GAME.ISLAND_GET_COLLECT_POINT, {
			ids = arg1_79
		})
	end)
	arg0_1:bind(var0_0.GET_POINT_AWARD, function(arg0_80, arg1_80)
		arg0_1:sendNotification(GAME.ISLAND_GET_POINT_AWARD, {
			id = arg1_80
		})
	end)
	arg0_1:bind(var0_0.REMOVE_EXPIRED_TICKETS, function(arg0_81, arg1_81, arg2_81)
		arg0_1:sendNotification(GAME.ISLAND_REMOVE_EXPIRED_TICKET, {
			tickets = arg1_81,
			callback = arg2_81
		})
	end)
	arg0_1:bind(var0_0.USE_TICKETS, function(arg0_82, arg1_82, arg2_82, arg3_82)
		arg0_1:sendNotification(GAME.ISLAND_USE_TICKET, {
			type = arg1_82,
			id = arg2_82,
			tickets = arg3_82
		})
	end)
	arg0_1:bind(var0_0.EXCHANGE_ITME, function(arg0_83, arg1_83, arg2_83, arg3_83)
		arg0_1:sendNotification(GAME.ISLAND_EXCHANGE_ITEM, {
			list = arg1_83,
			tempId = arg2_83,
			tempCnt = arg3_83
		})
	end)
	arg0_1:bind(var0_0.ON_UNLOCK_TECH, function(arg0_84, arg1_84)
		arg0_1:sendNotification(GAME.ISLAND_UNLOCK_TECH, {
			techId = arg1_84
		})
	end)
	arg0_1:bind(var0_0.ON_FINISH_TECH_IMMD, function(arg0_85, arg1_85, arg2_85)
		arg0_1:sendNotification(GAME.ISLAND_FINISH_TECH_IMMD, {
			techId = arg1_85,
			callback = arg2_85
		})
	end)
	arg0_1:bind(var0_0.START_DELEGATION, function(arg0_86, arg1_86, arg2_86, arg3_86, arg4_86, arg5_86, arg6_86)
		arg0_1:sendNotification(GAME.ISLAND_START_DELEGATION, {
			build_id = arg1_86,
			area_id = arg2_86,
			ship_id = arg3_86,
			formula_id = arg4_86,
			num = arg5_86,
			extraCost = arg6_86
		})
	end)
	arg0_1:bind(var0_0.ADD_DELEGATION, function(arg0_87, arg1_87, arg2_87, arg3_87, arg4_87)
		arg0_1:sendNotification(GAME.ISLAND_ADD_DELEGATION, {
			build_id = arg1_87,
			area_id = arg2_87,
			add_num = arg3_87,
			extraCost = arg4_87
		})
	end)
	arg0_1:bind(var0_0.STOP_DELEGATION, function(arg0_88, arg1_88, arg2_88)
		arg0_1:sendNotification(GAME.ISLAND_FINISH_DELEGATION, {
			build_id = arg1_88,
			area_id = arg2_88
		})
	end)
	arg0_1:bind(var0_0.GET_DELEGATION_AWARD, function(arg0_89, arg1_89, arg2_89, arg3_89, arg4_89, arg5_89)
		arg0_1:sendNotification(GAME.ISLAND_GET_DELEGATION_AWARD, {
			build_id = arg1_89,
			area_id = arg2_89,
			type = arg3_89,
			callback = arg4_89,
			isPost = arg5_89
		})
	end)
	arg0_1:bind(var0_0.GET_SHOP_DATA, function(arg0_90, arg1_90, arg2_90)
		arg0_1:sendNotification(GAME.ISLAND_SHOP_OP, {
			operation = IslandConst.SHOP_GET_DATA,
			shopId = arg1_90,
			refreshAll = arg2_90
		})
	end)
	arg0_1:bind(var0_0.BUY_COMMODITY, function(arg0_91, arg1_91)
		arg0_1:sendNotification(GAME.ISLAND_SHOP_OP, {
			operation = IslandConst.SHOP_BUY_COMMODITY,
			commodityList = arg1_91
		})
	end)
	arg0_1:bind(var0_0.REFRESH_SHOP_BY_PLAYER, function(arg0_92, arg1_92, arg2_92)
		arg0_1:sendNotification(GAME.ISLAND_SHOP_OP, {
			operation = IslandConst.SHOP_REFRESH_BY_PLAYER,
			shopId = arg1_92,
			resource = arg2_92
		})
	end)
	arg0_1:bind(var0_0.DRAW_AWARD_OPERATION, function(arg0_93, arg1_93)
		arg0_1:sendNotification(GAME.ACTIVITY_DRAW_AWARD_OPERATION, arg1_93)
	end)
	arg0_1:bind(var0_0.SHOPPING, function(arg0_94, arg1_94, arg2_94)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_94,
			count = arg2_94
		})
	end)
	arg0_1:bind(var0_0.GET_AUTO_COLLECTION_DATA, function(arg0_95, arg1_95)
		arg0_1:sendNotification(GAME.ISLAND_GET_AUTO_COLLECTION_DATA, {
			type = arg1_95
		})
	end)
	arg0_1:bind(var0_0.PLAY_ROOM_INVITE_AGREE, function(arg0_96, arg1_96)
		arg0_1:sendNotification(GAME.PLAY_ROOM_JOIN_ROOM, arg1_96)
	end)
	arg0_1:bind(var0_0.PLAY_ROOM_INVITE_REFUSE, function(arg0_97, arg1_97)
		arg0_1:sendNotification(GAME.PLAY_ROOM_INVITE_REFUSE, arg1_97)
	end)
	arg0_1:bind(var0_0.PLAY_ROOM_MATCH_STOP, function(arg0_98)
		arg0_1:sendNotification(GAME.PLAY_ROOM_EXIT_ROOM, {
			arg = 0
		})
	end)
	arg0_1:bind(var0_0.CHEATER_TAVERN_OPERATE, function(arg0_99, arg1_99, arg2_99)
		arg0_1:sendNotification(GAME.ISLAND_PLAYER_CHEATER_OPERATE, {
			type = arg1_99,
			arg_list = arg2_99
		})
	end)
	arg0_1:bind(var0_0.CHEATER_TAVERN_CANCEL_DELEGATE, function(arg0_100, arg1_100)
		arg0_1:sendNotification(GAME.ISLAND_PLAYER_CHEATER_CANCEL_DELEGATE, {
			type = 1
		})
	end)
	arg0_1:bind(var0_0.CHEATER_TAVERN_START_SOLO_GAME, function(arg0_101)
		arg0_1:sendNotification(GAME.ISLAND_CHEATER_START_SOLO_GAME, {
			bot_num = 3
		})
	end)
	arg0_1:bind(var0_0.CHEATER_TAVERN_END_SOLO_GAME, function(arg0_102)
		arg0_1:sendNotification(GAME.ISLAND_CHEATER_END_SOLO_GAME)
	end)
	arg0_1:bind(var0_0.SHOW_MSG_BOX, function(arg0_103, arg1_103)
		arg0_1.viewComponent:ShowMsgbox(arg1_103)
	end)
end

function var0_0._listNotificationInterests(arg0_104)
	return {
		GAME.ISLAND_SET_NAME_DONE,
		GAME.ISLAND_PROSPERITY_AWARD_DONE,
		GAME.ISLAND_UPGRADE_DONE,
		GAME.ISLAND_SET_MANIFESTO_DONE,
		GAME.ISLAND_UPGRADE_INVENTORY_DONE,
		GAME.ISLAND_SUBMIT_ORDER_DONE,
		GAME.ISLAND_REPLACE_ORDER_DONE,
		GAME.ISLAND_GET_ORDER_EXP_AWARD_DONE,
		GAME.ISLAND_GET_RANDOM_REFRESH_TASK_DONE,
		GAME.ISLAND_ACCEPT_TASK_DONE,
		GAME.ISLAND_UPDATE_TASK_DONE,
		GAME.ISLAND_SUBMIT_TASK_DONE,
		GAME.ISLAND_SUBMIT_TASK_ONE_STEP_DONE,
		GAME.SUBMIT_ACTIVITY_TASK_IN_ISLAND_DONE,
		GAME.ISLAND_SET_TRACE_TASK_DONE,
		GAME.ISLAND_GET_ACHV_AWARD_DONE,
		GAME.ISLAND_SETTING_FLAG_DONE,
		GAME.ISLAND_UPDATE_ILLUSTRATION_DONE,
		GAME.ISLAND_UNLOCK_ILLUSTRATION_DONE,
		GAME.ISLAND_GET_COLLECT_POINT_DONE,
		GAME.ISLAND_GET_POINT_AWARD_DONE,
		GAME.ISLAND_REMOVE_EXPIRED_TICKET_DONE,
		GAME.ISLAND_USE_TICKET_DONE,
		GAME.ISLAND_EXCHANGE_ITEM_DONE,
		GAME.ISLAND_GET_SEASON_PT_AWARD_DONE,
		GAME.ISLAND_CONVERT_SEASON_PT_DONE,
		GAME.ISLAND_GET_SEASON_RANK_DONE,
		GAME.ISLAND_OPEN_RESTAURANT_DONE,
		GAME.ISLAND_CLOSE_RESTAURANT_DONE,
		GAME.ISLAND_UPGRADE_SKILL_DONE,
		GAME.ISLAND_USE_ITEM_DONE,
		GAME.ISLAND_GET_OVERFLOW_ITEM_DOME,
		GAME.ISLAND_SET_ORDER_TENDENCY_DONE,
		GAME.ISLAND_UNLOCK_TECH_DONE,
		GAME.ISLAND_FINISH_TECH_IMMD_DONE,
		GAME.ISLAND_SHIP_ORDER_OP_DONE,
		GAME.ISLAND_START_DELEGATION_DONE,
		GAME.ISLAND_GET_DELEGATION_AWARD_DONE,
		GAME.ISLAND_FINISH_DELEGATION_DONE,
		GAME.ISLAND_USE_SHIP_EXP_BOOK_DONE,
		GAME.ISLAND_SHIP_BREAKOUT_DONE,
		GAME.ISLNAD_SHIP_ATTR_UPGRADE_DONE,
		GAME.ISLNAD_SHIP_ATTR_LIMIT_UNLOCK_DONE,
		GAME.ISLAND_SHIP_SKILL_UPGRADE_DONE,
		GAME.ISLAND_INVITE_SHIP_DONE,
		GAME.ISLAND_GIVE_GIFT_DONE,
		GAME.ISLAND_SIGN_IN_INVITATION_DONE,
		GAME.FRIEND_SEARCH_DONE,
		GAME.ISLAND_REFRESH_INVITECODE_DONE,
		GAME.ISLAND_QUEUE_UP,
		GAME.ISLAND_ACCESS_OP_DONE,
		GAME.FRIEND_DELETE_DONE,
		GAME.FRIEND_SEND_REQUEST_DONE,
		GAME.ISLAND_SIGN_SHARE_SIGNIN_DONE,
		GAME.ISLAND_SIGN_IN_DONE,
		GAME.ISLAND_GET_NPC_ACTION_AWARD_DONE,
		GAME.ISLAND_FOLLOWER_OP_DONE,
		GAME.ISLAND_RESET_SP,
		GAME.ISLAND_REFRESH_SHIP_ORDER_DONE,
		GAME.ISLAND_EXCHANGE_SHIP_ORDER_DONE,
		GAME.ISLAND_RESET_SHIP_ORDER_DONE,
		GAME.ACTIVITY_DRAW_AWARD_OPERATION_DONE,
		NotificationProxy.FRIEND_REQUEST_REMOVED,
		NotificationProxy.FRIEND_REQUEST_ADDED,
		PlayerProxy.UPDATED,
		GAME.ISLAND_SHOP_OP_DONE,
		GAME.ISLAND_DROPMAIN_AWARD,
		GAME.ISLAND_CHANGE_COMMANDER_DRESS_DONE,
		GAME.ISLAND_CHANGE_ROLE_DRESS_DONE,
		GAME.ISLAND_SEND_ROLE_DRESS_READ_DONE,
		GAME.ISLAND_SEND_COMMANDER_DRESS_READ_DONE,
		GAME.ISLAND_BUY_ROLE_SKIN_COLOR_DONE,
		GAME.ISLAND_BUY_ROLE_DRESS_COLOR_DONE,
		GAME.ISLAND_GET_AUTO_COLLECTION_DATA_DONE,
		GAME.ISLAND_TAKE_AUTO_COLLECTION_DONE,
		PlayerProxy.UPDATED,
		IslandSettingsPage.SELECTCUSTOMGRAPHICSETTING,
		IslandSettingsPage.SELECTGRAPHICSETTINGLEVEL,
		NotificationProxy.FRIEND_REQUEST_REMOVED,
		NotificationProxy.FRIEND_REQUEST_ADDED,
		ActivityProxy.ACTIVITY_UPDATED,
		IslandShipOrderCard.EVENT_CD_END,
		GAME.PLAY_ROOM_JOIN_ROOM_DONE,
		GAME.PLAY_ROOM_MATCH_ENTER_READY_ROOM,
		GAME.ISLAND_CHEATER_FIRSTROND_START,
		GAME.ISLAND_PLAYER_CHEATER_OPERATE_DONE,
		GAME.ISLAND_CHEATER_OPERATE_DONE_NOTIFY,
		GAME.ISLAND_CHEATER_END_SCORE_NOTIFY,
		GAME.ISLAND_CHEATER_REAL_END_NOTIFY,
		GAME.ISLAND_CHEATER_START_SOLO_GAME_DONE,
		GAME.ISLAND_CHEATER_END_SOLO_GAME_DONE,
		GAME.ISLAND_CHEATER_RECONNECT,
		CheaterTavernEvent.PLAY_ROOM_LOAD_ROOM_SCENE,
		GAME.LOAD_LAYERS,
		CheaterTavernEvent.OPEN_SELECT_SHIP,
		GAME.PLAY_ROOM_ALL_LOAD_OVER,
		GAME.PLAY_ROOM_REDAY_ROOM_REFRESH,
		GAME.PLAY_ROOM_MATCH_REDAY_ROOM_REFRESH,
		GAME.ISLAND_CHEATER_DELEGATE_NOTIFY,
		CheaterTavernEvent.CLOSE_SHIP_SELECT_PAGE,
		IslandProxy.PRESS_BACK,
		var0_0.OPEN_MACHA_MODEL_PREVIEW,
		var0_0.SKIP_MAP
	}
end

function var0_0._handleNotification(arg0_105, arg1_105)
	local var0_105 = arg1_105:getName()
	local var1_105 = arg1_105:getBody()

	if var0_105 == GAME.ISLAND_PROSPERITY_AWARD_DONE or var0_105 == GAME.ISLAND_CONVERT_SEASON_PT_DONE or var0_105 == GAME.ISLAND_GET_SEASON_PT_AWARD_DONE or var0_105 == GAME.ISLAND_GET_ACHV_AWARD_DONE or var0_105 == GAME.ISLAND_FINISH_TECH_DONE or var0_105 == GAME.ISLAND_FINISH_TECH_IMMD_DONE or var0_105 == GAME.ISLAND_SUBMIT_TASK_ONE_STEP_DONE or var0_105 == GAME.SUBMIT_ACTIVITY_TASK_IN_ISLAND_DONE or var0_105 == GAME.ISLAND_GET_POINT_AWARD_DONE or var0_105 == GAME.ISLAND_UNLOCK_ILLUSTRATION_DONE or var0_105 == GAME.ISLAND_EXCHANGE_ITEM_DONE or var0_105 == GAME.ISLAND_SHIP_ORDER_OP_DONE or var0_105 == GAME.ISLAND_GET_DELEGATION_AWARD_DONE or var0_105 == GAME.ISLAND_GET_NPC_ACTION_AWARD_DONE then
		arg0_105.viewComponent:HandleAwardDisplay(var1_105.dropData, var1_105.callback)
	elseif var0_105 == var0_0.OPEN_MACHA_MODEL_PREVIEW then
		arg0_105.viewComponent:OpenPage(IslandMechaModelPreviewPage)
	elseif var0_105 == var0_0.SKIP_MAP then
		arg0_105.viewComponent:emit(IslandBaseMediator.SWITCH_MAP, var1_105.mapId)
	elseif var0_105 == GAME.ISLAND_INVITE_SHIP_DONE then
		arg0_105:HandleShipDisplay(var1_105.ship)
	elseif var0_105 == GAME.ISLAND_TAKE_AUTO_COLLECTION_DONE then
		arg0_105.viewComponent:HandleAwardDisplay(var1_105.dropData, var1_105.callback, IslandAwardDisplayPage.AUTO_COLLECT)
	elseif var0_105 == GAME.ISLAND_SHIP_BREAKOUT_DONE then
		arg0_105:HandleShipBreakOutAwardDisplay(var1_105)
	elseif var0_105 == GAME.ISLAND_GET_ORDER_EXP_AWARD_DONE then
		seriesAsync({
			function(arg0_106)
				arg0_105.viewComponent:emit(IslandOrderPage.ON_UPDADE, {
					level = var1_105.level,
					callback = arg0_106
				})
			end
		}, function()
			arg0_105.viewComponent:HandleAwardDisplay(var1_105.dropData, var1_105.callback)
		end)
	elseif var0_105 == GAME.ISLAND_GET_OVERFLOW_ITEM_DOME then
		if #var1_105.awards <= 0 then
			return
		end

		arg0_105.viewComponent:DisplayAward({
			title = i18n("island_item_transfer"),
			awards = var1_105.awards,
			callback = var1_105.callback
		})
	elseif var0_105 == GAME.ISLAND_SET_MANIFESTO_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_set_manifesto_success"))
	elseif var0_105 == GAME.ISLAND_SUBMIT_ORDER_DONE then
		local var2_105 = {
			function(arg0_108)
				arg0_105.viewComponent:HandleAwardDisplay(var1_105.dropData, arg0_108)
			end
		}

		seriesAsync(var2_105, function()
			if var1_105.callback then
				var1_105.callback()
			end

			arg0_105.viewComponent:emit(IslandScene.ON_CHECK_ORDER_EXP_AWARD)
		end)
	elseif var0_105 == GAME.ISLAND_ACCEPT_TASK_DONE then
		arg0_105:HandleTaskAccepted(var1_105)
	elseif var0_105 == GAME.ISLAND_SUBMIT_TASK_DONE then
		seriesAsync({
			function(arg0_110)
				local var0_110, var1_110 = IslandTask.GetSubmitPlayInfo(var1_105.taskId)

				if var0_110 == 1 then
					arg0_105.viewComponent:PlayStory({
						name = var1_110,
						callback = arg0_110
					})
				elseif var0_110 == 2 then
					arg0_105.viewComponent:OnPlayPerformance({
						name = var1_110,
						callback = arg0_110
					})
				else
					arg0_110()
				end
			end
		}, function()
			local function var0_111()
				local var0_112 = pg.island_task[var1_105.taskId].com_page

				if var0_112 ~= "" and var0_112[1] then
					arg0_105.viewComponent:OpenPage(_G[var0_112[1]], var0_112[2] and unpack(var0_112[2]))
				end

				existCall(var1_105.callback)
			end

			arg0_105.viewComponent:HandleAwardDisplay(var1_105.dropData, var0_111)
		end)
	elseif var0_105 == GAME.ISLAND_SET_TRACE_TASK_DONE then
		arg0_105.viewComponent:OnUpdateTrackTask(var1_105.traceId, var1_105.type)
	elseif var0_105 == GAME.ISLAND_REMOVE_EXPIRED_TICKET_DONE then
		arg0_105.viewComponent:ShowMsgbox({
			hideNo = true,
			type = IslandMsgBox.TYPE_TICKET_EXPIRED,
			body = {
				type = IslandTicketExpiredMsgBoxWindow.TYPES.EXPIRED,
				tickets = var1_105.tickets
			},
			onHide = var1_105.callback
		})
	elseif var0_105 == GAME.ISLAND_CLOSE_RESTAURANT_DONE then
		seriesAsync({
			function(arg0_113)
				if var1_105.isUpgrade then
					arg0_105.viewComponent:OpenPage(IslandRestaurantUpgradePage, var1_105, arg0_113)
				else
					arg0_113()
				end
			end,
			function(arg0_114)
				if var1_105.isSpEvent then
					arg0_105.viewComponent:OpenPage(IslandRestaurantSettlePage4Event, var1_105, arg0_114)
				else
					arg0_105.viewComponent:OpenPage(IslandRestaurantSettlePage, var1_105, arg0_114)
				end
			end
		}, function()
			arg0_105.viewComponent:HandleAwardDisplay(var1_105.dropData)
		end)
	elseif var0_105 == GAME.ISLAND_DROPMAIN_AWARD then
		arg0_105.viewComponent:UpdateMainAwardReward({
			awards = var1_105.dropData.awards
		})
	elseif var0_105 == GAME.ISLAND_QUEUE_UP then
		arg0_105.viewComponent:ShowQueueUpMsgBox(var1_105.id, var1_105.pos)
	elseif var0_105 == GAME.ISLAND_SIGN_IN_DONE then
		-- block empty
	elseif var0_105 == GAME.ISLAND_RESET_SP then
		arg0_105.viewComponent:ShowMsgbox({
			content = i18n("grapihcs3d_setting_common_unstuck_msgbox"),
			onYes = function()
				arg0_105.viewComponent:emitCoreController(IslandProxy.RESET_SP)
			end
		})
	elseif var0_105 == GAME.PLAY_ROOM_JOIN_ROOM_DONE then
		if getProxy(ContextProxy):getCurrentContext():getContextByMediator(PlayRoomMainMediator) == nil then
			if arg0_105.viewComponent:GetPage(IslandCheaterTavernPrepareMainPage) then
				arg0_105:sendNotification(CheaterTavernEvent.PLAY_ROOM_LOAD_ROOM_SCENE, IslandCheaterTavernConst.SceneRoomType.CustomRoom)
			else
				arg0_105.viewComponent:OpenPage(_G.IslandCheaterTavernPrepareMainPage, true, IslandCheaterTavernConst.SceneRoomType.CustomRoom)
			end
		end
	elseif var0_105 == GAME.PLAY_ROOM_MATCH_ENTER_READY_ROOM then
		if arg0_105.viewComponent:GetPage(IslandCheaterTavernPrepareMainPage) then
			arg0_105:sendNotification(CheaterTavernEvent.PLAY_ROOM_LOAD_ROOM_SCENE, IslandCheaterTavernConst.SceneRoomType.MatchInfoRoom)
		else
			arg0_105.viewComponent:OpenPage(_G.IslandCheaterTavernPrepareMainPage, true, IslandCheaterTavernConst.SceneRoomType.MatchInfoRoom)
		end
	end
end

function var0_0.HandleTaskAccepted(arg0_117, arg1_117)
	local var0_117 = {}
	local var1_117 = getProxy(IslandProxy):GetIsland():GetTaskAgency()

	for iter0_117, iter1_117 in ipairs(arg1_117.taskIds) do
		local var2_117 = pg.island_task[iter1_117]

		if var2_117.rec_perform ~= "" then
			table.insert(var0_117, function(arg0_118)
				arg0_117.viewComponent:PlayStory({
					name = var2_117.rec_perform,
					callback = arg0_118
				})
			end)
		end

		if var2_117.trigger_tips == 1 then
			table.insert(var0_117, function(arg0_119)
				arg0_117.viewComponent:ShowTaskAcceptPage({
					taskId = iter1_117,
					callback = arg0_119
				})
			end)
		end

		local var3_117 = var1_117:GetTask(iter1_117)

		if var3_117:IsFinish() and var3_117:IsSubmitImmediately() then
			table.insert(var0_117, function(arg0_120)
				pg.m02:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
					taskId = iter1_117,
					callback = arg0_120
				})
			end)
		end
	end

	seriesAsync(var0_117, function()
		existCall(arg1_117.callback)
	end)
end

function var0_0.HandleShipBreakOutAwardDisplay(arg0_122, arg1_122)
	seriesAsync({
		function(arg0_123)
			arg0_122.viewComponent:DisplayAward({
				type = IslandAwardDisplayPage.TYPE_SHIP_BREAK,
				newShip = arg1_122.newShip,
				oldShip = arg1_122.oldShip,
				callback = arg0_123
			})
		end,
		function(arg0_124)
			onNextTick(arg0_124)
		end,
		function(arg0_125)
			if not arg1_122.isUnlockSkill then
				arg0_125()

				return
			end

			arg0_122.viewComponent:DisplayAward({
				type = IslandAwardDisplayPage.TYPE_SHIP_SKILL,
				skill = arg1_122.newShip:GetSkill(),
				ship = arg1_122.newShip,
				callback = arg0_125
			})
		end
	})
end

function var0_0.HandleShipDisplay(arg0_126, arg1_126)
	arg0_126.viewComponent:OpenPage(IslandGetShipPage, arg1_126)
end

return var0_0
