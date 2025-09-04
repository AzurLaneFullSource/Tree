local var0_0 = class("IslandFriendList4GuildPage", import(".IslandFriendListPage"))

function var0_0.GetData(arg0_1, arg1_1)
	local var0_1 = getProxy(GuildProxy):getRawData()
	local var1_1 = var0_1 and var0_1:getSortMemberWithoutSelf() or {}

	if #var1_1 <= 0 then
		return arg1_1({})
	end

	local var2_1 = {}

	for iter0_1, iter1_1 in pairs(var1_1) do
		table.insert(var2_1, iter1_1.id)
	end

	arg0_1:emit(IslandMediator.GET_GIFT_TAG, var2_1, function()
		arg1_1(var1_1)
	end)
end

return var0_0
