local var0_0 = class("AuctionGameMainSettlementMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	local var0_1 = getProxy(ContextProxy):getContextByMediator(AuctionGameMainMediator)

	if var0_1 then
		getProxy(ContextProxy):RemoveContext(var0_1)
	end
end

function var0_0.remove(arg0_2)
	return
end

return var0_0
