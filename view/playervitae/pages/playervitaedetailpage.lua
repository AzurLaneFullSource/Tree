local var0_0 = class("PlayerVitaeDetailPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "PlayerVitaeDetailPage"
end

function var0_0.OnPlayerNameChange(arg0_2, arg1_2)
	arg0_2.player = arg1_2
	arg0_2.nameTxt.text = arg1_2.name
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.medalTpl = arg0_3._tf:Find("medalList/tpl")
	arg0_3.emblemIcon = arg0_3._tf:Find("power/medal"):GetComponent(typeof(Image))
	arg0_3.emblemTxt = arg0_3._tf:Find("power/medal_text"):GetComponent(typeof(Image))
	arg0_3.highestEmblem = arg0_3._tf:Find("power/rank"):GetComponent(typeof(Text))
	arg0_3.powerTxt = arg0_3._tf:Find("power/power"):GetComponent(typeof(Text))
	arg0_3.collectionTxt = arg0_3._tf:Find("power/collection"):GetComponent(typeof(Text))
	arg0_3.modityNameBtn = arg0_3._tf:Find("info/name")
	arg0_3.nameTxt = arg0_3._tf:Find("info/name/Text"):GetComponent(typeof(Text))
	arg0_3.idTxt = arg0_3._tf:Find("info/uid"):GetComponent(typeof(Text))
	arg0_3.levelTxt = arg0_3._tf:Find("info/level"):GetComponent(typeof(Text))
	arg0_3.expTxt = arg0_3._tf:Find("info/exp"):GetComponent(typeof(Text))
	arg0_3.copyBtn = arg0_3._tf:Find("info/copy")
	arg0_3.statisticTpl = arg0_3._tf:Find("statistics/tpl")
	arg0_3.shareBtn = arg0_3._tf:Find("btn_share")
	arg0_3.attireBtn = arg0_3._tf:Find("btn_attire")
	arg0_3.attireBtnTip = arg0_3.attireBtn:Find("tip")
	arg0_3.inputField = arg0_3._tf:Find("greet/InputField")
	arg0_3.writeBtn = arg0_3._tf:Find("greet/write_btn")
	arg0_3.animPanels = {
		arg0_3._tf:Find("info"),
		arg0_3._tf:Find("power"),
		arg0_3._tf:Find("statistics"),
		arg0_3._tf:Find("greet")
	}

	setText(arg0_3._tf:Find("power/collection_label"), i18n("friend_resume_collection_rate"))
	setText(arg0_3._tf:Find("power/power_label"), i18n("friend_resume_fleet_gs"))
	setText(arg0_3._tf:Find("info/title_name"), i18n("friend_resume_title"))
	setText(arg0_3._tf:Find("statistics/title_name"), i18n("friend_resume_data_title"))
	setText(arg0_3._tf:Find("greet/InputField/Placeholder"), i18n("player_manifesto_placeholder"))
	arg0_3:MatchResolution()
end

function var0_0.PreCalcAspect(arg0_4, arg1_4)
	return arg0_4.rect.height / arg1_4
end

function var0_0.MatchResolution(arg0_5)
	local var0_5 = var0_0.PreCalcAspect(arg0_5._parentTf, arg0_5._tf.rect.height)

	arg0_5._tf.localScale = Vector3(var0_5, var0_5, 1)
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6.modityNameBtn, function()
		local var0_7, var1_7 = arg0_6.player:canModifyName()

		if not var0_7 then
			pg.TipsMgr.GetInstance():ShowTips(var1_7)

			return
		end

		arg0_6.contextData.renamePage:ExecuteAction("Show", arg0_6.player)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.copyBtn, function()
		UniPasteBoard.SetClipBoardString(arg0_6.player.id)
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_id_copy_ok"))
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.writeBtn, function()
		activateInputField(arg0_6.inputField)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeAdmira)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.attireBtn, function()
		arg0_6:emit(PlayerVitaeMediator.ON_ATTIRE)
	end, SFX_PANEL)
	setActive(arg0_6.attireBtnTip, underscore.any(getProxy(AttireProxy):needTip(), function(arg0_12)
		return arg0_12 == true
	end))
	onInputEndEdit(arg0_6, arg0_6.inputField, function(arg0_13)
		if wordVer(arg0_13) > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("playerinfo_mask_word"))
			activateInputField(arg0_6.inputField)

			return
		end

		if not arg0_13 or arg0_6.manifesto == arg0_13 then
			return
		end

		arg0_6.manifesto = arg0_13

		arg0_6:emit(PlayerVitaeMediator.CHANGE_MANIFESTO, arg0_13)
	end)
	arg0_6._tf:SetAsFirstSibling()
end

function var0_0.Show(arg0_14, arg1_14, arg2_14)
	var0_0.super.Show(arg0_14)

	arg0_14.player = arg1_14

	arg0_14:UpdateMedals()
	arg0_14:UpdatePower()
	arg0_14:UpdateInfo()
	arg0_14:UpdateStatistics()

	if arg2_14 then
		arg0_14:DoEnterAnimation()
	end
end

function var0_0.DoEnterAnimation(arg0_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.animPanels) do
		local var0_15 = iter1_15.localPosition.x
		local var1_15 = iter0_15 * 0.05
		local var2_15 = 0.2 + (iter0_15 - 1) * 0.05

		iter1_15.localPosition = Vector3(var0_15 + 800, iter1_15.localPosition.y, 0)

		LeanTween.moveLocalX(iter1_15.gameObject, var0_15, var2_15):setDelay(var1_15):setEase(LeanTweenType.easeInOutSine)
	end
end

function var0_0.UpdateMedals(arg0_16)
	local var0_16 = arg0_16.player.displayTrophyList
	local var1_16 = math.min(5, #var0_16)
	local var2_16 = 353
	local var3_16 = 30

	UIItemList.StaticAlign(arg0_16.medalTpl.parent, arg0_16.medalTpl, var1_16, function(arg0_17, arg1_17, arg2_17)
		arg1_17 = arg1_17 + 1

		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = var0_16[arg1_17]
			local var1_17 = var0_17 > 1000000000 and LoveLetterTrophy.New({
				id = var0_17
			}) or Trophy.New({
				id = var0_17
			})
			local var2_17 = arg2_17:Find("icon")
			local var3_17 = arg2_17:Find("now")
			local var4_17 = var1_17:isLoverLetter()

			setActive(var2_17, not var4_17)
			setActive(var3_17, var4_17)

			if var4_17 then
				setLoveLetterMedal(var3_17:Find("medal"), var1_17, {
					hideMark = true
				})
			else
				LoadImageSpriteAsync("medal/s_" .. var1_17:getConfig("icon"), var2_17, true)
			end

			local var5_17 = var2_16 - (arg1_17 - 1) * (var3_16 + arg2_17.sizeDelta.x)

			arg2_17.anchoredPosition = Vector2(var5_17, arg2_17.anchoredPosition.y)
		end
	end)
end

function var0_0.UpdatePower(arg0_18)
	local var0_18 = getProxy(MilitaryExerciseProxy):RawGetSeasonInfo()
	local var1_18 = SeasonInfo.getEmblem(var0_18.score, var0_18.rank)

	LoadSpriteAsync("emblem/" .. var1_18, function(arg0_19)
		arg0_18.emblemIcon.sprite = arg0_19

		arg0_18.emblemIcon:SetNativeSize()
	end)
	LoadSpriteAsync("emblem/n_" .. var1_18, function(arg0_20)
		if arg0_18.exited then
			return
		end

		arg0_18.emblemTxt.sprite = arg0_20

		arg0_18.emblemTxt:SetNativeSize()
	end)

	local var2_18 = math.max(arg0_18.player.maxRank, 1)
	local var3_18 = pg.arena_data_rank[math.min(var2_18, 14)]

	arg0_18.highestEmblem.text = i18n("friend_resume_title_metal") .. var3_18.name

	getProxy(BayProxy):GetBayPowerRootedAsyn(function(arg0_21)
		if arg0_18.exited then
			return
		end

		arg0_18.powerTxt.text = math.floor(arg0_21)
	end)

	arg0_18.collectionTxt.text = getProxy(CollectionProxy):getCollectionRate() * 100 .. "%"
end

function var0_0.UpdateInfo(arg0_22)
	arg0_22.nameTxt.text = arg0_22.player.name
	arg0_22.idTxt.text = arg0_22.player.id
	arg0_22.levelTxt.text = "LV." .. arg0_22.player.level

	local var0_22 = getConfigFromLevel1(pg.user_level, arg0_22.player.level).exp

	arg0_22.expTxt.text = arg0_22.player.exp .. "/" .. var0_22

	local var1_22 = arg0_22.player:GetManifesto()

	setInputText(arg0_22.inputField, var1_22)
end

function var0_0.UpdateStatistics(arg0_23)
	local var0_23 = arg0_23:GetDisplayStatisticsData()
	local var1_23 = 2
	local var2_23 = Vector2(355, 25)
	local var3_23 = arg0_23.statisticTpl.anchoredPosition
	local var4_23 = arg0_23.statisticTpl.sizeDelta.x

	for iter0_23 = 1, #var0_23, var1_23 do
		local var5_23 = var3_23.y - (iter0_23 - 1) * var2_23.y

		for iter1_23 = 1, var1_23 do
			local var6_23 = iter1_23 == 1 and iter0_23 == 1 and arg0_23.statisticTpl or cloneTplTo(arg0_23.statisticTpl, arg0_23.statisticTpl.parent)
			local var7_23 = var0_23[iter0_23 + (iter1_23 - 1)]

			setText(var6_23, i18n(var7_23[1]))
			setText(var6_23:Find("value"), var7_23[2])

			local var8_23 = var3_23.x + (iter1_23 - 1) * var2_23.x

			var6_23.anchoredPosition = Vector2(var8_23, var5_23)
		end
	end
end

function var0_0.GetDisplayStatisticsData(arg0_24)
	local var0_24 = arg0_24.player
	local var1_24 = string.format("%0.1f", var0_24.winCount / math.max(var0_24.attackCount, 1) * 100) .. "%"
	local var2_24 = string.format("%0.1f", var0_24.pvp_win_count / math.max(var0_24.pvp_attack_count, 1) * 100) .. "%"

	return {
		{
			"friend_resume_ship_count",
			var0_24.shipCount
		},
		{
			"friend_event_count",
			var0_24.collect_attack_count
		},
		{
			"friend_resume_attack_count",
			var0_24.attackCount
		},
		{
			"friend_resume_manoeuvre_count",
			var0_24.pvp_attack_count
		},
		{
			"friend_resume_attack_win_rate",
			var1_24
		},
		{
			"friend_resume_manoeuvre_win_rate",
			var2_24
		}
	}
end

function var0_0.OnDestroy(arg0_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.animPanels) do
		if LeanTween.isTweening(iter1_25.gameObject) then
			LeanTween.cancel(iter1_25.gameObject)
		end
	end

	eachChild(arg0_25.medalTpl.parent, function(arg0_26, arg1_26)
		if arg0_26:Find("now/medal").childCount > 0 then
			returnLoveLetterMedal(arg0_26:Find("now/medal"):GetChild(0))
		end
	end)

	arg0_25.exited = true
end

return var0_0
