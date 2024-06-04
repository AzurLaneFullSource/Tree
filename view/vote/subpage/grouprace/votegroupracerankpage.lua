local var0 = class("VoteGroupRaceRankPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "GroupRaceRank"
end

function var0.OnInit(arg0)
	arg0.cards = {}
	arg0.title1 = arg0:findTF("stages/title1")
	arg0.title2 = arg0:findTF("stages/title2")
	arg0.scrollRect = arg0:findTF("scrollrect"):GetComponent("LScrollRect")

	function arg0.scrollRect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scrollRect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	setText(arg0:findTF("titles/rank_title"), i18n("vote_label_rank"))
	setText(arg0:findTF("titles/votes"), i18n("word_votes"))
	setText(arg0:findTF("tip"), i18n("vote_label_rank_fresh_time_tip"))
end

function var0.Update(arg0, arg1)
	arg0.voteGroup = arg1
	arg0.phase = arg1:GetStage()

	setActive(arg0.title1, arg0.phase == VoteGroup.VOTE_STAGE)
	setActive(arg0.title2, arg0.phase ~= VoteGroup.VOTE_STAGE)
	setActive(arg0:findTF("tip"), arg0.phase == VoteGroup.VOTE_STAGE)
	arg0:UpdateList()
end

function var0.UpdateList(arg0)
	arg0.displays = arg0.voteGroup:GetRankList()

	arg0.scrollRect:SetTotalCount(#arg0.displays)
end

function var0.OnInitItem(arg0, arg1)
	local var0 = arg0:NewCard(arg1)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]
	local var1 = arg0.displays[arg1 + 1]
	local var2 = arg0.voteGroup:GetVotes(var1)
	local var3 = arg1 + 1
	local var4 = arg0.voteGroup:GetRiseColor(var3)

	var0.Update(var1, var3, var2, var4)
end

function var0.NewCard(arg0, arg1)
	local var0 = arg1.transform

	return {
		Update = function(arg0, arg1, arg2, arg3)
			setText(var0:Find("number"), setColorStr(arg1, arg3))
			setText(var0:Find("name"), setColorStr(shortenString(arg0:getShipName(), 6), arg3))
			setText(var0:Find("Text"), setColorStr(arg2, arg3))
		end
	}
end

function var0.OnDestroy(arg0)
	return
end

return var0
