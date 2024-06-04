local var0 = class("ChallengeShareMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	local var0 = arg0.contextData.mode
	local var1 = getProxy(ChallengeProxy):getUserChallengeInfo(var0)

	arg0.viewComponent:setLevel(var1:getLevel())

	local var2 = {
		regularFleet = var1:getRegularFleet(),
		submarineFleet = var1:getSubmarineFleet()
	}
	local var3 = var2.regularFleet:getShipsByTeam(TeamType.Main, true)[1]

	arg0.viewComponent:setFlagShipPaint(var3:getPainting())

	local var4 = {}

	for iter0, iter1 in ipairs(var2.regularFleet:getShips(true)) do
		if iter1.id ~= var3.id then
			table.insert(var4, iter1:getPainting())
		end
	end

	for iter2, iter3 in ipairs(var2.submarineFleet:getShips(true)) do
		if iter3.id ~= var3.id then
			table.insert(var4, iter3:getPainting())
		end
	end

	arg0.viewComponent:setShipPaintList(var4)
end

return var0
