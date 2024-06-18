local var0_0 = class("MainBaseView", import("view.base.BaseEventLogic"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._tf = arg1_1
	arg0_1._go = arg1_1.gameObject
	arg0_1.foldableHelper = MainFoldableHelper.New(arg1_1, arg0_1:GetDirection())
end

function var0_0.Init(arg0_2)
	return
end

function var0_0.Fold(arg0_3, arg1_3, arg2_3)
	arg0_3.foldableHelper:Fold(arg1_3, arg2_3)
end

function var0_0.Refresh(arg0_4)
	return
end

function var0_0.Disable(arg0_5)
	return
end

function var0_0.GetDirection(arg0_6)
	return Vector2.zero
end

function var0_0.Dispose(arg0_7)
	arg0_7.exited = true

	arg0_7:disposeEvent()

	if arg0_7.foldableHelper then
		pg.DelegateInfo.Dispose(arg0_7)
		arg0_7.foldableHelper:Dispose()

		arg0_7.foldableHelper = nil
	end
end

return var0_0
