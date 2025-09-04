local var0_0 = class("IslandFriendSearchCard", import(".IslandFriendCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.addBtn = arg1_1.transform:Find("add")

	setText(arg0_1.addBtn:Find("Text"), i18n("island_add_friend"))
end

function var0_0.Update(arg0_2, arg1_2)
	var0_0.super.Update(arg0_2, arg1_2)

	local var0_2 = getProxy(FriendProxy):isFriend(arg1_2.id)

	setActive(arg0_2.addBtn, not var0_2)
	setActive(arg0_2.visitBtn, var0_2)
end

return var0_0
