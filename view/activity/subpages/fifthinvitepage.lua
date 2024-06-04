local var0 = class("FifthInvitePage", import(".FourthInvitePage"))

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.five_qingdian.tip
		})
	end, SFX_PANEL)
end

return var0
