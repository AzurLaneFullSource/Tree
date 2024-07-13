local var0_0 = class("SelectDorm3DMediator", import("view.base.ContextMediator"))

var0_0.ON_DORM = "SelectDorm3DMediator.ON_DORM"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_DORM, function(arg0_2, arg1_2)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_3)
			arg0_1:sendNotification(GAME.CHANGE_SCENE, SCENE.DORM3D, {
				showLoading = false,
				groupId = arg1_2,
				resumeCallback = arg0_3
			})
		end)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == nil then
		-- block empty
	end
end

return var0_0
