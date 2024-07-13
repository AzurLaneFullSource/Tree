local var0_0 = class("VoteGroupRaceRankPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "GroupRaceRank"
end

function var0_0.OnInit(arg0_2)
	arg0_2.cards = {}
	arg0_2.title1 = arg0_2:findTF("stages/title1")
	arg0_2.title2 = arg0_2:findTF("stages/title2")
	arg0_2.scrollRect = arg0_2:findTF("scrollrect"):GetComponent("LScrollRect")

	function arg0_2.scrollRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end

	setText(arg0_2:findTF("titles/rank_title"), i18n("vote_label_rank"))
	setText(arg0_2:findTF("titles/votes"), i18n("word_votes"))
	setText(arg0_2:findTF("tip"), i18n("vote_label_rank_fresh_time_tip"))
end

function var0_0.Update(arg0_5, arg1_5)
	arg0_5.voteGroup = arg1_5
	arg0_5.phase = arg1_5:GetStage()

	setActive(arg0_5.title1, arg0_5.phase == VoteGroup.VOTE_STAGE)
	setActive(arg0_5.title2, arg0_5.phase ~= VoteGroup.VOTE_STAGE)
	setActive(arg0_5:findTF("tip"), arg0_5.phase == VoteGroup.VOTE_STAGE)
	arg0_5:UpdateList()
end

function var0_0.UpdateList(arg0_6)
	arg0_6.displays = arg0_6.voteGroup:GetRankList()

	arg0_6.scrollRect:SetTotalCount(#arg0_6.displays)
end

function var0_0.OnInitItem(arg0_7, arg1_7)
	local var0_7 = arg0_7:NewCard(arg1_7)

	arg0_7.cards[arg1_7] = var0_7
end

function var0_0.OnUpdateItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.cards[arg2_8]
	local var1_8 = arg0_8.displays[arg1_8 + 1]
	local var2_8 = arg0_8.voteGroup:GetVotes(var1_8)
	local var3_8 = arg1_8 + 1
	local var4_8 = arg0_8.voteGroup:GetRiseColor(var3_8)

	var0_8.Update(var1_8, var3_8, var2_8, var4_8)
end

function var0_0.NewCard(arg0_9, arg1_9)
	local var0_9 = arg1_9.transform

	return {
		Update = function(arg0_10, arg1_10, arg2_10, arg3_10)
			setText(var0_9:Find("number"), setColorStr(arg1_10, arg3_10))
			setText(var0_9:Find("name"), setColorStr(shortenString(arg0_10:getShipName(), 6), arg3_10))
			setText(var0_9:Find("Text"), setColorStr(arg2_10, arg3_10))
		end
	}
end

function var0_0.OnDestroy(arg0_11)
	return
end

return var0_0
