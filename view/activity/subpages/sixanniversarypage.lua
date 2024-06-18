local var0_0 = class("SixAnniversaryPage", import("...base.BaseActivityPage"))
local var1_0 = 42
local var2_0 = {}
local var3_0 = 3.5
local var4_0 = 1
local var5_0 = 5
local var6_0 = SCENE.NEWYEAR_BACKHILL_2023
local var7_0 = false
local var8_0 = "sixth"

function var0_0.OnInit(arg0_1)
	arg0_1.hideIndex = {}
	arg0_1.scrollAble = var7_0

	local var0_1 = findTF(arg0_1._tf, "BtnList")

	if PLATFORM_CODE == PLATFORM_CH then
		var2_0 = {
			1,
			2,
			3,
			4,
			5,
			6,
			7
		}
	else
		var2_0 = {
			1,
			2,
			3,
			4,
			5,
			6,
			7
		}
	end

	if PLATFORM_CODE == PLATFORM_CH then
		arg0_1.hideIndex = {}
	elseif PLATFORM_CODE == PLATFORM_CHT then
		arg0_1.hideIndex = {
			2,
			3,
			5
		}
	else
		arg0_1.hideIndex = {
			2,
			5
		}
	end

	local var1_1 = getProxy(ActivityProxy):getActivityById(ActivityConst.SIX_SIGN_ACT_ID)

	if not var1_1 or not var1_1:isShow() then
		table.insert(arg0_1.hideIndex, 4)
	end

	arg0_1:findUI()
end

function var0_0.findUI(arg0_2)
	arg0_2.paintBackTF = arg0_2:findTF("Paints/PaintBack")
	arg0_2.paintFrontTF = arg0_2:findTF("Paints/PaintFront")
	arg0_2.skinShopBtn = arg0_2:findTF("BtnShop")
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
	arg0_3.paintNamePrefix = var8_0
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
	local var3_4 = nil or LoadSprite(var2_4, var1_4)

	setImageSprite(arg0_4.paintBackTF, var3_4)
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
	arg0_7:initPaint()
	arg0_7:initBtnList(arg0_7.btnList1)
	arg0_7:initBtnList(arg0_7.btnList2)
	arg0_7:initBtnList(arg0_7.btnList3)
	arg0_7:initTimer()
end

function var0_0.initPaint(arg0_9)
	local var0_9 = (arg0_9.curPaintIndex - 1) % arg0_9.paintCount + 1
	local var1_9 = arg0_9.paintNamePrefix .. var2_0[var0_9]
	local var2_9 = arg0_9.paintPathPrefix .. var1_9

	setImageSprite(arg0_9.paintFrontTF, LoadSprite(var2_9, var1_9))

	local var3_9 = arg0_9.paintNamePrefix .. var2_0[var0_9]
	local var4_9 = arg0_9.paintPathPrefix .. var3_9

	setImageSprite(arg0_9.paintBackTF, LoadSprite(var4_9, var3_9))
end

function var0_0.initBtnList(arg0_10, arg1_10)
	for iter0_10 = 1, #arg1_10 do
		arg0_10:initBtnEvent(arg1_10[iter0_10], iter0_10)
	end
end

function var0_0.initBtnEvent(arg0_11, arg1_11, arg2_11)
	if arg2_11 == 1 then
		onButton(arg0_11, arg1_11, function()
			arg0_11:emit(ActivityMediator.GO_PRAY_POOL)
		end, SFX_PANEL)
	elseif arg2_11 == 2 then
		onButton(arg0_11, arg1_11, function()
			arg0_11:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
				wrap = ChargeScene.TYPE_DIAMOND
			})
		end, SFX_PANEL)
	elseif arg2_11 == 3 then
		onButton(arg0_11, arg1_11, function()
			arg0_11:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.ACTIVITY_TYPE_RETURN_AWARD_ID6)
		end, SFX_PANEL)
	elseif arg2_11 == 4 then
		onButton(arg0_11, arg1_11, function()
			arg0_11:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.SIX_SIGN_ACT_ID)
		end, SFX_PANEL)
	elseif arg2_11 == 5 then
		onButton(arg0_11, arg1_11, function()
			arg0_11:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SUMMARY)
		end, SFX_PANEL)
	end
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

	if arg0_17.scrollAble then
		arg0_17.frameTimer2 = Timer.New(function()
			local var0_19 = arg0_17.btnContainer.anchoredPosition.x - arg0_17.btnSpeed * var0_17

			if arg0_17.startAnchoredPosX - var0_19 >= arg0_17.moveLength then
				var0_19 = arg0_17.btnContainer.anchoredPosition.x + arg0_17.moveLength
			end

			arg0_17.btnContainer.anchoredPosition = Vector3(var0_19, 0, 0)
		end, var0_17, -1, false)

		arg0_17.frameTimer2:Start()
	end
end

function var0_0.OnDestroy(arg0_20)
	if LeanTween.isTweening(go(arg0_20.paintFrontTF)) then
		LeanTween.cancel(go(arg0_20.paintFrontTF))
	end

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
