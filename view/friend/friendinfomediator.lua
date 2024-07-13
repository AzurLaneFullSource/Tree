local var0_0 = class("FriendInfoMediator", import("..base.ContextMediator"))

var0_0.OPEND_FRIEND = "FriendInfoMediator:OPEND_FRIEND"
var0_0.OPEN_RESUME = "FriendInfoMediator:OPEN_RESUME"
var0_0.OPEN_BACKYARD = "FriendInfoMediator:OPEN_BACKYARD"
var0_0.TOGGLE_BLACK = "FriendInfoMediator:TOGGLE_BLACK"
var0_0.INFORM = "FriendInfoMediator:INFORM"
var0_0.INFORM_BACKYARD = "FriendInfoMediator:INFORM_BACKYARD"

function var0_0.register(arg0_1)
	local var0_1 = arg0_1.contextData.friend

	assert(var0_1, "friend is nil")
	arg0_1.viewComponent:setFriend(var0_1)
	arg0_1:bind(var0_0.INFORM_BACKYARD, function(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
		arg0_1:sendNotification(GAME.INFORM_THEME_TEMPLATE, {
			uid = arg1_2,
			content = arg2_2,
			tid = arg3_2,
			playerName = arg4_2
		})
	end)
	arg0_1:bind(var0_0.OPEND_FRIEND, function(arg0_3)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			limit = 20,
			yesText = "text_apply",
			type = MSGBOX_TYPE_INPUT,
			placeholder = i18n("friend_request_msg_placeholder"),
			title = i18n("friend_request_msg_title"),
			onYes = function(arg0_4)
				arg0_1:sendNotification(GAME.FRIEND_SEND_REQUEST, {
					id = var0_1.id,
					msg = arg0_4
				})
			end
		})
	end)
	arg0_1:bind(var0_0.OPEN_RESUME, function(arg0_5)
		arg0_1:addSubLayers(Context.New({
			mediator = resumeMediator,
			viewComponent = resumeLayer,
			data = {
				player = var0_1,
				parent = arg0_1.contextData.parent,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_NOTIFICATION
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_BACKYARD, function(arg0_6)
		arg0_1:sendNotification(GAME.VISIT_BACKYARD, var0_1.id)
	end)
	arg0_1:bind(var0_0.TOGGLE_BLACK, function(arg0_7)
		local var0_7 = getProxy(FriendProxy)
		local var1_7 = var0_1.id

		if var0_7:getBlackPlayerById(var1_7) ~= nil then
			arg0_1:sendNotification(GAME.FRIEND_RELIEVE_BLACKLIST, var1_7)
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
	arg0_1:bind(var0_0.INFORM, function(arg0_9, arg1_9, arg2_9, arg3_9)
		arg0_1:sendNotification(GAME.INFORM, {
			playerId = arg1_9,
			info = arg2_9,
			content = arg3_9
		})
	end)

	local var1_1 = getProxy(FriendProxy)

	if not var1_1:getBlackList() then
		arg0_1:sendNotification(GAME.GET_BLACK_LIST)
	end

	arg0_1.viewComponent:setFriendProxy(var1_1)
end

function var0_0.listNotificationInterests(arg0_10)
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

function var0_0.handleNotification(arg0_11, arg1_11)
	local var0_11 = arg1_11:getName()
	local var1_11 = arg1_11:getBody()

	if var0_11 == GAME.VISIT_BACKYARD_DONE then
		arg0_11.viewComponent:emit(BaseUI.ON_CLOSE)
		arg0_11:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD, {
			player = var1_11.player,
			dorm = var1_11.dorm,
			mode = CourtYardConst.SYSTEM_VISIT
		})
	elseif var0_11 == GAME.GET_BLACK_LIST_DONE or var0_11 == GAME.FRIEND_ADD_BLACKLIST_DONE or var0_11 == GAME.FRIEND_RELIEVE_BLACKLIST_DONE then
		arg0_11.viewComponent:updateBlack()
	elseif var0_11 == GAME.INFORM_DONE or var0_11 == GAME.INFORM_THEME_TEMPLATE_DONE then
		arg0_11.viewComponent:closeInfromPanel()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			parent = arg0_11.contextData.parent,
			content = i18n("inform_sueecss_tip")
		})
	elseif var0_11 == GAME.FINISH_STAGE then
		arg0_11.viewComponent:closeView()
	end
end

return var0_0
