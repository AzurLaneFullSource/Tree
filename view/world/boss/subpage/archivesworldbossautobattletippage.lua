local var0_0 = class("ArchivesWorldBossAutoBattleTipPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ArchivesWorldBossAutoBattleTipUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("window/top/close")
	arg0_2.startBtn = arg0_2:findTF("window/btns/start")
	arg0_2.cancelBtn = arg0_2:findTF("window/btns/cancel")

	setText(arg0_2:findTF("window/top/title"), i18n("world_boss_title_auto_battle"))
	setText(arg0_2:findTF("window/msg_panel/highest_damage/label"), i18n("world_boss_title_highest_damge"))
	setText(arg0_2:findTF("window/msg_panel/label"), i18n("world_boss_title_estimation"))
	setText(arg0_2:findTF("window/msg_panel/battle_cnt/label"), i18n("world_boss_title_battle_cnt"))
	setText(arg0_2:findTF("window/msg_panel/oil/label"), i18n("world_boss_title_consume_oil_cnt"))
	setText(arg0_2:findTF("window/msg_panel/time/label"), i18n("world_boss_title_spend_time"))
	setText(arg0_2:findTF("window/btns/cancel/pic"), i18n("word_cancel"))
	setText(arg0_2:findTF("window/btns/start/pic"), i18n("word_start"))

	arg0_2.highestDamageTxt = arg0_2:findTF("window/msg_panel/highest_damage/Text"):GetComponent(typeof(Text))
	arg0_2.battleCntTxt = arg0_2:findTF("window/msg_panel/battle_cnt/Text"):GetComponent(typeof(Text))
	arg0_2.oilTxt = arg0_2:findTF("window/msg_panel/oil/Text"):GetComponent(typeof(Text))
	arg0_2.timeTxt = arg0_2:findTF("window/msg_panel/time/Text"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.startBtn, function()
		if arg0_3.OnYes then
			arg0_3.OnYes()
		end

		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_8, arg1_8)
	var0_0.super.Show(arg0_8)

	arg0_8.highestDamageTxt.text = arg1_8.highestDamage
	arg0_8.battleCntTxt.text = arg1_8.autoBattleCnt > 100 and ">100" or arg1_8.autoBattleCnt
	arg0_8.oilTxt.text = arg1_8.oil
	arg0_8.timeTxt.text = arg1_8.time .. "MIN"
	arg0_8.OnYes = arg1_8.onYes
end

function var0_0.Hide(arg0_9)
	var0_0.super.Hide(arg0_9)

	arg0_9.OnYes = nil
end

function var0_0.OnDestroy(arg0_10)
	if arg0_10:isShowing() then
		arg0_10:Hide()
	end
end

return var0_0
