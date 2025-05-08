local var0_0 = class("SyncUnitInteraction", import(".SyncUnitMovable"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1:UpdateOwner(arg1_1.slots)
end

function var0_0.UpdateOwner(arg0_2, arg1_2)
	local var0_2 = getProxy(PlayerProxy):getPlayerId()

	arg0_2.owner = arg1_2 and #arg1_2 > 0 and arg1_2[1].owner_id or 0

	if arg0_2.owner == 0 then
		arg0_2.ownerType = SyncUnitMovable.OWNER_TYPE_NONE
	elseif arg0_2.owner == var0_2 then
		arg0_2.ownerType = SyncUnitMovable.OWNER_TYPE_CLIENT
	else
		arg0_2.ownerType = SyncUnitMovable.OWNER_TYPE_SERVER
	end
end

function var0_0.SetOwnerType(arg0_3, arg1_3)
	arg0_3.ownerType = arg1_3
end

function var0_0.GetStatus(arg0_4)
	return 0
end

return var0_0
