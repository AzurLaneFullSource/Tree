local var0 = class("FriendMediator", import("..base.ContextMediator"))

var0.SEARCH_FRIEND = "FriendMediator:SEARCH_FRIEND"
var0.ADD_FRIEND = "FriendMediator:ADD_FRIEND"
var0.ACCEPT_REQUEST = "FriendMediator:ACCEPT_REQUEST"
var0.REFUSE_REQUEST = "FriendMediator:REFUSE_REQUEST"
var0.DELETE_FRIEND = "FriendMediator:DELETE_FRIEND"
var0.OPEN_RESUME = "FriendMediator:OPEN_RESUME"
var0.OPEN_RESUME_BY_VO = "FriendMediator:OPEN_RESUME_BY_VO"
var0.REFUSE_ALL_REQUEST = "FriendMediator:REFUSE_ALL_REQUEST"
var0.OPEN_CHATROOM = "FriendMediator:OPEN_CHATROOM"
var0.VISIT_BACKYARD = "FriendMediator:VISIT_BACKYRAD"
var0.RELIEVE_BLACKLIST = "FriendMediator:RELIEVE_BLACKLIST"
var0.GET_BLACK_LIST = "FriendMediator:GET_BLACK_LIST"

function var0.register(arg0)
	local var0 = getProxy(FriendProxy)
	local var1 = var0:getAllFriends()

	arg0.viewComponent:setFriendVOs(var1)

	local var2 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var2)

	local var3 = getProxy(NotificationProxy):getRequests()

	arg0.viewComponent:setRequests(var3)

	local var4 = var0:getBlackList()

	arg0.viewComponent:setBlackList(var4)
	arg0:bind(var0.GET_BLACK_LIST, function(arg0)
		arg0:sendNotification(GAME.GET_BLACK_LIST)
	end)
	arg0:bind(var0.SEARCH_FRIEND, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.FRIEND_SEARCH, {
			type = arg1,
			keyword = arg2
		})
	end)
	arg0:bind(var0.OPEN_CHATROOM, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChatRoomMediator,
			viewComponent = ChatRoomLayer,
			data = {
				friendVO = arg1
			}
		}))
	end)
	arg0:bind(var0.ADD_FRIEND, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.FRIEND_SEND_REQUEST, {
			id = arg1,
			msg = arg2
		})
	end)
	arg0:bind(var0.ACCEPT_REQUEST, function(arg0, arg1)
		arg0:sendNotification(GAME.FRIEND_ACCEPT_REQUEST, arg1)
	end)
	arg0:bind(var0.REFUSE_ALL_REQUEST, function(arg0)
		arg0:sendNotification(GAME.FRIEND_REJECT_REQUEST, 0)
	end)
	arg0:bind(var0.REFUSE_REQUEST, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.FRIEND_REJECT_REQUEST, arg1.id)

		if arg2 then
			arg0:sendNotification(GAME.FRIEND_ADD_BLACKLIST, arg1)
		end
	end)
	arg0:bind(var0.DELETE_FRIEND, function(arg0, arg1)
		arg0:sendNotification(GAME.FRIEND_DELETE, arg1)
	end)
	arg0:bind(var0.OPEN_RESUME, function(arg0, arg1)
		arg0:sendNotification(GAME.FRIEND_SEARCH, {
			type = SearchFriendCommand.SEARCH_TYPE_RESUME,
			keyword = arg1
		})
	end)
	arg0:bind(var0.OPEN_RESUME_BY_VO, function(arg0, arg1)
		arg0:openResume(arg1)
	end)
	arg0:bind(var0.VISIT_BACKYARD, function(arg0, arg1)
		arg0:sendNotification(GAME.VISIT_BACKYARD, arg1)
	end)
	arg0:bind(var0.RELIEVE_BLACKLIST, function(arg0, arg1)
		arg0:sendNotification(GAME.FRIEND_RELIEVE_BLACKLIST, arg1)
	end)
	arg0:updateChatNotification()
end

function var0.updateChatNotification(arg0)
	local var0 = getProxy(FriendProxy):getNewMsgCount()

	arg0.viewComponent:updateChatNotification(var0)
end

function var0.openResume(arg0, arg1)
	arg0:addSubLayers(Context.New({
		mediator = resumeMediator,
		viewComponent = resumeLayer,
		data = {
			player = arg1
		}
	}))
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.FRIEND_SEARCH_DONE then
		if var1.type == SearchFriendCommand.SEARCH_TYPE_RESUME then
			arg0:openResume(var1.list[1])
		else
			arg0.viewComponent:setSearchResult(var1.list)
			arg0.viewComponent:updatePage(FriendScene.SEARCH_PAGE)

			if table.getCount(var1.list) > 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("friend_search_succeed"))
			end
		end
	elseif var0 == GAME.FRIEND_SEND_REQUEST_DONE then
		arg0.viewComponent:removeSearchResult(var1)
		arg0.viewComponent:updatePage(FriendScene.SEARCH_PAGE)
	elseif var0 == NotificationProxy.FRIEND_REQUEST_REMOVED or var0 == NotificationProxy.FRIEND_REQUEST_ADDED then
		local var2 = getProxy(NotificationProxy):getRequests()

		arg0.viewComponent:setRequests(var2)
		arg0.viewComponent:updatePage(FriendScene.REQUEST_PAGE)
		arg0.viewComponent:updateRequestTip()
	elseif var0 == FriendProxy.FRIEND_REMOVED or var0 == FriendProxy.FRIEND_ADDED or var0 == FriendProxy.FRIEND_UPDATED then
		local var3 = getProxy(FriendProxy):getAllFriends()

		arg0.viewComponent:setFriendVOs(var3)
		arg0.viewComponent:updatePage(FriendScene.FRIEND_PAGE)

		if var0 == FriendProxy.FRIEND_UPDATED then
			arg0:updateChatNotification()
		end
	elseif var0 == FriendProxy.RELIEVE_BLACKLIST or var0 == FriendProxy.BLACK_LIST_UPDATED or var0 == FriendProxy.ADD_INTO_BLACKLIST then
		local var4 = getProxy(FriendProxy):getBlackList()

		arg0.viewComponent:setBlackList(var4)
		arg0.viewComponent:updatePage(FriendScene.BLACKLIST_PAGE)
	elseif var0 == GAME.VISIT_BACKYARD_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COURTYARD, {
			player = var1.player,
			dorm = var1.dorm,
			mode = CourtYardConst.SYSTEM_VISIT
		})
	end
end

return var0
