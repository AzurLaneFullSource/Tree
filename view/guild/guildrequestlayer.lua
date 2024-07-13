local var0_0 = class("GuildRequestLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "GuildRequestUI"
end

function var0_0.setRequest(arg0_2, arg1_2)
	arg0_2.requestVOs = arg1_2
end

function var0_0.init(arg0_3)
	arg0_3.viewRect = arg0_3:findTF("request_panel/view")
	arg0_3.listEmptyTF = arg0_3:findTF("main/frame/empty")
	arg0_3.listEmptyTF = arg0_3:findTF("empty")

	setActive(arg0_3.listEmptyTF, false)

	arg0_3.listEmptyTxt = arg0_3:findTF("Text", arg0_3.listEmptyTF)

	setText(arg0_3.listEmptyTxt, i18n("list_empty_tip_guildrequestui"))

	arg0_3.scrollRect = arg0_3.viewRect:GetComponent("LScrollRect")
end

function var0_0.didEnter(arg0_4)
	pg.GuildPaintingMgr:GetInstance():Hide()
end

function var0_0.initRequests(arg0_5)
	arg0_5.requestCards = {}

	function arg0_5.scrollRect.onInitItem(arg0_6)
		arg0_5:onInitItem(arg0_6)
	end

	function arg0_5.scrollRect.onUpdateItem(arg0_7, arg1_7)
		arg0_5:onUpdateItem(arg0_7, arg1_7)
	end

	arg0_5:SetTotalCount()
end

function var0_0.onInitItem(arg0_8, arg1_8)
	local var0_8 = GuildRequestCard.New(arg1_8)

	onButton(arg0_8, var0_8.accpetBtn, function()
		arg0_8:emit(GuildRequestMediator.ACCPET, var0_8.requestVO.player.id)
	end, SFX_PANEL)
	onButton(arg0_8, var0_8.rejectBtn, function()
		arg0_8:emit(GuildRequestMediator.REJECT, var0_8.requestVO.player.id)
	end, SFX_PANEL)

	arg0_8.requestCards[arg1_8] = var0_8
end

function var0_0.onUpdateItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.requestCards[arg2_11]

	if not var0_11 then
		arg0_11:onInitItem(arg2_11)

		var0_11 = arg0_11.requestCards[arg2_11]
	end

	local var1_11 = arg0_11.requestVOs[arg1_11 + 1]

	var0_11:Update(var1_11)
end

function var0_0.SetTotalCount(arg0_12)
	table.sort(arg0_12.requestVOs, function(arg0_13, arg1_13)
		return arg0_13.timestamp < arg1_13.timestamp
	end)
	arg0_12.scrollRect:SetTotalCount(#arg0_12.requestVOs, 0)
	setActive(arg0_12.listEmptyTF, #arg0_12.requestVOs <= 0)
end

function var0_0.addRequest(arg0_14, arg1_14)
	table.insert(arg0_14.requestVOs, arg1_14)
	arg0_14:SetTotalCount()
end

function var0_0.deleteRequest(arg0_15, arg1_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.requestVOs) do
		if iter1_15.player.id == arg1_15 then
			table.remove(arg0_15.requestVOs, iter0_15)

			break
		end
	end

	arg0_15:SetTotalCount()
end

function var0_0.onBackPressed(arg0_16)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0_16:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.requestCards) do
		iter1_17:Dispose()
	end
end

return var0_0
