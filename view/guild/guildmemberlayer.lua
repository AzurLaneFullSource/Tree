local var0_0 = class("GuildMemberLayer", import("..base.BaseUI"))

function var0_0.setGuildVO(arg0_1, arg1_1)
	arg0_1.guildVO = arg1_1

	arg0_1:setMemberVOs(arg1_1:getSortMember())
end

function var0_0.setMemberVOs(arg0_2, arg1_2)
	arg0_2.memberVOs = arg1_2
end

function var0_0.setPlayerVO(arg0_3, arg1_3)
	arg0_3.playerVO = arg1_3
end

function var0_0.SetRanks(arg0_4, arg1_4)
	arg0_4.ranks = arg1_4
end

function var0_0.getUIName(arg0_5)
	return "GuildMemberUI"
end

function var0_0.init(arg0_6)
	arg0_6.buttonsPanel = arg0_6:findTF("buttons_panel")
	arg0_6.toggleGroup = arg0_6:findTF("buttons_panel"):GetComponent(typeof(ToggleGroup))
	arg0_6.chatPanel = arg0_6:findTF("chat")

	setActive(arg0_6.chatPanel, false)
	setActive(arg0_6.buttonsPanel, false)

	arg0_6.btns = {
		arg0_6:findTF("buttons_panel/info_btn"),
		arg0_6:findTF("buttons_panel/duty_btn"),
		arg0_6:findTF("buttons_panel/fire_btn"),
		arg0_6:findTF("buttons_panel/impeach_btn")
	}
	arg0_6.helpBtn = arg0_6:findTF("help")
	arg0_6.pages = {
		GuildMemberInfoPage.New(arg0_6._tf, arg0_6.event),
		GuildAppiontPage.New(arg0_6._tf, arg0_6.event),
		GuildFirePage.New(arg0_6._tf, arg0_6.event),
		GuildImpeachPage.New(arg0_6._tf, arg0_6.event)
	}
	arg0_6.contextData.rankPage = GuildRankPage.New(arg0_6._tf, arg0_6.event)
	arg0_6.listPage = GuildMemberListPage.New(arg0_6._tf, arg0_6.event, arg0_6.contextData)

	function arg0_6.listPage.OnClickMember(arg0_7)
		arg0_6:LoadPainting(arg0_7)
	end

	arg0_6.buttonPos = arg0_6.buttonsPanel.localPosition
end

function var0_0.didEnter(arg0_8)
	local function var0_8()
		if arg0_8.page then
			local var0_9 = table.indexof(arg0_8.pages, arg0_8.page)
			local var1_9 = arg0_8.btns[var0_9]

			setActive(var1_9:Find("sel"), false)
		end
	end

	for iter0_8, iter1_8 in ipairs(arg0_8.btns) do
		onButton(arg0_8, iter1_8, function()
			if iter0_8 == 2 and arg0_8.memberVO:IsRecruit() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_trainee_duty_change_tip"))

				return
			end

			if arg0_8.page and not arg0_8.page:GetLoaded() then
				return
			end

			local var0_10 = arg0_8.pages[iter0_8]

			pg.UIMgr.GetInstance():LoadingOn()

			local function var1_10()
				if arg0_8.page then
					arg0_8.page:Hide()
				end

				var0_8()
				setActive(iter1_8:Find("sel"), true)

				arg0_8.page = var0_10

				pg.UIMgr.GetInstance():LoadingOff()
			end

			var0_10:ExecuteAction("Show", arg0_8.guildVO, arg0_8.playerVO, arg0_8.memberVO, var1_10)
		end, SFX_PANEL)
		arg0_8.pages[iter0_8]:SetCallBack(function(arg0_12)
			arg0_8.buttonsPanel.localPosition = arg0_12

			setParent(arg0_8.buttonsPanel, pg.UIMgr:GetInstance().OverlayMain)
		end, function()
			var0_8()
			setParent(arg0_8.buttonsPanel, arg0_8._tf)

			arg0_8.buttonsPanel.localPosition = arg0_8.buttonPos
		end)
	end

	onButton(arg0_8, arg0_8.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_member_tip.tip
		})
	end, SFX_PANEL)
	arg0_8.listPage:ExecuteAction("SetUp", arg0_8.guildVO, arg0_8.memberVOs, arg0_8.ranks)
end

function var0_0.LoadPainting(arg0_15, arg1_15)
	arg0_15.memberVO = arg1_15

	local var0_15 = arg1_15.duty
	local var1_15 = arg0_15.guildVO:getDutyByMemberId(arg0_15.playerVO.id)

	setActive(arg0_15.buttonsPanel, true)

	local var2_15 = arg1_15:GetManifesto()

	if HXSet.isHxPropose() then
		var2_15 = ""
	end

	if not var2_15 or var2_15 == "" then
		setActive(arg0_15.chatPanel, false)
	else
		setActive(arg0_15.chatPanel, true)
		setText(arg0_15:findTF("Text", arg0_15.chatPanel), var2_15)
	end

	local var3_15

	if HXSet.isHxPropose() then
		local var4_15 = arg0_15.guildVO:GetOfficePainting()

		pg.GuildPaintingMgr:GetInstance():Update(var4_15, Vector3(-643, -160, 0))
	else
		local var5_15 = Ship.New({
			configId = arg1_15.icon,
			skin_id = arg1_15.skinId
		}):getPainting()

		pg.GuildPaintingMgr:GetInstance():Update(var5_15, Vector3(-484, 0, 0), true)
	end

	setActive(arg0_15.btns[4], var1_15 == GuildConst.DUTY_DEPUTY_COMMANDER and var0_15 == GuildConst.DUTY_COMMANDER and arg1_15:isLongOffLine())

	local var6_15 = (var1_15 == GuildConst.DUTY_DEPUTY_COMMANDER or var1_15 == GuildConst.DUTY_COMMANDER) and var1_15 < var0_15

	setButtonEnabled(arg0_15.btns[2], var6_15)
	setGray(arg0_15.btns[2], not var6_15, true)

	local var7_15 = (var1_15 == GuildConst.DUTY_DEPUTY_COMMANDER or var1_15 == GuildConst.DUTY_COMMANDER) and var1_15 < var0_15

	setButtonEnabled(arg0_15.btns[3], var7_15)
	setGray(arg0_15.btns[3], not var7_15, true)
end

function var0_0.RefreshMembers(arg0_16)
	if arg0_16.listPage:GetLoaded() then
		arg0_16.listPage:Flush(arg0_16.guildVO, arg0_16.memberVOs, arg0_16.ranks)
	end
end

function var0_0.ActiveDefaultMenmber(arg0_17)
	if arg0_17.listPage:GetLoaded() then
		arg0_17.listPage:TriggerFirstCard()
	end
end

function var0_0.UpdateRankList(arg0_18, arg1_18, arg2_18)
	arg0_18.ranks[arg1_18] = arg2_18

	if arg0_18.contextData.rankPage and arg0_18.contextData.rankPage:GetLoaded() then
		arg0_18.contextData.rankPage:ExecuteAction("OnUpdateRankList", arg1_18, arg2_18)
	end
end

function var0_0.ShowInfoPanel(arg0_19, arg1_19)
	arg0_19.pages[1]:ExecuteAction("Flush", arg1_19)
end

function var0_0.onBackPressed(arg0_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.pages) do
		if iter1_20:GetLoaded() and iter1_20:isShowing() then
			iter1_20:Hide()

			return
		end
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0_20:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_21)
	arg0_21.contextData.rankPage:Destroy()

	arg0_21.listPage.OnClickMember = nil

	arg0_21.listPage:Destroy()

	for iter0_21, iter1_21 in ipairs(arg0_21.pages) do
		iter1_21:Destroy()
	end

	if isActive(pg.MsgboxMgr:GetInstance()._go) then
		triggerButton(pg.MsgboxMgr:GetInstance()._closeBtn)
	end
end

return var0_0
