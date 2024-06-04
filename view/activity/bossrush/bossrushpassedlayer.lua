local var0 = class("BossRushPassedLayer", import("view.challenge.ChallengePassedLayer"))

var0.GROW_TIME = 0.55

function var0.getUIName(arg0)
	return "BossRushPassedUI"
end

function var0.didEnter(arg0)
	arg0.tweenObjs = {}

	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
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

function var0.initData(arg0)
	arg0.curIndex = arg0.contextData.curIndex
end

function var0.updateSlider(arg0, arg1)
	local var0 = arg1 or arg0.curIndex
	local var1 = arg0.contextData.maxIndex

	if var1 < var0 then
		var0 = var0 % var1 == 0 and var1 or var0 % var1
	end

	local var2 = 1 / (var1 - 1)
	local var3 = (var0 - 1) * var2

	arg0.sliderSC.value = var3

	local var4 = GetComponent(arg0.squareTpl, typeof(LayoutElement)).preferredWidth
	local var5 = var4 * 0.5
	local var6 = (arg0.squareContainer.rect.width - var4) * var2

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

			setAnchoredPosition(arg2, {
				y = 0,
				x = var5 + var6 * arg1
			})
		end
	end)
	arg0.squareList:align(var1)
end

function var0.moveSlider(arg0, arg1)
	local var0 = arg1 or arg0.curIndex
	local var1 = arg0.contextData.maxIndex

	if var1 < var0 then
		var0 = var0 % var1 == 0 and var1 or var0 % var1
	end

	local var2 = 1 / (var1 - 1)
	local var3 = (var0 - 1) * var2
	local var4 = var0 * var2

	LeanTween.value(go(arg0.slider), var3, var4, var0.GROW_TIME):setDelay(1.4):setOnUpdate(System.Action_float(function(arg0)
		arg0.sliderSC.value = arg0
	end)):setOnComplete(System.Action(function()
		arg0:updateSlider(var0 + 1)
	end))
end

return var0
