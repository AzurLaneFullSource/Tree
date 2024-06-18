local var0_0 = class("Friend", import(".Player"))

var0_0.ONLINE = 1
var0_0.OFFLINE = 0

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.shipCount = arg1_1.ship_count or 0
	arg0_1.collectionCount = arg1_1.collection_count or 0
	arg0_1.online = arg1_1.online or 1
	arg0_1.preOnLineTime = arg1_1.pre_online_time or 0
	arg0_1.requestMsg = arg1_1.request_msg or ""
	arg0_1.score = arg0_1.score + SeasonInfo.INIT_POINT
	arg0_1.unreadCount = 0
end

function var0_0.increaseUnreadCount(arg0_2)
	arg0_2.unreadCount = arg0_2.unreadCount + 1
end

function var0_0.resetUnreadCount(arg0_3)
	arg0_3.unreadCount = 0
end

function var0_0.isOnline(arg0_4)
	return arg0_4.online == var0_0.ONLINE
end

function var0_0.hasUnreadMsg(arg0_5)
	return arg0_5.unreadCount > 0
end

function var0_0.GetManifesto(arg0_6)
	if getProxy(PlayerProxy):getRawData():ShouldCheckCustomName() then
		return ""
	else
		return var0_0.super.GetManifesto(arg0_6)
	end
end

return var0_0
