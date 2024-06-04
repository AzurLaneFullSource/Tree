local var0 = class("VoteFinalsRaceShipsPageForRank", import(".VoteFinalsRaceShipsPage"))

function var0.getUIName(arg0)
	return "FinalsRaceShipsRank"
end

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	arg0.loadedPaintings = {}
end

function var0.UpdateTop3(arg0, arg1, arg2, arg3)
	arg0:ClearPaintings()
	var0.super.UpdateTop3(arg0, arg1, arg2, arg3)
	setText(arg0.num1TF:Find("Text"), i18n("vote_lable_ship_votes", arg1 and arg0.voteGroup:GetVotes(arg1) or 0))
end

function var0.LoadPainting(arg0, arg1, arg2)
	setPaintingPrefabAsync(arg1, arg2, "pifu", function()
		table.insert(arg0.loadedPaintings, {
			tr = arg1,
			painting = arg2
		})
	end)
end

function var0.ClearPaintings(arg0)
	for iter0, iter1 in ipairs(arg0.loadedPaintings) do
		local var0 = iter1.tr
		local var1 = iter1.painting

		retPaintingPrefab(var0, var1)
	end

	arg0.loadedPaintings = {}
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)
	arg0:ClearPaintings()
end

return var0
