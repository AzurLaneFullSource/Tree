local var0_0 = class("AgoraFurnitureSlot")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1
	arg0_1.hostId = arg2_1
	arg0_1.userId = nil
end

function var0_0.Lock(arg0_2, arg1_2)
	arg0_2.userId = arg1_2
end

function var0_0.Release(arg0_3)
	arg0_3.userId = nil
end

function var0_0.IsEmpty(arg0_4)
	return arg0_4.userId == nil
end

function var0_0.IsUsing(arg0_5, arg1_5)
	return arg0_5.userId == arg1_5
end

function var0_0.GetHostId(arg0_6)
	return arg0_6.hostId
end

function var0_0.GetUserId(arg0_7)
	return arg0_7.userId
end

return var0_0
