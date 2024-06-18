local var0_0 = class("ShrineResultView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ShrineResult"
end

function var0_0.OnInit(arg0_2)
	arg0_2:Show()
	arg0_2:initData()
	arg0_2:initUI()
end

function var0_0.OnDestroy(arg0_3)
	if arg0_3.closeFunc then
		arg0_3.closeFunc()

		arg0_3.closeFunc = nil
	end
end

function var0_0.initData(arg0_4)
	return
end

function var0_0.initUI(arg0_5)
	arg0_5.bg = arg0_5:findTF("BGImg")
	arg0_5.dft = GetComponent(arg0_5._tf, "DftAniEvent")
	arg0_5.text_buff = arg0_5:findTF("Main/MainBox/Text_Buff")
	arg0_5.text_nobuff = arg0_5:findTF("Main/MainBox/Text_NoBuff")
	arg0_5.buffImg_1 = arg0_5:findTF("Main/MainBox/Buff_1")
	arg0_5.buffImg_2 = arg0_5:findTF("Main/MainBox/Buff_2")
	arg0_5.buffImg_3 = arg0_5:findTF("Main/MainBox/Buff_3")

	onButton(arg0_5, arg0_5.bg, function()
		arg0_5:Destroy()
	end, SFX_CANCEL)
	arg0_5.dft:SetStartEvent(function()
		setButtonEnabled(arg0_5.bg, false)
	end)
	arg0_5.dft:SetEndEvent(function()
		setButtonEnabled(arg0_5.bg, true)
	end)
end

function var0_0.updateView(arg0_9, arg1_9, arg2_9)
	if arg2_9 then
		setText(arg0_9.text_buff, arg1_9)
	else
		setText(arg0_9.text_nobuff, arg1_9)
	end

	setActive(arg0_9.text_buff, arg2_9)
	setActive(arg0_9.text_nobuff, not arg2_9)
	setActive(arg0_9.buffImg_1, arg2_9 == 1)
	setActive(arg0_9.buffImg_2, arg2_9 == 2)
	setActive(arg0_9.buffImg_3, arg2_9 == 3)
end

function var0_0.setCloseFunc(arg0_10, arg1_10)
	arg0_10.closeFunc = arg1_10
end

return var0_0
