local var0_0 = class("FriendInfoMediator", import("..base.ContextMediator"))

var0_0.OPEND_FRIEND = "FriendInfoMediator:OPEND_FRIEND"
var0_0.OPEN_RESUME = "FriendInfoMediator:OPEN_RESUME"
var0_0.OPEN_BACKYARD = "FriendInfoMediator:OPEN_BACKYARD"
var0_0.TOGGLE_BLACK = "FriendInfoMediator:TOGGLE_BLACK"
var0_0.INFORM = "FriendInfoMediator:INFORM"
var0_0.INFORM_BACKYARD = "FriendInfoMediator:INFORM_BACKYARD"
var0_0.OPEN_ISLAND_CARD = "FriendInfoMediator:OPEN_ISLAND_CARD"

function var0_0.register(arg0_1)
	local var0_1 = arg0_1.contextData.friend

	assert(var0_1, "friend is nil")
	arg0_1.viewComponent:setFriend(var0_1)
	arg0_1:bind(var0_0.OPEN_ISLAND_CARD, function(arg0_2)
		arg0_1:addSubLayers(Context.New({
			mediator = IslandOtherCardMediator,
			viewComponent = IslandOtherCardLayer,
			data = {
				userId = arg0_1.contextData.friend.id
			}
		}))
	end)
	arg0_1:bind(var0_0.INFORM_BACKYARD, function(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
		arg0_1:sendNotification(GAME.INFORM_THEME_TEMPLATE, {
			uid = arg1_3,
			content = arg2_3,
			tid = arg3_3,
			playerName = arg4_3
		})
	end)
	arg0_1:bind(var0_0.OPEND_FRIEND, function(arg0_4)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			limit = 20,
			yesText = "text_apply",
			type = MSGBOX_TYPE_INPUT,
			placeholder = i18n("friend_request_msg_placeholder"),
			title = i18n("friend_request_msg_title"),
			onYes = function(arg0_5)
				arg0_1:sendNotification(GAME.FRIEND_SEND_REQUEST, {
					id = var0_1.id,
					msg = arg0_5
				})
			end
		})
	end)
	arg0_1:bind(var0_0.OPEN_RESUME, function(arg0_6)
		arg0_1:addSubLayers(Context.New({
			mediator = resumeMediator,
			viewComponent = resumeLayer,
			data = {
				player = var0_1,
				parent = arg0_1.contextData.parent
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_BACKYARD, function(arg0_7)
		arg0_1:sendNotification(GAME.VISIT_BACKYARD, var0_1.id)
	end)
	arg0_1:bind(var0_0.TOGGLE_BLACK, function(arg0_8)
		local var0_8 = getProxy(FriendProxy)
		local var1_8 = var0_1.id

		if var0_8:getBlackPlayerById(var1_8) ~= nil then
			arg0_1:sendNotification(GAME.FRIEND_RELIEVE_BLACKLIST, var1_8)
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = false,
				content = i18n("friend_confirm_add_blacklist", var0_1.name),
				onYes = function()
					arg0_1:sendNotification(GAME.FRIEND_ADD_BLACKLIST, var0_1)
				end
			})
		end
	end)
	arg0_1:bind(var0_0.INFORM, function(arg0_10, arg1_10, arg2_10, arg3_10)
		arg0_1:sendNotification(GAME.INFORM, {
			playerId = arg1_10,
			info = arg2_10,
			content = arg3_10
		})
	end)

	local var1_1 = getProxy(FriendProxy)

	if not var1_1:getBlackList() then
		arg0_1:sendNotification(GAME.GET_BLACK_LIST)
	end

	arg0_1.viewComponent:setFriendProxy(var1_1)
end

function var0_0.listNotificationInterests(arg0_11)
	return {
		GAME.VISIT_BACKYARD_DONE,
		GAME.GET_BLACK_LIST_DONE,
		GAME.FRIEND_ADD_BLACKLIST_DONE,
		GAME.FRIEND_RELIEVE_BLACKLIST_DONE,
		GAME.INFORM_DONE,
		GAME.INFORM_THEME_TEMPLATE_DONE,
		GAME.FINISH_STAGE
	}
end

function var0_0.handleNotification(arg0_12, arg1_12)
	local var0_12 = arg1_12:getName()
	local var1_12 = arg1_12:getBody()

	if var0_12 == GAME.VISIT_BACKYARD_DONE then
		arg0_12.viewComponent:emit(BaseUI.ON_CLOSE)
		arg0_12:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD, {
			player = var1_12.player,
			dorm = var1_12.dorm,
			mode = CourtYardConst.SYSTEM_VISIT
		})
	elseif var0_12 == GAME.GET_BLACK_LIST_DONE or var0_12 == GAME.FRIEND_ADD_BLACKLIST_DONE or var0_12 == GAME.FRIEND_RELIEVE_BLACKLIST_DONE then
		arg0_12.viewComponent:updateBlack()
	elseif var0_12 == GAME.INFORM_DONE or var0_12 == GAME.INFORM_THEME_TEMPLATE_DONE then
		arg0_12.viewComponent:closeInfromPanel()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			parent = arg0_12.contextData.parent,
			content = i18n("inform_sueecss_tip")
		})
	elseif var0_12 == GAME.FINISH_STAGE then
		arg0_12.viewComponent:closeView()
	end
end

return var0_0
