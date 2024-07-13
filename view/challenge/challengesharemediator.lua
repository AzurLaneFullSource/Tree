local var0_0 = class("ChallengeShareMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	local var0_1 = arg0_1.contextData.mode
	local var1_1 = getProxy(ChallengeProxy):getUserChallengeInfo(var0_1)

	arg0_1.viewComponent:setLevel(var1_1:getLevel())

	local var2_1 = {
		regularFleet = var1_1:getRegularFleet(),
		submarineFleet = var1_1:getSubmarineFleet()
	}
	local var3_1 = var2_1.regularFleet:getShipsByTeam(TeamType.Main, true)[1]

	arg0_1.viewComponent:setFlagShipPaint(var3_1:getPainting())

	local var4_1 = {}

	for iter0_1, iter1_1 in ipairs(var2_1.regularFleet:getShips(true)) do
		if iter1_1.id ~= var3_1.id then
			table.insert(var4_1, iter1_1:getPainting())
		end
	end

	for iter2_1, iter3_1 in ipairs(var2_1.submarineFleet:getShips(true)) do
		if iter3_1.id ~= var3_1.id then
			table.insert(var4_1, iter3_1:getPainting())
		end
	end

	arg0_1.viewComponent:setShipPaintList(var4_1)
end

return var0_0
