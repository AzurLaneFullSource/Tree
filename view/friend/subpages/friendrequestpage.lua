local var0 = class("FriendRequestPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "FriendRequestUI"
end

function var0.OnLoaded(arg0)
	arg0.requestPanel = arg0:findTF("request_panel")
	arg0.requestTopTF = arg0:findTF("request_view_top")
	arg0.refuseAllBtn = arg0:findTF("refuse_all_btn", arg0.requestTopTF)
end

function var0.OnInit(arg0)
	arg0.refuseMsgBox = FriendRefusePage.New(arg0._tf, arg0.event)

	onButton(arg0, arg0.refuseAllBtn, function()
		arg0:emit(FriendMediator.REFUSE_ALL_REQUEST)
	end, SFX_PANEL)
end

function var0.UpdateData(arg0, arg1)
	arg0.requestVOs = arg1.requestVOs or {}

	if not arg0.isInit then
		arg0.isInit = true

		arg0:isInitRequestPage()
	else
		arg0:sortRequest()
	end
end

function var0.isInitRequestPage(arg0)
	arg0.requestItems = {}
	arg0.requestRect = arg0.requestPanel:Find("mask/view"):GetComponent("LScrollRect")

	function arg0.requestRect.onInitItem(arg0)
		arg0:onInitItem(arg0)
	end

	function arg0.requestRect.onUpdateItem(arg0, arg1)
		arg0:onUpdateItem(arg0, arg1)
	end

	arg0:sortRequest()
end

function var0.sortRequest(arg0)
	arg0.requestRect:SetTotalCount(#arg0.requestVOs, -1)
end

function var0.onInitItem(arg0, arg1)
	local var0 = FriendRequestCard.New(arg1)

	onButton(arg0, var0.acceptBtn, function()
		if var0.friendVO then
			arg0:emit(FriendMediator.ACCEPT_REQUEST, var0.friendVO.id)
		end
	end, SFX_PANEL)
	onButton(arg0, var0.refuseBtn, function()
		if var0.friendVO then
			arg0.refuseMsgBox:ExecuteAction("Show", i18n("refuse_friend"), i18n("refuse_and_add_into_bl"), function(arg0)
				arg0:emit(FriendMediator.REFUSE_REQUEST, var0.friendVO, arg0)
			end)
		end
	end)
	onButton(arg0, var0.resumeBtn, function()
		arg0:emit(FriendMediator.OPEN_RESUME, var0.friendVO.id)
	end, SFX_PANEL)

	arg0.requestItems[arg1] = var0
end

function var0.onUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.requestItems[arg2]

	if not var0 then
		arg0:onInitItem(arg2)

		var0 = arg0.requestItems[arg2]
	end

	local var1 = arg0.requestVOs[arg1 + 1]

	var0:update(var1.player, var1.timestamp, var1.content)
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.requestItems or {}) do
		iter1:dispose()
	end

	arg0.refuseMsgBox:Destroy()
end

return var0
