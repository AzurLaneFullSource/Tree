local var0 = class("FriendInfoMediator", import("..base.ContextMediator"))

var0.OPEND_FRIEND = "FriendInfoMediator:OPEND_FRIEND"
var0.OPEN_RESUME = "FriendInfoMediator:OPEN_RESUME"
var0.OPEN_BACKYARD = "FriendInfoMediator:OPEN_BACKYARD"
var0.TOGGLE_BLACK = "FriendInfoMediator:TOGGLE_BLACK"
var0.INFORM = "FriendInfoMediator:INFORM"
var0.INFORM_BACKYARD = "FriendInfoMediator:INFORM_BACKYARD"

function var0.register(arg0)
	local var0 = arg0.contextData.friend

	assert(var0, "friend is nil")
	arg0.viewComponent:setFriend(var0)
	arg0:bind(var0.INFORM_BACKYARD, function(arg0, arg1, arg2, arg3, arg4)
		arg0:sendNotification(GAME.INFORM_THEME_TEMPLATE, {
			uid = arg1,
			content = arg2,
			tid = arg3,
			playerName = arg4
		})
	end)
	arg0:bind(var0.OPEND_FRIEND, function(arg0)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			limit = 20,
			yesText = "text_apply",
			type = MSGBOX_TYPE_INPUT,
			placeholder = i18n("friend_request_msg_placeholder"),
			title = i18n("friend_request_msg_title"),
			onYes = function(arg0)
				arg0:sendNotification(GAME.FRIEND_SEND_REQUEST, {
					id = var0.id,
					msg = arg0
				})
			end
		})
	end)
	arg0:bind(var0.OPEN_RESUME, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = resumeMediator,
			viewComponent = resumeLayer,
			data = {
				player = var0,
				parent = arg0.contextData.parent,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_NOTIFICATION
			}
		}))
	end)
	arg0:bind(var0.OPEN_BACKYARD, function(arg0)
		arg0:sendNotification(GAME.VISIT_BACKYARD, var0.id)
	end)
	arg0:bind(var0.TOGGLE_BLACK, function(arg0)
		local var0 = getProxy(FriendProxy)
		local var1 = var0.id

		if var0:getBlackPlayerById(var1) ~= nil then
			arg0:sendNotification(GAME.FRIEND_RELIEVE_BLACKLIST, var1)
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = false,
				content = i18n("friend_confirm_add_blacklist", var0.name),
				onYes = function()
					arg0:sendNotification(GAME.FRIEND_ADD_BLACKLIST, var0)
				end
			})
		end
	end)
	arg0:bind(var0.INFORM, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.INFORM, {
			playerId = arg1,
			info = arg2,
			content = arg3
		})
	end)

	local var1 = getProxy(FriendProxy)

	if not var1:getBlackList() then
		arg0:sendNotification(GAME.GET_BLACK_LIST)
	end

	arg0.viewComponent:setFriendProxy(var1)
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.VISIT_BACKYARD_DONE then
		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD, {
			player = var1.player,
			dorm = var1.dorm,
			mode = CourtYardConst.SYSTEM_VISIT
		})
	elseif var0 == GAME.GET_BLACK_LIST_DONE or var0 == GAME.FRIEND_ADD_BLACKLIST_DONE or var0 == GAME.FRIEND_RELIEVE_BLACKLIST_DONE then
		arg0.viewComponent:updateBlack()
	elseif var0 == GAME.INFORM_DONE or var0 == GAME.INFORM_THEME_TEMPLATE_DONE then
		arg0.viewComponent:closeInfromPanel()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			parent = arg0.contextData.parent,
			content = i18n("inform_sueecss_tip")
		})
	elseif var0 == GAME.FINISH_STAGE then
		arg0.viewComponent:closeView()
	end
end

return var0
