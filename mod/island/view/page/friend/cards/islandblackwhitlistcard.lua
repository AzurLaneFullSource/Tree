local var0_0 = class("IslandBlackWhitListCard", import(".IslandFriendCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.removeBtn = arg1_1.transform:Find("remove")

	setText(arg0_1.removeBtn:Find("Text"), i18n("island_btn_label_remove"))
end

return var0_0
