local var0_0 = class("IslandBaseAgency")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.host = arg1_1

	arg0_1:Init(arg2_1)
	arg0_1:Register()

	arg0_1.isInit = false
end

function var0_0.GetHost(arg0_2)
	return arg0_2.host
end

function var0_0.DispatchEvent(arg0_3, arg1_3, ...)
	arg0_3:GetHost():DispatchEvent(arg1_3, ...)
end

function var0_0.On(arg0_4, arg1_4, arg2_4)
	arg0_4:GetHost():On(arg1_4, arg2_4)
end

function var0_0.Init(arg0_5, arg1_5)
	arg0_5.isInit = true

	arg0_5:OnInit(arg1_5)
end

function var0_0.IsInitData(arg0_6)
	return arg0_6.isInit
end

function var0_0.SetDirty(arg0_7)
	arg0_7.isInit = false
end

function var0_0.Register(arg0_8)
	return
end

function var0_0.OnInit(arg0_9)
	return
end

return var0_0
