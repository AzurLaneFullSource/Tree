local var0_0 = class("MedalAlbumTemplateMediator", import("view.base.ContextMediator"))

var0_0.ON_TASK_GO = "ON_TASK_GO"
var0_0.ON_TASK_SUBMIT = "ON_TASK_SUBMIT"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	local var0_1 = getProxy(PlayerProxy):getRawData():getActivityMedalGroup()

	arg0_1.viewComponent:SetMedalGroupData(var0_1)
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.ON_TASK_GO, function(arg0_3, arg1_3)
		arg0_2:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_3
		})
	end)
	arg0_2:bind(var0_0.ON_TASK_SUBMIT, function(arg0_4, arg1_4, arg2_4)
		seriesAsync({
			function(arg0_5)
				arg0_2.awardIndex = 0
				arg0_2.showAwards = {}

				arg0_2:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
					act_id = arg1_4:getActId(),
					task_ids = {
						arg1_4.id
					}
				}, arg2_4)
			end
		}, function()
			return
		end)
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.SUBMIT_ACTIVITY_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		if getProxy(ContextProxy):getCurrentContext().mediator.__cname ~= "ActivityMediator" then
			arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8.awards)
		end

		arg0_8.viewComponent:FlushTaskPanel()
	end
end

return var0_0
