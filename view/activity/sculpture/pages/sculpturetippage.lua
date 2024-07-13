local var0_0 = class("SculptureTipPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SculptureTipUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.tip = arg0_2:findTF("tip")
end

function var0_0.OnInit(arg0_3)
	return
end

function var0_0.Show(arg0_4)
	var0_0.super.Show(arg0_4)
	setActive(arg0_4.tip, true)
	onDelayTick(function()
		arg0_4:Hide()
	end, 2)
end

function var0_0.Hide(arg0_6)
	var0_0.super.Hide(arg0_6)
	setActive(arg0_6.tip, false)
end

function var0_0.OnDestroy(arg0_7)
	return
end

return var0_0
