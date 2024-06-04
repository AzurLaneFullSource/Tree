local var0 = class("AvroraTWCBTPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.get = arg0:findTF("get", arg0.bg)
	arg0.go = arg0:findTF("go", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.go, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)

	local var0 = getProxy(ChapterProxy):isClear(304)

	setActive(arg0.go, not var0)
	setActive(arg0.get, var0)
end

return var0
