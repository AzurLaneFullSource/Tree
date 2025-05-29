local var0_0 = class("NewSkinTBMediator", import("..base.ContextMediator"))

var0_0.ON_EXIT = "NewSkinTBMediator:ON_EXIT"
var0_0.GO_SET_TB_SKIN = "NewSkinTBMediator:GO_SET_TB_SKIN"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_SET_TB_SKIN, function(arg0_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EDUCATE_DOCK, {
			OnSelected = function(arg0_3)
				arg0_1:sendNotification(GAME.CHANGE_EDUCATE, {
					id = arg0_3
				})
			end,
			tbSkinId = arg0_1.contextData.skinId
		})
	end)

	arg0_1.contextData.secId = NewEducateHelper.GetSecIdBySkinId(arg0_1.contextData.skinId)
	arg0_1.contextData.isClose = getProxy(PlayerProxy):getRawData():GetEducateCharacter() == arg0_1.contextData.secId

	arg0_1.viewComponent:setSkin(arg0_1.contextData.skinId)
end

function var0_0.onUIAvalible(arg0_4)
	return
end

function var0_0.listNotificationInterests(arg0_5)
	return {}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()
end

return var0_0
