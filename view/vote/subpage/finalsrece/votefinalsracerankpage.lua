local var0_0 = class("VoteFinalsRaceRankPage", import("..GroupRace.VoteGroupRaceRankPage"))

function var0_0.getUIName(arg0_1)
	return "FinalsRaceRank"
end

function var0_0.NewCard(arg0_2, arg1_2)
	local var0_2 = arg1_2.transform

	return {
		Update = function(arg0_3, arg1_3, arg2_3, arg3_3)
			setActive(var0_2:Find("1"), arg1_3 == 1)
			setActive(var0_2:Find("2"), arg1_3 == 2)
			setActive(var0_2:Find("3"), arg1_3 == 3)
			setText(var0_2:Find("number"), arg1_3)
			setText(var0_2:Find("name"), shortenString(arg0_3:getShipName(), 6))
			setText(var0_2:Find("Text"), arg2_3)
		end
	}
end

function var0_0.OnDestroy(arg0_4)
	return
end

return var0_0
