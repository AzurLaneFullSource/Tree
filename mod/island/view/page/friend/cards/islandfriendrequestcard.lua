local var0_0 = class("IslandFriendRequestCard", import(".IslandFriendCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.agreeBtn = arg1_1.transform:Find("agree")
	arg0_1.refuseBtn = arg1_1.transform:Find("refuse")

	setText(arg0_1.agreeBtn:Find("Text"), i18n("island_friend_agree"))
	setText(arg0_1.refuseBtn:Find("Text"), i18n("island_friend_refuse"))
end

function var0_0.Update(arg0_2, arg1_2)
	var0_0.super.Update(arg0_2, arg1_2.player)

	arg0_2.descTxt.text = arg1_2.content
end

function var0_0.UpdateOnline(arg0_3, arg1_3)
	setActive(arg0_3.onlineTr, false)
	setActive(arg0_3.offlineTr, false)
	setActive(arg0_3.giftTr, false)
end

return var0_0
