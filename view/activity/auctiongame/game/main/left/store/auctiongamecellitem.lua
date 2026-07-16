local var0_0 = class("AuctionGameCellItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	return
end

function var0_0.didEnter(arg0_3)
	return
end

function var0_0.Show(arg0_4, arg1_4)
	setActive(arg0_4._go, arg1_4)
end

function var0_0.GetPosition(arg0_5)
	return arg0_5.uiItemTf.anchoredPosition
end

function var0_0.willExit(arg0_6)
	arg0_6:detach()
	Object.Destroy(arg0_6._go)
end

return var0_0
