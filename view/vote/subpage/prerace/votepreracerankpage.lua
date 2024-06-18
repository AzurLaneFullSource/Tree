local var0_0 = class("VotePreRaceRankPage", import("....base.BaseSubView"))

var0_0.RANK_DISPLAY_COUNT = 15

function var0_0.getUIName(arg0_1)
	return "PreRaceRank"
end

function var0_0.OnInit(arg0_2)
	arg0_2.uiitemlist = UIItemList.New(arg0_2:findTF("content"), arg0_2:findTF("content/tpl"))
	arg0_2.prevBtn = arg0_2:findTF("prev")
	arg0_2.nextBtn = arg0_2:findTF("next")
	arg0_2.tip = arg0_2:findTF("tip")
	arg0_2.title1 = arg0_2:findTF("stages/title1")
	arg0_2.title2 = arg0_2:findTF("stages/title2")
	arg0_2.rankTitle = arg0_2:findTF("titles/rank_title")

	onButton(arg0_2, arg0_2.nextBtn, function()
		local var0_3 = arg0_2.page + 1

		if var0_3 > arg0_2.maxPage then
			var0_3 = 1
		end

		arg0_2.page = var0_3

		arg0_2:initRank(arg0_2.page)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.prevBtn, function()
		local var0_4 = arg0_2.page - 1

		if var0_4 <= 0 then
			var0_4 = arg0_2.maxPage
		end

		arg0_2.page = var0_4

		arg0_2:initRank(arg0_2.page)
	end, SFX_PANEL)
	setText(arg0_2:findTF("titles/rank_title"), i18n("vote_label_rank"))
	setText(arg0_2:findTF("tip"), i18n("vote_label_rank_fresh_time_tip"))
end

function var0_0.initRank(arg0_5, arg1_5)
	local var0_5 = (arg1_5 - 1) * var0_0.RANK_DISPLAY_COUNT
	local var1_5 = arg0_5.voteShips

	arg0_5.uiitemlist:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = var0_5 + arg1_6 + 1
			local var1_6 = var1_5[var0_6]

			if var1_6 then
				arg0_5:UpdateShipInfo(arg2_6, var1_6:getShipName(), var0_6)
			end

			setActive(arg2_6, var1_6)
		end
	end)
	arg0_5.uiitemlist:align(var0_0.RANK_DISPLAY_COUNT)
	arg0_5:UpdateTitle()
end

function var0_0.UpdateShipInfo(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg0_7.voteGroup:GetRiseColor(arg3_7)

	setText(arg1_7:Find("Text"), setColorStr(shortenString(arg2_7, 9), var0_7))
	setText(arg1_7:Find("number"), setColorStr(arg3_7, var0_7))
end

function var0_0.UpdateTitle(arg0_8)
	local var0_8 = arg0_8.voteGroup:getConfig("next_round_number")

	setActive(arg0_8.rankTitle, true)
end

function var0_0.Update(arg0_9, arg1_9)
	arg0_9.voteGroup = arg1_9
	arg0_9.voteShips = arg1_9:getList()
	arg0_9.page = 1
	arg0_9.maxPage = math.ceil(#arg0_9.voteShips / var0_0.RANK_DISPLAY_COUNT)
	arg0_9.phase = arg1_9:GetStage()

	setActive(arg0_9.title1, arg0_9.phase == VoteGroup.VOTE_STAGE)
	setActive(arg0_9.title2, arg0_9.phase ~= VoteGroup.VOTE_STAGE)
	setActive(arg0_9.tip, arg0_9.phase == VoteGroup.VOTE_STAGE)
	arg0_9:UpdateTitle()
	arg0_9:initRank(arg0_9.page)
	arg0_9:Show()
end

function var0_0.OnDestroy(arg0_10)
	return
end

return var0_0
