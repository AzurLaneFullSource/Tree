local var0_0 = class("FourthJpPage", import("...base.BaseActivityPage"))
local var1_0 = 3
local var2_0 = 6

function var0_0.OnInit(arg0_1)
	arg0_1.hideIndex = {}
	arg0_1.scrollAble = true

	if PLATFORM_CODE == PLATFORM_JP then
		arg0_1.hideIndex = {}
		arg0_1.scrollAble = true
	elseif PLATFORM_CODE == PLATFORM_US then
		arg0_1.hideIndex = {
			1,
			2,
			3,
			5
		}
		arg0_1.scrollAble = false
	else
		arg0_1.hideIndex = {
			2,
			5
		}
		arg0_1.scrollAble = false
	end

	arg0_1:findUI()
	arg0_1:initData()
end

function var0_0.findUI(arg0_2)
	arg0_2.paintBackTF = arg0_2:findTF("Paints/PaintBack")
	arg0_2.paintFrontTF = arg0_2:findTF("Paints/PaintFront")
	arg0_2.skinShopBtn = arg0_2:findTF("BtnShop")
	arg0_2.btnContainer = arg0_2:findTF("BtnList/Viewport/Content")

	local var0_2 = arg0_2.btnContainer.childCount / var1_0

	arg0_2.btnList1 = {}

	for iter0_2 = 0, var0_2 - 1 do
		arg0_2.btnList1[iter0_2 + 1] = arg0_2.btnContainer:GetChild(iter0_2)
	end

	arg0_2.btnList2 = {}

	for iter1_2 = var0_2, 2 * var0_2 - 1 do
		arg0_2.btnList2[#arg0_2.btnList2 + 1] = arg0_2.btnContainer:GetChild(iter1_2)
	end

	arg0_2.btnList3 = {}

	for iter2_2 = var0_2 * 2, 3 * var0_2 - 1 do
		arg0_2.btnList3[#arg0_2.btnList3 + 1] = arg0_2.btnContainer:GetChild(iter2_2)
	end

	for iter3_2 = 1, var0_2 * var1_0 do
		if table.contains(arg0_2.hideIndex, iter3_2 % var2_0) or not arg0_2.scrollAble and iter3_2 > var2_0 then
			setActive(arg0_2.btnContainer:GetChild(iter3_2 - 1), false)
		end
	end

	arg0_2.gridLayoutGroupCom = GetComponent(arg0_2.btnContainer, "GridLayoutGroup")
end

function var0_0.initData(arg0_3)
	arg0_3.paintCount = 10
	arg0_3.curPaintIndex = 1
	arg0_3.paintSwitchTime = 1
	arg0_3.paintStaticTime = 3.5
	arg0_3.paintStaticCountValue = 0
	arg0_3.paintPathPrefix = "clutter/"
	arg0_3.paintNamePrefix = "fourthJp"
	arg0_3.btnCount = arg0_3.btnContainer.childCount / var1_0
	arg0_3.btnSpeed = 50
	arg0_3.btnSizeX = arg0_3.gridLayoutGroupCom.cellSize.x
	arg0_3.btnMarginX = arg0_3.gridLayoutGroupCom.spacing.x
	arg0_3.moveLength = (arg0_3.btnCount - #arg0_3.hideIndex) * (arg0_3.btnSizeX + arg0_3.btnMarginX)
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
	onButton(arg0_7, arg0_7.skinShopBtn, function()
		arg0_7:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0_7:initPaint()
	arg0_7:initBtnList(arg0_7.btnList1)
	arg0_7:initBtnList(arg0_7.btnList2)
	arg0_7:initBtnList(arg0_7.btnList3)
	arg0_7:initTimer()
end

function var0_0.initPaint(arg0_9)
	local var0_9 = arg0_9.curPaintIndex
	local var1_9 = (var0_9 - 1) % arg0_9.paintCount + 1
	local var2_9 = arg0_9.paintNamePrefix .. var0_9
	local var3_9 = arg0_9.paintPathPrefix .. var2_9

	setImageSprite(arg0_9.paintFrontTF, LoadSprite(var3_9, var2_9))

	local var4_9 = arg0_9.paintNamePrefix .. var1_9
	local var5_9 = arg0_9.paintPathPrefix .. var4_9

	setImageSprite(arg0_9.paintBackTF, LoadSprite(var5_9, var4_9))
end

function var0_0.initBtnList(arg0_10, arg1_10)
	onButton(arg0_10, arg1_10[1], function()
		arg0_10:emit(ActivityMediator.GO_PRAY_POOL)
	end, SFX_PANEL)
	onButton(arg0_10, arg1_10[2], function()
		arg0_10:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SUMMARY)
	end, SFX_PANEL)
	onButton(arg0_10, arg1_10[3], function()
		arg0_10:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.RETUREN_AWARD_1)
	end, SFX_PANEL)
	onButton(arg0_10, arg1_10[4], function()
		arg0_10:emit(ActivityMediator.GO_MINI_GAME, 30)
	end, SFX_PANEL)
	onButton(arg0_10, arg1_10[5], function()
		arg0_10:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
			wrap = ChargeScene.TYPE_DIAMOND
		})
	end, SFX_PANEL)
	onButton(arg0_10, arg1_10[6], function()
		arg0_10:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.AMUSEMENT_PARK2)
	end, SFX_PANEL)
end

function var0_0.initTimer(arg0_17)
	local var0_17 = 0.0166666666666667

	arg0_17.paintStaticCountValue = 0
	arg0_17.frameTimer = Timer.New(function()
		arg0_17.paintStaticCountValue = arg0_17.paintStaticCountValue + var0_17

		if arg0_17.paintStaticCountValue >= arg0_17.paintStaticTime then
			arg0_17.paintStaticCountValue = 0

			arg0_17:switchNextPaint()
		end
	end, var0_17, -1, false)

	arg0_17.frameTimer:Start()

	arg0_17.frameTimer2 = Timer.New(function()
		if arg0_17.scrollAble then
			local var0_19 = arg0_17.btnContainer.anchoredPosition.x - arg0_17.btnSpeed * var0_17

			if arg0_17.startAnchoredPosX - var0_19 >= arg0_17.moveLength then
				var0_19 = arg0_17.btnContainer.anchoredPosition.x + arg0_17.moveLength
			end

			arg0_17.btnContainer.anchoredPosition = Vector3(var0_19, 0, 0)
		end
	end, var0_17, -1, false)

	arg0_17.frameTimer2:Start()
end

function var0_0.OnDestroy(arg0_20)
	if arg0_20.frameTimer then
		arg0_20.frameTimer:Stop()

		arg0_20.frameTimer = nil
	end

	if arg0_20.frameTimer2 then
		arg0_20.frameTimer2:Stop()

		arg0_20.frameTimer2 = nil
	end
end

return var0_0
