local var0_0 = class("IslandSeasonReviewPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandSeasonReviewPanel"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:Find("content")

	setText(var0_2:Find("infos/left/Text"), i18n("island_first_season"))

	arg0_2.contentTF = var0_2:Find("infos")
	arg0_2.emptyTF = var0_2:Find("empty")

	setText(arg0_2.emptyTF, i18n("island_season_review_miss"))
	setText(arg0_2.contentTF:Find("season/title/Text"), i18n("island_season_title"))
	setText(arg0_2.contentTF:Find("prod/title/Text"), i18n("island_season_review_produce"))
	setText(arg0_2.contentTF:Find("relax/title/Text"), i18n("island_season_review_relax"))

	arg0_2.iconTF = arg0_2.contentTF:Find("island/icon_mask/icon")
	arg0_2.infoTFs = {
		arg0_2.contentTF:Find("island/list"),
		arg0_2.contentTF:Find("season/list"),
		arg0_2.contentTF:Find("prod/list"),
		arg0_2.contentTF:Find("relax/list")
	}

	for iter0_2, iter1_2 in ipairs(arg0_2.infoTFs) do
		eachChild(iter1_2, function(arg0_3)
			setText(arg0_3:Find("name"), IslandSeasonReview.KEY2NAME[tonumber(arg0_3.name)])
		end)
	end
end

function var0_0.OnInit(arg0_4)
	arg0_4.newestId = IslandSeasonAgency.GetCurrentSeason() - 1
	arg0_4.switchPanel = IslandSeasonSwitchPanel.New(arg0_4._tf, arg0_4.event, setmetatable({
		count = arg0_4.newestId,
		onSelected = function(arg0_5)
			arg0_4:Flush(arg0_5)
		end,
		defaultSelId = arg0_4.newestId
	}, {
		__index = arg0_4.contextData
	}))
	arg0_4.rankType = PowerRank.TYPE_ISLAND_SEASON_PT
	arg0_4.playerRankVOs = {}
end

function var0_0.Show(arg0_6)
	arg0_6.super.Show(arg0_6)
	arg0_6.switchPanel:ExecuteAction("Show")
end

function var0_0.Flush(arg0_7, arg1_7)
	local var0_7 = getProxy(IslandProxy):GetIsland():GetSeasonAgency():GetReviewData(arg1_7)

	setActive(arg0_7.emptyTF, not var0_7)
	setActive(arg0_7.contentTF, var0_7)

	if var0_7 then
		for iter0_7, iter1_7 in ipairs(arg0_7.infoTFs) do
			eachChild(iter1_7, function(arg0_8)
				setText(arg0_8:Find("value"), var0_7:GetRecordData(tonumber(arg0_8.name)))
			end)
		end
	end

	arg0_7.seasonId = arg1_7

	if not arg0_7.playerRankVOs[arg1_7] or getProxy(BillboardProxy):canFetch(arg0_7.rankType, arg0_7.seasonId) then
		arg0_7:emit(IslandMediator.ON_GET_SEASON_RANK, arg0_7.rankType, arg0_7.seasonId)
	else
		arg0_7:UpdataIcon()
	end
end

function var0_0.UpdateRankVOs(arg0_9, arg1_9, arg2_9, arg3_9)
	arg0_9.playerRankVOs[arg1_9] = arg3_9
end

function var0_0.UpdataIcon(arg0_10)
	local var0_10 = arg0_10.playerRankVOs[arg0_10.seasonId]

	if var0_10 then
		local var1_10 = "squareicon/" .. pg.ship_skin_template[var0_10.skinId].prefab

		GetImageSpriteFromAtlasAsync(var1_10, "", arg0_10.iconTF)
	end
end

return var0_0
