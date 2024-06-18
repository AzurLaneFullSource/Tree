local var0_0 = class("VoteShip", import("..BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.voteId = arg2_1
	arg0_1.group = arg1_1.key
	arg0_1.totalVotes = arg1_1.value1
	arg0_1.votes = arg1_1.value2
	arg0_1.netVotes = arg1_1.value3
	arg0_1.configId = arg0_1:GenConfigId(arg0_1.group)

	assert(arg0_1.configId)
end

function var0_0.GenConfigId(arg0_2, arg1_2)
	for iter0_2 = 4, 1, -1 do
		local var0_2 = tonumber(arg1_2 .. iter0_2)

		if pg.ship_data_statistics[var0_2] then
			return var0_2
		end
	end
end

function var0_0.bindConfigTable(arg0_3)
	return pg.ship_data_statistics
end

function var0_0.getRarity(arg0_4)
	return arg0_4:getConfig("rarity")
end

function var0_0.getShipName(arg0_5)
	if arg0_5.group == 30507 then
		local var0_5, var1_5 = i18n("name_zhanliejahe")

		return var0_5
	end

	return arg0_5:getConfig("name")
end

function var0_0.getEnName(arg0_6)
	return arg0_6:getConfig("english_name")
end

function var0_0.getTeamType(arg0_7)
	return TeamType.GetTeamFromShipType(arg0_7:getShipType())
end

function var0_0.getPainting(arg0_8)
	local var0_8 = arg0_8:getConfig("skin_id")

	return pg.ship_skin_template[var0_8].painting
end

function var0_0.GetDesc(arg0_9)
	local var0_9 = arg0_9:getConfig("skin_id")

	return ShipWordHelper.RawGetWord(var0_9, ShipWordHelper.WORD_TYPE_PROFILE)
end

function var0_0.getShipType(arg0_10)
	if arg0_10:IsFunRace() then
		return ""
	else
		return (arg0_10:getConfig("type"))
	end
end

function var0_0.getShipTypeName(arg0_11)
	if arg0_11:IsFunRace() then
		return ""
	else
		local var0_11 = arg0_11:getConfig("type")

		return pg.ship_data_by_type[var0_11].type_name
	end
end

function var0_0.IsFunRace(arg0_12)
	return pg.activity_vote[arg0_12.voteId].type == VoteConst.RACE_TYPE_FUN
end

function var0_0.getNationality(arg0_13)
	if arg0_13:IsFunRace() then
		return nil
	else
		return arg0_13:getConfig("nationality")
	end
end

function var0_0.getNation(arg0_14)
	return arg0_14:getNationality()
end

function var0_0.IsMatchSearchKey(arg0_15, arg1_15)
	if not arg1_15 or arg1_15 == "" then
		return true
	end

	arg1_15 = string.lower(string.gsub(arg1_15, "%.", "%%."))

	return string.find(string.lower(arg0_15:getShipName()), arg1_15)
end

function var0_0.UpdateVoteCnt(arg0_16, arg1_16)
	arg0_16.votes = arg0_16.votes + arg1_16
end

function var0_0.getScore(arg0_17)
	return arg0_17.votes
end

function var0_0.GetTotalScore(arg0_18)
	return arg0_18.totalVotes
end

function var0_0.isSamaGroup(arg0_19, arg1_19)
	return arg0_19.group == arg1_19
end

function var0_0.GetGameVotes(arg0_20)
	if arg0_20.votes >= 100000 then
		return math.floor(arg0_20.votes / 1000) .. "K"
	else
		return arg0_20.votes
	end
end

function var0_0.getTotalVotes(arg0_21)
	if arg0_21.totalVotes >= 100000 then
		return math.floor(arg0_21.totalVotes / 1000) .. "K"
	else
		return arg0_21.totalVotes
	end
end

return var0_0
