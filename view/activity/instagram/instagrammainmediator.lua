local var0_0 = class("InstagramMainMediator", import("...base.ContextMediator"))

var0_0.OPEN_CHAT = "InstagramMainMediator:OPEN_CHAT"
var0_0.OPEN_JUUS = "InstagramMainMediator:OPEN_JUUS"
var0_0.CLOSE_CHAT = "InstagramMainMediator:CLOSE_CHAT"
var0_0.CLOSE_JUUS = "InstagramMainMediator:CLOSE_JUUS"
var0_0.CHANGE_JUUS_TIP = "InstagramMainMediator:CHANGE_JUUS_TIP"
var0_0.CHANGE_CHAT_TIP = "InstagramMainMediator:CHANGE_CHAT_TIP"
var0_0.CLOSE_ALL = "InstagramMainMediator:CLOSE_ALL"
var0_0.CLOSE_JUUS_DETAIL = "InstagramMainMediator:CLOSE_JUUS_DETAIL"
var0_0.JUUS_BACK_PRESSED = "InstagramMainMediator:JUUS_BACK_PRESSED"
var0_0.INS_BACK_PRESSED = "InstagramMainMediator:INS_BACK_PRESSED"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_CHAT, function(arg0_2)
		arg0_1:addSubLayers(Context.New({
			viewComponent = InstagramChatLayer,
			mediator = InstagramChatMediator,
			data = {
				groupName = arg0_1.viewComponent:getGroupName()
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_JUUS, function(arg0_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = InstagramLayer,
			mediator = InstagramMediator,
			data = {
				groupName = arg0_1.viewComponent:getGroupName()
			}
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_CHAT, function(arg0_4)
		arg0_1:removeSubLayers(InstagramChatMediator)
	end)
	arg0_1:bind(var0_0.CLOSE_JUUS, function(arg0_5)
		arg0_1:removeSubLayers(InstagramMediator)
	end)
	arg0_1:bind(var0_0.CLOSE_JUUS_DETAIL, function(arg0_6)
		arg0_1:sendNotification(InstagramMediator.CLOSE_DETAIL)
	end)
	arg0_1:bind(var0_0.JUUS_BACK_PRESSED, function(arg0_7)
		arg0_1:sendNotification(InstagramChatMediator.BACK_PRESSED)
	end)
	arg0_1:bind(var0_0.INS_BACK_PRESSED, function(arg0_8)
		arg0_1:sendNotification(InstagramMediator.BACK_PRESSED)
	end)
end

function var0_0.listNotificationInterests(arg0_9)
	return {
		var0_0.CHANGE_CHAT_TIP,
		var0_0.CHANGE_JUUS_TIP,
		var0_0.CLOSE_ALL
	}
end

function var0_0.handleNotification(arg0_10, arg1_10)
	local var0_10 = arg1_10:getName()
	local var1_10 = arg1_10:getBody()

	if var0_10 == var0_0.CHANGE_CHAT_TIP then
		arg0_10.viewComponent:ChangeChatTip()
	elseif var0_10 == var0_0.CHANGE_JUUS_TIP then
		arg0_10.viewComponent:ChangeJuusTip()
	elseif var0_10 == var0_0.CLOSE_ALL then
		arg0_10.viewComponent:closeView()
	end
end

return var0_0
