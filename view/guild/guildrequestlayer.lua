local var0 = class("GuildRequestLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "GuildRequestUI"
end

function var0.setRequest(arg0, arg1)
	arg0.requestVOs = arg1
end

function var0.init(arg0)
	arg0.viewRect = arg0:findTF("request_panel/view")
	arg0.listEmptyTF = arg0:findTF("main/frame/empty")
	arg0.listEmptyTF = arg0:findTF("empty")

	setActive(arg0.listEmptyTF, false)

	arg0.listEmptyTxt = arg0:findTF("Text", arg0.listEmptyTF)

	setText(arg0.listEmptyTxt, i18n("list_empty_tip_guildrequestui"))

	arg0.scrollRect = arg0.viewRect:GetComponent("LScrollRect")
end

function var0.didEnter(arg0)
	pg.GuildPaintingMgr:GetInstance():Hide()
end

function var0.initRequests(arg0)
	arg0.requestCards = {}

	function arg0.scrollRect.onInitItem(arg0)
		arg0:onInitItem(arg0)
	end

	function arg0.scrollRect.onUpdateItem(arg0, arg1)
		arg0:onUpdateItem(arg0, arg1)
	end

	arg0:SetTotalCount()
end

function var0.onInitItem(arg0, arg1)
	local var0 = GuildRequestCard.New(arg1)

	onButton(arg0, var0.accpetBtn, function()
		arg0:emit(GuildRequestMediator.ACCPET, var0.requestVO.player.id)
	end, SFX_PANEL)
	onButton(arg0, var0.rejectBtn, function()
		arg0:emit(GuildRequestMediator.REJECT, var0.requestVO.player.id)
	end, SFX_PANEL)

	arg0.requestCards[arg1] = var0
end

function var0.onUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.requestCards[arg2]

	if not var0 then
		arg0:onInitItem(arg2)

		var0 = arg0.requestCards[arg2]
	end

	local var1 = arg0.requestVOs[arg1 + 1]

	var0:Update(var1)
end

function var0.SetTotalCount(arg0)
	table.sort(arg0.requestVOs, function(arg0, arg1)
		return arg0.timestamp < arg1.timestamp
	end)
	arg0.scrollRect:SetTotalCount(#arg0.requestVOs, 0)
	setActive(arg0.listEmptyTF, #arg0.requestVOs <= 0)
end

function var0.addRequest(arg0, arg1)
	table.insert(arg0.requestVOs, arg1)
	arg0:SetTotalCount()
end

function var0.deleteRequest(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.requestVOs) do
		if iter1.player.id == arg1 then
			table.remove(arg0.requestVOs, iter0)

			break
		end
	end

	arg0:SetTotalCount()
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0:emit(var0.ON_BACK)
end

function var0.willExit(arg0)
	for iter0, iter1 in pairs(arg0.requestCards) do
		iter1:Dispose()
	end
end

return var0
