local var0 = class("FeastScene", import("view.base.BaseUI"))

var0.PAGE_INVITATION = 1
var0.ON_TASK_UPDATE = "FeastScene:ON_TASK_UPDATE"
var0.ON_ACT_UPDATE = "FeastScene:ON_ACT_UPDATE"
var0.ON_SKIP_GIVE_GIFT = "FeastScene:ON_SKIP_GIVE_GIFT"
var0.ON_BACK_FEAST = "FeastScene:ON_BACK_FEAST"
var0.ON_MAKE_TICKET = "FeastScene:ON_MAKE_TICKET"
var0.ON_GOT_TICKET = "FeastScene:ON_GOT_TICKET"
var0.ON_GOT_GIFT = "FeastScene:ON_GOT_GIFT"
var0.GO_INTERACTION = "FeastScene:GO_INTERACTION"
var0.GO_INVITATION = "FeastScene:GO_INVITATION"

function var0.getUIName(arg0)
	return "FeastUI"
end

function var0.forceGC(arg0)
	return true
end

function var0.PlayBGM(arg0)
	pg.CriMgr.GetInstance():StopBGM()
end

function var0.init(arg0)
	arg0.mainCG = GetOrAddComponent(arg0._tf, typeof(CanvasGroup))
	arg0.backBtn = arg0:findTF("main/return")
	arg0.invitationBtn = arg0:findTF("btns/invitation")
	arg0.invitationBtnTip = arg0.invitationBtn:Find("tip")
	arg0.taskBtn = arg0:findTF("btns/task")
	arg0.taskBtnTip = arg0.taskBtn:Find("tip")
	arg0.invitationPage = FeastInvitationPage.New(arg0._tf, arg0.event)
	arg0.taskPage = FeastTaskPage.New(arg0._tf, arg0.event)
	arg0.helpBtn = arg0:findTF("main/help")
	arg0.homeBtn = arg0:findTF("main/home")
	arg0.buffUIlist = UIItemList.New(arg0:findTF("main/buffs"), arg0:findTF("main/buffs/tpl"))

	setText(arg0.invitationBtn:Find("Text"), i18n("feast_invitation_btn_label"))
	setText(arg0.taskBtn:Find("Text"), i18n("feast_task_btn_label"))
end

function var0.didEnter(arg0)
	arg0:BlockEvents()
	arg0:SetUpCourtYard()
end

function var0.OnCourtYardLoaded(arg0)
	arg0:UnBlockEvents()
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0, arg0.invitationBtn, function()
		arg0.invitationPage:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0, arg0.taskBtn, function()
		arg0.taskPage:ExecuteAction("Show")
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.feast_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.homeBtn, function()
		arg0:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	arg0:bind(FeastScene.ON_TASK_UPDATE, function()
		arg0:UpdateTips()
	end)
	arg0:bind(FeastScene.ON_ACT_UPDATE, function()
		arg0:UpdateTips()
	end)
	arg0:bind(FeastScene.ON_GOT_GIFT, function()
		arg0:UpdateTips()
	end)
	arg0:bind(FeastScene.ON_GOT_TICKET, function()
		arg0:UpdateTips()
	end)
	arg0:bind(FeastScene.GO_INTERACTION, function()
		if arg0.taskPage and arg0.taskPage:GetLoaded() and arg0.taskPage:isShowing() then
			arg0.taskPage:Hide()
		end
	end)
	arg0:bind(FeastScene.GO_INVITATION, function()
		if arg0.taskPage and arg0.taskPage:GetLoaded() and arg0.taskPage:isShowing() then
			arg0.taskPage:Hide()
		end

		arg0.invitationPage:ExecuteAction("Show")
	end)
	arg0:bind(FeastScene.ON_ACT_UPDATE, function()
		arg0:UpdateBuffs()
	end)
	arg0:bind(FeastScene.ON_BACK_FEAST, function()
		if arg0.invitationPage and arg0.invitationPage:GetLoaded() and arg0.invitationPage:isShowing() then
			arg0.invitationPage:Hide()
		end
	end)
	arg0:PlayEnterStory()
	arg0:UpdateTips()
	arg0:UpdateBuffs()

	if arg0.contextData.page and arg0.contextData.page == var0.PAGE_INVITATION then
		triggerButton(arg0.invitationBtn)
	end
end

function var0.UpdateBuffs(arg0)
	local var0 = getProxy(FeastProxy):GetBuffList()

	arg0.buffUIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, {
					type = DROP_TYPE_BUFF,
					id = var0.id
				})
			end, SFX_PANEL)
		end
	end)
	arg0.buffUIlist:align(#var0)
end

function var0.PlayEnterStory(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST):getConfig("config_client")[6]

	if var0 and var0 ~= "" and not pg.NewStoryMgr.GetInstance():IsPlayed(var0) then
		pg.NewStoryMgr.GetInstance():Play(var0)
	end
end

function var0.UpdateTips(arg0)
	setActive(arg0.invitationBtnTip, getProxy(FeastProxy):ShouldTipInvitation())
	setActive(arg0.taskBtnTip, getProxy(FeastProxy):ShouldTipTask())
end

function var0.SetUpCourtYard(arg0)
	arg0.contextData.mode = CourtYardConst.SYSTEM_FEAST

	arg0:emit(FeastMediator.SET_UP, 1)
end

function var0.BlockEvents(arg0)
	arg0.mainCG.blocksRaycasts = false
end

function var0.UnBlockEvents(arg0)
	arg0.mainCG.blocksRaycasts = true
end

function var0.onBackPressed(arg0)
	if arg0.invitationPage and arg0.invitationPage:GetLoaded() and arg0.invitationPage:isShowing() then
		arg0.invitationPage:onBackPressed()

		return
	end

	if arg0.taskPage and arg0.taskPage:GetLoaded() and arg0.taskPage:isShowing() then
		arg0.taskPage:Hide()

		return
	end

	arg0:emit(var0.ON_BACK_PRESSED)
end

function var0.willExit(arg0)
	if arg0.invitationPage then
		arg0.invitationPage:Destroy()

		arg0.invitationPage = nil
	end

	if arg0.taskPage then
		arg0.taskPage:Destroy()

		arg0.taskPage = nil
	end
end

return var0
