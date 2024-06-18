local var0_0 = class("FriendMediator", import("..base.ContextMediator"))

var0_0.SEARCH_FRIEND = "FriendMediator:SEARCH_FRIEND"
var0_0.ADD_FRIEND = "FriendMediator:ADD_FRIEND"
var0_0.ACCEPT_REQUEST = "FriendMediator:ACCEPT_REQUEST"
var0_0.REFUSE_REQUEST = "FriendMediator:REFUSE_REQUEST"
var0_0.DELETE_FRIEND = "FriendMediator:DELETE_FRIEND"
var0_0.OPEN_RESUME = "FriendMediator:OPEN_RESUME"
var0_0.OPEN_RESUME_BY_VO = "FriendMediator:OPEN_RESUME_BY_VO"
var0_0.REFUSE_ALL_REQUEST = "FriendMediator:REFUSE_ALL_REQUEST"
var0_0.OPEN_CHATROOM = "FriendMediator:OPEN_CHATROOM"
var0_0.VISIT_BACKYARD = "FriendMediator:VISIT_BACKYRAD"
var0_0.RELIEVE_BLACKLIST = "FriendMediator:RELIEVE_BLACKLIST"
var0_0.GET_BLACK_LIST = "FriendMediator:GET_BLACK_LIST"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(FriendProxy)
	local var1_1 = var0_1:getAllFriends()

	arg0_1.viewComponent:setFriendVOs(var1_1)

	local var2_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var2_1)

	local var3_1 = getProxy(NotificationProxy):getRequests()

	arg0_1.viewComponent:setRequests(var3_1)

	local var4_1 = var0_1:getBlackList()

	arg0_1.viewComponent:setBlackList(var4_1)
	arg0_1:bind(var0_0.GET_BLACK_LIST, function(arg0_2)
		arg0_1:sendNotification(GAME.GET_BLACK_LIST)
	end)
	arg0_1:bind(var0_0.SEARCH_FRIEND, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.FRIEND_SEARCH, {
			type = arg1_3,
			keyword = arg2_3
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHATROOM, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			mediator = ChatRoomMediator,
			viewComponent = ChatRoomLayer,
			data = {
				friendVO = arg1_4
			}
		}))
	end)
	arg0_1:bind(var0_0.ADD_FRIEND, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.FRIEND_SEND_REQUEST, {
			id = arg1_5,
			msg = arg2_5
		})
	end)
	arg0_1:bind(var0_0.ACCEPT_REQUEST, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.FRIEND_ACCEPT_REQUEST, arg1_6)
	end)
	arg0_1:bind(var0_0.REFUSE_ALL_REQUEST, function(arg0_7)
		arg0_1:sendNotification(GAME.FRIEND_REJECT_REQUEST, 0)
	end)
	arg0_1:bind(var0_0.REFUSE_REQUEST, function(arg0_8, arg1_8, arg2_8)
		arg0_1:sendNotification(GAME.FRIEND_REJECT_REQUEST, arg1_8.id)

		if arg2_8 then
			arg0_1:sendNotification(GAME.FRIEND_ADD_BLACKLIST, arg1_8)
		end
	end)
	arg0_1:bind(var0_0.DELETE_FRIEND, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.FRIEND_DELETE, arg1_9)
	end)
	arg0_1:bind(var0_0.OPEN_RESUME, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.FRIEND_SEARCH, {
			type = SearchFriendCommand.SEARCH_TYPE_RESUME,
			keyword = arg1_10
		})
	end)
	arg0_1:bind(var0_0.OPEN_RESUME_BY_VO, function(arg0_11, arg1_11)
		arg0_1:openResume(arg1_11)
	end)
	arg0_1:bind(var0_0.VISIT_BACKYARD, function(arg0_12, arg1_12)
		arg0_1:sendNotification(GAME.VISIT_BACKYARD, arg1_12)
	end)
	arg0_1:bind(var0_0.RELIEVE_BLACKLIST, function(arg0_13, arg1_13)
		arg0_1:sendNotification(GAME.FRIEND_RELIEVE_BLACKLIST, arg1_13)
	end)
	arg0_1:updateChatNotification()
end

function var0_0.updateChatNotification(arg0_14)
	local var0_14 = getProxy(FriendProxy):getNewMsgCount()

	arg0_14.viewComponent:updateChatNotification(var0_14)
end

function var0_0.openResume(arg0_15, arg1_15)
	arg0_15:addSubLayers(Context.New({
		mediator = resumeMediator,
		viewComponent = resumeLayer,
		data = {
			player = arg1_15
		}
	}))
end

function var0_0.listNotificationInterests(arg0_16)
	return {
		GAME.FRIEND_SEARCH_DONE,
		GAME.FRIEND_SEND_REQUEST_DONE,
		NotificationProxy.FRIEND_REQUEST_REMOVED,
		NotificationProxy.FRIEND_REQUEST_ADDED,
		FriendProxy.FRIEND_REMOVED,
		FriendProxy.FRIEND_ADDED,
		FriendProxy.FRIEND_UPDATED,
		GAME.VISIT_BACKYARD_DONE,
		GAME.FRIEND_RELIEVE_BLACKLIST_DONE,
		FriendProxy.RELIEVE_BLACKLIST,
		FriendProxy.BLACK_LIST_UPDATED,
		FriendProxy.ADD_INTO_BLACKLIST
	}
end

function var0_0.handleNotification(arg0_17, arg1_17)
	local var0_17 = arg1_17:getName()
	local var1_17 = arg1_17:getBody()

	if var0_17 == GAME.FRIEND_SEARCH_DONE then
		if var1_17.type == SearchFriendCommand.SEARCH_TYPE_RESUME then
			arg0_17:openResume(var1_17.list[1])
		else
			arg0_17.viewComponent:setSearchResult(var1_17.list)
			arg0_17.viewComponent:updatePage(FriendScene.SEARCH_PAGE)

			if table.getCount(var1_17.list) > 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("friend_search_succeed"))
			end
		end
	elseif var0_17 == GAME.FRIEND_SEND_REQUEST_DONE then
		arg0_17.viewComponent:removeSearchResult(var1_17)
		arg0_17.viewComponent:updatePage(FriendScene.SEARCH_PAGE)
	elseif var0_17 == NotificationProxy.FRIEND_REQUEST_REMOVED or var0_17 == NotificationProxy.FRIEND_REQUEST_ADDED then
		local var2_17 = getProxy(NotificationProxy):getRequests()

		arg0_17.viewComponent:setRequests(var2_17)
		arg0_17.viewComponent:updatePage(FriendScene.REQUEST_PAGE)
		arg0_17.viewComponent:updateRequestTip()
	elseif var0_17 == FriendProxy.FRIEND_REMOVED or var0_17 == FriendProxy.FRIEND_ADDED or var0_17 == FriendProxy.FRIEND_UPDATED then
		local var3_17 = getProxy(FriendProxy):getAllFriends()

		arg0_17.viewComponent:setFriendVOs(var3_17)
		arg0_17.viewComponent:updatePage(FriendScene.FRIEND_PAGE)

		if var0_17 == FriendProxy.FRIEND_UPDATED then
			arg0_17:updateChatNotification()
		end
	elseif var0_17 == FriendProxy.RELIEVE_BLACKLIST or var0_17 == FriendProxy.BLACK_LIST_UPDATED or var0_17 == FriendProxy.ADD_INTO_BLACKLIST then
		local var4_17 = getProxy(FriendProxy):getBlackList()

		arg0_17.viewComponent:setBlackList(var4_17)
		arg0_17.viewComponent:updatePage(FriendScene.BLACKLIST_PAGE)
	elseif var0_17 == GAME.VISIT_BACKYARD_DONE then
		arg0_17:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD, {
			player = var1_17.player,
			dorm = var1_17.dorm,
			mode = CourtYardConst.SYSTEM_VISIT
		})
	end
end

return var0_0
