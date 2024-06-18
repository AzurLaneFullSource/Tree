local var0_0 = class("VoteFinalsRaceShipsPageForRank", import(".VoteFinalsRaceShipsPage"))

function var0_0.getUIName(arg0_1)
	return "FinalsRaceShipsRank"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.loadedPaintings = {}
end

function var0_0.UpdateTop3(arg0_3, arg1_3, arg2_3, arg3_3)
	arg0_3:ClearPaintings()
	var0_0.super.UpdateTop3(arg0_3, arg1_3, arg2_3, arg3_3)
	setText(arg0_3.num1TF:Find("Text"), i18n("vote_lable_ship_votes", arg1_3 and arg0_3.voteGroup:GetVotes(arg1_3) or 0))
end

function var0_0.LoadPainting(arg0_4, arg1_4, arg2_4)
	setPaintingPrefabAsync(arg1_4, arg2_4, "pifu", function()
		table.insert(arg0_4.loadedPaintings, {
			tr = arg1_4,
			painting = arg2_4
		})
	end)
end

function var0_0.ClearPaintings(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.loadedPaintings) do
		local var0_6 = iter1_6.tr
		local var1_6 = iter1_6.painting

		retPaintingPrefab(var0_6, var1_6)
	end

	arg0_6.loadedPaintings = {}
end

function var0_0.OnDestroy(arg0_7)
	var0_0.super.OnDestroy(arg0_7)
	arg0_7:ClearPaintings()
end

return var0_0
