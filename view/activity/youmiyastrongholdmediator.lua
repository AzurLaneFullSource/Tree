local var0_0 = class("YoumiyaStrongholdMediator", import("view.base.ContextMediator"))

var0_0.MAKE_FURNITURE = "YoumiyaStrongholdMediator.MAKE_FURNITURE"
var0_0.GET_AWARD = "YoumiyaStrongholdMediator.GET_AWARD"
var0_0.YOUMIA_GO_SCENE = "YoumiyaStrongholdMediator.YOUMIA_GO_SCENE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.MAKE_FURNITURE, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = ActivityConst.YUMIA_BASE_ACT_ID,
			arg1 = arg1_2,
			consumes = arg2_2
		})
	end)
	arg0_1:bind(var0_0.GET_AWARD, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			activity_id = ActivityConst.YUMIA_BASE_ACT_ID,
			arg1 = arg1_3,
			canGetIndex = arg2_3
		})
	end)
	arg0_1:bind(var0_0.YOUMIA_GO_SCENE, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_4, arg2_4)
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		ActivityProxy.ACTIVITY_OPERATION_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0_6.viewComponent:RefreshView()
	end
end

return var0_0
