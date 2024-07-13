local var0_0 = class("CattertAddHomeExpAndCommanderExpAnim", import(".CatteryAddHomeExpAnim"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.expSlider = findTF(arg0_1._tf, "home/slider"):GetComponent(typeof(Slider))
	arg0_1.levelTxt = findTF(arg0_1._tf, "home/level"):GetComponent(typeof(Text))
	arg0_1.expTxt = findTF(arg0_1._tf, "home/exp"):GetComponent(typeof(Text))
	arg0_1.addition = findTF(arg0_1._tf, "home/addition")
	arg0_1.additionExpTxt = arg0_1.addition:Find("Text"):GetComponent(typeof(Text))
	arg0_1.uilist = UIItemList.New(findTF(arg0_1._tf, "commanders"), findTF(arg0_1._tf, "commanders/tpl"))
	arg0_1.cards = {}

	arg0_1.uilist:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			arg0_1:UpdateCommander(arg2_2, arg0_1.displays[arg1_2 + 1])
		end
	end)

	arg0_1.animRiseH = arg0_1.addition.localPosition.y

	setActive(arg0_1._tf, false)
end

function var0_0.RefreshAward(arg0_3)
	return
end

function var0_0.Action(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4)
	arg0_4.commanderExps = arg1_4

	parallelAsync({
		function(arg0_5)
			var0_0.super.Action(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg0_5)
		end,
		function(arg0_6)
			arg0_4:InitCommanders()
			arg0_4:DoCommandersAnim(arg0_6)
		end
	}, arg5_4)
end

function var0_0.HideOrShowAddition(arg0_7, arg1_7)
	setActive(arg0_7.addition, arg1_7 > 0)
end

function var0_0.GetAwardOffset(arg0_8)
	return 473
end

function var0_0.InitCommanders(arg0_9)
	local var0_9 = getProxy(CommanderProxy):GetCommanderHome():GetCatteries()

	arg0_9.displays = {}

	for iter0_9, iter1_9 in pairs(var0_9) do
		table.insert(arg0_9.displays, iter1_9)
	end

	table.sort(arg0_9.displays, function(arg0_10, arg1_10)
		return arg0_10:GetCommanderId() > arg1_10:GetCommanderId()
	end)
	arg0_9.uilist:align(#arg0_9.displays)
end

function var0_0.DoCommandersAnim(arg0_11, arg1_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11.cards) do
		table.insert(var0_11, function(arg0_12)
			iter1_11:Action(arg0_12)
		end)
	end

	parallelAsync(var0_11, arg1_11)
end

function var0_0.UpdateCommander(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.cards[arg1_13]

	if not var0_13 then
		var0_13 = CatteryAnimCard.New(arg1_13)
		arg0_13.cards[arg1_13] = var0_13
	end

	local var1_13 = 0
	local var2_13 = _.detect(arg0_13.commanderExps, function(arg0_14)
		return arg0_14.id == arg2_13.id
	end)

	if var2_13 then
		var1_13 = var2_13.value
	end

	var0_13:Update(arg2_13, var1_13)
end

function var0_0.Clear(arg0_15)
	var0_0.super.Clear(arg0_15)

	for iter0_15, iter1_15 in pairs(arg0_15.cards) do
		iter1_15:Clear()
	end
end

function var0_0.Dispose(arg0_16)
	var0_0.super.Dispose(arg0_16)

	for iter0_16, iter1_16 in pairs(arg0_16.cards) do
		iter1_16:Dispose()
	end

	arg0_16.cards = nil
end

return var0_0
