local var0_0 = class("Spring23AnniversaryPage", import("...base.BaseActivityPage"))
local var1_0 = 42
local var2_0 = {}
local var3_0 = 3.5
local var4_0 = 1
local var5_0 = 6
local var6_0 = SCENE.NEWYEAR_BACKHILL_2023
local var7_0 = "spring23a"

function var0_0.OnInit(arg0_1)
	arg0_1.hideIndex = {}
	arg0_1.scrollAble = false

	local var0_1 = findTF(arg0_1._tf, "BtnList")

	setActive(var0_1, false)

	if PLATFORM_CODE == PLATFORM_CH then
		var2_0 = {
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
			11,
			12,
			13,
			14,
			15,
			16
		}
	elseif PLATFORM_CODE == PLATFORM_CHT then
		var2_0 = {
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
			11,
			12,
			13,
			14,
			15,
			16
		}
	else
		var2_0 = {
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
			11,
			12,
			13,
			14,
			15,
			16
		}
	end

	if PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_CHT then
		arg0_1.hideIndex = {}
		arg0_1.scrollAble = true
		var0_1.anchoredPosition = Vector2(-11, -20)
		var0_1.sizeDelta = Vector2(1437, 90)
	elseif PLATFORM_CODE == PLATFORM_US then
		arg0_1.hideIndex = {}
		arg0_1.scrollAble = false
		var0_1.anchoredPosition = Vector2(678, -20)
		var0_1.sizeDelta = Vector2(1186, 90)
	else
		arg0_1.hideIndex = {}
		arg0_1.scrollAble = false
		var0_1.anchoredPosition = Vector2(115, -20)
		var0_1.sizeDelta = Vector2(1186, 90)
	end

	arg0_1:findUI()
end

function var0_0.findUI(arg0_2)
	arg0_2.paintBackTF = arg0_2:findTF("Paints/PaintBack")
	arg0_2.paintFrontTF = arg0_2:findTF("Paints/PaintFront")
	arg0_2.skinShopBtn = arg0_2:findTF("BtnShop")
	arg0_2.btnGo = arg0_2:findTF("BtnGo")
	arg0_2.btnContainer = arg0_2:findTF("BtnList/Viewport/Content")

	local var0_2 = arg0_2.btnContainer.childCount / 3

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

	for iter3_2 = 1, var0_2 * 3 do
		if table.contains(arg0_2.hideIndex, (iter3_2 - 1) % var5_0 + 1) or not arg0_2.scrollAble and iter3_2 > var5_0 then
			setActive(arg0_2.btnContainer:GetChild(iter3_2 - 1), false)
		end
	end

	arg0_2.gridLayoutGroupCom = GetComponent(arg0_2.btnContainer, "GridLayoutGroup")
end

function var0_0.initData(arg0_3)
	arg0_3.displayDatas = arg0_3.activity:getConfig("config_client").display_link

	local var0_3 = {}

	if arg0_3.displayDatas and #arg0_3.displayDatas then
		for iter0_3 = 1, #arg0_3.displayDatas do
			local var1_3 = arg0_3.displayDatas[iter0_3]
			local var2_3 = var1_3[1]
			local var3_3 = var1_3[2]

			if var3_3 and var3_3 ~= 0 then
				local var4_3 = pg.shop_template[var3_3].time
				local var5_3, var6_3 = pg.TimeMgr.GetInstance():inTime(var4_3)

				if not var5_3 then
					table.insert(var0_3, var2_3)
				end
			end
		end
	end

	if var0_3 and #var0_3 > 0 then
		for iter1_3 = #var2_0, 1, -1 do
			local var7_3 = var2_0[iter1_3]

			if table.contains(var0_3, var7_3) then
				table.remove(var2_0, iter1_3)
			end
		end
	end

	arg0_3.paintCount = #var2_0
	arg0_3.curPaintIndex = math.random(1, #var2_0)
	arg0_3.paintSwitchTime = var4_0
	arg0_3.paintStaticTime = var3_0
	arg0_3.paintStaticCountValue = 0
	arg0_3.paintPathPrefix = "clutter/"
	arg0_3.paintNamePrefix = var7_0
	arg0_3.btnCount = arg0_3.btnContainer.childCount / 3
	arg0_3.btnSpeed = 50
	arg0_3.btnSizeX = arg0_3.gridLayoutGroupCom.cellSize.x
	arg0_3.btnMarginX = arg0_3.gridLayoutGroupCom.spacing.x
	arg0_3.moveLength = (arg0_3.btnCount - #arg0_3.hideIndex) * (arg0_3.btnSizeX + arg0_3.btnMarginX)
	arg0_3.startAnchoredPosX = arg0_3.btnContainer.anchoredPosition.x
end

function var0_0.switchNextPaint(arg0_4)
	arg0_4.frameTimer:Stop()

	local var0_4 = arg0_4.curPaintIndex % arg0_4.paintCount + 1
	local var1_4 = arg0_4.paintNamePrefix .. var2_0[var0_4]
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
	arg0_7:initData()
	onButton(arg0_7, arg0_7.skinShopBtn, function()
		arg0_7:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end)
	onButton(arg0_7, arg0_7.btnGo, function()
		arg0_7:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SPRING_FESTIVAL_BACKHILL_2023)
	end)
	arg0_7:initPaint()
	arg0_7:initBtnList(arg0_7.btnList1)
	arg0_7:initBtnList(arg0_7.btnList2)
	arg0_7:initBtnList(arg0_7.btnList3)
	arg0_7:initTimer()
end

function var0_0.initPaint(arg0_10)
	local var0_10 = (arg0_10.curPaintIndex - 1) % arg0_10.paintCount + 1
	local var1_10 = arg0_10.paintNamePrefix .. var2_0[var0_10]
	local var2_10 = arg0_10.paintPathPrefix .. var1_10

	setImageSprite(arg0_10.paintFrontTF, LoadSprite(var2_10, var1_10))

	local var3_10 = arg0_10.paintNamePrefix .. var2_0[var0_10]
	local var4_10 = arg0_10.paintPathPrefix .. var3_10

	setImageSprite(arg0_10.paintBackTF, LoadSprite(var4_10, var3_10))
end

function var0_0.initBtnList(arg0_11, arg1_11)
	for iter0_11 = 1, #arg1_11 do
		arg0_11:initBtnEvent(arg1_11[iter0_11], iter0_11)
	end
end

function var0_0.initBtnEvent(arg0_12, arg1_12, arg2_12)
	if arg2_12 == 1 then
		onButton(arg0_12, arg1_12, function()
			arg0_12:emit(ActivityMediator.GO_PRAY_POOL)
		end, SFX_PANEL)
	elseif arg2_12 == 2 then
		onButton(arg0_12, arg1_12, function()
			arg0_12:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.ACTIVITY_TYPE_RETURN_AWARD_ID5)
		end, SFX_PANEL)
	elseif arg2_12 == 3 then
		onButton(arg0_12, arg1_12, function()
			arg0_12:emit(ActivityMediator.EVENT_GO_SCENE, var6_0)
		end, SFX_PANEL)
	elseif arg2_12 == 4 then
		onButton(arg0_12, arg1_12, function()
			arg0_12:emit(ActivityMediator.GO_MINI_GAME, var1_0)
		end, SFX_PANEL)
	elseif arg2_12 == 5 then
		onButton(arg0_12, arg1_12, function()
			arg0_12:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SUMMARY)
		end, SFX_PANEL)
	elseif arg2_12 == 6 then
		onButton(arg0_12, arg1_12, function()
			arg0_12:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
				wrap = ChargeScene.TYPE_DIAMOND
			})
		end, SFX_PANEL)
	end
end

function var0_0.initTimer(arg0_19)
	local var0_19 = 0.0166666666666667

	arg0_19.paintStaticCountValue = 0
	arg0_19.frameTimer = Timer.New(function()
		arg0_19.paintStaticCountValue = arg0_19.paintStaticCountValue + var0_19

		if arg0_19.paintStaticCountValue >= arg0_19.paintStaticTime then
			arg0_19.paintStaticCountValue = 0

			arg0_19:switchNextPaint()
		end
	end, var0_19, -1, false)

	arg0_19.frameTimer:Start()

	if arg0_19.scrollAble then
		arg0_19.frameTimer2 = Timer.New(function()
			local var0_21 = arg0_19.btnContainer.anchoredPosition.x - arg0_19.btnSpeed * var0_19

			if arg0_19.startAnchoredPosX - var0_21 >= arg0_19.moveLength then
				var0_21 = arg0_19.btnContainer.anchoredPosition.x + arg0_19.moveLength
			end

			arg0_19.btnContainer.anchoredPosition = Vector3(var0_21, 0, 0)
		end, var0_19, -1, false)

		arg0_19.frameTimer2:Start()
	end
end

function var0_0.OnDestroy(arg0_22)
	if LeanTween.isTweening(go(arg0_22.paintFrontTF)) then
		LeanTween.cancel(go(arg0_22.paintFrontTF))
	end

	if arg0_22.frameTimer then
		arg0_22.frameTimer:Stop()

		arg0_22.frameTimer = nil
	end

	if arg0_22.frameTimer2 then
		arg0_22.frameTimer2:Stop()

		arg0_22.frameTimer2 = nil
	end
end

return var0_0
