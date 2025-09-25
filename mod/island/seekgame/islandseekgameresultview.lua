local var0_0 = class("IslandSeekGameResultView", import("Mod.Island.Core.View.IslandASynLoadSubView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.uiName = arg2_1

	var0_0.super.Ctor(arg0_1, arg1_1)
end

function var0_0.GetUIName(arg0_2)
	return arg0_2.uiName
end

function var0_0.FirstFlush(arg0_3)
	arg0_3.animation = arg0_3._tf:GetComponent(typeof(Animation))

	local var0_3 = arg0_3._tf:GetComponent(typeof(DftAniEvent))

	setText(arg0_3._tf:Find("Text"), i18n("island_seek_game_tip"))
	onButton(arg0_3, arg0_3._tf, function()
		if arg0_3.clickableTime and arg0_3.clickableTime > pg.TimeMgr.GetInstance():GetServerTime() then
			return
		end

		if arg0_3.playAnimation then
			return
		end

		arg0_3.playAnimation = true

		arg0_3:GetView():RestartGame()
		arg0_3.animation:Play("anim_IslandSeekGameUI_out")
	end, SFX_PANEL)
	var0_3:SetEndEvent(function(arg0_5)
		arg0_3:Hide()

		arg0_3.playAnimation = false
	end)

	arg0_3.aniDft = var0_3
end

function var0_0.Flush(arg0_6)
	arg0_6.animation:Play("anim_IslandSeekGameUI_in")

	arg0_6.clickableTime = pg.island_set.seek_game_reset_cd.key_value_int + pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.OnDestroy(arg0_7)
	if arg0_7.aniDft then
		arg0_7.aniDft:SetEndEvent(nil)
	end
end

return var0_0
