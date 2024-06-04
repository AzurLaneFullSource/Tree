local var0 = class("CatteryAnimCard", import("..CatterySettlementCard"))
local var1 = 1

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0.emptyTF = findTF(arg0._tf, "empty")
	arg0.commanderTF = findTF(arg0._tf, "commander")
	arg0.char = arg0.commanderTF:Find("mask/char")
	arg0.slider = arg0.commanderTF:Find("slider"):GetComponent(typeof(Slider))
	arg0.nameTxt = arg0.commanderTF:Find("name/Text"):GetComponent(typeof(Text))
	arg0.levelTxt = arg0.commanderTF:Find("name/level"):GetComponent(typeof(Text))
	arg0.expTxt = arg0.commanderTF:Find("exp"):GetComponent(typeof(Text))
	arg0.addition = arg0.commanderTF:Find("addition")
	arg0.additionTxt = arg0.addition:Find("Text"):GetComponent(typeof(Text))
	arg0.additionY = arg0.addition.localPosition.y
end

function var0.UpdateCommander(arg0)
	var0.super.UpdateCommander(arg0)

	arg0.additionTxt.text = arg0.exp .. "<size=40>EXP</size>"
end

function var0.Action(arg0, arg1)
	setActive(arg0.addition, false)

	if not arg0.commander or arg0.exp <= 0 then
		arg1()

		return
	end

	local var0 = {}

	arg0:InitAnim(var0)
	table.insert(var0, function(arg0)
		arg0:AdditionAnim(var1, arg0)
	end)
	parallelAsync(var0, arg1)
end

function var0.Clear(arg0)
	var0.super.Clear(arg0)

	if LeanTween.isTweening(go(arg0.addition)) then
		LeanTween.cancel(go(arg0.addition))
	end
end

function var0.LoadCommander(arg0, arg1)
	arg0:ReturnCommander()

	arg0.painting = arg1:getPainting()

	setCommanderPaintingPrefab(arg0.char, arg0.painting, "result1")
end

function var0.AdditionAnim(arg0, arg1, arg2)
	setActive(arg0.addition, true)

	local var0 = arg0.additionY

	LeanTween.value(go(arg0.addition), var0, var0 + 25, arg1):setOnUpdate(System.Action_float(function(arg0)
		arg0.addition.localPosition = Vector3(arg0.addition.localPosition.x, arg0, 0)
	end)):setOnComplete(System.Action(function()
		setActive(arg0.addition, false)
		arg2()

		arg0.addition.localPosition = Vector3(arg0.addition.localPosition.x, var0, 0)
	end))
end

function var0.GetColor(arg0)
	return "#ffffff"
end

return var0
