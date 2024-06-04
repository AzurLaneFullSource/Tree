local var0 = class("CatteryAddHomeExpAnim")
local var1 = 1

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0.expSlider = findTF(arg0._tf, "slider"):GetComponent(typeof(Slider))
	arg0.levelTxt = findTF(arg0._tf, "level"):GetComponent(typeof(Text))
	arg0.expTxt = findTF(arg0._tf, "exp"):GetComponent(typeof(Text))
	arg0.addition = findTF(arg0._tf, "addition")
	arg0.additionExp = findTF(arg0._tf, "addition/exp")
	arg0.additionExpTxt = arg0.additionExp:Find("Text"):GetComponent(typeof(Text))
	arg0.additionItem = findTF(arg0._tf, "addition/item")
	arg0.additionItemImg = findTF(arg0._tf, "addition/item/icon")
	arg0.animRiseH = arg0.addition.localPosition.y

	setActive(arg0._tf, false)
end

function var0.Action(arg0, arg1, arg2, arg3, arg4, arg5)
	setActive(arg0._tf, true)

	arg0.callback = arg5

	local var0 = arg0:GetAwardOffset(arg3, arg4)

	setAnchoredPosition(arg0.addition, {
		x = var0
	})
	arg0:RefreshAward(arg3, arg4)
	arg0:RefreshHome(arg2)
end

function var0.GetAwardOffset(arg0, arg1, arg2)
	return (arg1 or arg2) and -82 or -15
end

function var0.RefreshAward(arg0, arg1, arg2)
	if arg1 then
		GetImageSpriteFromAtlasAsync("Props/20010", "", arg0.additionItemImg)
	elseif arg2 then
		GetImageSpriteFromAtlasAsync("Props/dormMoney", "", arg0.additionItemImg)
	end

	setActive(arg0.additionItem, arg1 or arg2)
end

function var0.RefreshHome(arg0, arg1)
	local var0 = getProxy(CommanderProxy):GetCommanderHome()

	arg0.additionExpTxt.text = arg1 .. "<size=40>EXP</size>"

	if var0.exp - arg1 < 0 then
		arg0:DoUpgradeAnim(var0, arg1)
	else
		arg0:DoAddExpAnim(var0, arg1)
	end
end

function var0.DoUpgradeAnim(arg0, arg1, arg2)
	arg0.levelTxt.text = "LV." .. arg1:GetLevel() - 1

	if arg2 == 0 then
		arg0:IfIsMaxLevel(arg1, arg2, true)

		return
	end

	local var0 = arg1:GetPrevLevelExp()
	local var1 = var0 - math.abs(arg1.exp - arg2)

	arg0.expTxt.text = "<color=#92FC63FF>" .. var1 .. "/</color>" .. var0

	local var2 = var1 / var0

	arg0.expSlider.value = var2

	local var3 = arg1:GetNextLevelExp()
	local var4 = arg1.exp / var3

	arg0:AddExpAnim(var2, 1, var1, var0, var0, function()
		arg0.levelTxt.text = "LV." .. arg1:GetLevel()

		arg0:AddExpAnim(0, var4, 0, arg1.exp, var3, function()
			arg0:IfIsMaxLevel(arg1, arg2)
		end)
	end)
	arg0:AdditionAnim(var1, function()
		if arg0.callback then
			arg0.callback()
		end

		arg0.callback = nil
	end)
end

function var0.DoAddExpAnim(arg0, arg1, arg2)
	arg0.levelTxt.text = "LV." .. arg1:GetLevel()

	if arg2 == 0 then
		arg0:IfIsMaxLevel(arg1, arg2, true)

		return
	end

	local var0 = arg1:GetNextLevelExp()
	local var1 = arg1.exp / var0
	local var2 = arg1.exp - arg2
	local var3 = var2 / var0

	arg0:AddExpAnim(var3, var1, var2, arg1.exp, var0)
	arg0:AdditionAnim(var1, function()
		if arg0.callback then
			arg0.callback()
		end

		arg0.callback = nil

		arg0:IfIsMaxLevel(arg1, arg2)
	end)
end

function var0.IfIsMaxLevel(arg0, arg1, arg2, arg3)
	if arg1:IsMaxLevel() then
		arg0.expTxt.text = "MAX"
		arg0.expSlider.value = 1
	end

	arg0:HideOrShowAddition(arg2)

	if arg3 then
		if not IsNil(arg0.additionItem) and isActive(arg0.additionItem) then
			arg0:AdditionAnim(var1, function()
				if arg0.callback then
					arg0.callback()
				end

				arg0.callback = nil
			end)
		else
			Timer.New(function()
				if arg0.callback then
					arg0.callback()
				end

				arg0.callback = nil
			end, var1, 1):Start()
		end
	end
end

function var0.HideOrShowAddition(arg0, arg1)
	setActive(arg0.additionExp, arg1 > 0)
end

function var0.Clear(arg0)
	if not IsNil(arg0.expSlider) and LeanTween.isTweening(go(arg0.expSlider)) then
		LeanTween.cancel(go(arg0.expSlider))
	end

	if not IsNil(arg0.expTxt) and LeanTween.isTweening(go(arg0.expTxt)) then
		LeanTween.cancel(go(arg0.expTxt))
	end

	if not IsNil(arg0.addition) and LeanTween.isTweening(go(arg0.addition)) then
		LeanTween.cancel(go(arg0.addition))
	end
end

function var0.Hide(arg0)
	arg0:Clear()
	setActive(arg0._tf, false)
end

function var0.Dispose(arg0)
	arg0:Hide()
end

function var0.AddExpAnim(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	parallelAsync({
		function(arg0)
			LeanTween.value(go(arg0.expSlider), arg1, arg2, var1):setOnUpdate(System.Action_float(function(arg0)
				arg0.expSlider.value = arg0
			end)):setOnComplete(System.Action(arg0))
		end,
		function(arg0)
			LeanTween.value(go(arg0.expTxt), arg3, arg4, var1):setOnUpdate(System.Action_float(function(arg0)
				local var0 = math.ceil(arg0)

				arg0.expTxt.text = "<color=#92FC63FF>" .. var0 .. "/</color>" .. arg5
			end)):setOnComplete(System.Action(arg0))
		end
	}, function()
		if arg6 then
			arg6()
		end
	end)
end

function var0.AdditionAnim(arg0, arg1, arg2)
	setActive(arg0.addition, true)
	LeanTween.value(go(arg0.addition), arg0.animRiseH, arg0.animRiseH + 25, arg1):setOnUpdate(System.Action_float(function(arg0)
		arg0.addition.localPosition = Vector3(arg0.addition.localPosition.x, arg0, 0)
	end)):setOnComplete(System.Action(function()
		setActive(arg0.addition, false)
		arg2()

		arg0.addition.localPosition = Vector3(arg0.addition.localPosition.x, 0, 0)
	end))
end

return var0
