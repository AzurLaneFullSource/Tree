local var0 = class("CatteryOpAnimPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "CatteryOPAnimUI"
end

function var0.OnLoaded(arg0)
	arg0.homeExpAnim = CatteryAddHomeExpAnim.New(arg0:findTF("bg/single"))
	arg0.homeAndCommanderAnim = CattertAddHomeExpAndCommanderExpAnim.New(arg0:findTF("bg/both"))
end

function var0.OnInit(arg0)
	return
end

function var0.AddPlan(arg0, arg1)
	arg0:RemoveTimer()
	arg0:Show()

	local var0, var1, var2, var3 = arg0:ParseData(arg1)
	local var4

	if #var0 > 0 then
		var4 = arg0.homeAndCommanderAnim
	else
		var4 = arg0.homeExpAnim
	end

	if arg0.player then
		arg0.player:Clear()

		if arg0.player ~= var4 then
			arg0.player:Hide()
		end
	end

	arg0.doAnim = true

	var4:Action(var0, var1, var2, var3, function()
		arg0.doAnim = false

		if arg0.exited then
			return
		end

		arg0.timer = Timer.New(function()
			var4:Hide()
			arg0:Hide()
		end, 0.5, 1)

		arg0.timer:Start()
	end)

	arg0.player = var4
end

function var0.ParseData(arg0, arg1)
	local var0 = false
	local var1 = false

	for iter0, iter1 in ipairs(arg1.awards) do
		if iter1.id == Item.COMMANDER_QUICKLY_TOOL_ID then
			var0 = true
		end

		if iter1.id == PlayerConst.ResDormMoney then
			var1 = true
		end
	end

	return arg1.commanderExps, arg1.homeExp, var0, var1
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.OnDestroy(arg0)
	arg0:RemoveTimer()

	arg0.doAnim = nil

	arg0.homeExpAnim:Dispose()
	arg0.homeAndCommanderAnim:Dispose()

	arg0.exited = true
end

return var0
