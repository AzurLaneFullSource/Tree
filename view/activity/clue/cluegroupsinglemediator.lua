local var0_0 = class("ClueGroupSingleMediator", import("view.base.ContextMediator"))

var0_0.OPEN_CLUE_JUMP = "ClueGroupSingleMediator.OPEN_CLUE_JUMP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_CLUE_JUMP, function(arg0_2, arg1_2)
		print(arg1_2)
		arg0_1:sendNotification(ClueMapMediator.OPEN_CLUE_JUMP, {
			jumpID = arg1_2
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()
end

return var0_0
