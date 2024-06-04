local var0 = class("CardPairZQPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.slider = arg0:findTF("slider", arg0.bg)
	arg0.step = arg0:findTF("step", arg0.bg)
	arg0.progress = arg0:findTF("progress", arg0.bg)
	arg0.displayBtn = arg0:findTF("display_btn", arg0.bg)
	arg0.battleBtn = arg0:findTF("battle_btn", arg0.bg)
	arg0.getBtn = arg0:findTF("get_btn", arg0.bg)
	arg0.gotBtn = arg0:findTF("got_btn", arg0.bg)
	arg0.gotIcon = arg0:findTF("icon_got", arg0.bg)
	arg0.maskList = arg0:findTF("maskList", arg0.bg)
end

function var0.OnDataSetting(arg0)
	local var0 = arg0.activity:getConfig("config_data")[1]
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CARD_PAIRS)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity.data2

	for iter0 = 1, 7 do
		local var1 = arg0:findTF("mask" .. iter0, arg0.maskList)

		setActive(var1, iter0 <= var0)
		setActive(arg0:findTF("frame", var1), var0 <= iter0)
	end

	setActive(arg0.gotIcon, var0 >= 7)
	setSlider(arg0.slider, 0, 6, var0 - 1 >= 0 and var0 - 1 or 0)
	setActive(arg0.battleBtn, true)
	setActive(arg0.getBtn, false)
	setActive(arg0.gotBtn, false)
end

return var0
