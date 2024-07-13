local var0_0 = class("BossRushPassedLayer", import("view.challenge.ChallengePassedLayer"))

var0_0.GROW_TIME = 0.55

function var0_0.getUIName(arg0_1)
	return "BossRushPassedUI"
end

function var0_0.didEnter(arg0_2)
	arg0_2.tweenObjs = {}

	pg.UIMgr.GetInstance():OverlayPanel(arg0_2._tf)
	arg0_2:updateSlider(arg0_2.curIndex)
	arg0_2:moveSlider(arg0_2.curIndex)
	onButton(arg0_2, arg0_2._tf, function()
		arg0_2:emit(var0_0.ON_CLOSE)
	end)
	arg0_2._tf:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_4)
		arg0_2:emit(var0_0.ON_CLOSE)
	end)
end

function var0_0.willExit(arg0_5)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_5._tf)
	LeanTween.cancel(go(arg0_5.slider))

	for iter0_5, iter1_5 in ipairs(arg0_5.tweenObjs) do
		LeanTween.cancel(iter1_5)
	end

	arg0_5.tweenObjs = {}
end

function var0_0.onBackPressed(arg0_6)
	triggerButton(arg0_6._tf)
end

function var0_0.initData(arg0_7)
	arg0_7.curIndex = arg0_7.contextData.curIndex
end

function var0_0.updateSlider(arg0_8, arg1_8)
	local var0_8 = arg1_8 or arg0_8.curIndex
	local var1_8 = arg0_8.contextData.maxIndex

	if var1_8 < var0_8 then
		var0_8 = var0_8 % var1_8 == 0 and var1_8 or var0_8 % var1_8
	end

	local var2_8 = 1 / (var1_8 - 1)
	local var3_8 = (var0_8 - 1) * var2_8

	arg0_8.sliderSC.value = var3_8

	local var4_8 = GetComponent(arg0_8.squareTpl, typeof(LayoutElement)).preferredWidth
	local var5_8 = var4_8 * 0.5
	local var6_8 = (arg0_8.squareContainer.rect.width - var4_8) * var2_8

	arg0_8.squareList:make(function(arg0_9, arg1_9, arg2_9)
		local var0_9 = arg0_8:findTF("UnFinished", arg2_9)
		local var1_9 = arg0_8:findTF("Finished", arg2_9)
		local var2_9 = arg0_8:findTF("Challengeing", arg2_9)
		local var3_9 = arg0_8:findTF("Arrow", arg2_9)

		local function var4_9()
			setActive(var1_9, true)
			setActive(var0_9, false)
			setActive(var2_9, false)
		end

		local function var5_9()
			setActive(var1_9, false)
			setActive(var0_9, true)
			setActive(var2_9, false)
		end

		local function var6_9()
			setActive(var1_9, false)
			setActive(var0_9, false)
			setActive(var2_9, true)
		end

		if arg0_9 == UIItemList.EventUpdate then
			if arg1_9 + 1 < var0_8 then
				setActive(var3_9, false)
				var4_9()
			elseif arg1_9 + 1 == var0_8 then
				setActive(var3_9, true)
				var6_9()
			elseif arg1_9 + 1 > var0_8 then
				setActive(var3_9, false)
				var5_9()
			end

			setAnchoredPosition(arg2_9, {
				y = 0,
				x = var5_8 + var6_8 * arg1_9
			})
		end
	end)
	arg0_8.squareList:align(var1_8)
end

function var0_0.moveSlider(arg0_13, arg1_13)
	local var0_13 = arg1_13 or arg0_13.curIndex
	local var1_13 = arg0_13.contextData.maxIndex

	if var1_13 < var0_13 then
		var0_13 = var0_13 % var1_13 == 0 and var1_13 or var0_13 % var1_13
	end

	local var2_13 = 1 / (var1_13 - 1)
	local var3_13 = (var0_13 - 1) * var2_13
	local var4_13 = var0_13 * var2_13

	LeanTween.value(go(arg0_13.slider), var3_13, var4_13, var0_0.GROW_TIME):setDelay(1.4):setOnUpdate(System.Action_float(function(arg0_14)
		arg0_13.sliderSC.value = arg0_14
	end)):setOnComplete(System.Action(function()
		arg0_13:updateSlider(var0_13 + 1)
	end))
end

return var0_0
