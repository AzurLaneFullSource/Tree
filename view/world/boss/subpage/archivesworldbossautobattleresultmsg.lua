local var0_0 = class("ArchivesWorldBossAutoBattleResultMsg", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ArchivesWorldBossAutoBattleResultUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("window/top/close")
	arg0_2.confirmBtn = arg0_2:findTF("window/btns/start")

	setText(arg0_2:findTF("window/top/title"), i18n("world_boss_title_auto_battle"))
	setText(arg0_2:findTF("window/msg_panel/label"), i18n("world_boss_archives_auto_battle_reusle_title"))
	setText(arg0_2:findTF("window/msg_panel/battle_cnt/label"), i18n("world_boss_title_battle_cnt"))
	setText(arg0_2:findTF("window/msg_panel/damage/label"), i18n("world_boss_title_total_damage"))
	setText(arg0_2:findTF("window/msg_panel/oil/label"), i18n("world_boss_title_consume_oil_cnt"))
	setText(arg0_2:findTF("window/btns/start/pic"), i18n("text_confirm"))

	arg0_2.battleCntTxt = arg0_2:findTF("window/msg_panel/battle_cnt/Text"):GetComponent(typeof(Text))
	arg0_2.damageTxt = arg0_2:findTF("window/msg_panel/damage/Text"):GetComponent(typeof(Text))
	arg0_2.oilTxt = arg0_2:findTF("window/msg_panel/oil/Text"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7)
	arg0_7.battleCntTxt.text = arg1_7.battleCnt
	arg0_7.damageTxt.text = arg1_7.damage
	arg0_7.oilTxt.text = arg1_7.oil

	var0_0.super.Show(arg0_7)
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0
