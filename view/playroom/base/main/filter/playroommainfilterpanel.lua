local var0_0 = class("PlayRoomMainFilterPanel", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1
	arg0_1.data = arg3_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.btnItemList = {}
end

function var0_0.didEnter(arg0_3, arg1_3, arg2_3)
	setText(arg0_3.uiTitleText, arg1_3.titleText)

	for iter0_3, iter1_3 in ipairs(arg1_3.btnList) do
		arg0_3.btnItemList[iter0_3] = PlayRoomMainFilterBtn.New(Object.Instantiate(arg0_3.uiTplBtn, arg0_3.uiTplPanel), arg0_3)

		arg0_3.btnItemList[iter0_3]:didEnter(iter1_3, arg2_3)
	end

	setActive(arg0_3._go, arg1_3.hide ~= true)
end

function var0_0.willExit(arg0_4)
	arg0_4:detach()

	for iter0_4, iter1_4 in ipairs(arg0_4.btnItemList) do
		iter1_4:willExit()
	end

	arg0_4.btnItemList = nil

	Object.Destroy(arg0_4._go)

	arg0_4._tf = nil
	arg0_4._go = nil
end

function var0_0.RefreshUI(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.btnItemList) do
		iter1_5:RefreshUI()
	end
end

return var0_0
