local var0_0 = class("ChallengePassedLayer", import("..base.BaseUI"))

var0_0.BOSS_NUM = 5
var0_0.GROW_TIME = 0.55

function var0_0.getUIName(arg0_1)
	return "ChallengePassedUI"
end

function var0_0.init(arg0_2)
	arg0_2:findUI()
	arg0_2:initData()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3.tweenObjs = {}

	pg.UIMgr.GetInstance():OverlayPanel(arg0_3._tf)
	arg0_3:updatePainting(arg0_3.paintingName, arg0_3.paintingTF, arg0_3.paintingShadow1, true)

	if arg0_3.paintingNamemNext then
		arg0_3:updatePainting(arg0_3.paintingNamemNext, arg0_3.paintingNextTF, arg0_3.paintingNextShadow1)
	end

	arg0_3:updateSlider(arg0_3.curIndex)
	arg0_3:moveSlider(arg0_3.curIndex)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end)
	arg0_3._tf:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_5)
		arg0_3:emit(var0_0.ON_CLOSE)
	end)
end

function var0_0.willExit(arg0_6)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_6._tf)
	LeanTween.cancel(go(arg0_6.slider))

	for iter0_6, iter1_6 in ipairs(arg0_6.tweenObjs) do
		LeanTween.cancel(iter1_6)
	end

	arg0_6.tweenObjs = {}
end

function var0_0.onBackPressed(arg0_7)
	triggerButton(arg0_7._tf)
end

function var0_0.findUI(arg0_8)
	arg0_8.bg = arg0_8:findTF("BG")
	arg0_8.paintingTF = arg0_8:findTF("Painting")
	arg0_8.paintingShadow1 = arg0_8:findTF("Painting/PaintingShadow1")
	arg0_8.paintingNextTF = arg0_8:findTF("PaintingNext")
	arg0_8.paintingNextShadow1 = arg0_8:findTF("PaintingNext/PaintingShadow1")
	arg0_8.material1 = arg0_8:findTF("material1"):GetComponent(typeof(Image)).material
	arg0_8.slider = arg0_8:findTF("Slider")
	arg0_8.squareContainer = arg0_8:findTF("SquareList", arg0_8.slider)
	arg0_8.squareTpl = arg0_8:findTF("Squre", arg0_8.slider)
	arg0_8.squareList = UIItemList.New(arg0_8.squareContainer, arg0_8.squareTpl)
	arg0_8.sliderSC = GetComponent(arg0_8.slider, "Slider")
end

function var0_0.initData(arg0_9)
	local var0_9 = arg0_9.contextData.mode
	local var1_9 = getProxy(ChallengeProxy):getUserChallengeInfo(var0_9)

	arg0_9.curIndex = var1_9:getLevel()

	local var2_9 = arg0_9.curIndex % ChallengeConst.BOSS_NUM

	if var2_9 == 0 then
		var2_9 = ChallengeConst.BOSS_NUM
	end

	local var3_9 = var1_9:getDungeonIDList()
	local var4_9 = var3_9[var2_9]
	local var5_9 = 0

	if var0_9 == ChallengeProxy.MODE_CASUAL then
		if var2_9 ~= ChallengeConst.BOSS_NUM then
			var5_9 = var3_9[var2_9 + 1]
		end
	elseif var2_9 == ChallengeConst.BOSS_NUM then
		var5_9 = var1_9:getNextInfiniteDungeonIDList()[1]
	else
		var5_9 = var3_9[var2_9 + 1]
	end

	arg0_9.paintingName = pg.expedition_challenge_template[var4_9].char_icon[1]

	if var5_9 ~= 0 then
		arg0_9.paintingNamemNext = pg.expedition_challenge_template[var5_9].char_icon[1]
	end
end

function var0_0.addListener(arg0_10)
	onButton(arg0_10, arg0_10._tf, function()
		LeanTween.cancel(go(arg0_10.slider))
		arg0_10:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
end

function var0_0.updatePainting(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	local function var0_12(arg0_13)
		arg0_13.material:SetFloat("_LineGray", 0.3)
		arg0_13.material:SetFloat("_TearDistance", 0)
		LeanTween.cancel(arg0_13.gameObject)
		table.insert(arg0_12.tweenObjs, arg0_13.gameObject)
		LeanTween.value(arg0_13.gameObject, 0, 2, 2):setLoopClamp():setOnUpdate(System.Action_float(function(arg0_14)
			if arg0_14 >= 1.2 then
				arg0_13.material:SetFloat("_LineGray", 0.3)
			elseif arg0_14 >= 1.1 then
				arg0_13.material:SetFloat("_LineGray", 0.45)
			elseif arg0_14 >= 1.03 then
				arg0_13.material:SetFloat("_TearDistance", 0)
			elseif arg0_14 >= 1 then
				arg0_13.material:SetFloat("_TearDistance", 0.3)
			elseif arg0_14 >= 0.35 then
				arg0_13.material:SetFloat("_LineGray", 0.3)
			elseif arg0_14 >= 0.3 then
				arg0_13.material:SetFloat("_LineGray", 0.4)
			elseif arg0_14 >= 0.25 then
				arg0_13.material:SetFloat("_LineGray", 0.3)
			elseif arg0_14 >= 0.2 then
				arg0_13.material:SetFloat("_LineGray", 0.4)
			end
		end))
	end

	setPaintingPrefab(arg2_12, arg1_12, "chuanwu")

	local var1_12 = arg0_12:findTF("fitter", arg2_12):GetChild(0)

	if var1_12 then
		local var2_12 = GetComponent(var1_12, "MeshImage")

		if arg4_12 then
			var2_12.material = arg0_12.material1

			var2_12.material:SetFloat("_LineDensity", 7)
			var0_12(var2_12)
		end
	end

	setPaintingPrefabAsync(arg3_12, arg1_12, "chuanwu")

	local var3_12 = arg0_12:findTF("fitter", arg3_12):GetChild(0)

	if var3_12 then
		var3_12:GetComponent("Image").color = Color.New(1, 1, 1, 0.15)
	end

	arg3_12.localScale = Vector3(2.2, 2.2, 1)
end

function var0_0.updateSlider(arg0_15, arg1_15)
	local var0_15 = arg1_15 or arg0_15.curIndex

	if var0_15 > ChallengeConst.BOSS_NUM then
		var0_15 = var0_15 % ChallengeConst.BOSS_NUM == 0 and ChallengeConst.BOSS_NUM or var0_15 % ChallengeConst.BOSS_NUM
	end

	local var1_15 = 1 / (ChallengeConst.BOSS_NUM - 1)
	local var2_15 = (var0_15 - 1) * var1_15

	arg0_15.sliderSC.value = var2_15

	arg0_15.squareList:make(function(arg0_16, arg1_16, arg2_16)
		local var0_16 = arg0_15:findTF("UnFinished", arg2_16)
		local var1_16 = arg0_15:findTF("Finished", arg2_16)
		local var2_16 = arg0_15:findTF("Challengeing", arg2_16)
		local var3_16 = arg0_15:findTF("Arrow", arg2_16)

		local function var4_16()
			setActive(var1_16, true)
			setActive(var0_16, false)
			setActive(var2_16, false)
		end

		local function var5_16()
			setActive(var1_16, false)
			setActive(var0_16, true)
			setActive(var2_16, false)
		end

		local function var6_16()
			setActive(var1_16, false)
			setActive(var0_16, false)
			setActive(var2_16, true)
		end

		if arg0_16 == UIItemList.EventUpdate then
			if arg1_16 + 1 < var0_15 then
				setActive(var3_16, false)
				var4_16()
			elseif arg1_16 + 1 == var0_15 then
				setActive(var3_16, true)
				var6_16()
			elseif arg1_16 + 1 > var0_15 then
				setActive(var3_16, false)
				var5_16()
			end
		end
	end)
	arg0_15.squareList:align(ChallengeConst.BOSS_NUM)
end

function var0_0.moveSlider(arg0_20, arg1_20)
	local var0_20 = arg1_20 or arg0_20.curIndex

	if var0_20 > ChallengeConst.BOSS_NUM then
		var0_20 = var0_20 % ChallengeConst.BOSS_NUM == 0 and ChallengeConst.BOSS_NUM or var0_20 % ChallengeConst.BOSS_NUM
	end

	local var1_20 = 1 / (ChallengeConst.BOSS_NUM - 1)
	local var2_20 = (var0_20 - 1) * var1_20
	local var3_20 = var0_20 * var1_20

	LeanTween.value(go(arg0_20.slider), var2_20, var3_20, var0_0.GROW_TIME):setDelay(1.4):setOnUpdate(System.Action_float(function(arg0_21)
		arg0_20.sliderSC.value = arg0_21
	end)):setOnComplete(System.Action(function()
		arg0_20:updateSlider(var0_20 + 1)
	end))
end

return var0_0
