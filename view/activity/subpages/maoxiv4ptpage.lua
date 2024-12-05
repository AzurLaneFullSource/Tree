local var0_0 = class("MaoxiV4PtPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.battleBtn, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))
	end, SFX_PANEL)
end

return var0_0
