local var0_0 = class("FriendSearchCard", import(".FriendCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.addBtn = arg0_1.tf:Find("frame/add_btn")
	arg0_1.levelTF = arg0_1.tf:Find("frame/request_info/lv_bg/Text"):GetComponent(typeof(Text))
end

function var0_0.update(arg0_2, arg1_2)
	var0_0.super.update(arg0_2, arg1_2)

	arg0_2.manifestoTF.text = arg1_2:GetManifesto()
	arg0_2.levelTF.text = "Lv." .. arg1_2.level
end

return var0_0
