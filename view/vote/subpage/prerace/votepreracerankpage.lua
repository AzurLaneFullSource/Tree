local var0 = class("VotePreRaceRankPage", import("....base.BaseSubView"))

var0.RANK_DISPLAY_COUNT = 15

function var0.getUIName(arg0)
	return "PreRaceRank"
end

function var0.OnInit(arg0)
	arg0.uiitemlist = UIItemList.New(arg0:findTF("content"), arg0:findTF("content/tpl"))
	arg0.prevBtn = arg0:findTF("prev")
	arg0.nextBtn = arg0:findTF("next")
	arg0.tip = arg0:findTF("tip")
	arg0.title1 = arg0:findTF("stages/title1")
	arg0.title2 = arg0:findTF("stages/title2")
	arg0.rankTitle = arg0:findTF("titles/rank_title")

	onButton(arg0, arg0.nextBtn, function()
		local var0 = arg0.page + 1

		if var0 > arg0.maxPage then
			var0 = 1
		end

		arg0.page = var0

		arg0:initRank(arg0.page)
	end, SFX_PANEL)
	onButton(arg0, arg0.prevBtn, function()
		local var0 = arg0.page - 1

		if var0 <= 0 then
			var0 = arg0.maxPage
		end

		arg0.page = var0

		arg0:initRank(arg0.page)
	end, SFX_PANEL)
	setText(arg0:findTF("titles/rank_title"), i18n("vote_label_rank"))
	setText(arg0:findTF("tip"), i18n("vote_label_rank_fresh_time_tip"))
end

function var0.initRank(arg0, arg1)
	local var0 = (arg1 - 1) * var0.RANK_DISPLAY_COUNT
	local var1 = arg0.voteShips

	arg0.uiitemlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0 + arg1 + 1
			local var1 = var1[var0]

			if var1 then
				arg0:UpdateShipInfo(arg2, var1:getShipName(), var0)
			end

			setActive(arg2, var1)
		end
	end)
	arg0.uiitemlist:align(var0.RANK_DISPLAY_COUNT)
	arg0:UpdateTitle()
end

function var0.UpdateShipInfo(arg0, arg1, arg2, arg3)
	local var0 = arg0.voteGroup:GetRiseColor(arg3)

	setText(arg1:Find("Text"), setColorStr(shortenString(arg2, 9), var0))
	setText(arg1:Find("number"), setColorStr(arg3, var0))
end

function var0.UpdateTitle(arg0)
	local var0 = arg0.voteGroup:getConfig("next_round_number")

	setActive(arg0.rankTitle, true)
end

function var0.Update(arg0, arg1)
	arg0.voteGroup = arg1
	arg0.voteShips = arg1:getList()
	arg0.page = 1
	arg0.maxPage = math.ceil(#arg0.voteShips / var0.RANK_DISPLAY_COUNT)
	arg0.phase = arg1:GetStage()

	setActive(arg0.title1, arg0.phase == VoteGroup.VOTE_STAGE)
	setActive(arg0.title2, arg0.phase ~= VoteGroup.VOTE_STAGE)
	setActive(arg0.tip, arg0.phase == VoteGroup.VOTE_STAGE)
	arg0:UpdateTitle()
	arg0:initRank(arg0.page)
	arg0:Show()
end

function var0.OnDestroy(arg0)
	return
end

return var0
