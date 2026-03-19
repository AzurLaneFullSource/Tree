local var0_0 = class("NewEducateRankMediator", import("view.newEducate.base.NewEducateContextMediator"))

var0_0.ON_GET_RANK = "NewEducateRankMediator.ON_GET_RANK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_GET_RANK, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_RANK, {
			type = arg1_2,
			tbId = arg2_2
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.NEW_EDUCATE_GET_RANK_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.NEW_EDUCATE_GET_RANK_DONE then
		arg0_4.viewComponent:OnGetRankDone(var1_4.type, var1_4.tbId, var1_4.list, var1_4.playerInfo)
	end
end

return var0_0
