local var0 = class("CattertAddHomeExpAndCommanderExpAnim", import(".CatteryAddHomeExpAnim"))

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0.expSlider = findTF(arg0._tf, "home/slider"):GetComponent(typeof(Slider))
	arg0.levelTxt = findTF(arg0._tf, "home/level"):GetComponent(typeof(Text))
	arg0.expTxt = findTF(arg0._tf, "home/exp"):GetComponent(typeof(Text))
	arg0.addition = findTF(arg0._tf, "home/addition")
	arg0.additionExpTxt = arg0.addition:Find("Text"):GetComponent(typeof(Text))
	arg0.uilist = UIItemList.New(findTF(arg0._tf, "commanders"), findTF(arg0._tf, "commanders/tpl"))
	arg0.cards = {}

	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateCommander(arg2, arg0.displays[arg1 + 1])
		end
	end)

	arg0.animRiseH = arg0.addition.localPosition.y

	setActive(arg0._tf, false)
end

function var0.RefreshAward(arg0)
	return
end

function var0.Action(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0.commanderExps = arg1

	parallelAsync({
		function(arg0)
			var0.super.Action(arg0, arg1, arg2, arg3, arg4, arg0)
		end,
		function(arg0)
			arg0:InitCommanders()
			arg0:DoCommandersAnim(arg0)
		end
	}, arg5)
end

function var0.HideOrShowAddition(arg0, arg1)
	setActive(arg0.addition, arg1 > 0)
end

function var0.GetAwardOffset(arg0)
	return 473
end

function var0.InitCommanders(arg0)
	local var0 = getProxy(CommanderProxy):GetCommanderHome():GetCatteries()

	arg0.displays = {}

	for iter0, iter1 in pairs(var0) do
		table.insert(arg0.displays, iter1)
	end

	table.sort(arg0.displays, function(arg0, arg1)
		return arg0:GetCommanderId() > arg1:GetCommanderId()
	end)
	arg0.uilist:align(#arg0.displays)
end

function var0.DoCommandersAnim(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.cards) do
		table.insert(var0, function(arg0)
			iter1:Action(arg0)
		end)
	end

	parallelAsync(var0, arg1)
end

function var0.UpdateCommander(arg0, arg1, arg2)
	local var0 = arg0.cards[arg1]

	if not var0 then
		var0 = CatteryAnimCard.New(arg1)
		arg0.cards[arg1] = var0
	end

	local var1 = 0
	local var2 = _.detect(arg0.commanderExps, function(arg0)
		return arg0.id == arg2.id
	end)

	if var2 then
		var1 = var2.value
	end

	var0:Update(arg2, var1)
end

function var0.Clear(arg0)
	var0.super.Clear(arg0)

	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Clear()
	end
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)

	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end

	arg0.cards = nil
end

return var0
