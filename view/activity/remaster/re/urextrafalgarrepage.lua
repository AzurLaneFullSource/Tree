local var0_0 = class("UrExTrafalgarRePage", import("view.activity.subPages.UrExTrafalgarPage"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	ActivityRemasterUtil.AdapterCoreScene(arg0_1, arg1_1, arg2_1, arg3_1)
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	arg0_2:UpdateTime()
end

function var0_0.UpdateTime(arg0_3)
	ActivityRemasterUtil.UpdateTime(arg0_3)
end

return var0_0
