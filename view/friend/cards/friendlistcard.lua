local var0 = class("FriendListCard", import(".FriendCard"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.occuptBtn = arg0.tf:Find("frame/btns/occupy_btn")
	arg0.deleteBtn = arg0.tf:Find("frame/btns/delete_btn")
	arg0.backYardBtn = arg0.tf:Find("frame/btns/backyard_btn")
	arg0.chatTip = arg0.tf:Find("frame/btns/occupy_btn/tip")
	arg0.date = arg0.tf:Find("frame/request_info/date"):GetComponent(typeof(Text))
	arg0.online = arg0.tf:Find("frame/request_info/online")
	arg0.levelTF = arg0.tf:Find("frame/request_info/lv_bg/Text"):GetComponent(typeof(Text))
end

function var0.update(arg0, arg1)
	var0.super.update(arg0, arg1)
	setActive(arg0.chatTip, arg1.unreadCount > 0)

	arg0.manifestoTF.text = arg1:GetManifesto()

	setActive(arg0.online, arg1.online == Friend.ONLINE)
	setActive(arg0.date.gameObject, arg1.online ~= Friend.ONLINE)

	if arg1.online ~= Friend.ONLINE then
		arg0.date.text = getOfflineTimeStamp(arg1.preOnLineTime)
	end

	arg0.levelTF.text = "Lv." .. arg1.level
end

return var0
