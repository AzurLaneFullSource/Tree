local var0 = class("FiveAnniversaryPage", import("...base.BaseActivityPage"))
local var1 = 42
local var2 = {}
local var3 = 3.5
local var4 = 1
local var5 = 6
local var6 = SCENE.BACKHILL_CAMPUSFESTIVAL_2022

function var0.OnInit(arg0)
	arg0.hideIndex = {}
	arg0.scrollAble = false

	local var0 = findTF(arg0._tf, "BtnList")

	if PLATFORM_CODE == PLATFORM_CH then
		var2 = {
			2,
			3,
			5,
			8
		}
	elseif PLATFORM_CODE == PLATFORM_CHT then
		var2 = {
			1,
			2,
			3,
			4,
			5,
			6,
			7,
			8,
			9,
			10,
			11
		}
	else
		var2 = {
			1,
			2,
			3,
			4,
			5,
			6,
			7,
			8,
			9,
			10
		}
	end

	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_CHT then
		arg0.hideIndex = {}
		arg0.scrollAble = true
		var0.anchoredPosition = Vector2(-11, -20)
		var0.sizeDelta = Vector2(1437, 90)
	elseif PLATFORM_CODE == PLATFORM_US then
		arg0.hideIndex = {
			1,
			2,
			5,
			6
		}
		arg0.scrollAble = false
		var0.anchoredPosition = Vector2(678, -20)
		var0.sizeDelta = Vector2(1186, 90)
	else
		arg0.hideIndex = {
			5,
			6
		}
		arg0.scrollAble = false
		var0.anchoredPosition = Vector2(115, -20)
		var0.sizeDelta = Vector2(1186, 90)
	end

	arg0:findUI()
	arg0:initData()
end

function var0.findUI(arg0)
	arg0.paintBackTF = arg0:findTF("Paints/PaintBack")
	arg0.paintFrontTF = arg0:findTF("Paints/PaintFront")
	arg0.skinShopBtn = arg0:findTF("BtnShop")
	arg0.btnContainer = arg0:findTF("BtnList/Viewport/Content")

	local var0 = arg0.btnContainer.childCount / 3

	arg0.btnList1 = {}

	for iter0 = 0, var0 - 1 do
		arg0.btnList1[iter0 + 1] = arg0.btnContainer:GetChild(iter0)
	end

	arg0.btnList2 = {}

	for iter1 = var0, 2 * var0 - 1 do
		arg0.btnList2[#arg0.btnList2 + 1] = arg0.btnContainer:GetChild(iter1)
	end

	arg0.btnList3 = {}

	for iter2 = var0 * 2, 3 * var0 - 1 do
		arg0.btnList3[#arg0.btnList3 + 1] = arg0.btnContainer:GetChild(iter2)
	end

	for iter3 = 1, var0 * 3 do
		if table.contains(arg0.hideIndex, (iter3 - 1) % var5 + 1) or not arg0.scrollAble and iter3 > var5 then
			setActive(arg0.btnContainer:GetChild(iter3 - 1), false)
		end
	end

	arg0.gridLayoutGroupCom = GetComponent(arg0.btnContainer, "GridLayoutGroup")
end

function var0.initData(arg0)
	arg0.paintCount = #var2
	arg0.curPaintIndex = 1
	arg0.paintSwitchTime = var4
	arg0.paintStaticTime = var3
	arg0.paintStaticCountValue = 0
	arg0.paintPathPrefix = "clutter/"
	arg0.paintNamePrefix = "fivea"
	arg0.btnCount = arg0.btnContainer.childCount / 3
	arg0.btnSpeed = 50
	arg0.btnSizeX = arg0.gridLayoutGroupCom.cellSize.x
	arg0.btnMarginX = arg0.gridLayoutGroupCom.spacing.x
	arg0.moveLength = (arg0.btnCount - #arg0.hideIndex) * (arg0.btnSizeX + arg0.btnMarginX)
	arg0.startAnchoredPosX = arg0.btnContainer.anchoredPosition.x
end

function var0.switchNextPaint(arg0)
	arg0.frameTimer:Stop()

	local var0 = arg0.curPaintIndex % arg0.paintCount + 1
	local var1 = arg0.paintNamePrefix .. var2[var0]
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
	onButton(arg0, arg0.skinShopBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end)
	arg0:initPaint()
	arg0:initBtnList(arg0.btnList1)
	arg0:initBtnList(arg0.btnList2)
	arg0:initBtnList(arg0.btnList3)
	arg0:initTimer()
end

function var0.initPaint(arg0)
	local var0 = (arg0.curPaintIndex - 1) % arg0.paintCount + 1
	local var1 = arg0.paintNamePrefix .. var2[var0]
	local var2 = arg0.paintPathPrefix .. var1

	setImageSprite(arg0.paintFrontTF, LoadSprite(var2, var1))

	local var3 = arg0.paintNamePrefix .. var2[var0]
	local var4 = arg0.paintPathPrefix .. var3

	setImageSprite(arg0.paintBackTF, LoadSprite(var4, var3))
end

function var0.initBtnList(arg0, arg1)
	for iter0 = 1, #arg1 do
		arg0:initBtnEvent(arg1[iter0], iter0)
	end
end

function var0.initBtnEvent(arg0, arg1, arg2)
	if arg2 == 1 then
		onButton(arg0, arg1, function()
			arg0:emit(ActivityMediator.GO_PRAY_POOL)
		end, SFX_PANEL)
	elseif arg2 == 2 then
		onButton(arg0, arg1, function()
			if PLATFORM_CODE == PLATFORM_CHT then
				arg0:emit(ActivityMediator.SELECT_ACTIVITY, 41327)
			else
				arg0:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.ACTIVITY_TYPE_RETURN_AWARD_ID5)
			end
		end, SFX_PANEL)
	elseif arg2 == 3 then
		onButton(arg0, arg1, function()
			if PLATFORM_CODE == PLATFORM_CHT then
				arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SIXTH_ANNIVERSARY_JP)
			else
				arg0:emit(ActivityMediator.EVENT_GO_SCENE, var6)
			end
		end, SFX_PANEL)
	elseif arg2 == 4 then
		onButton(arg0, arg1, function()
			if PLATFORM_CODE == PLATFORM_CHT then
				arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SIXTH_ANNIVERSARY_JP_DARK)
			else
				arg0:emit(ActivityMediator.GO_MINI_GAME, var1)
			end
		end, SFX_PANEL)
	elseif arg2 == 5 then
		onButton(arg0, arg1, function()
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SUMMARY)
		end, SFX_PANEL)
	elseif arg2 == 6 then
		onButton(arg0, arg1, function()
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
				wrap = ChargeScene.TYPE_DIAMOND
			})
		end, SFX_PANEL)
	end
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

	if arg0.scrollAble then
		arg0.frameTimer2 = Timer.New(function()
			local var0 = arg0.btnContainer.anchoredPosition.x - arg0.btnSpeed * var0

			if arg0.startAnchoredPosX - var0 >= arg0.moveLength then
				var0 = arg0.btnContainer.anchoredPosition.x + arg0.moveLength
			end

			arg0.btnContainer.anchoredPosition = Vector3(var0, 0, 0)
		end, var0, -1, false)

		arg0.frameTimer2:Start()
	end
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
