local var0 = class("FriendBlackListCard", import(".FriendCard"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.btn = arg0.tf:Find("frame/occupy_btn")
end

function var0.update(arg0, arg1)
	var0.super.update(arg0, arg1)
end

return var0
