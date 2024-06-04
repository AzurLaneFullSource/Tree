local var0 = class("SculptureMediator", import("view.base.ContextMediator"))

var0.ON_UNLOCK_SCULPTURE = "SculptureMediator:ON_UNLOCK_SCULPTURE"
var0.ON_DRAW_SCULPTURE = "SculptureMediator:ON_DRAW_SCULPTURE"
var0.ON_JOINT_SCULPTURE = "SculptureMediator:ON_JOINT_SCULPTURE"
var0.ON_FINSIH_SCULPTURE = "SculptureMediator:ON_FINSIH_SCULPTURE"

function var0.register(arg0)
	arg0:bind(var0.ON_FINSIH_SCULPTURE, function(arg0, arg1)
		arg0:sendNotification(GAME.SCULPTURE_ACT_OP, {
			id = arg1,
			state = SculptureActivity.STATE_FINSIH
		})
	end)
	arg0:bind(var0.ON_JOINT_SCULPTURE, function(arg0, arg1)
		arg0:sendNotification(GAME.SCULPTURE_ACT_OP, {
			id = arg1,
			state = SculptureActivity.STATE_JOINT
		})
	end)
	arg0:bind(var0.ON_UNLOCK_SCULPTURE, function(arg0, arg1)
		arg0:sendNotification(GAME.SCULPTURE_ACT_OP, {
			id = arg1,
			state = SculptureActivity.STATE_UNLOCK
		})
	end)
	arg0:bind(var0.ON_DRAW_SCULPTURE, function(arg0, arg1)
		arg0:sendNotification(GAME.SCULPTURE_ACT_OP, {
			id = arg1,
			state = SculptureActivity.STATE_DRAW
		})
	end)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SCULPTURE)

	arg0.viewComponent:SetActivity(var0)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SCULPTURE_ACT_OP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SCULPTURE_ACT_OP_DONE then
		arg0.viewComponent:OnUpdateActivity(var1.state, var1.id, var1.activity)

		if #var1.awards > 0 then
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
		end
	end
end

return var0
