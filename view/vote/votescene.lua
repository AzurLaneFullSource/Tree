local var0 = class("VoteScene", import("..base.BaseUI"))

var0.ShipIndex = {
	typeIndex = ShipIndexConst.TypeAll,
	campIndex = ShipIndexConst.CampAll,
	rarityIndex = ShipIndexConst.RarityAll
}
var0.ShipIndexData = {
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

function var0.getUIName(arg0)
	return "VoteUI"
end

function var0.LoadUIFromPool(arg0, arg1, arg2)
	local var0 = arg0.contextData.voteGroup
	local var1
	local var2 = var0:isFinalsRace() and "VoteUIForFinal" or var0:isResurrectionRace() and "VoteUIForResurrection" or var0:IsFunMetaRace() and "VoteUIForMeta" or var0:IsFunSireRace() and "VoteUIForSire" or var0:IsFunKidRace() and "VoteUIForKid" or "VoteUI"

	var0.super.LoadUIFromPool(arg0, var2, arg2)
end

function var0.init(arg0)
	arg0.title = arg0:findTF("main/right_panel/title/main"):GetComponent(typeof(Text))
	arg0.titleBg1 = arg0:findTF("main/right_panel/title/title_bg1")
	arg0.titleBg2 = arg0:findTF("main/right_panel/title/title_bg2")
	arg0.titleBg3 = arg0:findTF("main/right_panel/title/title_bg3")
	arg0.subTitle = arg0:findTF("main/right_panel/title/Text"):GetComponent(typeof(Text))
	arg0.tagtimeTF = arg0:findTF("main/right_panel/title/main/sub"):GetComponent(typeof(Text))
	arg0.backBtn = arg0:findTF("blur_panel/adapt/top/back_btn")
	arg0.helpBtn = arg0:findTF("main/right_panel/title/help")
	arg0.filterBtn = arg0:findTF("main/right_panel/filter_bg/filter_btn")
	arg0.filterSel = arg0:findTF("main/right_panel/filter_bg/filter_btn/Image")
	arg0.scheduleBtn = arg0:findTF("main/right_panel/title/schedule")
	arg0.awardBtn = arg0:findTF("main/right_panel/filter_bg/award_btn")
	arg0.ticketBtn = arg0:findTF("main/right_panel/filter_bg/ticket")
	arg0.numberTxt = arg0:findTF("main/right_panel/filter_bg/Text"):GetComponent(typeof(Text))
	arg0.search = arg0:findTF("main/right_panel/filter_bg/search")

	setText(arg0:findTF("main/right_panel/filter_bg/search/hold"), i18n("dockyard_search_holder"))
end

function var0.GetPageMap(arg0)
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

function var0.didEnter(arg0)
	local var0 = arg0:GetPageMap()
	local var1 = arg0.contextData.voteGroup:getConfig("type")
	local var2 = var0[var1][1]
	local var3 = var0[var1][2]

	arg0.shipsPage = var2.New(arg0:findTF("main/right_panel"), arg0.event, arg0.contextData)

	arg0.shipsPage:SetCallBack(function(arg0, arg1)
		seriesAsync({
			function(arg0)
				arg0:CheckPaintingRes(arg0, arg0)
			end
		}, function()
			arg0:OnVote(arg0, arg1)
		end)
	end)

	arg0.rankPage = var3.New(arg0:findTF("main/left_panel"), arg0.event, arg0.contextData)
	arg0.voteMsgBox = VoteDiaplayPage.New(arg0._tf, arg0.event)
	arg0.awardWindowPage = VoteAwardWindowPage.New(arg0._tf, arg0.event)

	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.helpBtn, function()
		local var0 = arg0.contextData.voteGroup:getConfig("help_text")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[var0].tip
		})
	end, SFX_PANEL)
	setActive(arg0.helpBtn, false)
	onButton(arg0, arg0.filterBtn, function()
		local var0 = Clone(var0.ShipIndexData)

		var0.indexDatas = Clone(var0.ShipIndex)

		function var0.callback(arg0)
			var0.ShipIndex.typeIndex = arg0.typeIndex
			var0.ShipIndex.rarityIndex = arg0.rarityIndex
			var0.ShipIndex.campIndex = arg0.campIndex

			arg0:initShips()
		end

		arg0:emit(VoteMediator.ON_FILTER, var0)
	end, SFX_PANEL)
	onInputEndEdit(arg0, arg0.search, function()
		arg0:initShips()
	end)
	onButton(arg0, arg0.scheduleBtn, function()
		arg0:emit(VoteMediator.ON_SCHEDULE)
	end, SFX_PANEL)
	onButton(arg0, arg0.awardBtn, function()
		arg0.awardWindowPage:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0, arg0.ticketBtn, function()
		arg0:emit(VoteMediator.OPEN_EXCHANGE)
	end)
	arg0:updateMainview()
	arg0:initTitles()
end

function var0.CheckPaintingRes(arg0, arg1, arg2)
	local var0 = arg1.voteShip:getPainting()
	local var1 = {}

	for iter0, iter1 in ipairs({
		var0
	}) do
		PaintingGroupConst.AddPaintingNameWithFilteMap(var1, iter1)
	end

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var1,
		finishFunc = arg2
	})
end

function var0.OnVote(arg0, arg1, arg2)
	local var0 = arg1.voteShip
	local var1 = arg0.contextData.voteGroup:GetRank(var0)
	local var2 = arg0:GetVotes()

	arg2 = defaultValue(arg2, false)

	arg0.voteMsgBox:ExecuteAction("Open", var0, var1, var2, arg2, function(arg0)
		if arg0.contextData.voteGroup:GetStage() ~= VoteGroup.VOTE_STAGE then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		if arg0 <= var2 then
			arg0:emit(VoteMediator.ON_VOTE, arg0.contextData.voteGroup.id, var0.group, arg0)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("vote_not_enough"))
		end
	end)
end

function var0.updateMainview(arg0)
	arg0:initShips()
	arg0:initRanks()
	arg0:updateNumber()
end

function var0.initRanks(arg0)
	arg0.rankPage:ExecuteAction("Update", arg0.contextData.voteGroup)
end

function var0.initShips(arg0)
	arg0.displays = {}

	local var0 = arg0.contextData.voteGroup:GetRankList()
	local var1 = getInputText(arg0.search)

	for iter0, iter1 in ipairs(var0) do
		if var0.ShipIndex.typeIndex == ShipIndexConst.TypeAll and var0.ShipIndex.rarityIndex == ShipIndexConst.RarityAll and var0.ShipIndex.campIndex == ShipIndexConst.CampAll and iter1:IsMatchSearchKey(var1) then
			table.insert(arg0.displays, iter1)
		else
			local var2 = iter1

			if ShipIndexConst.filterByType(var2, var0.ShipIndex.typeIndex) and ShipIndexConst.filterByRarity(var2, var0.ShipIndex.rarityIndex) and ShipIndexConst.filterByCamp(var2, var0.ShipIndex.campIndex) and iter1:IsMatchSearchKey(var1) then
				table.insert(arg0.displays, iter1)
			end
		end
	end

	local var3 = arg0:GetVotes()

	arg0.shipsPage:ExecuteAction("Update", arg0.contextData.voteGroup, arg0.displays, var3)
	setActive(arg0.filterSel, var0.ShipIndex.typeIndex ~= ShipIndexConst.TypeAll or var0.ShipIndex.campIndex ~= ShipIndexConst.CampAll or var0.ShipIndex.rarityIndex ~= ShipIndexConst.RarityAll)
end

function var0.initTitles(arg0)
	arg0.tagtimeTF.text = arg0.contextData.voteGroup:getTimeDesc()

	if not arg0.contextData.voteGroup:isFinalsRace() then
		arg0.title.text = arg0.contextData.voteGroup:getConfig("name")
	end

	arg0.subTitle.text = arg0.contextData.voteGroup:getConfig("desc")
end

function var0.updateNumber(arg0)
	arg0.numberTxt.text = "X" .. arg0:GetVotes()
end

function var0.GetVotes(arg0)
	return (getProxy(VoteProxy):GetVotesByConfigId(arg0.contextData.voteGroup.configId))
end

function var0.onBackPressed(arg0)
	if arg0.voteMsgBox and arg0.voteMsgBox:GetLoaded() and arg0.voteMsgBox:isShowing() then
		arg0.voteMsgBox:Close()

		return
	end

	if arg0.awardWindowPage and arg0.awardWindowPage:GetLoaded() and arg0.awardWindowPage:isShowing() then
		arg0.awardWindowPage:Hide()

		return
	end

	arg0:emit(var0.ON_BACK_PRESSED)
end

function var0.willExit(arg0)
	if arg0.rankPage then
		arg0.rankPage:Destroy()

		arg0.rankPage = nil
	end

	if arg0.shipsPage then
		arg0.shipsPage:Destroy()

		arg0.shipsPage = nil
	end

	if arg0.voteMsgBox then
		arg0.voteMsgBox:Destroy()

		arg0.voteMsgBox = nil
	end

	if arg0.awardWindowPage then
		arg0.awardWindowPage:Destroy()

		arg0.awardWindowPage = nil
	end
end

return var0
