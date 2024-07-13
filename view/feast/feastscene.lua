local var0_0 = class("FeastScene", import("view.base.BaseUI"))

var0_0.PAGE_INVITATION = 1
var0_0.ON_TASK_UPDATE = "FeastScene:ON_TASK_UPDATE"
var0_0.ON_ACT_UPDATE = "FeastScene:ON_ACT_UPDATE"
var0_0.ON_SKIP_GIVE_GIFT = "FeastScene:ON_SKIP_GIVE_GIFT"
var0_0.ON_BACK_FEAST = "FeastScene:ON_BACK_FEAST"
var0_0.ON_MAKE_TICKET = "FeastScene:ON_MAKE_TICKET"
var0_0.ON_GOT_TICKET = "FeastScene:ON_GOT_TICKET"
var0_0.ON_GOT_GIFT = "FeastScene:ON_GOT_GIFT"
var0_0.GO_INTERACTION = "FeastScene:GO_INTERACTION"
var0_0.GO_INVITATION = "FeastScene:GO_INVITATION"

function var0_0.getUIName(arg0_1)
	return "FeastUI"
end

function var0_0.forceGC(arg0_2)
	return true
end

function var0_0.PlayBGM(arg0_3)
	pg.CriMgr.GetInstance():StopBGM()
end

function var0_0.init(arg0_4)
	arg0_4.mainCG = GetOrAddComponent(arg0_4._tf, typeof(CanvasGroup))
	arg0_4.backBtn = arg0_4:findTF("main/return")
	arg0_4.invitationBtn = arg0_4:findTF("btns/invitation")
	arg0_4.invitationBtnTip = arg0_4.invitationBtn:Find("tip")
	arg0_4.taskBtn = arg0_4:findTF("btns/task")
	arg0_4.taskBtnTip = arg0_4.taskBtn:Find("tip")
	arg0_4.invitationPage = FeastInvitationPage.New(arg0_4._tf, arg0_4.event)
	arg0_4.taskPage = FeastTaskPage.New(arg0_4._tf, arg0_4.event)
	arg0_4.helpBtn = arg0_4:findTF("main/help")
	arg0_4.homeBtn = arg0_4:findTF("main/home")
	arg0_4.buffUIlist = UIItemList.New(arg0_4:findTF("main/buffs"), arg0_4:findTF("main/buffs/tpl"))

	setText(arg0_4.invitationBtn:Find("Text"), i18n("feast_invitation_btn_label"))
	setText(arg0_4.taskBtn:Find("Text"), i18n("feast_task_btn_label"))
end

function var0_0.didEnter(arg0_5)
	arg0_5:BlockEvents()
	arg0_5:SetUpCourtYard()
end

function var0_0.OnCourtYardLoaded(arg0_6)
	arg0_6:UnBlockEvents()
	onButton(arg0_6, arg0_6.backBtn, function()
		arg0_6:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.invitationBtn, function()
		arg0_6.invitationPage:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.taskBtn, function()
		arg0_6.taskPage:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.feast_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.homeBtn, function()
		arg0_6:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	arg0_6:bind(FeastScene.ON_TASK_UPDATE, function()
		arg0_6:UpdateTips()
	end)
	arg0_6:bind(FeastScene.ON_ACT_UPDATE, function()
		arg0_6:UpdateTips()
	end)
	arg0_6:bind(FeastScene.ON_GOT_GIFT, function()
		arg0_6:UpdateTips()
	end)
	arg0_6:bind(FeastScene.ON_GOT_TICKET, function()
		arg0_6:UpdateTips()
	end)
	arg0_6:bind(FeastScene.GO_INTERACTION, function()
		if arg0_6.taskPage and arg0_6.taskPage:GetLoaded() and arg0_6.taskPage:isShowing() then
			arg0_6.taskPage:Hide()
		end
	end)
	arg0_6:bind(FeastScene.GO_INVITATION, function()
		if arg0_6.taskPage and arg0_6.taskPage:GetLoaded() and arg0_6.taskPage:isShowing() then
			arg0_6.taskPage:Hide()
		end

		arg0_6.invitationPage:ExecuteAction("Show")
	end)
	arg0_6:bind(FeastScene.ON_ACT_UPDATE, function()
		arg0_6:UpdateBuffs()
	end)
	arg0_6:bind(FeastScene.ON_BACK_FEAST, function()
		if arg0_6.invitationPage and arg0_6.invitationPage:GetLoaded() and arg0_6.invitationPage:isShowing() then
			arg0_6.invitationPage:Hide()
		end
	end)
	arg0_6:PlayEnterStory()
	arg0_6:UpdateTips()
	arg0_6:UpdateBuffs()

	if arg0_6.contextData.page and arg0_6.contextData.page == var0_0.PAGE_INVITATION then
		triggerButton(arg0_6.invitationBtn)
	end
end

function var0_0.UpdateBuffs(arg0_20)
	local var0_20 = getProxy(FeastProxy):GetBuffList()

	arg0_20.buffUIlist:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			local var0_21 = var0_20[arg1_21 + 1]

			onButton(arg0_20, arg2_21, function()
				arg0_20:emit(BaseUI.ON_DROP, {
					type = DROP_TYPE_BUFF,
					id = var0_21.id
				})
			end, SFX_PANEL)
		end
	end)
	arg0_20.buffUIlist:align(#var0_20)
end

function var0_0.PlayEnterStory(arg0_23)
	local var0_23 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST):getConfig("config_client")[6]

	if var0_23 and var0_23 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0_23) then
		pg.NewStoryMgr.GetInstance():Play(var0_23)
	end
end

function var0_0.UpdateTips(arg0_24)
	setActive(arg0_24.invitationBtnTip, getProxy(FeastProxy):ShouldTipInvitation())
	setActive(arg0_24.taskBtnTip, getProxy(FeastProxy):ShouldTipTask())
end

function var0_0.SetUpCourtYard(arg0_25)
	arg0_25.contextData.mode = CourtYardConst.SYSTEM_FEAST

	arg0_25:emit(FeastMediator.SET_UP, 1)
end

function var0_0.BlockEvents(arg0_26)
	arg0_26.mainCG.blocksRaycasts = false
end

function var0_0.UnBlockEvents(arg0_27)
	arg0_27.mainCG.blocksRaycasts = true
end

function var0_0.onBackPressed(arg0_28)
	if arg0_28.invitationPage and arg0_28.invitationPage:GetLoaded() and arg0_28.invitationPage:isShowing() then
		arg0_28.invitationPage:onBackPressed()

		return
	end

	if arg0_28.taskPage and arg0_28.taskPage:GetLoaded() and arg0_28.taskPage:isShowing() then
		arg0_28.taskPage:Hide()

		return
	end

	arg0_28:emit(var0_0.ON_BACK_PRESSED)
end

function var0_0.willExit(arg0_29)
	if arg0_29.invitationPage then
		arg0_29.invitationPage:Destroy()

		arg0_29.invitationPage = nil
	end

	if arg0_29.taskPage then
		arg0_29.taskPage:Destroy()

		arg0_29.taskPage = nil
	end
end

return var0_0
