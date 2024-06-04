local var0 = class("FriendSearchCard", import(".FriendCard"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.addBtn = arg0.tf:Find("frame/add_btn")
	arg0.levelTF = arg0.tf:Find("frame/request_info/lv_bg/Text"):GetComponent(typeof(Text))
end

function var0.update(arg0, arg1)
	var0.super.update(arg0, arg1)

	arg0.manifestoTF.text = arg1:GetManifesto()
	arg0.levelTF.text = "Lv." .. arg1.level
end

return var0
