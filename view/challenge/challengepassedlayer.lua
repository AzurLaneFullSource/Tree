local var0 = class("ChallengePassedLayer", import("..base.BaseUI"))

var0.BOSS_NUM = 5
var0.GROW_TIME = 0.55

function var0.getUIName(arg0)
	return "ChallengePassedUI"
end

function var0.init(arg0)
	arg0:findUI()
	arg0:initData()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0.tweenObjs = {}

	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
	arg0:updatePainting(arg0.paintingName, arg0.paintingTF, arg0.paintingShadow1, true)

	if arg0.paintingNamemNext then
		arg0:updatePainting(arg0.paintingNamemNext, arg0.paintingNextTF, arg0.paintingNextShadow1)
	end

	arg0:updateSlider(arg0.curIndex)
	arg0:moveSlider(arg0.curIndex)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end)
	arg0._tf:GetComponent("DftAniEvent"):SetEndEvent(function(arg0)
		arg0:emit(var0.ON_CLOSE)
	end)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	LeanTween.cancel(go(arg0.slider))

	for iter0, iter1 in ipairs(arg0.tweenObjs) do
		LeanTween.cancel(iter1)
	end

	arg0.tweenObjs = {}
end

function var0.onBackPressed(arg0)
	triggerButton(arg0._tf)
end

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.paintingTF = arg0:findTF("Painting")
	arg0.paintingShadow1 = arg0:findTF("Painting/PaintingShadow1")
	arg0.paintingNextTF = arg0:findTF("PaintingNext")
	arg0.paintingNextShadow1 = arg0:findTF("PaintingNext/PaintingShadow1")
	arg0.material1 = arg0:findTF("material1"):GetComponent(typeof(Image)).material
	arg0.slider = arg0:findTF("Slider")
	arg0.squareContainer = arg0:findTF("SquareList", arg0.slider)
	arg0.squareTpl = arg0:findTF("Squre", arg0.slider)
	arg0.squareList = UIItemList.New(arg0.squareContainer, arg0.squareTpl)
	arg0.sliderSC = GetComponent(arg0.slider, "Slider")
end

function var0.initData(arg0)
	local var0 = arg0.contextData.mode
	local var1 = getProxy(ChallengeProxy):getUserChallengeInfo(var0)

	arg0.curIndex = var1:getLevel()

	local var2 = arg0.curIndex % ChallengeConst.BOSS_NUM

	if var2 == 0 then
		var2 = ChallengeConst.BOSS_NUM
	end

	local var3 = var1:getDungeonIDList()
	local var4 = var3[var2]
	local var5 = 0

	if var0 == ChallengeProxy.MODE_CASUAL then
		if var2 ~= ChallengeConst.BOSS_NUM then
			var5 = var3[var2 + 1]
		end
	elseif var2 == ChallengeConst.BOSS_NUM then
		var5 = var1:getNextInfiniteDungeonIDList()[1]
	else
		var5 = var3[var2 + 1]
	end

	arg0.paintingName = pg.expedition_challenge_template[var4].char_icon[1]

	if var5 ~= 0 then
		arg0.paintingNamemNext = pg.expedition_challenge_template[var5].char_icon[1]
	end
end

function var0.addListener(arg0)
	onButton(arg0, arg0._tf, function()
		LeanTween.cancel(go(arg0.slider))
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
end

function var0.updatePainting(arg0, arg1, arg2, arg3, arg4)
	local function var0(arg0)
		arg0.material:SetFloat("_LineGray", 0.3)
		arg0.material:SetFloat("_TearDistance", 0)
		LeanTween.cancel(arg0.gameObject)
		table.insert(arg0.tweenObjs, arg0.gameObject)
		LeanTween.value(arg0.gameObject, 0, 2, 2):setLoopClamp():setOnUpdate(System.Action_float(function(arg0)
			if arg0 >= 1.2 then
				arg0.material:SetFloat("_LineGray", 0.3)
			elseif arg0 >= 1.1 then
				arg0.material:SetFloat("_LineGray", 0.45)
			elseif arg0 >= 1.03 then
				arg0.material:SetFloat("_TearDistance", 0)
			elseif arg0 >= 1 then
				arg0.material:SetFloat("_TearDistance", 0.3)
			elseif arg0 >= 0.35 then
				arg0.material:SetFloat("_LineGray", 0.3)
			elseif arg0 >= 0.3 then
				arg0.material:SetFloat("_LineGray", 0.4)
			elseif arg0 >= 0.25 then
				arg0.material:SetFloat("_LineGray", 0.3)
			elseif arg0 >= 0.2 then
				arg0.material:SetFloat("_LineGray", 0.4)
			end
		end))
	end

	setPaintingPrefab(arg2, arg1, "chuanwu")

	local var1 = arg0:findTF("fitter", arg2):GetChild(0)

	if var1 then
		local var2 = GetComponent(var1, "MeshImage")

		if arg4 then
			var2.material = arg0.material1

			var2.material:SetFloat("_LineDensity", 7)
			var0(var2)
		end
	end

	setPaintingPrefabAsync(arg3, arg1, "chuanwu")

	local var3 = arg0:findTF("fitter", arg3):GetChild(0)

	if var3 then
		var3:GetComponent("Image").color = Color.New(1, 1, 1, 0.15)
	end

	arg3.localScale = Vector3(2.2, 2.2, 1)
end

function var0.updateSlider(arg0, arg1)
	local var0 = arg1 or arg0.curIndex

	if var0 > ChallengeConst.BOSS_NUM then
		var0 = var0 % ChallengeConst.BOSS_NUM == 0 and ChallengeConst.BOSS_NUM or var0 % ChallengeConst.BOSS_NUM
	end

	local var1 = 1 / (ChallengeConst.BOSS_NUM - 1)
	local var2 = (var0 - 1) * var1

	arg0.sliderSC.value = var2

	arg0.squareList:make(function(arg0, arg1, arg2)
		local var0 = arg0:findTF("UnFinished", arg2)
		local var1 = arg0:findTF("Finished", arg2)
		local var2 = arg0:findTF("Challengeing", arg2)
		local var3 = arg0:findTF("Arrow", arg2)

		local function var4()
			setActive(var1, true)
			setActive(var0, false)
			setActive(var2, false)
		end

		local function var5()
			setActive(var1, false)
			setActive(var0, true)
			setActive(var2, false)
		end

		local function var6()
			setActive(var1, false)
			setActive(var0, false)
			setActive(var2, true)
		end

		if arg0 == UIItemList.EventUpdate then
			if arg1 + 1 < var0 then
				setActive(var3, false)
				var4()
			elseif arg1 + 1 == var0 then
				setActive(var3, true)
				var6()
			elseif arg1 + 1 > var0 then
				setActive(var3, false)
				var5()
			end
		end
	end)
	arg0.squareList:align(ChallengeConst.BOSS_NUM)
end

function var0.moveSlider(arg0, arg1)
	local var0 = arg1 or arg0.curIndex

	if var0 > ChallengeConst.BOSS_NUM then
		var0 = var0 % ChallengeConst.BOSS_NUM == 0 and ChallengeConst.BOSS_NUM or var0 % ChallengeConst.BOSS_NUM
	end

	local var1 = 1 / (ChallengeConst.BOSS_NUM - 1)
	local var2 = (var0 - 1) * var1
	local var3 = var0 * var1

	LeanTween.value(go(arg0.slider), var2, var3, var0.GROW_TIME):setDelay(1.4):setOnUpdate(System.Action_float(function(arg0)
		arg0.sliderSC.value = arg0
	end)):setOnComplete(System.Action(function()
		arg0:updateSlider(var0 + 1)
	end))
end

return var0
