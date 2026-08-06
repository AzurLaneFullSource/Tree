local var0_0 = class("IslandSeasonReviewPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandSeasonReviewPanel"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:Find("content")

	arg0_2.leftPanel = var0_2:Find("left")
	arg0_2.titleImg = arg0_2._tf:Find("content/left/Image"):GetComponent(typeof(Image))
	arg0_2.seasonNumImg = arg0_2._tf:Find("content/left/num"):GetComponent(typeof(Image))
	arg0_2.infoPanel = var0_2:Find("infos")
	arg0_2.emptyTF = var0_2:Find("empty")

	setText(arg0_2.emptyTF:Find("Text"), i18n("island_season_review_miss"))
	setText(arg0_2.infoPanel:Find("season/title/Text"), i18n("island_season_title"))
	setText(arg0_2.infoPanel:Find("prod/title/Text"), i18n("island_season_review_produce"))
	setText(arg0_2.infoPanel:Find("relax/title/Text"), i18n("island_season_review_relax"))

	arg0_2.switchPanel = IslandSeasonSwitchPanel.New(arg0_2._tf)
	arg0_2.iconTF = arg0_2.infoPanel:Find("island/icon_mask/icon")
	arg0_2.infoTFs = {
		arg0_2.infoPanel:Find("island/list"),
		arg0_2.infoPanel:Find("season/list"),
		arg0_2.infoPanel:Find("prod/list"),
		arg0_2.infoPanel:Find("relax/list")
	}

	for iter0_2, iter1_2 in ipairs(arg0_2.infoTFs) do
		eachChild(iter1_2, function(arg0_3)
			setText(arg0_3:Find("name"), IslandSeasonReview.KEY2NAME[tonumber(arg0_3.name)])
		end)
	end
end

function var0_0.OnInit(arg0_4)
	arg0_4.newestId = IslandSeasonAgency.GetCurrentSeason() - 1
	arg0_4.rankType = PowerRank.TYPE_ISLAND_SEASON_PT
	arg0_4.playerRankVOs = {}
end

function var0_0.Show(arg0_5)
	arg0_5.super.Show(arg0_5)
	arg0_5:Flush(arg0_5.newestId)
	IslandSeasonRedDotHelper.UpdateEnterReview()
	arg0_5:emit(IslandSeasonPage.UPDATE_REDDOT, IslandSeasonPage.PAGE_REVIEW)
end

function var0_0.Hide(arg0_6)
	var0_0.super.Hide(arg0_6)
	arg0_6.switchPanel:ExecuteAction("Hide")
end

function var0_0.Flush(arg0_7, arg1_7)
	local var0_7 = getProxy(IslandProxy):GetIsland():GetSeasonAgency():GetReviewData(arg1_7)

	setActive(arg0_7.emptyTF, not var0_7)
	setActive(arg0_7.infoPanel, var0_7)

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

	arg0_7.switchPanel:ExecuteAction("Show", arg1_7, function(arg0_9)
		arg0_7:Flush(arg0_9)
	end)

	arg0_7.titleImg.sprite = GetSpriteFromAtlas("ui/IslandSeasonTheme" .. arg1_7 .. "_atlas", "title")
	arg0_7.seasonNumImg.sprite = GetSpriteFromAtlas("ui/IslandSeasonTheme" .. arg1_7 .. "_atlas", "num")
end

function var0_0.UpdateRankVOs(arg0_10, arg1_10, arg2_10, arg3_10)
	arg0_10.playerRankVOs[arg1_10] = arg3_10
end

function var0_0.UpdataIcon(arg0_11)
	if arg0_11.playerRankVOs[arg0_11.seasonId] then
		-- block empty
	end
end

function var0_0.OnDestroy(arg0_12)
	if arg0_12.switchPanel then
		arg0_12.switchPanel:Destroy()

		arg0_12.switchPanel = nil
	end
end

return var0_0
