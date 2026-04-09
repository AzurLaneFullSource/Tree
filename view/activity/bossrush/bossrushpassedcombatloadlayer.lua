local var0_0 = class("BossRushPassedCombatLoadLayer", import(".BossRushPassedLayer"))

var0_0.GROW_TIME = 0.55

function var0_0.getUIName(arg0_1)
	return "BossRushPassedUI"
end

function var0_0.didEnter(arg0_2)
	arg0_2.tweenObjs = {}

	pg.UIMgr.GetInstance():OverlayPanel(arg0_2._tf)
	arg0_2:updateSlider(arg0_2.curIndex)
	arg0_2:initSliderArea(arg0_2.curIndex)

	arg0_2._tf:GetComponent("Animator").enabled = false

	arg0_2:combatPreload()
end

function var0_0.willExit(arg0_3)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_3._tf)

	for iter0_3, iter1_3 in ipairs(arg0_3.tweenObjs) do
		LeanTween.cancel(iter1_3)
	end

	arg0_3.tweenObjs = {}
end

function var0_0.onBackPressed(arg0_4)
	return
end

function var0_0.initData(arg0_5)
	arg0_5.curIndex = arg0_5.contextData.curIndex
end

function var0_0.combatPreload(arg0_6)
	PoolMgr.GetInstance():DestroyAllSprite()

	arg0_6._loadObs = {}

	ys.Battle.BattleFXPool.GetInstance():Init()

	local var0_6 = ys.Battle.BattleResourceManager.GetInstance()

	var0_6:Init()

	local var1_6, var2_6 = CombatLoadUI.GetTotalResourceList(arg0_6.contextData)

	for iter0_6, iter1_6 in ipairs(var1_6) do
		var0_6:AddPreloadResource(iter1_6)
	end

	for iter2_6, iter3_6 in ipairs(var2_6) do
		var0_6:AddPreloadCV(iter3_6)
	end

	local function var3_6()
		arg0_6:updateSlider(arg0_6.curIndex + 1)
		arg0_6:emit(ChallengePassedCombatLoadMediator.FINISH, arg0_6._loadObs)
	end

	local var4_6 = 0

	local function var5_6(arg0_8)
		local var0_8
		local var1_8 = var4_6 == 0 and 0 or arg0_8 / var4_6

		arg0_6:moveSlider(var1_8)
	end

	local var6_6 = pg.UIMgr.GetInstance():GetMainCamera()

	setActive(var6_6, true)

	var4_6 = var0_6:StartPreload(var3_6, var5_6)
end

function var0_0.initSliderArea(arg0_9)
	local var0_9 = arg0_9.curIndex
	local var1_9 = arg0_9.contextData.maxIndex

	if var1_9 < var0_9 then
		var0_9 = var0_9 % var1_9 == 0 and var1_9 or var0_9 % var1_9
	end

	local var2_9 = 1 / (var1_9 - 1)

	arg0_9.curpercent = (var0_9 - 1) * var2_9
	arg0_9.nextprecent = var0_9 * var2_9
	arg0_9.deltaPercent = arg0_9.nextprecent - arg0_9.curpercent
end

function var0_0.moveSlider(arg0_10, arg1_10)
	arg0_10.sliderSC.value = arg0_10.curpercent + arg0_10.deltaPercent * arg1_10
end

return var0_0
