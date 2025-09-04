local var0_0 = class("IslandFriendRequestPage", import(".IslandFriendListPage"))

function var0_0.getUIName(arg0_1)
	return "IslandFriendRequestUI"
end

function var0_0.CreateCard(arg0_2, arg1_2)
	return IslandFriendRequestCard.New(arg1_2)
end

function var0_0.OnInitItem(arg0_3, arg1_3)
	var0_0.super.OnInitItem(arg0_3, arg1_3)

	local var0_3 = arg0_3.cards[arg1_3]

	onButton(arg0_3, var0_3.agreeBtn, function()
		arg0_3:emit(IslandMediator.ACCEPT_REQUEST, var0_3.player.id)
	end, SFX_PANEL)
	onButton(arg0_3, var0_3.refuseBtn, function()
		arg0_3:emit(IslandMediator.REFUSE_REQUEST, var0_3.player.id, false)
	end, SFX_PANEL)
end

function var0_0.GetData(arg0_6, arg1_6)
	local var0_6 = getProxy(NotificationProxy):getRequests()

	if #var0_6 <= 0 then
		return arg1_6({})
	end

	arg1_6(var0_6)
end

return var0_0
