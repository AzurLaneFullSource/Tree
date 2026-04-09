local var0_0 = class("PlayRoomMainFilterBtn", import("view.base.BasePanel"))

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

function var0_0.didEnter(arg0_3, arg1_3, arg2_3)
	setText(arg0_3.uiText, arg1_3.text)
	setText(arg0_3.uiText2, arg1_3.text)
	onButton(arg0_3, arg0_3.uiBtn, function()
		arg1_3.clickBtn()
	end)
	setActive(arg0_3._go, true)

	arg0_3.data = arg1_3
end

function var0_0.willExit(arg0_5)
	arg0_5:detach()
	Object.Destroy(arg0_5._go)

	arg0_5._tf = nil
	arg0_5._go = nil
end

function var0_0.RefreshUI(arg0_6)
	setActive(arg0_6.uiSelectTf, arg0_6.data.selected())
	setActive(arg0_6.uiUnSelectTf, not arg0_6.data.selected())
end

return var0_0
