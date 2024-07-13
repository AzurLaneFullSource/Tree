local var0_0 = class("CatteryAnimCard", import("..CatterySettlementCard"))
local var1_0 = 1

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.emptyTF = findTF(arg0_1._tf, "empty")
	arg0_1.commanderTF = findTF(arg0_1._tf, "commander")
	arg0_1.char = arg0_1.commanderTF:Find("mask/char")
	arg0_1.slider = arg0_1.commanderTF:Find("slider"):GetComponent(typeof(Slider))
	arg0_1.nameTxt = arg0_1.commanderTF:Find("name/Text"):GetComponent(typeof(Text))
	arg0_1.levelTxt = arg0_1.commanderTF:Find("name/level"):GetComponent(typeof(Text))
	arg0_1.expTxt = arg0_1.commanderTF:Find("exp"):GetComponent(typeof(Text))
	arg0_1.addition = arg0_1.commanderTF:Find("addition")
	arg0_1.additionTxt = arg0_1.addition:Find("Text"):GetComponent(typeof(Text))
	arg0_1.additionY = arg0_1.addition.localPosition.y
end

function var0_0.UpdateCommander(arg0_2)
	var0_0.super.UpdateCommander(arg0_2)

	arg0_2.additionTxt.text = arg0_2.exp .. "<size=40>EXP</size>"
end

function var0_0.Action(arg0_3, arg1_3)
	setActive(arg0_3.addition, false)

	if not arg0_3.commander or arg0_3.exp <= 0 then
		arg1_3()

		return
	end

	local var0_3 = {}

	arg0_3:InitAnim(var0_3)
	table.insert(var0_3, function(arg0_4)
		arg0_3:AdditionAnim(var1_0, arg0_4)
	end)
	parallelAsync(var0_3, arg1_3)
end

function var0_0.Clear(arg0_5)
	var0_0.super.Clear(arg0_5)

	if LeanTween.isTweening(go(arg0_5.addition)) then
		LeanTween.cancel(go(arg0_5.addition))
	end
end

function var0_0.LoadCommander(arg0_6, arg1_6)
	arg0_6:ReturnCommander()

	arg0_6.painting = arg1_6:getPainting()

	setCommanderPaintingPrefab(arg0_6.char, arg0_6.painting, "result1")
end

function var0_0.AdditionAnim(arg0_7, arg1_7, arg2_7)
	setActive(arg0_7.addition, true)

	local var0_7 = arg0_7.additionY

	LeanTween.value(go(arg0_7.addition), var0_7, var0_7 + 25, arg1_7):setOnUpdate(System.Action_float(function(arg0_8)
		arg0_7.addition.localPosition = Vector3(arg0_7.addition.localPosition.x, arg0_8, 0)
	end)):setOnComplete(System.Action(function()
		setActive(arg0_7.addition, false)
		arg2_7()

		arg0_7.addition.localPosition = Vector3(arg0_7.addition.localPosition.x, var0_7, 0)
	end))
end

function var0_0.GetColor(arg0_10)
	return "#ffffff"
end

return var0_0
