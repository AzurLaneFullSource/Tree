local var0 = class("VirtualVoteShip", import(".VoteShip"))

function var0.GenConfigId(arg0, arg1)
	return arg1
end

function var0.bindConfigTable(arg0)
	return pg.activity_vote_virtual_ship_data
end

function var0.getRarity(arg0)
	return arg0:getConfig("rarity")
end

function var0.getShipName(arg0)
	return arg0:getConfig("name")
end

function var0.getEnName(arg0)
	return arg0:getConfig("english_name")
end

function var0.getTeamType(arg0)
	return TeamType.GetTeamFromShipType(arg0:getShipType())
end

function var0.getPainting(arg0)
	return arg0:getConfig("painting")
end

function var0.GetDesc(arg0)
	return arg0:getConfig("desc")
end

function var0.getShipType(arg0)
	return ""
end

function var0.getNationality(arg0)
	return nil
end

return var0
