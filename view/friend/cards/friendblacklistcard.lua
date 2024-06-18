local var0_0 = class("FriendBlackListCard", import(".FriendCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.btn = arg0_1.tf:Find("frame/occupy_btn")
end

function var0_0.update(arg0_2, arg1_2)
	var0_0.super.update(arg0_2, arg1_2)
end

return var0_0
