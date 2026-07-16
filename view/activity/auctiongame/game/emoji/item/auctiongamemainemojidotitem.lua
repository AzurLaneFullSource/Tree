local var0_0 = class("AuctionGameMainEmojiDotItem", import("view.base.BasePanel"))

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

function var0_0.didEnter(arg0_3, arg1_3)
	setActive(arg0_3.uiSelectedGo, arg1_3)
end

function var0_0.willExit(arg0_4)
	arg0_4:detach()
	Object.Destroy(arg0_4._go)
end

return var0_0
