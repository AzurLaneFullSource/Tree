local var0_0 = class("FriendRequestPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "FriendRequestUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.requestPanel = arg0_2._tf:Find("request_panel")
	arg0_2.requestTopTF = arg0_2._tf:Find("request_view_top")
	arg0_2.refuseAllBtn = arg0_2.requestTopTF:Find("refuse_all_btn")
	arg0_2.informPanel = arg0_2._tf:Find("inform_panel")
	arg0_2.toggleTpl = arg0_2.informPanel:Find("frame/window/main/Toggle")
	arg0_2.buttonTpl = arg0_2.informPanel:Find("frame/window/main/button")
	arg0_2.toggleContainer = arg0_2.informPanel:Find("frame/window/main/toggles")
	arg0_2.confirmBtn = arg0_2.informPanel:Find("frame/window/buttons/confirm_btn")
	arg0_2.cancelBtn = arg0_2.informPanel:Find("frame/window/buttons/cancel_btn")
	arg0_2.backBtn = arg0_2.informPanel:Find("frame/window/top/btnBack")
	arg0_2.nameTF = arg0_2.informPanel:Find("frame/window/name"):GetComponent(typeof(Text))

	setActive(arg0_2.informPanel, false)
end

function var0_0.OnInit(arg0_3)
	arg0_3.refuseMsgBox = FriendRefusePage.New(arg0_3._tf, arg0_3.event)

	onButton(arg0_3, arg0_3.refuseAllBtn, function()
		arg0_3:emit(FriendMediator.REFUSE_ALL_REQUEST)
	end, SFX_PANEL)
	arg0_3:InitInform()
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
	onButton(arg0_15, var0_15.reportBtn, function()
		if var0_15.friendVO then
			arg0_15:openInfromPanel(var0_15.friendVO, var1_15.content)
		end
	end)
end

function var0_0.openInfromPanel(arg0_17, arg1_17, arg2_17)
	setActive(arg0_17.informPanel, true)
	arg0_17:UpdateInform(arg1_17, arg2_17)
end

function var0_0.closeInfromPanel(arg0_18)
	setActive(arg0_18.informPanel, false)
end

function var0_0.InitInform(arg0_19)
	local var0_19 = require("ShareCfg.informCfg")

	for iter0_19, iter1_19 in ipairs(var0_19) do
		local var1_19 = cloneTplTo(arg0_19.toggleTpl, arg0_19.toggleContainer)

		var1_19:Find("Label"):GetComponent("Text").text = iter1_19.content

		onToggle(arg0_19, var1_19, function(arg0_20)
			if arg0_20 then
				arg0_19.informInfo = iter1_19.content
			end
		end)
	end

	onButton(arg0_19, arg0_19.cancelBtn, function()
		arg0_19:closeInfromPanel()
	end)
	onButton(arg0_19, arg0_19.backBtn, function()
		arg0_19:closeInfromPanel()
	end)
end

function var0_0.UpdateInform(arg0_23, arg1_23, arg2_23)
	arg0_23.nameTF.text = i18n("inform_player", arg1_23.name)

	onButton(arg0_23, arg0_23.confirmBtn, function()
		if not arg0_23.informInfo then
			pg.TipsMgr.GetInstance():ShowTips(i18n("inform_select_type"))

			return
		end

		arg0_23:emit(FriendMediator.INFORM, arg1_23.id, arg0_23.informInfo, arg2_23)
	end)
end

function var0_0.OnDestroy(arg0_25)
	for iter0_25, iter1_25 in pairs(arg0_25.requestItems or {}) do
		iter1_25:dispose()
	end

	arg0_25.refuseMsgBox:Destroy()
end

return var0_0
