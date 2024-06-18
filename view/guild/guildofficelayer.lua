local var0_0 = class("GuildOfficeLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "GuildEmptyUI"
end

function var0_0.setPlayer(arg0_2, arg1_2)
	arg0_2.playerVO = arg1_2
end

function var0_0.SetGuild(arg0_3, arg1_3)
	arg0_3.guild = arg1_3
	arg0_3.isAdmin = GuildMember.IsAdministrator(arg1_3:getSelfDuty())

	if arg0_3.taskPage and arg0_3.taskPage:GetLoaded() then
		arg0_3.taskPage:OnUpdateGuild(arg0_3.guild, arg0_3.isAdmin)
	end
end

function var0_0.init(arg0_4)
	arg0_4.taskPage = GuildOfficeTaskPage.New(arg0_4._tf, arg0_4.event)
	arg0_4.helpBtn = arg0_4:findTF("frame/help")
end

function var0_0.didEnter(arg0_5)
	local var0_5 = arg0_5.guild:GetOfficePainting()

	pg.GuildPaintingMgr:GetInstance():Update(var0_5, Vector3(-737, -171, 0))
	arg0_5.taskPage:ExecuteAction("Update", arg0_5.guild, arg0_5.isAdmin)
	onButton(arg0_5, arg0_5.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_office_tip.tip
		})
	end, SFX_PANEL)
end

function var0_0.UpdateContribution(arg0_7)
	if arg0_7.taskPage and arg0_7.taskPage:GetLoaded() then
		arg0_7.taskPage:OnUpdateContribution()
	end
end

function var0_0.UpdateSupplyPanel(arg0_8)
	if arg0_8.taskPage and arg0_8.taskPage:GetLoaded() then
		arg0_8.taskPage:OnUpdateSupplyPanel()
	end
end

function var0_0.UpdateTask(arg0_9, arg1_9)
	if arg0_9.taskPage and arg0_9.taskPage:GetLoaded() then
		arg0_9.taskPage:OnUpdateTask(arg1_9)
	end
end

function var0_0.onBackPressed(arg0_10)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0_10:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_11)
	arg0_11.taskPage:Destroy()

	if isActive(pg.MsgboxMgr:GetInstance()._go) then
		triggerButton(pg.MsgboxMgr:GetInstance()._closeBtn)
	end
end

return var0_0
