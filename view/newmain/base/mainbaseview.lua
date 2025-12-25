local var0_0 = class("MainBaseView", import("view.base.BaseEventLogic"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._tf = arg1_1
	arg0_1._go = arg1_1.gameObject
	arg0_1.foldableHelper = MainFoldableHelper.New(arg1_1, arg0_1:GetDirection())
	arg0_1._canvasGroup = GetOrAddComponent(arg0_1._tf, typeof(CanvasGroup))
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

function var0_0.SetVisible(arg0_7, arg1_7)
	setActive(arg0_7._tf, arg1_7)
end

function var0_0.SetEffectVisible(arg0_8, arg1_8)
	return
end

function var0_0.SetAlpha(arg0_9, arg1_9)
	arg0_9._canvasGroup.alpha = arg1_9
end

function var0_0.SetInteractable(arg0_10, arg1_10)
	arg0_10._canvasGroup.interactable = arg1_10 and arg1_10 or false
end

function var0_0.SetBlocksRaycasts(arg0_11, arg1_11)
	arg0_11._canvasGroup.blocksRaycasts = arg1_11 and arg1_11 or false
end

function var0_0.IgnoreParentGroups(arg0_12, arg1_12)
	arg0_12._canvasGroup.ignoreParentGroups = arg1_12
end

function var0_0.Dispose(arg0_13)
	arg0_13.exited = true

	arg0_13:disposeEvent()

	if arg0_13.foldableHelper then
		pg.DelegateInfo.Dispose(arg0_13)
		arg0_13.foldableHelper:Dispose()

		arg0_13.foldableHelper = nil
	end
end

return var0_0
