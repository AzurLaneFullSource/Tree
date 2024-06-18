local var0_0 = class("CatteryAddHomeExpAnim")
local var1_0 = 1

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.expSlider = findTF(arg0_1._tf, "slider"):GetComponent(typeof(Slider))
	arg0_1.levelTxt = findTF(arg0_1._tf, "level"):GetComponent(typeof(Text))
	arg0_1.expTxt = findTF(arg0_1._tf, "exp"):GetComponent(typeof(Text))
	arg0_1.addition = findTF(arg0_1._tf, "addition")
	arg0_1.additionExp = findTF(arg0_1._tf, "addition/exp")
	arg0_1.additionExpTxt = arg0_1.additionExp:Find("Text"):GetComponent(typeof(Text))
	arg0_1.additionItem = findTF(arg0_1._tf, "addition/item")
	arg0_1.additionItemImg = findTF(arg0_1._tf, "addition/item/icon")
	arg0_1.animRiseH = arg0_1.addition.localPosition.y

	setActive(arg0_1._tf, false)
end

function var0_0.Action(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2)
	setActive(arg0_2._tf, true)

	arg0_2.callback = arg5_2

	local var0_2 = arg0_2:GetAwardOffset(arg3_2, arg4_2)

	setAnchoredPosition(arg0_2.addition, {
		x = var0_2
	})
	arg0_2:RefreshAward(arg3_2, arg4_2)
	arg0_2:RefreshHome(arg2_2)
end

function var0_0.GetAwardOffset(arg0_3, arg1_3, arg2_3)
	return (arg1_3 or arg2_3) and -82 or -15
end

function var0_0.RefreshAward(arg0_4, arg1_4, arg2_4)
	if arg1_4 then
		GetImageSpriteFromAtlasAsync("Props/20010", "", arg0_4.additionItemImg)
	elseif arg2_4 then
		GetImageSpriteFromAtlasAsync("Props/dormMoney", "", arg0_4.additionItemImg)
	end

	setActive(arg0_4.additionItem, arg1_4 or arg2_4)
end

function var0_0.RefreshHome(arg0_5, arg1_5)
	local var0_5 = getProxy(CommanderProxy):GetCommanderHome()

	arg0_5.additionExpTxt.text = arg1_5 .. "<size=40>EXP</size>"

	if var0_5.exp - arg1_5 < 0 then
		arg0_5:DoUpgradeAnim(var0_5, arg1_5)
	else
		arg0_5:DoAddExpAnim(var0_5, arg1_5)
	end
end

function var0_0.DoUpgradeAnim(arg0_6, arg1_6, arg2_6)
	arg0_6.levelTxt.text = "LV." .. arg1_6:GetLevel() - 1

	if arg2_6 == 0 then
		arg0_6:IfIsMaxLevel(arg1_6, arg2_6, true)

		return
	end

	local var0_6 = arg1_6:GetPrevLevelExp()
	local var1_6 = var0_6 - math.abs(arg1_6.exp - arg2_6)

	arg0_6.expTxt.text = "<color=#92FC63FF>" .. var1_6 .. "/</color>" .. var0_6

	local var2_6 = var1_6 / var0_6

	arg0_6.expSlider.value = var2_6

	local var3_6 = arg1_6:GetNextLevelExp()
	local var4_6 = arg1_6.exp / var3_6

	arg0_6:AddExpAnim(var2_6, 1, var1_6, var0_6, var0_6, function()
		arg0_6.levelTxt.text = "LV." .. arg1_6:GetLevel()

		arg0_6:AddExpAnim(0, var4_6, 0, arg1_6.exp, var3_6, function()
			arg0_6:IfIsMaxLevel(arg1_6, arg2_6)
		end)
	end)
	arg0_6:AdditionAnim(var1_0, function()
		if arg0_6.callback then
			arg0_6.callback()
		end

		arg0_6.callback = nil
	end)
end

function var0_0.DoAddExpAnim(arg0_10, arg1_10, arg2_10)
	arg0_10.levelTxt.text = "LV." .. arg1_10:GetLevel()

	if arg2_10 == 0 then
		arg0_10:IfIsMaxLevel(arg1_10, arg2_10, true)

		return
	end

	local var0_10 = arg1_10:GetNextLevelExp()
	local var1_10 = arg1_10.exp / var0_10
	local var2_10 = arg1_10.exp - arg2_10
	local var3_10 = var2_10 / var0_10

	arg0_10:AddExpAnim(var3_10, var1_10, var2_10, arg1_10.exp, var0_10)
	arg0_10:AdditionAnim(var1_0, function()
		if arg0_10.callback then
			arg0_10.callback()
		end

		arg0_10.callback = nil

		arg0_10:IfIsMaxLevel(arg1_10, arg2_10)
	end)
end

function var0_0.IfIsMaxLevel(arg0_12, arg1_12, arg2_12, arg3_12)
	if arg1_12:IsMaxLevel() then
		arg0_12.expTxt.text = "MAX"
		arg0_12.expSlider.value = 1
	end

	arg0_12:HideOrShowAddition(arg2_12)

	if arg3_12 then
		if not IsNil(arg0_12.additionItem) and isActive(arg0_12.additionItem) then
			arg0_12:AdditionAnim(var1_0, function()
				if arg0_12.callback then
					arg0_12.callback()
				end

				arg0_12.callback = nil
			end)
		else
			Timer.New(function()
				if arg0_12.callback then
					arg0_12.callback()
				end

				arg0_12.callback = nil
			end, var1_0, 1):Start()
		end
	end
end

function var0_0.HideOrShowAddition(arg0_15, arg1_15)
	setActive(arg0_15.additionExp, arg1_15 > 0)
end

function var0_0.Clear(arg0_16)
	if not IsNil(arg0_16.expSlider) and LeanTween.isTweening(go(arg0_16.expSlider)) then
		LeanTween.cancel(go(arg0_16.expSlider))
	end

	if not IsNil(arg0_16.expTxt) and LeanTween.isTweening(go(arg0_16.expTxt)) then
		LeanTween.cancel(go(arg0_16.expTxt))
	end

	if not IsNil(arg0_16.addition) and LeanTween.isTweening(go(arg0_16.addition)) then
		LeanTween.cancel(go(arg0_16.addition))
	end
end

function var0_0.Hide(arg0_17)
	arg0_17:Clear()
	setActive(arg0_17._tf, false)
end

function var0_0.Dispose(arg0_18)
	arg0_18:Hide()
end

function var0_0.AddExpAnim(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19, arg6_19)
	parallelAsync({
		function(arg0_20)
			LeanTween.value(go(arg0_19.expSlider), arg1_19, arg2_19, var1_0):setOnUpdate(System.Action_float(function(arg0_21)
				arg0_19.expSlider.value = arg0_21
			end)):setOnComplete(System.Action(arg0_20))
		end,
		function(arg0_22)
			LeanTween.value(go(arg0_19.expTxt), arg3_19, arg4_19, var1_0):setOnUpdate(System.Action_float(function(arg0_23)
				local var0_23 = math.ceil(arg0_23)

				arg0_19.expTxt.text = "<color=#92FC63FF>" .. var0_23 .. "/</color>" .. arg5_19
			end)):setOnComplete(System.Action(arg0_22))
		end
	}, function()
		if arg6_19 then
			arg6_19()
		end
	end)
end

function var0_0.AdditionAnim(arg0_25, arg1_25, arg2_25)
	setActive(arg0_25.addition, true)
	LeanTween.value(go(arg0_25.addition), arg0_25.animRiseH, arg0_25.animRiseH + 25, arg1_25):setOnUpdate(System.Action_float(function(arg0_26)
		arg0_25.addition.localPosition = Vector3(arg0_25.addition.localPosition.x, arg0_26, 0)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_25.addition, false)
		arg2_25()

		arg0_25.addition.localPosition = Vector3(arg0_25.addition.localPosition.x, 0, 0)
	end))
end

return var0_0
