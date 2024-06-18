local var0_0 = class("ThirdAnniversaryJPPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1:findUI()
	arg0_1:initData()
end

function var0_0.findUI(arg0_2)
	arg0_2.paintBackTF = arg0_2:findTF("Paints/PaintBack")
	arg0_2.paintFrontTF = arg0_2:findTF("Paints/PaintFront")
	arg0_2.skinShopBtn = arg0_2:findTF("BtnShop")
	arg0_2.btnContainer = arg0_2:findTF("BtnList/Viewport/Content")

	local var0_2 = arg0_2.btnContainer.childCount / 2

	arg0_2.btnList1 = {}

	for iter0_2 = 0, var0_2 - 1 do
		arg0_2.btnList1[iter0_2 + 1] = arg0_2.btnContainer:GetChild(iter0_2)
	end

	arg0_2.btnList2 = {}

	for iter1_2 = 5, 2 * var0_2 - 1 do
		arg0_2.btnList2[#arg0_2.btnList2 + 1] = arg0_2.btnContainer:GetChild(iter1_2)
	end

	arg0_2.gridLayoutGroupCom = GetComponent(arg0_2.btnContainer, "GridLayoutGroup")
end

function var0_0.initData(arg0_3)
	arg0_3.paintCount = 16
	arg0_3.curPaintIndex = 1
	arg0_3.paintSwitchTime = 1
	arg0_3.paintStaticTime = 3.5
	arg0_3.paintStaticCountValue = 0
	arg0_3.paintPathPrefix = "thirdanniversaryjppage/"
	arg0_3.paintNamePrefix = "paint"
	arg0_3.btnCount = arg0_3.btnContainer.childCount / 2
	arg0_3.btnSpeed = 50
	arg0_3.btnSizeX = arg0_3.gridLayoutGroupCom.cellSize.x
	arg0_3.btnMarginX = arg0_3.gridLayoutGroupCom.spacing.x
	arg0_3.moveLength = arg0_3.btnCount * (arg0_3.btnSizeX + arg0_3.btnMarginX)
	arg0_3.startAnchoredPosX = arg0_3.btnContainer.anchoredPosition.x
end

function var0_0.switchNextPaint(arg0_4)
	arg0_4.frameTimer:Stop()

	local var0_4 = arg0_4.curPaintIndex % arg0_4.paintCount + 1
	local var1_4 = arg0_4.paintNamePrefix .. var0_4
	local var2_4 = arg0_4.paintPathPrefix .. var1_4

	setImageSprite(arg0_4.paintBackTF, LoadSprite(var2_4, var1_4))
	LeanTween.value(go(arg0_4.paintFrontTF), 1, 0, arg0_4.paintSwitchTime):setOnUpdate(System.Action_float(function(arg0_5)
		setImageAlpha(arg0_4.paintFrontTF, arg0_5)
		setImageAlpha(arg0_4.paintBackTF, 1 - arg0_5)
	end)):setOnComplete(System.Action(function()
		setImageFromImage(arg0_4.paintFrontTF, arg0_4.paintBackTF)
		setImageAlpha(arg0_4.paintFrontTF, 1)
		setImageAlpha(arg0_4.paintBackTF, 0)

		arg0_4.curPaintIndex = var0_4

		arg0_4.frameTimer:Start()
	end))
end

function var0_0.OnFirstFlush(arg0_7)
	arg0_7:initPaint()
	arg0_7:initBtnList(arg0_7.btnList1)
	arg0_7:initBtnList(arg0_7.btnList2)
	arg0_7:initTimer()
end

function var0_0.initPaint(arg0_8)
	local var0_8 = arg0_8.curPaintIndex
	local var1_8 = (var0_8 - 1) % arg0_8.paintCount + 1
	local var2_8 = arg0_8.paintNamePrefix .. var0_8
	local var3_8 = arg0_8.paintPathPrefix .. var2_8

	setImageSprite(arg0_8.paintFrontTF, LoadSprite(var3_8, var2_8))

	local var4_8 = arg0_8.paintNamePrefix .. var1_8
	local var5_8 = arg0_8.paintPathPrefix .. var4_8

	setImageSprite(arg0_8.paintBackTF, LoadSprite(var5_8, var4_8))
end

function var0_0.initBtnList(arg0_9, arg1_9)
	onButton(arg0_9, arg1_9[1], function()
		arg0_9:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT)
	end, SFX_PANEL)
	onButton(arg0_9, arg1_9[2], function()
		arg0_9:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	onButton(arg0_9, arg1_9[3], function()
		arg0_9:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP, {
			type = SkinShopScene.SHOP_TYPE_TIMELIMIT
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg1_9[4], function()
		arg0_9:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.THIRD_ANNIVERSARY_AKIBA)
	end, SFX_PANEL)
	onButton(arg0_9, arg1_9[5], function()
		arg0_9:emit(ActivityMediator.SELECT_ACTIVITY, pg.activity_const.JIUJIU_ADVENTURE_ID.act_id)
	end, SFX_PANEL)
end

function var0_0.initTimer(arg0_15)
	local var0_15 = 0.0166666666666667

	arg0_15.paintStaticCountValue = 0
	arg0_15.frameTimer = Timer.New(function()
		arg0_15.paintStaticCountValue = arg0_15.paintStaticCountValue + var0_15

		if arg0_15.paintStaticCountValue >= arg0_15.paintStaticTime then
			arg0_15.paintStaticCountValue = 0

			arg0_15:switchNextPaint()
		end
	end, var0_15, -1, false)

	arg0_15.frameTimer:Start()
end

function var0_0.OnDestroy(arg0_17)
	if arg0_17.frameTimer then
		arg0_17.frameTimer:Stop()

		arg0_17.frameTimer = nil
	end

	if arg0_17.frameTimer2 then
		arg0_17.frameTimer2:Stop()

		arg0_17.frameTimer2 = nil
	end
end

return var0_0
