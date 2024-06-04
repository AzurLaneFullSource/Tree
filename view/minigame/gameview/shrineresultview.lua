local var0 = class("ShrineResultView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ShrineResult"
end

function var0.OnInit(arg0)
	arg0:Show()
	arg0:initData()
	arg0:initUI()
end

function var0.OnDestroy(arg0)
	if arg0.closeFunc then
		arg0.closeFunc()

		arg0.closeFunc = nil
	end
end

function var0.initData(arg0)
	return
end

function var0.initUI(arg0)
	arg0.bg = arg0:findTF("BGImg")
	arg0.dft = GetComponent(arg0._tf, "DftAniEvent")
	arg0.text_buff = arg0:findTF("Main/MainBox/Text_Buff")
	arg0.text_nobuff = arg0:findTF("Main/MainBox/Text_NoBuff")
	arg0.buffImg_1 = arg0:findTF("Main/MainBox/Buff_1")
	arg0.buffImg_2 = arg0:findTF("Main/MainBox/Buff_2")
	arg0.buffImg_3 = arg0:findTF("Main/MainBox/Buff_3")

	onButton(arg0, arg0.bg, function()
		arg0:Destroy()
	end, SFX_CANCEL)
	arg0.dft:SetStartEvent(function()
		setButtonEnabled(arg0.bg, false)
	end)
	arg0.dft:SetEndEvent(function()
		setButtonEnabled(arg0.bg, true)
	end)
end

function var0.updateView(arg0, arg1, arg2)
	if arg2 then
		setText(arg0.text_buff, arg1)
	else
		setText(arg0.text_nobuff, arg1)
	end

	setActive(arg0.text_buff, arg2)
	setActive(arg0.text_nobuff, not arg2)
	setActive(arg0.buffImg_1, arg2 == 1)
	setActive(arg0.buffImg_2, arg2 == 2)
	setActive(arg0.buffImg_3, arg2 == 3)
end

function var0.setCloseFunc(arg0, arg1)
	arg0.closeFunc = arg1
end

return var0
