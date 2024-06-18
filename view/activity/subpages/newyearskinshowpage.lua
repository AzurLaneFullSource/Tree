local var0_0 = class("NewYearSkinShowPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1:findUI()
	arg0_1:initData()
end

function var0_0.findUI(arg0_2)
	arg0_2.paintBackTF = arg0_2:findTF("Paints/PaintBack")
	arg0_2.paintFrontTF = arg0_2:findTF("Paints/PaintFront")
	arg0_2.skinShopBtn = arg0_2:findTF("BtnShop")
	arg0_2.goBtn = arg0_2:findTF("BtnGO")

	onButton(arg0_2, arg0_2.skinShopBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.goBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.NEWYEAR_BACKHILL)
	end, SFX_PANEL)
end

function var0_0.initData(arg0_5)
	arg0_5.paintCount = 20
	arg0_5.curPaintIndex = 1
	arg0_5.paintSwitchTime = 1
	arg0_5.paintStaticTime = 3.5
	arg0_5.paintStaticCountValue = 0
	arg0_5.paintPathPrefix = "NewYearSkinShowPage/"
	arg0_5.paintNamePrefix = "NewYearA"
end

function var0_0.switchNextPaint(arg0_6)
	arg0_6.frameTimer:Stop()

	local var0_6 = arg0_6.curPaintIndex % arg0_6.paintCount + 1
	local var1_6 = arg0_6.paintNamePrefix .. var0_6
	local var2_6 = arg0_6.paintPathPrefix .. var1_6

	setImageSprite(arg0_6.paintBackTF, LoadSprite(var2_6, var1_6))
	LeanTween.value(go(arg0_6.paintFrontTF), 1, 0, arg0_6.paintSwitchTime):setOnUpdate(System.Action_float(function(arg0_7)
		setImageAlpha(arg0_6.paintFrontTF, arg0_7)
		setImageAlpha(arg0_6.paintBackTF, 1 - arg0_7)
	end)):setOnComplete(System.Action(function()
		setImageFromImage(arg0_6.paintFrontTF, arg0_6.paintBackTF)
		setImageAlpha(arg0_6.paintFrontTF, 1)
		setImageAlpha(arg0_6.paintBackTF, 0)

		arg0_6.curPaintIndex = var0_6

		arg0_6.frameTimer:Start()
	end))
end

function var0_0.OnFirstFlush(arg0_9)
	arg0_9:initPaint()
	arg0_9:initTimer()
end

function var0_0.initPaint(arg0_10)
	local var0_10 = arg0_10.curPaintIndex
	local var1_10 = (var0_10 - 1) % arg0_10.paintCount + 1
	local var2_10 = arg0_10.paintNamePrefix .. var0_10
	local var3_10 = arg0_10.paintPathPrefix .. var2_10

	setImageSprite(arg0_10.paintFrontTF, LoadSprite(var3_10, var2_10))

	local var4_10 = arg0_10.paintNamePrefix .. var1_10
	local var5_10 = arg0_10.paintPathPrefix .. var4_10

	setImageSprite(arg0_10.paintBackTF, LoadSprite(var5_10, var4_10))
end

function var0_0.initTimer(arg0_11)
	local var0_11 = 0.0166666666666667

	arg0_11.paintStaticCountValue = 0
	arg0_11.frameTimer = Timer.New(function()
		arg0_11.paintStaticCountValue = arg0_11.paintStaticCountValue + var0_11

		if arg0_11.paintStaticCountValue >= arg0_11.paintStaticTime then
			arg0_11.paintStaticCountValue = 0

			arg0_11:switchNextPaint()
		end
	end, var0_11, -1, false)

	arg0_11.frameTimer:Start()
end

function var0_0.OnDestroy(arg0_13)
	if arg0_13.frameTimer then
		arg0_13.frameTimer:Stop()

		arg0_13.frameTimer = nil
	end
end

return var0_0
