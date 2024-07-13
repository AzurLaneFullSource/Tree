local var0_0 = class("GuildRankPage", import("...base.GuildBasePage"))

function var0_0.getTargetUI(arg0_1)
	return "GuildRankBluePage", "GuildRankRedPage"
end

local var1_0 = {
	"commit",
	"task",
	"battle"
}
local var2_0 = {
	i18n("guild_member_rank_title_donate"),
	i18n("guild_member_rank_title_finish_cnt"),
	i18n("guild_member_rank_title_join_cnt")
}

function var0_0.PageId2RankLabel(arg0_2)
	return var2_0[arg0_2]
end

function var0_0.GetRank(arg0_3, arg1_3)
	return arg0_3.ranks[arg1_3]
end

function var0_0.OnUpdateRankList(arg0_4, arg1_4, arg2_4)
	if arg2_4 and table.getCount(arg2_4) > 0 then
		arg0_4.ranks[arg1_4] = arg2_4

		if arg0_4.pageId == arg1_4 then
			arg0_4:SwitchPage(arg1_4)
		end
	end
end

function var0_0.OnLoaded(arg0_5)
	arg0_5.tabContainer = arg0_5:findTF("frame/bg/tab")
	arg0_5.ranTypeTF = arg0_5:findTF("frame/bg/week")
	arg0_5.closeBtn = arg0_5:findTF("frame/close")
	arg0_5.rankLabel = arg0_5:findTF("frame/bg/title/Text"):GetComponent(typeof(Text))
	arg0_5.scrollrect = arg0_5:findTF("frame/bg/scrollrect"):GetComponent("LScrollRect")

	function arg0_5.scrollrect.onUpdateItem(arg0_6, arg1_6)
		arg0_5:OnUpdateItem(arg0_6, arg1_6)
	end

	setActive(arg0_5.ranTypeTF:Find("month"), true)
	setActive(arg0_5.ranTypeTF:Find("total"), true)
end

function var0_0.OnInit(arg0_7)
	onButton(arg0_7, arg0_7._tf, function()
		arg0_7:Hide()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.closeBtn, function()
		arg0_7:Hide()
	end, SFX_PANEL)

	local function var0_7()
		if arg0_7.pageId then
			arg0_7:SwitchPage(arg0_7.pageId)
		end

		arg0_7.ranTypeTF:Find("month"):GetComponent(typeof(Image)).enabled = arg0_7.ranType == 0
		arg0_7.ranTypeTF:Find("total"):GetComponent(typeof(Image)).enabled = arg0_7.ranType == 2
		arg0_7.ranTypeTF:GetComponent(typeof(Image)).enabled = arg0_7.ranType == 1
	end

	arg0_7.ranType = 0

	onButton(arg0_7, arg0_7.ranTypeTF, function()
		arg0_7.ranType = (arg0_7.ranType + 1) % 3

		var0_7()
	end, SFX_PANEL)
	arg0_7:InitTags()
	var0_7()
end

function var0_0.InitTags(arg0_12)
	for iter0_12, iter1_12 in ipairs(var1_0) do
		local var0_12 = arg0_12.tabContainer:Find(iter1_12)

		onToggle(arg0_12, var0_12, function(arg0_13)
			if arg0_13 then
				arg0_12:SwitchPage(iter0_12)
			end
		end, SFX_PANEL)
	end
end

function var0_0.Flush(arg0_14, arg1_14)
	arg0_14.ranks = arg1_14

	pg.UIMgr.GetInstance():BlurPanel(arg0_14._tf)
	arg0_14:Show()
	arg0_14._tf:SetAsLastSibling()
	triggerToggle(arg0_14.tabContainer:Find("commit"), true)
end

function var0_0.SwitchPage(arg0_15, arg1_15)
	arg0_15.pageId = arg1_15

	arg0_15.scrollrect:SetTotalCount(0)

	local var0_15 = arg0_15:GetRank(arg1_15)

	if not var0_15 or getProxy(GuildProxy):ShouldRefreshRank(arg1_15) then
		arg0_15:emit(GuildMemberMediator.GET_RANK, arg1_15)
	else
		assert(var0_15)
		arg0_15:InitRank(var0_15)
	end

	arg0_15.rankLabel.text = var0_0.PageId2RankLabel(arg1_15)
end

function var0_0.InitRank(arg0_16, arg1_16)
	arg0_16.displays = {}

	for iter0_16, iter1_16 in pairs(arg1_16) do
		table.insert(arg0_16.displays, iter1_16)
	end

	table.sort(arg0_16.displays, function(arg0_17, arg1_17)
		return arg0_17:GetScore(arg0_16.ranType) > arg1_17:GetScore(arg0_16.ranType)
	end)
	arg0_16.scrollrect:SetTotalCount(#arg0_16.displays)
end

function var0_0.OnUpdateItem(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.displays[arg1_18 + 1]

	setText(tf(arg2_18):Find("number"), arg1_18 + 1)
	setText(tf(arg2_18):Find("name"), var0_18:GetName())
	setText(tf(arg2_18):Find("score"), var0_18:GetScore(arg0_18.ranType))
end

function var0_0.Hide(arg0_19)
	if arg0_19:isShowing() then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_19._tf, arg0_19._parentTf)
	end

	var0_0.super.Hide(arg0_19)
end

function var0_0.OnDestroy(arg0_20)
	arg0_20:Hide()
end

return var0_0
