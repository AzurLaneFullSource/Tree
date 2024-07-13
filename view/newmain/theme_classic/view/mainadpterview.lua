local var0_0 = class("MainAdpterView", import("...base.MainBaseView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, nil)

	arg0_1.foldableHelperBottom = MainFoldableHelper.New(arg2_1, Vector2(0, -1))
	arg0_1.foldableHelperRight = MainFoldableHelper.New(arg3_1, Vector2(1, 0))
end

function var0_0.Fold(arg0_2, arg1_2, arg2_2)
	var0_0.super.Fold(arg0_2, arg1_2, arg2_2)
	arg0_2.foldableHelperBottom:Fold(arg1_2, arg2_2)
	arg0_2.foldableHelperRight:Fold(arg1_2, arg2_2)
end

function var0_0.GetDirection(arg0_3)
	return Vector2(0, 1)
end

function var0_0.Dispose(arg0_4)
	var0_0.super.Dispose(arg0_4)
	arg0_4.foldableHelperBottom:Dispose()
	arg0_4.foldableHelperRight:Dispose()
end

return var0_0
