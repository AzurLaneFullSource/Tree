local var0_0 = class("CatterySettlementCard")
local var1_0 = 1

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.tr = arg1_1
	arg0_1.go = arg1_1.gameObject
	arg0_1.emptyTF = findTF(arg0_1.tr, "empty")
	arg0_1.commanderTF = findTF(arg0_1.tr, "commander")
	arg0_1.nameTxt = findTF(arg0_1.commanderTF, "name"):GetComponent(typeof(Text))
	arg0_1.char = findTF(arg0_1.commanderTF, "mask/char")
	arg0_1.expTxt = findTF(arg0_1.commanderTF, "exp/Text"):GetComponent(typeof(Text))
	arg0_1.slider = findTF(arg0_1.commanderTF, "exp_bar"):GetComponent(typeof(Slider))
	arg0_1.levelTxt = findTF(arg0_1.commanderTF, "level"):GetComponent(typeof(Text))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.cattery = arg1_2
	arg0_2.exp = arg2_2

	local var0_2 = arg1_2:ExistCommander()

	if var0_2 then
		arg0_2:UpdateCommander()
	end

	setActive(arg0_2.emptyTF, not var0_2)
	setActive(arg0_2.commanderTF, var0_2)
end

function var0_0.UpdateCommander(arg0_3)
	local var0_3 = arg0_3.exp
	local var1_3 = arg0_3.cattery:GetCommander()
	local var2_3 = arg0_3:GetOldCommander(var1_3, var0_3)

	arg0_3.oldCommander = var2_3
	arg0_3.commander = var1_3

	arg0_3:LoadCommander(var1_3)

	arg0_3.slider.value = var2_3.exp / var2_3:getNextLevelExp()
	arg0_3.levelTxt.text = "LV." .. var2_3:getLevel()
	arg0_3.expTxt.text = var2_3.exp .. "/" .. var2_3:getNextLevelExp()
	arg0_3.nameTxt.text = var2_3:getName()
end

function var0_0.InitAnim(arg0_4, arg1_4)
	local var0_4 = arg0_4.commander:getLevel()
	local var1_4 = arg0_4.oldCommander:getLevel()
	local var2_4 = arg0_4.commander:getNextLevelExp()
	local var3_4 = arg0_4.commander.exp / var2_4

	if var1_4 < var0_4 then
		table.insert(arg1_4, function(arg0_5)
			arg0_4:DoUpgradeAnim(arg0_5)
		end)
	else
		table.insert(arg1_4, function(arg0_6)
			arg0_4:AddExpAnim(arg0_4.slider.value, var3_4, arg0_4.oldCommander.exp, arg0_4.commander.exp, var2_4, arg0_6)
		end)
	end
end

function var0_0.Action(arg0_7, arg1_7)
	if not arg0_7.commander then
		arg1_7()

		return
	end

	local var0_7 = {}

	arg0_7:InitAnim(var0_7)
	parallelAsync(var0_7, arg1_7)
end

function var0_0.DoUpgradeAnim(arg0_8, arg1_8)
	local var0_8 = arg0_8.commander:getLevel()
	local var1_8 = arg0_8.oldCommander:getLevel()
	local var2_8 = var1_8
	local var3_8 = arg0_8.commander:getNextLevelExp()
	local var4_8 = arg0_8.commander.exp / var3_8

	local function var5_8()
		var2_8 = var2_8 + 1
		arg0_8.levelTxt.text = "LV." .. var2_8
	end

	local var6_8 = {}
	local var7_8 = var1_8 + 1

	table.insert(var6_8, function(arg0_10)
		local var0_10 = arg0_8.oldCommander:getNextLevelExp()
		local var1_10 = arg0_8.oldCommander.exp

		arg0_8:AddExpAnim(arg0_8.slider.value, 1, var1_10, var0_10, var0_10, function()
			var5_8()
			arg0_10()
		end)
	end)

	while var7_8 ~= var0_8 do
		var7_8 = var7_8 + 1

		table.insert(var6_8, function(arg0_12)
			local var0_12 = arg0_8.oldCommander:getConfigExp(var2_8)

			arg0_8:AddExpAnim(0, 1, 0, var0_12, var0_12, function()
				var5_8()
				arg0_12()
			end)
		end)
	end

	table.insert(var6_8, function(arg0_14)
		arg0_8:AddExpAnim(0, var4_8, 0, arg0_8.commander.exp, var3_8, arg0_14)
	end)
	seriesAsync(var6_8, arg1_8)
end

function var0_0.LoadCommander(arg0_15, arg1_15)
	arg0_15:ReturnCommander()

	arg0_15.painting = arg1_15:getPainting()

	setCommanderPaintingPrefab(arg0_15.char, arg0_15.painting, "result")
end

function var0_0.ReturnCommander(arg0_16)
	if arg0_16.painting then
		retCommanderPaintingPrefab(arg0_16.char, arg0_16.painting)

		arg0_16.painting = nil
	end
end

function var0_0.Clear(arg0_17)
	if LeanTween.isTweening(go(arg0_17.slider)) then
		LeanTween.cancel(go(arg0_17.slider))
	end

	if LeanTween.isTweening(go(arg0_17.expTxt)) then
		LeanTween.cancel(go(arg0_17.expTxt))
	end
end

function var0_0.Dispose(arg0_18)
	arg0_18:Clear()
	arg0_18:ReturnCommander()
end

function var0_0.GetOldCommander(arg0_19, arg1_19, arg2_19)
	local var0_19 = Clone(arg1_19)

	var0_19:ReduceExp(arg2_19)

	return var0_19
end

function var0_0.AddExpAnim(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20, arg5_20, arg6_20)
	parallelAsync({
		function(arg0_21)
			LeanTween.value(go(arg0_20.slider), arg1_20, arg2_20, var1_0):setOnUpdate(System.Action_float(function(arg0_22)
				arg0_20.slider.value = arg0_22
			end)):setOnComplete(System.Action(arg0_21))
		end,
		function(arg0_23)
			LeanTween.value(go(arg0_20.expTxt), arg3_20, arg4_20, var1_0):setOnUpdate(System.Action_float(function(arg0_24)
				local var0_24 = math.ceil(arg0_24)

				arg0_20.expTxt.text = "<color=#94d53eFF>" .. var0_24 .. "/</color>" .. "<color=" .. arg0_20:GetColor() .. ">" .. arg5_20 .. "</color>"
			end)):setOnComplete(System.Action(arg0_23))
		end
	}, function()
		if arg6_20 then
			arg6_20()
		end
	end)
end

function var0_0.GetColor(arg0_26)
	return "#9f9999"
end

return var0_0
