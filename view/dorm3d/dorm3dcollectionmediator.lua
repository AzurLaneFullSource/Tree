local var0 = class("Dorm3dCollectionMediator", import("view.base.ContextMediator"))

var0.DO_TALK = "Dorm3dCollectionMediator.DO_TALK"

function var0.register(arg0)
	arg0:bind(var0.DO_TALK, function(arg0, arg1, arg2)
		arg0:sendNotification(Dorm3dSceneMediator.OTHER_DO_TALK, {
			talkId = arg1,
			callback = arg2
		})
		arg0.viewComponent:closeView()
	end)
	arg0.viewComponent:SetApartment(getProxy(ApartmentProxy):getApartment(arg0.contextData.groupId))
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {}
end

function var0.remove(arg0)
	return
end

return var0
