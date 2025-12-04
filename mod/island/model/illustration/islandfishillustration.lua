local var0_0 = class("IslandFishIllustration", import(".IslandIllustration"))

var0_0.MIN_CUP_KEY = 1
var0_0.MAX_CUP_KEY = 2

function var0_0.InitConfigData(arg0_1)
	arg0_1.minCupPoint, arg0_1.maxCupPoint = 0, 0

	for iter0_1, iter1_1 in ipairs(arg0_1:getConfig("collect_star")) do
		switch(iter1_1[1], {
			[var0_0.MIN_CUP_KEY] = function()
				arg0_1.minCupPoint = iter1_1[2]
			end,
			[var0_0.MAX_CUP_KEY] = function()
				arg0_1.maxCupPoint = iter1_1[2]
			end
		})
	end
end

function var0_0.GetReachPoints(arg0_4, arg1_4, arg2_4)
	local var0_4 = 0

	if arg1_4 then
		var0_4 = var0_4 + arg0_4.minCupPoint
	end

	if arg2_4 then
		var0_4 = var0_4 + arg0_4.maxCupPoint
	end

	return arg0_4.basePoint + var0_4
end

function var0_0.CheckTip(arg0_5)
	if arg0_5.status == var0_0.STATUS.CAN_UNLOCK then
		arg0_5.isTip = true

		return
	end

	local var0_5 = arg0_5:GetLinkConfigID()
	local var1_5 = getProxy(IslandProxy):GetIsland():GetFishingAgency():GetFish(var0_5)

	if not var1_5 then
		arg0_5.isTip = false

		return
	end

	arg0_5.isTip = arg0_5:GetReachPoints(var1_5:ReachMinCup(), var1_5:ReachMaxCup()) > arg0_5:GetPoints()
end

function var0_0.IsGotMinCup(arg0_6)
	return arg0_6.starPointGotData[var0_0.MIN_CUP_KEY]
end

function var0_0.IsGotMaxCup(arg0_7)
	return arg0_7.starPointGotData[var0_0.MAX_CUP_KEY]
end

return var0_0
