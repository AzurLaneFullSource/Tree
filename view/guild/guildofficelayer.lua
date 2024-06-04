local var0 = class("GuildOfficeLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "GuildEmptyUI"
end

function var0.setPlayer(arg0, arg1)
	arg0.playerVO = arg1
end

function var0.SetGuild(arg0, arg1)
	arg0.guild = arg1
	arg0.isAdmin = GuildMember.IsAdministrator(arg1:getSelfDuty())

	if arg0.taskPage and arg0.taskPage:GetLoaded() then
		arg0.taskPage:OnUpdateGuild(arg0.guild, arg0.isAdmin)
	end
end

function var0.init(arg0)
	arg0.taskPage = GuildOfficeTaskPage.New(arg0._tf, arg0.event)
	arg0.helpBtn = arg0:findTF("frame/help")
end

function var0.didEnter(arg0)
	local var0 = arg0.guild:GetOfficePainting()

	pg.GuildPaintingMgr:GetInstance():Update(var0, Vector3(-737, -171, 0))
	arg0.taskPage:ExecuteAction("Update", arg0.guild, arg0.isAdmin)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_office_tip.tip
		})
	end, SFX_PANEL)
end

function var0.UpdateContribution(arg0)
	if arg0.taskPage and arg0.taskPage:GetLoaded() then
		arg0.taskPage:OnUpdateContribution()
	end
end

function var0.UpdateSupplyPanel(arg0)
	if arg0.taskPage and arg0.taskPage:GetLoaded() then
		arg0.taskPage:OnUpdateSupplyPanel()
	end
end

function var0.UpdateTask(arg0, arg1)
	if arg0.taskPage and arg0.taskPage:GetLoaded() then
		arg0.taskPage:OnUpdateTask(arg1)
	end
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0:emit(var0.ON_BACK)
end

function var0.willExit(arg0)
	arg0.taskPage:Destroy()

	if isActive(pg.MsgboxMgr:GetInstance()._go) then
		triggerButton(pg.MsgboxMgr:GetInstance()._closeBtn)
	end
end

return var0
