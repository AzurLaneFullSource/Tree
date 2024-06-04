local var0 = class("MainAdpterView", import("...base.MainBaseView"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg1, nil)

	arg0.foldableHelperBottom = MainFoldableHelper.New(arg2, Vector2(0, -1))
	arg0.foldableHelperRight = MainFoldableHelper.New(arg3, Vector2(1, 0))
end

function var0.Fold(arg0, arg1, arg2)
	var0.super.Fold(arg0, arg1, arg2)
	arg0.foldableHelperBottom:Fold(arg1, arg2)
	arg0.foldableHelperRight:Fold(arg1, arg2)
end

function var0.GetDirection(arg0)
	return Vector2(0, 1)
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0.foldableHelperBottom:Dispose()
	arg0.foldableHelperRight:Dispose()
end

return var0
