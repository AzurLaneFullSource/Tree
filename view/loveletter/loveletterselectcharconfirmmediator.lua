local var0_0 = class("LoveLetterSelectCharConfirmMediator", import("view.base.ContextMediator"))

var0_0.SELECT_CHAR = "LoveLetterSelectCharConfirmMediator.SELECT_CHAR"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SELECT_CHAR, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg0_1.contextData.actId,
			arg1 = arg1_2
		})
	end)
	arg0_1.viewComponent:SetLoveLetter(arg0_1.contextData.groupId)
	arg0_1.viewComponent:SetActivity(arg0_1.contextData.actId)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {
		[ActivityProxy.ACTIVITY_OPERATION_DONE] = function(arg0_4, arg1_4)
			if arg1_4:getBody() == arg0_4.contextData.actId then
				arg0_4.viewComponent:closeView()
			end
		end
	}
end

return var0_0
