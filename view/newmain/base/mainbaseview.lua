local var0 = class("MainBaseView", import("view.base.BaseEventLogic"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg2)
	pg.DelegateInfo.New(arg0)

	arg0._tf = arg1
	arg0._go = arg1.gameObject
	arg0.foldableHelper = MainFoldableHelper.New(arg1, arg0:GetDirection())
end

function var0.Init(arg0)
	return
end

function var0.Fold(arg0, arg1, arg2)
	arg0.foldableHelper:Fold(arg1, arg2)
end

function var0.Refresh(arg0)
	return
end

function var0.Disable(arg0)
	return
end

function var0.GetDirection(arg0)
	return Vector2.zero
end

function var0.Dispose(arg0)
	arg0.exited = true

	arg0:disposeEvent()

	if arg0.foldableHelper then
		pg.DelegateInfo.Dispose(arg0)
		arg0.foldableHelper:Dispose()

		arg0.foldableHelper = nil
	end
end

return var0
