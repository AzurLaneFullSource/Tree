local var0 = class("GuildMemberLayer", import("..base.BaseUI"))

function var0.setGuildVO(arg0, arg1)
	arg0.guildVO = arg1

	arg0:setMemberVOs(arg1:getSortMember())
end

function var0.setMemberVOs(arg0, arg1)
	arg0.memberVOs = arg1
end

function var0.setPlayerVO(arg0, arg1)
	arg0.playerVO = arg1
end

function var0.SetRanks(arg0, arg1)
	arg0.ranks = arg1
end

function var0.getUIName(arg0)
	return "GuildMemberUI"
end

function var0.init(arg0)
	arg0.buttonsPanel = arg0:findTF("buttons_panel")
	arg0.toggleGroup = arg0:findTF("buttons_panel"):GetComponent(typeof(ToggleGroup))
	arg0.chatPanel = arg0:findTF("chat")

	setActive(arg0.chatPanel, false)
	setActive(arg0.buttonsPanel, false)

	arg0.btns = {
		arg0:findTF("buttons_panel/info_btn"),
		arg0:findTF("buttons_panel/duty_btn"),
		arg0:findTF("buttons_panel/fire_btn"),
		arg0:findTF("buttons_panel/impeach_btn")
	}
	arg0.helpBtn = arg0:findTF("help")
	arg0.pages = {
		GuildMemberInfoPage.New(arg0._tf, arg0.event),
		GuildAppiontPage.New(arg0._tf, arg0.event),
		GuildFirePage.New(arg0._tf, arg0.event),
		GuildImpeachPage.New(arg0._tf, arg0.event)
	}
	arg0.contextData.rankPage = GuildRankPage.New(arg0._tf, arg0.event)
	arg0.listPage = GuildMemberListPage.New(arg0._tf, arg0.event, arg0.contextData)

	function arg0.listPage.OnClickMember(arg0)
		arg0:LoadPainting(arg0)
	end

	arg0.buttonPos = arg0.buttonsPanel.localPosition
end

function var0.didEnter(arg0)
	local function var0()
		if arg0.page then
			local var0 = table.indexof(arg0.pages, arg0.page)
			local var1 = arg0.btns[var0]

			setActive(var1:Find("sel"), false)
		end
	end

	for iter0, iter1 in ipairs(arg0.btns) do
		onButton(arg0, iter1, function()
			if iter0 == 2 and arg0.memberVO:IsRecruit() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_trainee_duty_change_tip"))

				return
			end

			if arg0.page and not arg0.page:GetLoaded() then
				return
			end

			local var0 = arg0.pages[iter0]

			pg.UIMgr.GetInstance():LoadingOn()

			local function var1()
				if arg0.page then
					arg0.page:Hide()
				end

				var0()
				setActive(iter1:Find("sel"), true)

				arg0.page = var0

				pg.UIMgr.GetInstance():LoadingOff()
			end

			var0:ExecuteAction("Show", arg0.guildVO, arg0.playerVO, arg0.memberVO, var1)
		end, SFX_PANEL)
		arg0.pages[iter0]:SetCallBack(function(arg0)
			arg0.buttonsPanel.localPosition = arg0

			setParent(arg0.buttonsPanel, pg.UIMgr:GetInstance().OverlayMain)
		end, function()
			var0()
			setParent(arg0.buttonsPanel, arg0._tf)

			arg0.buttonsPanel.localPosition = arg0.buttonPos
		end)
	end

	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_member_tip.tip
		})
	end, SFX_PANEL)
	arg0.listPage:ExecuteAction("SetUp", arg0.guildVO, arg0.memberVOs, arg0.ranks)
end

function var0.LoadPainting(arg0, arg1)
	arg0.memberVO = arg1

	local var0 = arg1.duty
	local var1 = arg0.guildVO:getDutyByMemberId(arg0.playerVO.id)

	setActive(arg0.buttonsPanel, true)

	local var2 = arg1:GetManifesto()

	if HXSet.isHxPropose() then
		var2 = ""
	end

	if not var2 or var2 == "" then
		setActive(arg0.chatPanel, false)
	else
		setActive(arg0.chatPanel, true)
		setText(arg0:findTF("Text", arg0.chatPanel), var2)
	end

	local var3

	if HXSet.isHxPropose() then
		local var4 = arg0.guildVO:GetOfficePainting()

		pg.GuildPaintingMgr:GetInstance():Update(var4, Vector3(-643, -160, 0))
	else
		local var5 = Ship.New({
			configId = arg1.icon,
			skin_id = arg1.skinId
		}):getPainting()

		pg.GuildPaintingMgr:GetInstance():Update(var5, Vector3(-484, 0, 0), true)
	end

	setActive(arg0.btns[4], var1 == GuildConst.DUTY_DEPUTY_COMMANDER and var0 == GuildConst.DUTY_COMMANDER and arg1:isLongOffLine())

	local var6 = (var1 == GuildConst.DUTY_DEPUTY_COMMANDER or var1 == GuildConst.DUTY_COMMANDER) and var1 < var0

	setButtonEnabled(arg0.btns[2], var6)
	setGray(arg0.btns[2], not var6, true)

	local var7 = (var1 == GuildConst.DUTY_DEPUTY_COMMANDER or var1 == GuildConst.DUTY_COMMANDER) and var1 < var0

	setButtonEnabled(arg0.btns[3], var7)
	setGray(arg0.btns[3], not var7, true)
end

function var0.RefreshMembers(arg0)
	if arg0.listPage:GetLoaded() then
		arg0.listPage:Flush(arg0.guildVO, arg0.memberVOs, arg0.ranks)
	end
end

function var0.ActiveDefaultMenmber(arg0)
	if arg0.listPage:GetLoaded() then
		arg0.listPage:TriggerFirstCard()
	end
end

function var0.UpdateRankList(arg0, arg1, arg2)
	arg0.ranks[arg1] = arg2

	if arg0.contextData.rankPage and arg0.contextData.rankPage:GetLoaded() then
		arg0.contextData.rankPage:ExecuteAction("OnUpdateRankList", arg1, arg2)
	end
end

function var0.ShowInfoPanel(arg0, arg1)
	arg0.pages[1]:ExecuteAction("Flush", arg1)
end

function var0.onBackPressed(arg0)
	for iter0, iter1 in ipairs(arg0.pages) do
		if iter1:GetLoaded() and iter1:isShowing() then
			iter1:Hide()

			return
		end
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0:emit(var0.ON_BACK)
end

function var0.willExit(arg0)
	arg0.contextData.rankPage:Destroy()

	arg0.listPage.OnClickMember = nil

	arg0.listPage:Destroy()

	for iter0, iter1 in ipairs(arg0.pages) do
		iter1:Destroy()
	end

	if isActive(pg.MsgboxMgr:GetInstance()._go) then
		triggerButton(pg.MsgboxMgr:GetInstance()._closeBtn)
	end
end

return var0
