local var0_0 = class("NewEducateRankLayer", import("view.newEducate.base.NewEducateBaseUI"))

var0_0.TYPE = {
	ATTR = PowerRank.TYPE_TB_ATTR_SUM,
	ENDLESS = PowerRank.TYPE_TB_ENDLESS_WAVE
}

function var0_0.getUIName(arg0_1)
	return "NewEducateRankUI"
end

function var0_0.init(arg0_2)
	local var0_2 = arg0_2._tf:Find("window")

	setText(var0_2:Find("tip"), i18n("child2_rank_refresh_tip"))

	local var1_2 = var0_2:Find("header")

	setText(var1_2:Find("rank"), i18n("child2_rank_header_rank"))
	setText(var1_2:Find("info"), i18n("child2_rank_header_info"))

	arg0_2.headerValueTF = var1_2:Find("value")
	arg0_2.toggleTFs = {}
	arg0_2.toggleTFs[var0_0.TYPE.ATTR] = var0_2:Find("toggles/attr")

	setText(var0_2:Find("toggles/attr/Text"), i18n("child2_rank_toggle_attr"))

	arg0_2.toggleTFs[var0_0.TYPE.ENDLESS] = var0_2:Find("toggles/endless")

	setText(var0_2:Find("toggles/endless/Text"), i18n("child2_rank_toggle_endless"))

	arg0_2.playerRankTF = var0_2:Find("player")
	arg0_2.rankRect = var0_2:Find("view/content"):GetComponent("LScrollRect")
end

function var0_0.didEnter(arg0_3)
	arg0_3:OverlayPanel(arg0_3._tf, {
		groupDelta = 1
	})
	onButton(arg0_3, arg0_3._tf:Find("mask"), function()
		arg0_3:closeView()
	end, SFX_PANEL)

	for iter0_3, iter1_3 in pairs(arg0_3.toggleTFs) do
		onToggle(arg0_3, iter1_3, function(arg0_5)
			if arg0_5 and (not arg0_3.curType or arg0_3.curType ~= iter0_3) then
				arg0_3.curType = iter0_3

				arg0_3:UpdateView()
			end

			local var0_5 = arg0_5 and "Anim_NewEducateRankUI_sel" or "Anim_NewEducateRankUI_sel2"

			quickPlayAnimation(iter1_3, var0_5)
		end, SFX_PANEL)
	end

	function arg0_3.rankRect.onInitItem(arg0_6)
		arg0_3:OnInitItem(arg0_6)
	end

	function arg0_3.rankRect.onUpdateItem(arg0_7, arg1_7)
		arg0_3:OnUpdateItem(arg0_7, arg1_7)
	end

	arg0_3.playerCard = NewEducateRankCard.New(arg0_3.playerRankTF, NewEducateRankCard.TYPE_SELF, arg0_3)

	arg0_3:InitData()
	triggerToggle(arg0_3.toggleTFs[var0_0.TYPE.ATTR], true)
	NewEducateGuideSequence.CheckGuide(arg0_3.__cname)
end

function var0_0.InitData(arg0_8)
	arg0_8.cards = {}
	arg0_8.rankVOs = {}
	arg0_8.playerRankVOs = {}
	arg0_8.charId = arg0_8.contextData.char.id
end

function var0_0.OnInitItem(arg0_9, arg1_9)
	local var0_9 = NewEducateRankCard.New(arg1_9, NewEducateRankCard.TYPE_OTHER, arg0_9)

	arg0_9.cards[arg1_9] = var0_9
end

function var0_0.OnUpdateItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.cards[arg2_10]

	if not var0_10 then
		arg0_10:OnInitItem(arg2_10)

		var0_10 = arg0_10.cards[arg2_10]
	end

	local var1_10 = arg0_10.displayRankVOs[arg1_10 + 1]

	var0_10:Update(var1_10, arg0_10.curType)
end

function var0_0.UpdateView(arg0_11)
	local var0_11 = arg0_11.curType == var0_0.TYPE.ATTR and i18n("child2_rank_header_attr") or i18n("child2_rank_header_wave")

	setText(arg0_11.headerValueTF, var0_11)

	if not arg0_11.rankVOs[arg0_11.curType] or getProxy(BillboardProxy):canFetch(arg0_11.curType, arg0_11.charId) then
		arg0_11:emit(NewEducateRankMediator.ON_GET_RANK, arg0_11.curType, arg0_11.charId)
	else
		arg0_11:UpdataRankList()
	end
end

function var0_0.UpdataRankList(arg0_12)
	arg0_12.displayRankVOs = {}

	local var0_12 = arg0_12.rankVOs[arg0_12.curType]

	for iter0_12, iter1_12 in ipairs(arg0_12.rankVOs[arg0_12.curType]) do
		table.insert(arg0_12.displayRankVOs, iter1_12)
	end

	arg0_12.rankRect:SetTotalCount(#arg0_12.displayRankVOs)

	local var1_12 = arg0_12.playerRankVOs[arg0_12.curType]

	setActive(arg0_12.playerRankTF, var1_12)

	if var1_12 then
		arg0_12.playerCard:Update(var1_12, arg0_12.curType)
	end
end

function var0_0.OnGetRankDone(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	arg0_13.rankVOs[arg1_13] = arg3_13
	arg0_13.playerRankVOs[arg1_13] = arg4_13

	arg0_13:UpdataRankList()
end

function var0_0.willExit(arg0_14)
	ClearLScrollrect(arg0_14.rankRect)

	for iter0_14, iter1_14 in ipairs(arg0_14.cards) do
		iter1_14:Dispose()
	end

	arg0_14.cards = nil

	arg0_14.playerCard:Dispose()
	arg0_14:UnOverlayPanel(arg0_14._tf)
end

return var0_0
