local var0_0 = class("CultivatingPlantMediator", import("view.base.ContextMediator"))

var0_0.GO_SCENE = "CultivatingPlantMediator::GO_SCENE"
var0_0.ON_TASK_SUBMIT = "CultivatingPlantMediator::ON_TASK_SUBMIT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.NEW_EDUCATE_SELECT)
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.SUBMIT_TASK_V2, arg1_3.id)
	end)
end

function var0_0.initNotificationHandleDic(arg0_4)
	arg0_4.handleDic = {
		[GAME.SUBMIT_ACTIVITY_TASK_V2_DONE] = function(arg0_5, arg1_5)
			arg0_5.viewComponent:RefreshSubmitTaskDone()
		end
	}
end

function var0_0.remove(arg0_6)
	return
end

return var0_0
