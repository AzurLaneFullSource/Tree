local var0 = class("NewYear3thSkinShowPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0:findUI()
	arg0:initData()
end

function var0.findUI(arg0)
	arg0.paintBackTF = arg0:findTF("Paints/PaintBack")
	arg0.paintFrontTF = arg0:findTF("Paints/PaintFront")
	arg0.skinShopBtn = arg0:findTF("BtnShop")
	arg0.goBtn = arg0:findTF("BtnGO")

	onButton(arg0, arg0.skinShopBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	onButton(arg0, arg0.goBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SPRING_TOWN)
	end, SFX_PANEL)
end

function var0.initData(arg0)
	arg0.paintCount = 20
	arg0.curPaintIndex = 1
	arg0.paintSwitchTime = 1
	arg0.paintStaticTime = 3.5
	arg0.paintStaticCountValue = 0
	arg0.paintPathPrefix = "newyear3thskinshowpage/"
	arg0.paintNamePrefix = "NewYearSkin"
end

function var0.switchNextPaint(arg0)
	arg0.frameTimer:Stop()

	local var0 = arg0.curPaintIndex % arg0.paintCount + 1
	local var1 = arg0.paintNamePrefix .. var0
	local var2 = arg0.paintPathPrefix .. var1

	setImageSprite(arg0.paintBackTF, LoadSprite(var2, var1))
	LeanTween.value(go(arg0.paintFrontTF), 1, 0, arg0.paintSwitchTime):setOnUpdate(System.Action_float(function(arg0)
		setImageAlpha(arg0.paintFrontTF, arg0)
		setImageAlpha(arg0.paintBackTF, 1 - arg0)
	end)):setOnComplete(System.Action(function()
		setImageFromImage(arg0.paintFrontTF, arg0.paintBackTF)
		setImageAlpha(arg0.paintFrontTF, 1)
		setImageAlpha(arg0.paintBackTF, 0)

		arg0.curPaintIndex = var0

		arg0.frameTimer:Start()
	end))
end

function var0.OnFirstFlush(arg0)
	arg0:initPaint()
	arg0:initTimer()
end

function var0.initPaint(arg0)
	local var0 = arg0.curPaintIndex
	local var1 = (var0 - 1) % arg0.paintCount + 1
	local var2 = arg0.paintNamePrefix .. var0
	local var3 = arg0.paintPathPrefix .. var2

	setImageSprite(arg0.paintFrontTF, LoadSprite(var3, var2))

	local var4 = arg0.paintNamePrefix .. var1
	local var5 = arg0.paintPathPrefix .. var4

	setImageSprite(arg0.paintBackTF, LoadSprite(var5, var4))
end

function var0.initTimer(arg0)
	local var0 = 0.0166666666666667

	arg0.paintStaticCountValue = 0
	arg0.frameTimer = Timer.New(function()
		arg0.paintStaticCountValue = arg0.paintStaticCountValue + var0

		if arg0.paintStaticCountValue >= arg0.paintStaticTime then
			arg0.paintStaticCountValue = 0

			arg0:switchNextPaint()
		end
	end, var0, -1, false)

	arg0.frameTimer:Start()
end

function var0.OnDestroy(arg0)
	if arg0.frameTimer then
		arg0.frameTimer:Stop()

		arg0.frameTimer = nil
	end
end

return var0
