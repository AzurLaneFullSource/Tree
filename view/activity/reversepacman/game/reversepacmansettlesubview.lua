local var0_0 = class("ReversePacmanSettleSubView", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ReversePacmanSettlePanel"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2.uiTipText, i18n("word_click_to_close"))
	setText(arg0_2.uiAwardTF:Find("Image/title"), i18n("reverse_pacman_settle_award_title"))
	setText(arg0_2.uiFailPanel:Find("tips/Text"), i18n("reverse_pacman_settle_fail_tips"))
	setText(arg0_2.uiSuccessPanel:Find("infos/title"), i18n("reverse_pacman_settle_statistics"))
	setText(arg0_2.uiFailPanel:Find("infos/title"), i18n("reverse_pacman_settle_statistics"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.uiBgTF, function()
		arg0_3:Hide()
	end, SOUND_BACK)

	arg0_3.awardUIList = UIItemList.New(arg0_3.uiAwardTF:Find("list"), arg0_3.uiAwardTF:Find("list/tpl"))

	arg0_3.awardUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg0_3.awards[arg1_5 + 1]

			updateDrop(arg2_5, var0_5)
			onButton(arg0_3, arg2_5, function()
				arg0_3:emit(BaseUI.ON_DROP, var0_5)
			end, SFX_PANEL)
		end
	end)
end

function var0_0.Show(arg0_7, arg1_7, arg2_7)
	var0_0.super.Show(arg0_7)

	arg0_7.result = arg1_7.result
	arg0_7.time = arg1_7.useTime
	arg0_7.grade = arg1_7.grade
	arg0_7.shipCnt = arg1_7.shipCnt
	arg0_7.monsterCnt = arg1_7.monsterCnt
	arg0_7.awards = arg1_7.awards or {}

	if arg0_7.result == ReversePacmanConst.RESULT_TYPE.SUCCESS then
		arg0_7:ShowSuccessPanel()
	else
		arg0_7:ShowFailPanel()
	end

	arg0_7.hideCallback = arg2_7
end

function var0_0.ShowSuccessPanel(arg0_8)
	setActive(arg0_8.uiSuccessPanel, true)
	setActive(arg0_8.uiFailPanel, false)

	local var0_8 = string.format("<color=#54FDB6>%s</color>", arg0_8.time)

	setText(arg0_8.uiSuccessPanel:Find("infos/time"), i18n("reverse_pacman_settle_time", var0_8))
	setText(arg0_8.uiSuccessPanel:Find("infos/arrest"), i18n("reverse_pacman_settle_arrest", arg0_8.shipCnt, arg0_8.monsterCnt))
	LoadImageSpriteAtlasAsync("ui/reversepacmanui_atlas", "level_" .. arg0_8.grade, arg0_8.uiGradeTF, true)
	setActive(arg0_8.uiAwardTF, #arg0_8.awards > 0)
	arg0_8.awardUIList:align(#arg0_8.awards)
end

function var0_0.ShowFailPanel(arg0_9)
	setActive(arg0_9.uiSuccessPanel, false)
	setActive(arg0_9.uiFailPanel, true)

	local var0_9 = string.format("<color=#E54243>%s</color>", i18n("reverse_pacman_settle_timeout"))

	setText(arg0_9.uiFailPanel:Find("infos/time"), var0_9)
	setText(arg0_9.uiFailPanel:Find("infos/escape"), i18n("reverse_pacman_settle_escape"))
end

function var0_0.Hide(arg0_10)
	var0_0.super.Hide(arg0_10)
	existCall(arg0_10.hideCallback)
end

function var0_0.OnDestroy(arg0_11)
	return
end

return var0_0
