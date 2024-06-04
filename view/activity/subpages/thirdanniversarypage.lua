local var0 = class("ThirdAnniversaryPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0:findUI()
	arg0:initData()
end

function var0.findUI(arg0)
	arg0.paintBackTF = arg0:findTF("Paints/PaintBack")
	arg0.paintFrontTF = arg0:findTF("Paints/PaintFront")
	arg0.skinShopBtn = arg0:findTF("BtnShop")
	arg0.btnContainer = arg0:findTF("BtnList/Viewport/Content")

	local var0 = arg0.btnContainer.childCount / 2

	arg0.btnList1 = {}

	for iter0 = 0, var0 - 1 do
		arg0.btnList1[iter0 + 1] = arg0.btnContainer:GetChild(iter0)
	end

	arg0.btnList2 = {}

	for iter1 = 7, 2 * var0 - 1 do
		arg0.btnList2[#arg0.btnList2 + 1] = arg0.btnContainer:GetChild(iter1)
	end

	arg0.gridLayoutGroupCom = GetComponent(arg0.btnContainer, "GridLayoutGroup")
end

function var0.initData(arg0)
	arg0.paintCount = 14
	arg0.curPaintIndex = 1
	arg0.paintSwitchTime = 1
	arg0.paintStaticTime = 3.5
	arg0.paintStaticCountValue = 0
	arg0.paintPathPrefix = "thirdanniversarypage/"
	arg0.paintNamePrefix = "thirda"
	arg0.btnCount = arg0.btnContainer.childCount / 2
	arg0.btnSpeed = 50
	arg0.btnSizeX = arg0.gridLayoutGroupCom.cellSize.x
	arg0.btnMarginX = arg0.gridLayoutGroupCom.spacing.x
	arg0.moveLength = arg0.btnCount * (arg0.btnSizeX + arg0.btnMarginX)
	arg0.startAnchoredPosX = arg0.btnContainer.anchoredPosition.x
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
	arg0:initBtnList(arg0.btnList1)
	arg0:initBtnList(arg0.btnList2)
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

function var0.initBtnList(arg0, arg1)
	onButton(arg0, arg1[1], function()
		arg0:emit(ActivityMediator.GO_PRAY_POOL)
	end, SFX_PANEL)
	onButton(arg0, arg1[2], function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SUMMARY)
	end, SFX_PANEL)
	onButton(arg0, arg1[3], function()
		arg0:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.ACTIVITY_TYPE_RETURN_AWARD_ID3)
	end, SFX_PANEL)
	onButton(arg0, arg1[4], function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
			wrap = ChargeScene.TYPE_DIAMOND
		})
	end, SFX_PANEL)
	onButton(arg0, arg1[5], function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.THIRD_ANNIVERSARY_AKIBA)
	end, SFX_PANEL)
	onButton(arg0, arg1[6], function()
		arg0:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.PIZZAHUT_PT_PAGE)
	end, SFX_PANEL)
	onButton(arg0, arg1[7], function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
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

	arg0.frameTimer2 = Timer.New(function()
		local var0 = arg0.btnContainer.anchoredPosition.x - arg0.btnSpeed * var0

		if arg0.startAnchoredPosX - var0 >= arg0.moveLength then
			var0 = arg0.btnContainer.anchoredPosition.x + arg0.moveLength
		end

		arg0.btnContainer.anchoredPosition = Vector3(var0, 0, 0)
	end, var0, -1, false)

	arg0.frameTimer2:Start()
end

function var0.OnDestroy(arg0)
	if arg0.frameTimer then
		arg0.frameTimer:Stop()

		arg0.frameTimer = nil
	end

	if arg0.frameTimer2 then
		arg0.frameTimer2:Stop()

		arg0.frameTimer2 = nil
	end
end

return var0
