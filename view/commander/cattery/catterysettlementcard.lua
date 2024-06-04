local var0 = class("CatterySettlementCard")
local var1 = 1

function var0.Ctor(arg0, arg1)
	arg0.tr = arg1
	arg0.go = arg1.gameObject
	arg0.emptyTF = findTF(arg0.tr, "empty")
	arg0.commanderTF = findTF(arg0.tr, "commander")
	arg0.nameTxt = findTF(arg0.commanderTF, "name"):GetComponent(typeof(Text))
	arg0.char = findTF(arg0.commanderTF, "mask/char")
	arg0.expTxt = findTF(arg0.commanderTF, "exp/Text"):GetComponent(typeof(Text))
	arg0.slider = findTF(arg0.commanderTF, "exp_bar"):GetComponent(typeof(Slider))
	arg0.levelTxt = findTF(arg0.commanderTF, "level"):GetComponent(typeof(Text))
end

function var0.Update(arg0, arg1, arg2)
	arg0.cattery = arg1
	arg0.exp = arg2

	local var0 = arg1:ExistCommander()

	if var0 then
		arg0:UpdateCommander()
	end

	setActive(arg0.emptyTF, not var0)
	setActive(arg0.commanderTF, var0)
end

function var0.UpdateCommander(arg0)
	local var0 = arg0.exp
	local var1 = arg0.cattery:GetCommander()
	local var2 = arg0:GetOldCommander(var1, var0)

	arg0.oldCommander = var2
	arg0.commander = var1

	arg0:LoadCommander(var1)

	arg0.slider.value = var2.exp / var2:getNextLevelExp()
	arg0.levelTxt.text = "LV." .. var2:getLevel()
	arg0.expTxt.text = var2.exp .. "/" .. var2:getNextLevelExp()
	arg0.nameTxt.text = var2:getName()
end

function var0.InitAnim(arg0, arg1)
	local var0 = arg0.commander:getLevel()
	local var1 = arg0.oldCommander:getLevel()
	local var2 = arg0.commander:getNextLevelExp()
	local var3 = arg0.commander.exp / var2

	if var1 < var0 then
		table.insert(arg1, function(arg0)
			arg0:DoUpgradeAnim(arg0)
		end)
	else
		table.insert(arg1, function(arg0)
			arg0:AddExpAnim(arg0.slider.value, var3, arg0.oldCommander.exp, arg0.commander.exp, var2, arg0)
		end)
	end
end

function var0.Action(arg0, arg1)
	if not arg0.commander then
		arg1()

		return
	end

	local var0 = {}

	arg0:InitAnim(var0)
	parallelAsync(var0, arg1)
end

function var0.DoUpgradeAnim(arg0, arg1)
	local var0 = arg0.commander:getLevel()
	local var1 = arg0.oldCommander:getLevel()
	local var2 = var1
	local var3 = arg0.commander:getNextLevelExp()
	local var4 = arg0.commander.exp / var3

	local function var5()
		var2 = var2 + 1
		arg0.levelTxt.text = "LV." .. var2
	end

	local var6 = {}
	local var7 = var1 + 1

	table.insert(var6, function(arg0)
		local var0 = arg0.oldCommander:getNextLevelExp()
		local var1 = arg0.oldCommander.exp

		arg0:AddExpAnim(arg0.slider.value, 1, var1, var0, var0, function()
			var5()
			arg0()
		end)
	end)

	while var7 ~= var0 do
		var7 = var7 + 1

		table.insert(var6, function(arg0)
			local var0 = arg0.oldCommander:getConfigExp(var2)

			arg0:AddExpAnim(0, 1, 0, var0, var0, function()
				var5()
				arg0()
			end)
		end)
	end

	table.insert(var6, function(arg0)
		arg0:AddExpAnim(0, var4, 0, arg0.commander.exp, var3, arg0)
	end)
	seriesAsync(var6, arg1)
end

function var0.LoadCommander(arg0, arg1)
	arg0:ReturnCommander()

	arg0.painting = arg1:getPainting()

	setCommanderPaintingPrefab(arg0.char, arg0.painting, "result")
end

function var0.ReturnCommander(arg0)
	if arg0.painting then
		retCommanderPaintingPrefab(arg0.char, arg0.painting)

		arg0.painting = nil
	end
end

function var0.Clear(arg0)
	if LeanTween.isTweening(go(arg0.slider)) then
		LeanTween.cancel(go(arg0.slider))
	end

	if LeanTween.isTweening(go(arg0.expTxt)) then
		LeanTween.cancel(go(arg0.expTxt))
	end
end

function var0.Dispose(arg0)
	arg0:Clear()
	arg0:ReturnCommander()
end

function var0.GetOldCommander(arg0, arg1, arg2)
	local var0 = Clone(arg1)

	var0:ReduceExp(arg2)

	return var0
end

function var0.AddExpAnim(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	parallelAsync({
		function(arg0)
			LeanTween.value(go(arg0.slider), arg1, arg2, var1):setOnUpdate(System.Action_float(function(arg0)
				arg0.slider.value = arg0
			end)):setOnComplete(System.Action(arg0))
		end,
		function(arg0)
			LeanTween.value(go(arg0.expTxt), arg3, arg4, var1):setOnUpdate(System.Action_float(function(arg0)
				local var0 = math.ceil(arg0)

				arg0.expTxt.text = "<color=#94d53eFF>" .. var0 .. "/</color>" .. "<color=" .. arg0:GetColor() .. ">" .. arg5 .. "</color>"
			end)):setOnComplete(System.Action(arg0))
		end
	}, function()
		if arg6 then
			arg6()
		end
	end)
end

function var0.GetColor(arg0)
	return "#9f9999"
end

return var0
