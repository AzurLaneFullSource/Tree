local var0_0 = class("CardPairFXPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.startBtn = arg0_1:findTF("StartBtn", arg0_1.bg)
	arg0_1.slider = arg0_1:findTF("Slider", arg0_1.bg)
	arg0_1.heartImg = arg0_1:findTF("Fill/Heart", arg0_1.slider)
	arg0_1.gotImg = arg0_1:findTF("GotImg", arg0_1.bg)
end

function var0_0.OnDataSetting(arg0_2)
	return
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.startBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CARD_PAIRS)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_5)
	local var0_5 = arg0_5.activity.data1

	setActive(arg0_5.gotImg, var0_5 == 1)
	setActive(arg0_5.heartImg, var0_5 ~= 1)

	local var1_5 = arg0_5.activity.data2

	if var1_5 >= 7 then
		setActive(arg0_5.heartImg, false)
	end

	setSlider(arg0_5.slider, 0, 7, var1_5)
end

return var0_0
