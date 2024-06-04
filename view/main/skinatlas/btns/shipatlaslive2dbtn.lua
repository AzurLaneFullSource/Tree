local var0 = class("ShipAtlasLive2dBtn", import("....PlayerVitae.btns.PlayerVitaeLive2dBtn"))

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.event = arg3
	arg0.value = arg4
end

function var0.emit(arg0, ...)
	arg0.event:emit(...)
end

function var0.GetDefaultValue(arg0)
	return arg0.value
end

function var0.OnSwitch(arg0, arg1)
	return true
end

function var0.OnSwitchDone(arg0)
	arg0:emit(SkinAtlasPreviewPage.ON_L2D_SWITCH_DONE, arg0.flag)
end

return var0
