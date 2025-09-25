local var0_0 = class("IslandUIPool", import(".IslandObjectPool"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)

	arg0_1.canDel = arg5_1
end

function var0_0.CanDelete(arg0_2)
	return var0_0.super.CanDelete(arg0_2) and arg0_2.canDel
end

function var0_0.ActiveOrDisactiveItem(arg0_3, arg1_3, arg2_3)
	local var0_3 = GetOrAddComponent(arg1_3, typeof(CanvasGroup))

	var0_3.alpha = arg2_3 and 1 or 0
	var0_3.blocksRaycasts = arg2_3
end

return var0_0
