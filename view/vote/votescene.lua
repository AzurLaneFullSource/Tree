local var0_0 = class("VoteScene", import("..base.BaseUI"))

var0_0.ShipIndex = {
	typeIndex = ShipIndexConst.TypeAll,
	campIndex = ShipIndexConst.CampAll,
	rarityIndex = ShipIndexConst.RarityAll
}
var0_0.ShipIndexData = {
	customPanels = {
		typeIndex = {
			blueSeleted = true,
			mode = CustomIndexLayer.Mode.AND,
			options = ShipIndexConst.TypeIndexs,
			names = ShipIndexConst.TypeNames
		},
		campIndex = {
			blueSeleted = true,
			mode = CustomIndexLayer.Mode.AND,
			options = ShipIndexConst.CampIndexs,
			names = ShipIndexConst.CampNames
		},
		rarityIndex = {
			blueSeleted = true,
			mode = CustomIndexLayer.Mode.AND,
			options = ShipIndexConst.RarityIndexs,
			names = ShipIndexConst.RarityNames
		}
	},
	groupList = {
		{
			dropdown = false,
			titleTxt = "indexsort_index",
			titleENTxt = "indexsort_indexeng",
			tags = {
				"typeIndex"
			}
		},
		{
			dropdown = false,
			titleTxt = "indexsort_camp",
			titleENTxt = "indexsort_campeng",
			tags = {
				"campIndex"
			}
		},
		{
			dropdown = false,
			titleTxt = "indexsort_rarity",
			titleENTxt = "indexsort_rarityeng",
			tags = {
				"rarityIndex"
			}
		}
	}
}

function var0_0.getUIName(arg0_1)
	return "VoteUI"
end

function var0_0.LoadUIFromPool(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2.contextData.voteGroup
	local var1_2
	local var2_2 = var0_2:isFinalsRace() and "VoteUIForFinal" or var0_2:isResurrectionRace() and "VoteUIForResurrection" or var0_2:IsFunMetaRace() and "VoteUIForMeta" or var0_2:IsFunSireRace() and "VoteUIForSire" or var0_2:IsFunKidRace() and "VoteUIForKid" or "VoteUI"

	var0_0.super.LoadUIFromPool(arg0_2, var2_2, arg2_2)
end

function var0_0.init(arg0_3)
	arg0_3.title = arg0_3:findTF("main/right_panel/title/main"):GetComponent(typeof(Text))
	arg0_3.titleBg1 = arg0_3:findTF("main/right_panel/title/title_bg1")
	arg0_3.titleBg2 = arg0_3:findTF("main/right_panel/title/title_bg2")
	arg0_3.titleBg3 = arg0_3:findTF("main/right_panel/title/title_bg3")
	arg0_3.subTitle = arg0_3:findTF("main/right_panel/title/Text"):GetComponent(typeof(Text))
	arg0_3.tagtimeTF = arg0_3:findTF("main/right_panel/title/main/sub"):GetComponent(typeof(Text))
	arg0_3.backBtn = arg0_3:findTF("blur_panel/adapt/top/back_btn")
	arg0_3.helpBtn = arg0_3:findTF("main/right_panel/title/help")
	arg0_3.filterBtn = arg0_3:findTF("main/right_panel/filter_bg/filter_btn")
	arg0_3.filterSel = arg0_3:findTF("main/right_panel/filter_bg/filter_btn/Image")
	arg0_3.scheduleBtn = arg0_3:findTF("main/right_panel/title/schedule")
	arg0_3.awardBtn = arg0_3:findTF("main/right_panel/filter_bg/award_btn")
	arg0_3.ticketBtn = arg0_3:findTF("main/right_panel/filter_bg/ticket")
	arg0_3.numberTxt = arg0_3:findTF("main/right_panel/filter_bg/Text"):GetComponent(typeof(Text))
	arg0_3.search = arg0_3:findTF("main/right_panel/filter_bg/search")

	setText(arg0_3:findTF("main/right_panel/filter_bg/search/hold"), i18n("dockyard_search_holder"))
end

function var0_0.GetPageMap(arg0_4)
	return {
		[VoteConst.RACE_TYPE_PRE] = {
			VotePreRaceShipPage,
			VotePreRaceRankPage
		},
		[VoteConst.RACE_TYPE_GROUP] = {
			VoteGroupRaceShipPage,
			VoteGroupRaceRankPage
		},
		[VoteConst.RACE_TYPE_RESURGENCE] = {
			VoteGroupRaceShipPage,
			VoteGroupRaceRankPage
		},
		[VoteConst.RACE_TYPE_FINAL] = {
			VoteFinalsRaceShipsPage,
			VoteFinalsRaceRankPage
		},
		[VoteConst.RACE_TYPE_PRE_RESURGENCE] = {
			VoteGroupRaceShipPage,
			VoteGroupRaceRankPage
		},
		[VoteConst.RACE_TYPE_FUN] = {
			FunRaceShipsPage,
			VoteFunRaceRankPage
		}
	}
end

function var0_0.didEnter(arg0_5)
	local var0_5 = arg0_5:GetPageMap()
	local var1_5 = arg0_5.contextData.voteGroup:getConfig("type")
	local var2_5 = var0_5[var1_5][1]
	local var3_5 = var0_5[var1_5][2]

	arg0_5.shipsPage = var2_5.New(arg0_5:findTF("main/right_panel"), arg0_5.event, arg0_5.contextData)

	arg0_5.shipsPage:SetCallBack(function(arg0_6, arg1_6)
		seriesAsync({
			function(arg0_7)
				arg0_5:CheckPaintingRes(arg0_6, arg0_7)
			end
		}, function()
			arg0_5:OnVote(arg0_6, arg1_6)
		end)
	end)

	arg0_5.rankPage = var3_5.New(arg0_5:findTF("main/left_panel"), arg0_5.event, arg0_5.contextData)
	arg0_5.voteMsgBox = VoteDiaplayPage.New(arg0_5._tf, arg0_5.event)
	arg0_5.awardWindowPage = VoteAwardWindowPage.New(arg0_5._tf, arg0_5.event)

	onButton(arg0_5, arg0_5.backBtn, function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.helpBtn, function()
		local var0_10 = arg0_5.contextData.voteGroup:getConfig("help_text")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var0_10].tip
		})
	end, SFX_PANEL)
	setActive(arg0_5.helpBtn, false)
	onButton(arg0_5, arg0_5.filterBtn, function()
		local var0_11 = Clone(var0_0.ShipIndexData)

		var0_11.indexDatas = Clone(var0_0.ShipIndex)

		function var0_11.callback(arg0_12)
			var0_0.ShipIndex.typeIndex = arg0_12.typeIndex
			var0_0.ShipIndex.rarityIndex = arg0_12.rarityIndex
			var0_0.ShipIndex.campIndex = arg0_12.campIndex

			arg0_5:initShips()
		end

		arg0_5:emit(VoteMediator.ON_FILTER, var0_11)
	end, SFX_PANEL)
	onInputEndEdit(arg0_5, arg0_5.search, function()
		arg0_5:initShips()
	end)
	onButton(arg0_5, arg0_5.scheduleBtn, function()
		arg0_5:emit(VoteMediator.ON_SCHEDULE)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.awardBtn, function()
		arg0_5.awardWindowPage:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.ticketBtn, function()
		arg0_5:emit(VoteMediator.OPEN_EXCHANGE)
	end)
	arg0_5:updateMainview()
	arg0_5:initTitles()
end

function var0_0.CheckPaintingRes(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg1_17.voteShip:getPainting()
	local var1_17 = {}

	for iter0_17, iter1_17 in ipairs({
		var0_17
	}) do
		PaintingGroupConst.AddPaintingNameWithFilteMap(var1_17, iter1_17)
	end

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var1_17,
		finishFunc = arg2_17
	})
end

function var0_0.OnVote(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg1_18.voteShip
	local var1_18 = arg0_18.contextData.voteGroup:GetRank(var0_18)
	local var2_18 = arg0_18:GetVotes()

	arg2_18 = defaultValue(arg2_18, false)

	arg0_18.voteMsgBox:ExecuteAction("Open", var0_18, var1_18, var2_18, arg2_18, function(arg0_19)
		if arg0_18.contextData.voteGroup:GetStage() ~= VoteGroup.VOTE_STAGE then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		if arg0_19 <= var2_18 then
			arg0_18:emit(VoteMediator.ON_VOTE, arg0_18.contextData.voteGroup.id, var0_18.group, arg0_19)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("vote_not_enough"))
		end
	end)
end

function var0_0.updateMainview(arg0_20)
	arg0_20:initShips()
	arg0_20:initRanks()
	arg0_20:updateNumber()
end

function var0_0.initRanks(arg0_21)
	arg0_21.rankPage:ExecuteAction("Update", arg0_21.contextData.voteGroup)
end

function var0_0.initShips(arg0_22)
	arg0_22.displays = {}

	local var0_22 = arg0_22.contextData.voteGroup:GetRankList()
	local var1_22 = getInputText(arg0_22.search)

	for iter0_22, iter1_22 in ipairs(var0_22) do
		if var0_0.ShipIndex.typeIndex == ShipIndexConst.TypeAll and var0_0.ShipIndex.rarityIndex == ShipIndexConst.RarityAll and var0_0.ShipIndex.campIndex == ShipIndexConst.CampAll and iter1_22:IsMatchSearchKey(var1_22) then
			table.insert(arg0_22.displays, iter1_22)
		else
			local var2_22 = iter1_22

			if ShipIndexConst.filterByType(var2_22, var0_0.ShipIndex.typeIndex) and ShipIndexConst.filterByRarity(var2_22, var0_0.ShipIndex.rarityIndex) and ShipIndexConst.filterByCamp(var2_22, var0_0.ShipIndex.campIndex) and iter1_22:IsMatchSearchKey(var1_22) then
				table.insert(arg0_22.displays, iter1_22)
			end
		end
	end

	local var3_22 = arg0_22:GetVotes()

	arg0_22.shipsPage:ExecuteAction("Update", arg0_22.contextData.voteGroup, arg0_22.displays, var3_22)
	setActive(arg0_22.filterSel, var0_0.ShipIndex.typeIndex ~= ShipIndexConst.TypeAll or var0_0.ShipIndex.campIndex ~= ShipIndexConst.CampAll or var0_0.ShipIndex.rarityIndex ~= ShipIndexConst.RarityAll)
end

function var0_0.initTitles(arg0_23)
	arg0_23.tagtimeTF.text = arg0_23.contextData.voteGroup:getTimeDesc()

	if not arg0_23.contextData.voteGroup:isFinalsRace() then
		arg0_23.title.text = arg0_23.contextData.voteGroup:getConfig("name")
	end

	arg0_23.subTitle.text = arg0_23.contextData.voteGroup:getConfig("desc")
end

function var0_0.updateNumber(arg0_24)
	arg0_24.numberTxt.text = "X" .. arg0_24:GetVotes()
end

function var0_0.GetVotes(arg0_25)
	return (getProxy(VoteProxy):GetVotesByConfigId(arg0_25.contextData.voteGroup.configId))
end

function var0_0.onBackPressed(arg0_26)
	if arg0_26.voteMsgBox and arg0_26.voteMsgBox:GetLoaded() and arg0_26.voteMsgBox:isShowing() then
		arg0_26.voteMsgBox:Close()

		return
	end

	if arg0_26.awardWindowPage and arg0_26.awardWindowPage:GetLoaded() and arg0_26.awardWindowPage:isShowing() then
		arg0_26.awardWindowPage:Hide()

		return
	end

	arg0_26:emit(var0_0.ON_BACK_PRESSED)
end

function var0_0.willExit(arg0_27)
	if arg0_27.rankPage then
		arg0_27.rankPage:Destroy()

		arg0_27.rankPage = nil
	end

	if arg0_27.shipsPage then
		arg0_27.shipsPage:Destroy()

		arg0_27.shipsPage = nil
	end

	if arg0_27.voteMsgBox then
		arg0_27.voteMsgBox:Destroy()

		arg0_27.voteMsgBox = nil
	end

	if arg0_27.awardWindowPage then
		arg0_27.awardWindowPage:Destroy()

		arg0_27.awardWindowPage = nil
	end
end

return var0_0
