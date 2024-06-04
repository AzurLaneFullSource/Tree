local var0 = class("NewYearShrineBuffView", import(".ShrineBuffView"))

function var0.getUIName(arg0)
	return "NewYearShrineBuff"
end

function var0.initUI(arg0)
	var0.super.initUI(arg0)

	arg0.dft = GetComponent(arg0._tf, "DftAniEvent")

	arg0.dft:SetStartEvent(function()
		setButtonEnabled(arg0.backBtn, false)
	end)
	arg0.dft:SetEndEvent(function()
		setButtonEnabled(arg0.backBtn, true)
	end)
end

return var0
