local var0_0 = class("AvroraTWCBTPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.get = arg0_1:findTF("get", arg0_1.bg)
	arg0_1.go = arg0_1:findTF("go", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.go, function()
		arg0_2:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)

	local var0_2 = getProxy(ChapterProxy):isClear(304)

	setActive(arg0_2.go, not var0_2)
	setActive(arg0_2.get, var0_2)
end

return var0_0
