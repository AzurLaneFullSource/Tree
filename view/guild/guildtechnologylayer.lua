local var0 = class("GuildTechnologyLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "GuildEmptyUI"
end

function var0.setGuild(arg0, arg1)
	arg0.guildVO = arg1
end

function var0.init(arg0)
	arg0.technologyPage = GuildTechnologyPage.New(arg0._tf, arg0.event)
	arg0.helpBtn = arg0:findTF("frame/help")
end

function var0.didEnter(arg0)
	arg0:UpdatePainting()
	arg0.technologyPage:ExecuteAction("SetUp", arg0.guildVO)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_tech_tip.tip
		})
	end, SFX_PANEL)
end

function var0.UpdatePainting(arg0)
	local var0 = arg0.guildVO:GetOfficePainting()

	pg.GuildPaintingMgr:GetInstance():Update(var0, Vector3(-737, -171, 0))
end

function var0.UpdateUpgradeList(arg0)
	if arg0.technologyPage:GetLoaded() then
		arg0.technologyPage:UpdateUpgradeList()
	end
end

function var0.UpdateBreakOutList(arg0)
	if arg0.technologyPage:GetLoaded() then
		arg0.technologyPage:UpdateBreakOutList()
	end
end

function var0.UpdateGuild(arg0, arg1)
	arg0:setGuild(arg1)

	if arg0.technologyPage and arg0.technologyPage:GetLoaded() then
		arg0.technologyPage:Update(arg0.guildVO)
	end
end

function var0.UpdateAll(arg0)
	if arg0.technologyPage:GetLoaded() then
		arg0.technologyPage:Flush()
	end
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0:emit(var0.ON_BACK)
end

function var0.willExit(arg0)
	arg0.technologyPage:Destroy()

	if isActive(pg.MsgboxMgr:GetInstance()._go) then
		triggerButton(pg.MsgboxMgr:GetInstance()._closeBtn)
	end
end

return var0
