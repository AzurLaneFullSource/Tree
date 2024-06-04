local var0 = class("MainOverDueSkinSequence", import(".MainOverDueAttireSequence"))

function var0.Execute(arg0, arg1)
	local var0 = getProxy(ShipSkinProxy):getOverDueSkins()

	if #var0 > 0 then
		arg0:Display(SkinExpireDisplayPage, var0, arg1)
	else
		arg1()
	end
end

return var0
