local var0 = class("VoteFinalsRaceRankPage", import("..GroupRace.VoteGroupRaceRankPage"))

function var0.getUIName(arg0)
	return "FinalsRaceRank"
end

function var0.NewCard(arg0, arg1)
	local var0 = arg1.transform

	return {
		Update = function(arg0, arg1, arg2, arg3)
			setActive(var0:Find("1"), arg1 == 1)
			setActive(var0:Find("2"), arg1 == 2)
			setActive(var0:Find("3"), arg1 == 3)
			setText(var0:Find("number"), arg1)
			setText(var0:Find("name"), shortenString(arg0:getShipName(), 6))
			setText(var0:Find("Text"), arg2)
		end
	}
end

function var0.OnDestroy(arg0)
	return
end

return var0
