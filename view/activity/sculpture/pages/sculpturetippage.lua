local var0 = class("SculptureTipPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SculptureTipUI"
end

function var0.OnLoaded(arg0)
	arg0.tip = arg0:findTF("tip")
end

function var0.OnInit(arg0)
	return
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	setActive(arg0.tip, true)
	onDelayTick(function()
		arg0:Hide()
	end, 2)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	setActive(arg0.tip, false)
end

function var0.OnDestroy(arg0)
	return
end

return var0
