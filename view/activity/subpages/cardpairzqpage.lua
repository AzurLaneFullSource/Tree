local var0_0 = class("CardPairZQPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.slider = arg0_1.bg:Find("slider")
	arg0_1.step = arg0_1.bg:Find("step")
	arg0_1.progress = arg0_1.bg:Find("progress")
	arg0_1.displayBtn = arg0_1.bg:Find("display_btn")
	arg0_1.battleBtn = arg0_1.bg:Find("battle_btn")
	arg0_1.getBtn = arg0_1.bg:Find("get_btn")
	arg0_1.gotBtn = arg0_1.bg:Find("got_btn")
	arg0_1.gotIcon = arg0_1.bg:Find("icon_got")
	arg0_1.maskList = arg0_1.bg:Find("maskList")
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_data")[1]
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.battleBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CARD_PAIRS)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_5)
	local var0_5 = arg0_5.activity.data2

	for iter0_5 = 1, 7 do
		local var1_5 = arg0_5.maskList:Find("mask" .. iter0_5)

		setActive(var1_5, iter0_5 <= var0_5)
		setActive(var1_5:Find("frame"), var0_5 <= iter0_5)
	end

	setActive(arg0_5.gotIcon, var0_5 >= 7)
	setSlider(arg0_5.slider, 0, 6, var0_5 - 1 >= 0 and var0_5 - 1 or 0)
	setActive(arg0_5.battleBtn, true)
	setActive(arg0_5.getBtn, false)
	setActive(arg0_5.gotBtn, false)
end

return var0_0
