local var0 = class("CardPairFXPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.startBtn = arg0:findTF("StartBtn", arg0.bg)
	arg0.slider = arg0:findTF("Slider", arg0.bg)
	arg0.heartImg = arg0:findTF("Fill/Heart", arg0.slider)
	arg0.gotImg = arg0:findTF("GotImg", arg0.bg)
end

function var0.OnDataSetting(arg0)
	return
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.startBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CARD_PAIRS)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.activity.data1

	setActive(arg0.gotImg, var0 == 1)
	setActive(arg0.heartImg, var0 ~= 1)

	local var1 = arg0.activity.data2

	if var1 >= 7 then
		setActive(arg0.heartImg, false)
	end

	setSlider(arg0.slider, 0, 7, var1)
end

return var0
