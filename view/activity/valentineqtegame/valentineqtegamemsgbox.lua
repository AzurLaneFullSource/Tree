local var0 = class("ValentineQteGameMsgBox")

var0.EXIT_TXT = 1
var0.PAUSE_TXT = 2

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0._tf = arg1

	arg0:OnInit()
	arg0:OnRegister()
end

function var0.OnInit(arg0)
	arg0.confirmBtn = arg0._tf:Find("frame/btns/confirm_btn")
	arg0.cancelBtn = arg0._tf:Find("frame/btns/cancel_btn")
	arg0.texts = {
		[var0.EXIT_TXT] = arg0._tf:Find("frame/exit"),
		[var0.PAUSE_TXT] = arg0._tf:Find("frame/puase")
	}
end

function var0.OnRegister(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.settings.onYes then
			arg0.settings.onYes()
		end

		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		if arg0.settings.onNo then
			arg0.settings.onNo()
		end

		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	arg0.settings = arg1

	setActive(arg0._tf, true)

	for iter0, iter1 in pairs(arg0.texts) do
		setActive(iter1, false)
	end

	if arg0.texts[arg1.content] then
		setActive(arg0.texts[arg1.content], true)
	end

	setActive(arg0.cancelBtn, not arg1.noNo)
end

function var0.Hide(arg0)
	setActive(arg0._tf, false)

	arg0.settings = nil
end

function var0.Destroy(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:Hide()
end

return var0
