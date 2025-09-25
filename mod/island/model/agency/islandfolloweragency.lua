local var0_0 = class("IslandFollowerAgency", import(".IslandBaseAgency"))

var0_0.ADD_FOLLOWER = "IslandFollowerAgency:ADD_FOLLOWER"
var0_0.DEL_FOLLOWER = "IslandFollowerAgency:DEL_FOLLOWER"

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.followers = {}
end

function var0_0.InitPrivateData(arg0_2, arg1_2)
	for iter0_2, iter1_2 in ipairs(arg1_2.follow_ships) do
		table.insert(arg0_2.followers, iter1_2)
	end

	arg0_2.maxCnt = pg.island_set.max_follower_cnt.key_value_int
end

function var0_0.GetFollowers(arg0_3)
	return arg0_3.followers
end

function var0_0.AddFollower(arg0_4, arg1_4)
	if not arg0_4:Following(arg1_4) then
		table.insert(arg0_4.followers, arg1_4)
		arg0_4:DispatchEvent(IslandFollowerAgency.ADD_FOLLOWER, arg1_4)
	end
end

function var0_0.DelFollower(arg0_5, arg1_5)
	if arg0_5:Following(arg1_5) then
		table.removebyvalue(arg0_5.followers, arg1_5)
		arg0_5:DispatchEvent(IslandFollowerAgency.DEL_FOLLOWER, arg1_5)
	end
end

function var0_0.Following(arg0_6, arg1_6)
	return table.contains(arg0_6.followers, arg1_6)
end

function var0_0.ReachMaxCnt(arg0_7)
	return #arg0_7.followers >= arg0_7.maxCnt
end

return var0_0
