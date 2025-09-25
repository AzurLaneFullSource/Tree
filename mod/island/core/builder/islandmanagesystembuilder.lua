local var0_0 = class("IslandManageSystemBuilder", import(".IslandGenericBuilder"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, IslandConst.UNIT_LIST_MANAGE_SYSTEM)

	arg0_1.cls = arg2_1
end

function var0_0.LoadAsset(arg0_2, arg1_2, arg2_2)
	local var0_2 = GameObject.New()

	arg2_2(var0_2)
end

function var0_0.GetModule(arg0_3, arg1_3, arg2_3)
	return arg0_3.cls.New(arg1_3, arg2_3)
end

return var0_0
