local var0_0 = class("ShipAtlasLive2dBtn", import("....PlayerVitae.btns.PlayerVitaeLive2dBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.event = arg3_1
	arg0_1.value = arg4_1
end

function var0_0.emit(arg0_2, ...)
	arg0_2.event:emit(...)
end

function var0_0.GetDefaultValue(arg0_3)
	return arg0_3.value
end

function var0_0.OnSwitch(arg0_4, arg1_4)
	return true
end

function var0_0.OnSwitchDone(arg0_5)
	arg0_5:emit(SkinAtlasPreviewPage.ON_L2D_SWITCH_DONE, arg0_5.flag)
end

return var0_0
