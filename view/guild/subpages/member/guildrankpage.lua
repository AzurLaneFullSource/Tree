local var0 = class("GuildRankPage", import("...base.GuildBasePage"))

function var0.getTargetUI(arg0)
	return "GuildRankBluePage", "GuildRankRedPage"
end

local var1 = {
	"commit",
	"task",
	"battle"
}
local var2 = {
	i18n("guild_member_rank_title_donate"),
	i18n("guild_member_rank_title_finish_cnt"),
	i18n("guild_member_rank_title_join_cnt")
}

function var0.PageId2RankLabel(arg0)
	return var2[arg0]
end

function var0.GetRank(arg0, arg1)
	return arg0.ranks[arg1]
end

function var0.OnUpdateRankList(arg0, arg1, arg2)
	if arg2 and table.getCount(arg2) > 0 then
		arg0.ranks[arg1] = arg2

		if arg0.pageId == arg1 then
			arg0:SwitchPage(arg1)
		end
	end
end

function var0.OnLoaded(arg0)
	arg0.tabContainer = arg0:findTF("frame/bg/tab")
	arg0.ranTypeTF = arg0:findTF("frame/bg/week")
	arg0.closeBtn = arg0:findTF("frame/close")
	arg0.rankLabel = arg0:findTF("frame/bg/title/Text"):GetComponent(typeof(Text))
	arg0.scrollrect = arg0:findTF("frame/bg/scrollrect"):GetComponent("LScrollRect")

	function arg0.scrollrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	setActive(arg0.ranTypeTF:Find("month"), true)
	setActive(arg0.ranTypeTF:Find("total"), true)
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)

	local function var0()
		if arg0.pageId then
			arg0:SwitchPage(arg0.pageId)
		end

		arg0.ranTypeTF:Find("month"):GetComponent(typeof(Image)).enabled = arg0.ranType == 0
		arg0.ranTypeTF:Find("total"):GetComponent(typeof(Image)).enabled = arg0.ranType == 2
		arg0.ranTypeTF:GetComponent(typeof(Image)).enabled = arg0.ranType == 1
	end

	arg0.ranType = 0

	onButton(arg0, arg0.ranTypeTF, function()
		arg0.ranType = (arg0.ranType + 1) % 3

		var0()
	end, SFX_PANEL)
	arg0:InitTags()
	var0()
end

function var0.InitTags(arg0)
	for iter0, iter1 in ipairs(var1) do
		local var0 = arg0.tabContainer:Find(iter1)

		onToggle(arg0, var0, function(arg0)
			if arg0 then
				arg0:SwitchPage(iter0)
			end
		end, SFX_PANEL)
	end
end

function var0.Flush(arg0, arg1)
	arg0.ranks = arg1

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:Show()
	arg0._tf:SetAsLastSibling()
	triggerToggle(arg0.tabContainer:Find("commit"), true)
end

function var0.SwitchPage(arg0, arg1)
	arg0.pageId = arg1

	arg0.scrollrect:SetTotalCount(0)

	local var0 = arg0:GetRank(arg1)

	if not var0 or getProxy(GuildProxy):ShouldRefreshRank(arg1) then
		arg0:emit(GuildMemberMediator.GET_RANK, arg1)
	else
		assert(var0)
		arg0:InitRank(var0)
	end

	arg0.rankLabel.text = var0.PageId2RankLabel(arg1)
end

function var0.InitRank(arg0, arg1)
	arg0.displays = {}

	for iter0, iter1 in pairs(arg1) do
		table.insert(arg0.displays, iter1)
	end

	table.sort(arg0.displays, function(arg0, arg1)
		return arg0:GetScore(arg0.ranType) > arg1:GetScore(arg0.ranType)
	end)
	arg0.scrollrect:SetTotalCount(#arg0.displays)
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.displays[arg1 + 1]

	setText(tf(arg2):Find("number"), arg1 + 1)
	setText(tf(arg2):Find("name"), var0:GetName())
	setText(tf(arg2):Find("score"), var0:GetScore(arg0.ranType))
end

function var0.Hide(arg0)
	if arg0:isShowing() then
		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	end

	var0.super.Hide(arg0)
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
