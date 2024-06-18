local var0_0 = class("FriendListCard", import(".FriendCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.occuptBtn = arg0_1.tf:Find("frame/btns/occupy_btn")
	arg0_1.deleteBtn = arg0_1.tf:Find("frame/btns/delete_btn")
	arg0_1.backYardBtn = arg0_1.tf:Find("frame/btns/backyard_btn")
	arg0_1.chatTip = arg0_1.tf:Find("frame/btns/occupy_btn/tip")
	arg0_1.date = arg0_1.tf:Find("frame/request_info/date"):GetComponent(typeof(Text))
	arg0_1.online = arg0_1.tf:Find("frame/request_info/online")
	arg0_1.levelTF = arg0_1.tf:Find("frame/request_info/lv_bg/Text"):GetComponent(typeof(Text))
end

function var0_0.update(arg0_2, arg1_2)
	var0_0.super.update(arg0_2, arg1_2)
	setActive(arg0_2.chatTip, arg1_2.unreadCount > 0)

	arg0_2.manifestoTF.text = arg1_2:GetManifesto()

	setActive(arg0_2.online, arg1_2.online == Friend.ONLINE)
	setActive(arg0_2.date.gameObject, arg1_2.online ~= Friend.ONLINE)

	if arg1_2.online ~= Friend.ONLINE then
		arg0_2.date.text = getOfflineTimeStamp(arg1_2.preOnLineTime)
	end

	arg0_2.levelTF.text = "Lv." .. arg1_2.level
end

return var0_0
