local var0 = class("FriendDorm", import(".Dorm"))

function var0.GetName(arg0)
	if getProxy(PlayerProxy):getRawData():ShouldCheckCustomName() then
		return i18n("nodisplay_player_home_name")
	else
		return var0.super.GetName(arg0)
	end
end

function var0.GetShips(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.shipIds) do
		local var1 = Ship.New({
			energy = 100,
			id = iter1.id,
			configId = iter1.tid,
			skin_id = iter1.skin_id
		})

		var1.state = iter1.state

		var1:updateStateInfo34(0, 0)

		var0[var1.id] = var1
	end

	return var0
end

return var0
