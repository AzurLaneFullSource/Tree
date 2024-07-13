local var0_0 = class("CatteryOpAnimPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CatteryOPAnimUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.homeExpAnim = CatteryAddHomeExpAnim.New(arg0_2:findTF("bg/single"))
	arg0_2.homeAndCommanderAnim = CattertAddHomeExpAndCommanderExpAnim.New(arg0_2:findTF("bg/both"))
end

function var0_0.OnInit(arg0_3)
	return
end

function var0_0.AddPlan(arg0_4, arg1_4)
	arg0_4:RemoveTimer()
	arg0_4:Show()

	local var0_4, var1_4, var2_4, var3_4 = arg0_4:ParseData(arg1_4)
	local var4_4

	if #var0_4 > 0 then
		var4_4 = arg0_4.homeAndCommanderAnim
	else
		var4_4 = arg0_4.homeExpAnim
	end

	if arg0_4.player then
		arg0_4.player:Clear()

		if arg0_4.player ~= var4_4 then
			arg0_4.player:Hide()
		end
	end

	arg0_4.doAnim = true

	var4_4:Action(var0_4, var1_4, var2_4, var3_4, function()
		arg0_4.doAnim = false

		if arg0_4.exited then
			return
		end

		arg0_4.timer = Timer.New(function()
			var4_4:Hide()
			arg0_4:Hide()
		end, 0.5, 1)

		arg0_4.timer:Start()
	end)

	arg0_4.player = var4_4
end

function var0_0.ParseData(arg0_7, arg1_7)
	local var0_7 = false
	local var1_7 = false

	for iter0_7, iter1_7 in ipairs(arg1_7.awards) do
		if iter1_7.id == Item.COMMANDER_QUICKLY_TOOL_ID then
			var0_7 = true
		end

		if iter1_7.id == PlayerConst.ResDormMoney then
			var1_7 = true
		end
	end

	return arg1_7.commanderExps, arg1_7.homeExp, var0_7, var1_7
end

function var0_0.RemoveTimer(arg0_8)
	if arg0_8.timer then
		arg0_8.timer:Stop()

		arg0_8.timer = nil
	end
end

function var0_0.OnDestroy(arg0_9)
	arg0_9:RemoveTimer()

	arg0_9.doAnim = nil

	arg0_9.homeExpAnim:Dispose()
	arg0_9.homeAndCommanderAnim:Dispose()

	arg0_9.exited = true
end

return var0_0
