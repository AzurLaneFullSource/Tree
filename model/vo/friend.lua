local var0 = class("Friend", import(".Player"))

var0.ONLINE = 1
var0.OFFLINE = 0

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.shipCount = arg1.ship_count or 0
	arg0.collectionCount = arg1.collection_count or 0
	arg0.online = arg1.online or 1
	arg0.preOnLineTime = arg1.pre_online_time or 0
	arg0.requestMsg = arg1.request_msg or ""
	arg0.score = arg0.score + SeasonInfo.INIT_POINT
	arg0.unreadCount = 0
end

function var0.increaseUnreadCount(arg0)
	arg0.unreadCount = arg0.unreadCount + 1
end

function var0.resetUnreadCount(arg0)
	arg0.unreadCount = 0
end

function var0.isOnline(arg0)
	return arg0.online == var0.ONLINE
end

function var0.hasUnreadMsg(arg0)
	return arg0.unreadCount > 0
end

function var0.GetManifesto(arg0)
	if getProxy(PlayerProxy):getRawData():ShouldCheckCustomName() then
		return ""
	else
		return var0.super.GetManifesto(arg0)
	end
end

return var0
