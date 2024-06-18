local var0_0 = class("SculptureMediator", import("view.base.ContextMediator"))

var0_0.ON_UNLOCK_SCULPTURE = "SculptureMediator:ON_UNLOCK_SCULPTURE"
var0_0.ON_DRAW_SCULPTURE = "SculptureMediator:ON_DRAW_SCULPTURE"
var0_0.ON_JOINT_SCULPTURE = "SculptureMediator:ON_JOINT_SCULPTURE"
var0_0.ON_FINSIH_SCULPTURE = "SculptureMediator:ON_FINSIH_SCULPTURE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_FINSIH_SCULPTURE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.SCULPTURE_ACT_OP, {
			id = arg1_2,
			state = SculptureActivity.STATE_FINSIH
		})
	end)
	arg0_1:bind(var0_0.ON_JOINT_SCULPTURE, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.SCULPTURE_ACT_OP, {
			id = arg1_3,
			state = SculptureActivity.STATE_JOINT
		})
	end)
	arg0_1:bind(var0_0.ON_UNLOCK_SCULPTURE, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.SCULPTURE_ACT_OP, {
			id = arg1_4,
			state = SculptureActivity.STATE_UNLOCK
		})
	end)
	arg0_1:bind(var0_0.ON_DRAW_SCULPTURE, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.SCULPTURE_ACT_OP, {
			id = arg1_5,
			state = SculptureActivity.STATE_DRAW
		})
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SCULPTURE)

	arg0_1.viewComponent:SetActivity(var0_1)
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		GAME.SCULPTURE_ACT_OP_DONE
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == GAME.SCULPTURE_ACT_OP_DONE then
		arg0_7.viewComponent:OnUpdateActivity(var1_7.state, var1_7.id, var1_7.activity)

		if #var1_7.awards > 0 then
			arg0_7.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_7.awards)
		end
	end
end

return var0_0
