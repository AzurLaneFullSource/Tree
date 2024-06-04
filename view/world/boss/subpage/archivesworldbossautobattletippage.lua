local var0 = class("ArchivesWorldBossAutoBattleTipPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "ArchivesWorldBossAutoBattleTipUI"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("window/top/close")
	arg0.startBtn = arg0:findTF("window/btns/start")
	arg0.cancelBtn = arg0:findTF("window/btns/cancel")

	setText(arg0:findTF("window/top/title"), i18n("world_boss_title_auto_battle"))
	setText(arg0:findTF("window/msg_panel/highest_damage/label"), i18n("world_boss_title_highest_damge"))
	setText(arg0:findTF("window/msg_panel/label"), i18n("world_boss_title_estimation"))
	setText(arg0:findTF("window/msg_panel/battle_cnt/label"), i18n("world_boss_title_battle_cnt"))
	setText(arg0:findTF("window/msg_panel/oil/label"), i18n("world_boss_title_consume_oil_cnt"))
	setText(arg0:findTF("window/msg_panel/time/label"), i18n("world_boss_title_spend_time"))
	setText(arg0:findTF("window/btns/cancel/pic"), i18n("word_cancel"))
	setText(arg0:findTF("window/btns/start/pic"), i18n("word_start"))

	arg0.highestDamageTxt = arg0:findTF("window/msg_panel/highest_damage/Text"):GetComponent(typeof(Text))
	arg0.battleCntTxt = arg0:findTF("window/msg_panel/battle_cnt/Text"):GetComponent(typeof(Text))
	arg0.oilTxt = arg0:findTF("window/msg_panel/oil/Text"):GetComponent(typeof(Text))
	arg0.timeTxt = arg0:findTF("window/msg_panel/time/Text"):GetComponent(typeof(Text))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.startBtn, function()
		if arg0.OnYes then
			arg0.OnYes()
		end

		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.highestDamageTxt.text = arg1.highestDamage
	arg0.battleCntTxt.text = arg1.autoBattleCnt > 100 and ">100" or arg1.autoBattleCnt
	arg0.oilTxt.text = arg1.oil
	arg0.timeTxt.text = arg1.time .. "MIN"
	arg0.OnYes = arg1.onYes
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)

	arg0.OnYes = nil
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
