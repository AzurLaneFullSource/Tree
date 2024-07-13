local var0_0 = class("VirtualVoteShip", import(".VoteShip"))

function var0_0.GenConfigId(arg0_1, arg1_1)
	return arg1_1
end

function var0_0.bindConfigTable(arg0_2)
	return pg.activity_vote_virtual_ship_data
end

function var0_0.getRarity(arg0_3)
	return arg0_3:getConfig("rarity")
end

function var0_0.getShipName(arg0_4)
	return arg0_4:getConfig("name")
end

function var0_0.getEnName(arg0_5)
	return arg0_5:getConfig("english_name")
end

function var0_0.getTeamType(arg0_6)
	return TeamType.GetTeamFromShipType(arg0_6:getShipType())
end

function var0_0.getPainting(arg0_7)
	return arg0_7:getConfig("painting")
end

function var0_0.GetDesc(arg0_8)
	return arg0_8:getConfig("desc")
end

function var0_0.getShipType(arg0_9)
	return ""
end

function var0_0.getNationality(arg0_10)
	return nil
end

return var0_0
