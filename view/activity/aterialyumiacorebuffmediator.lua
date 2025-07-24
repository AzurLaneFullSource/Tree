local var0_0 = class("AterialYumiaCoreBuffMediator", import("view.base.ContextMediator"))

var0_0.SUBMIT_TASK = "AterialYumiaCoreBuffMediator.SUBMIT_TASK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SUBMIT_TASK, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_2)
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityById(ActivityConst.YUMIA_EXPEDITION_BUFF_ACT_ID)

	arg0_1.viewComponent:SetActivity(var0_1)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {
		[GAME.SUBMIT_TASK_AWARD_DOWN] = function(arg0_4, arg1_4)
			local var0_4 = arg1_4:getBody()

			arg0_4.viewComponent:UpdateView()
			arg0_4.viewComponent:ShowUpgrade(nil, true)
		end
	}
end

return var0_0
