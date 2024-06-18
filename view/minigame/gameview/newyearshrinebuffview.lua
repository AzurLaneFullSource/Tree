local var0_0 = class("NewYearShrineBuffView", import(".ShrineBuffView"))

function var0_0.getUIName(arg0_1)
	return "NewYearShrineBuff"
end

function var0_0.initUI(arg0_2)
	var0_0.super.initUI(arg0_2)

	arg0_2.dft = GetComponent(arg0_2._tf, "DftAniEvent")

	arg0_2.dft:SetStartEvent(function()
		setButtonEnabled(arg0_2.backBtn, false)
	end)
	arg0_2.dft:SetEndEvent(function()
		setButtonEnabled(arg0_2.backBtn, true)
	end)
end

return var0_0
