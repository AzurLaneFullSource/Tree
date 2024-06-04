local var0 = class("TestView", import("..BaseMiniGameView"))

function var0.getUIName(arg0)
	return "MailBoxUI2"
end

function var0.init(arg0)
	print("初始化")

	arg0._closeBtn = arg0:findTF("main/top/btnBack")
	arg0._btn1 = arg0:findTF("main/delete_all_button")
	arg0._btn2 = arg0:findTF("main/get_all_button")
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._closeBtn, function()
		arg0:emit(var0.ON_BACK)
	end)
	onButton(arg0, arg0._btn1, function()
		arg0:SendSuccess(1)
	end)
	onButton(arg0, arg0._btn2, function()
		arg0:SendFailure(1)
	end)
end

return var0
