local var0_0 = class("KindergartenMediator", import("view.base.ContextMediator"))

var0_0.GO_SCENE = "KindergartenMediator.GO_SCENE"
var0_0.GO_SUBLAYER = "KindergartenMediator.GO_SUBLAYER"
var0_0.ON_EXTRA_RANK = "KindergartenMediator.ON_EXTRA_RANK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_2, arg1_2, ...)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_2, ...)
	end)
	arg0_1:bind(var0_0.GO_SUBLAYER, function(arg0_3, arg1_3, arg2_3)
		arg0_1:addSubLayers(arg1_3, nil, arg2_3)
	end)
	arg0_1:bind(var0_0.ON_EXTRA_RANK, function(arg0_4)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			page = PowerRank.TYPE_BOSSRUSH
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_ACTIVITY_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_6.id == ActivityConst.ALVIT_PT_ACT_ID then
			arg0_6.viewComponent:UpdatePt()
		end
	elseif var0_6 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_6.viewComponent:UpdateTask()
	end
end

return var0_0
