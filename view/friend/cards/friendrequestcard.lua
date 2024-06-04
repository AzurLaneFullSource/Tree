local var0 = class("FriendRequestCard", import(".FriendCard"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.acceptBtn = arg0.tf:Find("frame/accpet_btn")
	arg0.refuseBtn = arg0.tf:Find("frame/refuse_btn")
	arg0.date = arg0.tf:Find("frame/request_info/date/Text"):GetComponent(typeof(Text))
	arg0.levelTF = arg0.tf:Find("frame/request_info/lv_bg/Text"):GetComponent(typeof(Text))
end

function var0.update(arg0, arg1, arg2, arg3)
	var0.super.update(arg0, arg1)

	arg0.manifestoTF.text = arg3
	arg0.date.text = pg.TimeMgr.GetInstance():STimeDescS(arg2)
	arg0.levelTF.text = "Lv." .. arg1.level
end

return var0
