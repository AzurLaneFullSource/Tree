local var0_0 = class("FriendRequestCard", import(".FriendCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.acceptBtn = arg0_1.tf:Find("frame/accpet_btn")
	arg0_1.refuseBtn = arg0_1.tf:Find("frame/refuse_btn")
	arg0_1.date = arg0_1.tf:Find("frame/request_info/date/Text"):GetComponent(typeof(Text))
	arg0_1.levelTF = arg0_1.tf:Find("frame/request_info/lv_bg/Text"):GetComponent(typeof(Text))
end

function var0_0.update(arg0_2, arg1_2, arg2_2, arg3_2)
	var0_0.super.update(arg0_2, arg1_2)

	arg0_2.manifestoTF.text = arg3_2
	arg0_2.date.text = pg.TimeMgr.GetInstance():STimeDescS(arg2_2)
	arg0_2.levelTF.text = "Lv." .. arg1_2.level
end

return var0_0
