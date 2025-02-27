local var0_0 = class("Dorm3dInsMainMediator", import("view.base.ContextMediator"))

var0_0.OPEN_CHAT = "Dorm3dInsMainMediator:OPEN_CHAT"
var0_0.OPEN_JUUS = "Dorm3dInsMainMediator:OPEN_JUUS"
var0_0.CLOSE_CHAT = "Dorm3dInsMainMediator:CLOSE_CHAT"
var0_0.CLOSE_JUUS = "Dorm3dInsMainMediator:CLOSE_JUUS"
var0_0.CHANGE_JUUS_TIP = "Dorm3dInsMainMediator:CHANGE_JUUS_TIP"
var0_0.CHANGE_CHAT_TIP = "Dorm3dInsMainMediator:CHANGE_CHAT_TIP"
var0_0.CLOSE_JUUS_DETAIL = "Dorm3dInsMainMediator.CLOSE_JUUS_DETAIL"
var0_0.JUUS_BACK_PRESSED = "Dorm3dInsMainMediator.JUUS_BACK_PRESSED"
var0_0.NotifyDormDelete = "Dorm3dInsMainMediator.NotifyDormDelete"
var0_0.ON_UNLOCK_DORM_ROOM = "Dorm3dInsMainMediator.ON_UNLOCK_DORM_ROOM"
var0_0.OPEN_INVITE_LAYER = "Dorm3dInsMainMediator.OPEN_INVITE_LAYER"
var0_0.OPEN_ROOM_UNLOCK_WINDOW = "Dorm3dInsMainMediator.OPEN_ROOM_UNLOCK_WINDOW"
var0_0.OPEN_PHONE = "Dorm3dInsMainMediator.OPEN_PHONE"
var0_0.CLOSE_PHONE = "Dorm3dInsMainMediator.CLOSE_PHONE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_CHAT, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dChatLayer,
			mediator = Dorm3dChatMediator,
			data = {
				chatId = arg1_2,
				tf = arg0_1.viewComponent._tf
			},
			onRemoved = function()
				arg0_1.viewComponent:OpenMain()
			end
		}))
	end)
	arg0_1:bind(var0_0.OPEN_JUUS, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dInstagramLayer,
			mediator = Dorm3dInstagramMediator,
			data = {
				apartmentGroupId = arg1_4,
				tf = arg0_1.viewComponent._tf
			},
			onRemoved = function()
				arg0_1.viewComponent:OpenMain()
			end
		}))
	end)
	arg0_1:bind(var0_0.OPEN_PHONE, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dInsPhoneLayer,
			mediator = Dorm3dInsPhoneMediator,
			data = {
				groupId = arg1_6,
				tf = arg0_1.viewComponent._tf
			},
			onRemoved = function()
				arg0_1.viewComponent:OpenMain()
			end
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_PHONE, function(arg0_8, arg1_8)
		arg0_1:removeSubLayers(Dorm3dInsPhoneMediator)
	end)
	arg0_1:bind(var0_0.CLOSE_CHAT, function(arg0_9)
		arg0_1:removeSubLayers(Dorm3dChatMediator)
	end)
	arg0_1:bind(var0_0.CLOSE_JUUS, function(arg0_10)
		arg0_1:removeSubLayers(Dorm3dInstagramMediator)
	end)
	arg0_1:bind(var0_0.CLOSE_JUUS_DETAIL, function(arg0_11)
		arg0_1:sendNotification(Dorm3dInstagramMediator.CLOSE_DETAIL)
	end)
	arg0_1:bind(var0_0.JUUS_BACK_PRESSED, function(arg0_12)
		arg0_1:sendNotification(Dorm3dInstagramMediator.BACK_PRESSED)
	end)
	arg0_1:bind(var0_0.NotifyDormDelete, function(arg0_13, arg1_13)
		arg0_1:sendNotification(var0_0.NotifyDormDelete, arg1_13)
	end)
	arg0_1:bind(var0_0.ON_UNLOCK_DORM_ROOM, function(arg0_14, arg1_14)
		arg0_1:sendNotification(GAME.APARTMENT_ROOM_UNLOCK, {
			roomId = arg1_14
		})
	end)
	arg0_1:bind(var0_0.OPEN_ROOM_UNLOCK_WINDOW, function(arg0_15, arg1_15, arg2_15)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dRoomUnlockWindow,
			mediator = Dorm3dRoomUnlockWindowMediator,
			data = {
				roomId = arg1_15,
				groupId = arg2_15
			},
			onRemoved = function()
				arg0_1.viewComponent:Flush()
			end
		}))
	end)
end

function var0_0.initNotificationHandleDic(arg0_17)
	arg0_17.handleDic = {
		[DormGroupConst.NotifyDormDownloadStart] = function(arg0_18, arg1_18)
			local var0_18 = arg1_18:getBody()

			arg0_18.viewComponent:DownloadUpdate(DormGroupConst.DormDownloadLock.roomId, "start")
		end,
		[DormGroupConst.NotifyDormDownloadProgress] = function(arg0_19, arg1_19)
			local var0_19 = arg1_19:getBody()

			arg0_19.viewComponent:DownloadUpdate(DormGroupConst.DormDownloadLock.roomId, "loading")
		end,
		[DormGroupConst.NotifyDormDownloadFinish] = function(arg0_20, arg1_20)
			arg0_20.viewComponent:DownloadUpdate(arg1_20:getBody(), "finish")
		end,
		[Dorm3dInsMainMediator.NotifyDormDelete] = function(arg0_21, arg1_21)
			arg0_21.viewComponent:DownloadUpdate(arg1_21:getBody(), "delete")
		end
	}
end

return var0_0
