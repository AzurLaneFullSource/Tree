local var0 = class("VoteShip", import("..BaseVO"))

function var0.Ctor(arg0, arg1, arg2)
	arg0.voteId = arg2
	arg0.group = arg1.key
	arg0.totalVotes = arg1.value1
	arg0.votes = arg1.value2
	arg0.netVotes = arg1.value3
	arg0.configId = arg0:GenConfigId(arg0.group)

	assert(arg0.configId)
end

function var0.GenConfigId(arg0, arg1)
	for iter0 = 4, 1, -1 do
		local var0 = tonumber(arg1 .. iter0)

		if pg.ship_data_statistics[var0] then
			return var0
		end
	end
end

function var0.bindConfigTable(arg0)
	return pg.ship_data_statistics
end

function var0.getRarity(arg0)
	return arg0:getConfig("rarity")
end

function var0.getShipName(arg0)
	if arg0.group == 30507 then
		local var0, var1 = i18n("name_zhanliejahe")

		return var0
	end

	return arg0:getConfig("name")
end

function var0.getEnName(arg0)
	return arg0:getConfig("english_name")
end

function var0.getTeamType(arg0)
	return TeamType.GetTeamFromShipType(arg0:getShipType())
end

function var0.getPainting(arg0)
	local var0 = arg0:getConfig("skin_id")

	return pg.ship_skin_template[var0].painting
end

function var0.GetDesc(arg0)
	local var0 = arg0:getConfig("skin_id")

	return ShipWordHelper.RawGetWord(var0, ShipWordHelper.WORD_TYPE_PROFILE)
end

function var0.getShipType(arg0)
	if arg0:IsFunRace() then
		return ""
	else
		return (arg0:getConfig("type"))
	end
end

function var0.getShipTypeName(arg0)
	if arg0:IsFunRace() then
		return ""
	else
		local var0 = arg0:getConfig("type")

		return pg.ship_data_by_type[var0].type_name
	end
end

function var0.IsFunRace(arg0)
	return pg.activity_vote[arg0.voteId].type == VoteConst.RACE_TYPE_FUN
end

function var0.getNationality(arg0)
	if arg0:IsFunRace() then
		return nil
	else
		return arg0:getConfig("nationality")
	end
end

function var0.getNation(arg0)
	return arg0:getNationality()
end

function var0.IsMatchSearchKey(arg0, arg1)
	if not arg1 or arg1 == "" then
		return true
	end

	arg1 = string.lower(string.gsub(arg1, "%.", "%%."))

	return string.find(string.lower(arg0:getShipName()), arg1)
end

function var0.UpdateVoteCnt(arg0, arg1)
	arg0.votes = arg0.votes + arg1
end

function var0.getScore(arg0)
	return arg0.votes
end

function var0.GetTotalScore(arg0)
	return arg0.totalVotes
end

function var0.isSamaGroup(arg0, arg1)
	return arg0.group == arg1
end

function var0.GetGameVotes(arg0)
	if arg0.votes >= 100000 then
		return math.floor(arg0.votes / 1000) .. "K"
	else
		return arg0.votes
	end
end

function var0.getTotalVotes(arg0)
	if arg0.totalVotes >= 100000 then
		return math.floor(arg0.totalVotes / 1000) .. "K"
	else
		return arg0.totalVotes
	end
end

return var0
