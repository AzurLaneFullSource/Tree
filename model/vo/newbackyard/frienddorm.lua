local var0_0 = class("FriendDorm", import(".Dorm"))

function var0_0.GetName(arg0_1)
	if getProxy(PlayerProxy):getRawData():ShouldCheckCustomName() then
		return i18n("nodisplay_player_home_name")
	else
		return var0_0.super.GetName(arg0_1)
	end
end

function var0_0.GetShips(arg0_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.shipIds) do
		local var1_2 = Ship.New({
			energy = 100,
			id = iter1_2.id,
			configId = iter1_2.tid,
			skin_id = iter1_2.skin_id
		})

		var1_2.state = iter1_2.state

		var1_2:updateStateInfo34(0, 0)

		var0_2[var1_2.id] = var1_2
	end

	return var0_2
end

return var0_0
