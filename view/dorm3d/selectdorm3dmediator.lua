local var0 = class("SelectDorm3DMediator", import("view.base.ContextMediator"))

var0.ON_DORM = "SelectDorm3DMediator.ON_DORM"

function var0.register(arg0)
	arg0:bind(var0.ON_DORM, function(arg0, arg1)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0)
			arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.DORM3D, {
				showLoading = false,
				groupId = arg1,
				resumeCallback = arg0
			})
		end)
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == nil then
		-- block empty
	end
end

return var0
