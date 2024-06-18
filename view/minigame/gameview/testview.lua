local var0_0 = class("TestView", import("..BaseMiniGameView"))

function var0_0.getUIName(arg0_1)
	return "MailBoxUI2"
end

function var0_0.init(arg0_2)
	print("初始化")

	arg0_2._closeBtn = arg0_2:findTF("main/top/btnBack")
	arg0_2._btn1 = arg0_2:findTF("main/delete_all_button")
	arg0_2._btn2 = arg0_2:findTF("main/get_all_button")
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._closeBtn, function()
		arg0_3:emit(var0_0.ON_BACK)
	end)
	onButton(arg0_3, arg0_3._btn1, function()
		arg0_3:SendSuccess(1)
	end)
	onButton(arg0_3, arg0_3._btn2, function()
		arg0_3:SendFailure(1)
	end)
end

return var0_0
