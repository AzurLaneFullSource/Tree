local var0_0 = class("FriendRequestPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "FriendRequestUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.requestPanel = arg0_2:findTF("request_panel")
	arg0_2.requestTopTF = arg0_2:findTF("request_view_top")
	arg0_2.refuseAllBtn = arg0_2:findTF("refuse_all_btn", arg0_2.requestTopTF)
end

function var0_0.OnInit(arg0_3)
	arg0_3.refuseMsgBox = FriendRefusePage.New(arg0_3._tf, arg0_3.event)

	onButton(arg0_3, arg0_3.refuseAllBtn, function()
		arg0_3:emit(FriendMediator.REFUSE_ALL_REQUEST)
	end, SFX_PANEL)
end

function var0_0.UpdateData(arg0_5, arg1_5)
	arg0_5.requestVOs = arg1_5.requestVOs or {}

	if not arg0_5.isInit then
		arg0_5.isInit = true

		arg0_5:isInitRequestPage()
	else
		arg0_5:sortRequest()
	end
end

function var0_0.isInitRequestPage(arg0_6)
	arg0_6.requestItems = {}
	arg0_6.requestRect = arg0_6.requestPanel:Find("mask/view"):GetComponent("LScrollRect")

	function arg0_6.requestRect.onInitItem(arg0_7)
		arg0_6:onInitItem(arg0_7)
	end

	function arg0_6.requestRect.onUpdateItem(arg0_8, arg1_8)
		arg0_6:onUpdateItem(arg0_8, arg1_8)
	end

	arg0_6:sortRequest()
end

function var0_0.sortRequest(arg0_9)
	arg0_9.requestRect:SetTotalCount(#arg0_9.requestVOs, -1)
end

function var0_0.onInitItem(arg0_10, arg1_10)
	local var0_10 = FriendRequestCard.New(arg1_10)

	onButton(arg0_10, var0_10.acceptBtn, function()
		if var0_10.friendVO then
			arg0_10:emit(FriendMediator.ACCEPT_REQUEST, var0_10.friendVO.id)
		end
	end, SFX_PANEL)
	onButton(arg0_10, var0_10.refuseBtn, function()
		if var0_10.friendVO then
			arg0_10.refuseMsgBox:ExecuteAction("Show", i18n("refuse_friend"), i18n("refuse_and_add_into_bl"), function(arg0_13)
				arg0_10:emit(FriendMediator.REFUSE_REQUEST, var0_10.friendVO, arg0_13)
			end)
		end
	end)
	onButton(arg0_10, var0_10.resumeBtn, function()
		arg0_10:emit(FriendMediator.OPEN_RESUME, var0_10.friendVO.id)
	end, SFX_PANEL)

	arg0_10.requestItems[arg1_10] = var0_10
end

function var0_0.onUpdateItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.requestItems[arg2_15]

	if not var0_15 then
		arg0_15:onInitItem(arg2_15)

		var0_15 = arg0_15.requestItems[arg2_15]
	end

	local var1_15 = arg0_15.requestVOs[arg1_15 + 1]

	var0_15:update(var1_15.player, var1_15.timestamp, var1_15.content)
end

function var0_0.OnDestroy(arg0_16)
	for iter0_16, iter1_16 in pairs(arg0_16.requestItems or {}) do
		iter1_16:dispose()
	end

	arg0_16.refuseMsgBox:Destroy()
end

return var0_0
