local var0_0 = class("IslandBaseMsgboxWindow", import("view.base.BaseSubView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.view = arg1_1

	var0_0.super.Ctor(arg0_1, arg2_1, arg0_1.view.event, arg0_1.view.contextData)
end

function var0_0.Show(arg0_2, arg1_2)
	var0_0.super.Show(arg0_2)

	arg0_2.settings = arg1_2

	arg0_2:OnShow()
	arg0_2._tf:SetAsLastSibling()
end

function var0_0.Hide(arg0_3)
	arg0_3.view:HideWindow(arg0_3)
	arg0_3:OnHide()

	arg0_3.settings = nil
end

function var0_0.OnShow(arg0_4)
	return
end

function var0_0.OnHide(arg0_5)
	return
end

return var0_0
