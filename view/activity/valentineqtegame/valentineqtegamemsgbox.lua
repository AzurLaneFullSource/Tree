local var0_0 = class("ValentineQteGameMsgBox")

var0_0.EXIT_TXT = 1
var0_0.PAUSE_TXT = 2

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._tf = arg1_1

	arg0_1:OnInit()
	arg0_1:OnRegister()
end

function var0_0.OnInit(arg0_2)
	arg0_2.confirmBtn = arg0_2._tf:Find("frame/btns/confirm_btn")
	arg0_2.cancelBtn = arg0_2._tf:Find("frame/btns/cancel_btn")

	GetComponent(arg0_2._tf:Find("frame/exit"), typeof(Image)):SetNativeSize()
	GetComponent(arg0_2._tf:Find("frame/puase"), typeof(Image)):SetNativeSize()

	arg0_2.texts = {
		[var0_0.EXIT_TXT] = arg0_2._tf:Find("frame/exit"),
		[var0_0.PAUSE_TXT] = arg0_2._tf:Find("frame/puase")
	}
end

function var0_0.OnRegister(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3.settings.onYes then
			arg0_3.settings.onYes()
		end

		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		if arg0_3.settings.onNo then
			arg0_3.settings.onNo()
		end

		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6)
	arg0_6.settings = arg1_6

	setActive(arg0_6._tf, true)

	for iter0_6, iter1_6 in pairs(arg0_6.texts) do
		setActive(iter1_6, false)
	end

	if arg0_6.texts[arg1_6.content] then
		setActive(arg0_6.texts[arg1_6.content], true)
	end

	setActive(arg0_6.cancelBtn, not arg1_6.noNo)
end

function var0_0.Hide(arg0_7)
	setActive(arg0_7._tf, false)

	arg0_7.settings = nil
end

function var0_0.Destroy(arg0_8)
	pg.DelegateInfo.Dispose(arg0_8)
	arg0_8:Hide()
end

return var0_0
