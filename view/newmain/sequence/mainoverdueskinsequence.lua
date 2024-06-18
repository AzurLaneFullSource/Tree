local var0_0 = class("MainOverDueSkinSequence", import(".MainOverDueAttireSequence"))

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = getProxy(ShipSkinProxy):getOverDueSkins()

	if #var0_1 > 0 then
		arg0_1:Display(SkinExpireDisplayPage, var0_1, arg1_1)
	else
		arg1_1()
	end
end

return var0_0
