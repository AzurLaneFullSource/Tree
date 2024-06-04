local var0 = class("ArchivesWorldBossAutoBattleResultMsg", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "ArchivesWorldBossAutoBattleResultUI"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("window/top/close")
	arg0.confirmBtn = arg0:findTF("window/btns/start")

	setText(arg0:findTF("window/top/title"), i18n("world_boss_title_auto_battle"))
	setText(arg0:findTF("window/msg_panel/label"), i18n("world_boss_archives_auto_battle_reusle_title"))
	setText(arg0:findTF("window/msg_panel/battle_cnt/label"), i18n("world_boss_title_battle_cnt"))
	setText(arg0:findTF("window/msg_panel/damage/label"), i18n("world_boss_title_total_damage"))
	setText(arg0:findTF("window/msg_panel/oil/label"), i18n("world_boss_title_consume_oil_cnt"))
	setText(arg0:findTF("window/btns/start/pic"), i18n("text_confirm"))

	arg0.battleCntTxt = arg0:findTF("window/msg_panel/battle_cnt/Text"):GetComponent(typeof(Text))
	arg0.damageTxt = arg0:findTF("window/msg_panel/damage/Text"):GetComponent(typeof(Text))
	arg0.oilTxt = arg0:findTF("window/msg_panel/oil/Text"):GetComponent(typeof(Text))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	arg0.battleCntTxt.text = arg1.battleCnt
	arg0.damageTxt.text = arg1.damage
	arg0.oilTxt.text = arg1.oil

	var0.super.Show(arg0)
end

function var0.OnDestroy(arg0)
	return
end

return var0
