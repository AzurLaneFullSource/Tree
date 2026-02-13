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
	onButton(arg0_6, arg0_6.writeBtn, function()
		activateInputField(arg0_6.inputField)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeAdmira)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.attireBtn, function()
		arg0_6:emit(PlayerVitaeMediator.ON_ATTIRE)
	end, SFX_PANEL)
	setActive(arg0_6.attireBtnTip, underscore.any(getProxy(AttireProxy):needTip(), function(arg0_11)
		return arg0_11 == true
	end))
	onInputEndEdit(arg0_6, arg0_6.inputField, function(arg0_12)
		if wordVer(arg0_12) > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("playerinfo_mask_word"))
			activateInputField(arg0_6.inputField)

			return
		end

		if not arg0_12 or arg0_6.manifesto == arg0_12 then
			return
		end

		arg0_6.manifesto = arg0_12

		arg0_6:emit(PlayerVitaeMediator.CHANGE_MANIFESTO, arg0_12)
	end)
	arg0_6._tf:SetAsFirstSibling()
end

function var0_0.Show(arg0_13, arg1_13, arg2_13)
	var0_0.super.Show(arg0_13)

	arg0_13.player = arg1_13

	arg0_13:UpdateMedals()
	arg0_13:UpdatePower()
	arg0_13:UpdateInfo()
	arg0_13:UpdateStatistics()

	if arg2_13 then
		arg0_13:DoEnterAnimation()
	end
end

function var0_0.DoEnterAnimation(arg0_14)
	for iter0_14, iter1_14 in ipairs(arg0_14.animPanels) do
		local var0_14 = iter1_14.localPosition.x
		local var1_14 = iter0_14 * 0.05
		local var2_14 = 0.2 + (iter0_14 - 1) * 0.05

		iter1_14.localPosition = Vector3(var0_14 + 800, iter1_14.localPosition.y, 0)

		LeanTween.moveLocalX(iter1_14.gameObject, var0_14, var2_14):setDelay(var1_14):setEase(LeanTweenType.easeInOutSine)
	end
end

function var0_0.UpdateMedals(arg0_15)
	local var0_15 = arg0_15.player.displayTrophyList
	local var1_15 = math.min(5, #var0_15)
	local var2_15 = 353
	local var3_15 = 30

	UIItemList.StaticAlign(arg0_15.medalTpl.parent, arg0_15.medalTpl, var1_15, function(arg0_16, arg1_16, arg2_16)
		arg1_16 = arg1_16 + 1

		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = var0_15[arg1_16]
			local var1_16 = var0_16 > 1000000000 and LoveLetterTrophy.New({
				id = var0_16
			}) or Trophy.New({
				id = var0_16
			})
			local var2_16 = arg2_16:Find("icon")
			local var3_16 = arg2_16:Find("now")
			local var4_16 = var1_16:isLoverLetter()

			setActive(var2_16, not var4_16)
			setActive(var3_16, var4_16)

			if var4_16 then
				setLoveLetterMedal(var3_16:Find("medal"), var1_16, {
					hideMark = true
				})
			else
				LoadImageSpriteAsync("medal/s_" .. var1_16:getConfig("icon"), var2_16, true)
			end

			local var5_16 = var2_15 - (arg1_16 - 1) * (var3_15 + arg2_16.sizeDelta.x)

			arg2_16.anchoredPosition = Vector2(var5_16, arg2_16.anchoredPosition.y)
		end
	end)
end

function var0_0.UpdatePower(arg0_17)
	local var0_17 = getProxy(MilitaryExerciseProxy):RawGetSeasonInfo()
	local var1_17 = SeasonInfo.getEmblem(var0_17.score, var0_17.rank)

	LoadSpriteAsync("emblem/" .. var1_17, function(arg0_18)
		arg0_17.emblemIcon.sprite = arg0_18

		arg0_17.emblemIcon:SetNativeSize()
	end)
	LoadSpriteAsync("emblem/n_" .. var1_17, function(arg0_19)
		if arg0_17.exited then
			return
		end

		arg0_17.emblemTxt.sprite = arg0_19

		arg0_17.emblemTxt:SetNativeSize()
	end)

	local var2_17 = math.max(arg0_17.player.maxRank, 1)
	local var3_17 = pg.arena_data_rank[math.min(var2_17, 14)]

	arg0_17.highestEmblem.text = i18n("friend_resume_title_metal") .. var3_17.name

	getProxy(BayProxy):GetBayPowerRootedAsyn(function(arg0_20)
		if arg0_17.exited then
			return
		end

		arg0_17.powerTxt.text = math.floor(arg0_20)
	end)

	arg0_17.collectionTxt.text = getProxy(CollectionProxy):getCollectionRate() * 100 .. "%"
end

function var0_0.UpdateInfo(arg0_21)
	arg0_21.nameTxt.text = arg0_21.player.name
	arg0_21.idTxt.text = arg0_21.player.id
	arg0_21.levelTxt.text = "LV." .. arg0_21.player.level

	local var0_21 = getConfigFromLevel1(pg.user_level, arg0_21.player.level).exp

	arg0_21.expTxt.text = arg0_21.player.exp .. "/" .. var0_21

	local var1_21 = arg0_21.player:GetManifesto()

	setInputText(arg0_21.inputField, var1_21)
end

function var0_0.UpdateStatistics(arg0_22)
	local var0_22 = arg0_22:GetDisplayStatisticsData()
	local var1_22 = 2
	local var2_22 = Vector2(355, 25)
	local var3_22 = arg0_22.statisticTpl.anchoredPosition
	local var4_22 = arg0_22.statisticTpl.sizeDelta.x

	for iter0_22 = 1, #var0_22, var1_22 do
		local var5_22 = var3_22.y - (iter0_22 - 1) * var2_22.y

		for iter1_22 = 1, var1_22 do
			local var6_22 = iter1_22 == 1 and iter0_22 == 1 and arg0_22.statisticTpl or cloneTplTo(arg0_22.statisticTpl, arg0_22.statisticTpl.parent)
			local var7_22 = var0_22[iter0_22 + (iter1_22 - 1)]

			setText(var6_22, i18n(var7_22[1]))
			setText(var6_22:Find("value"), var7_22[2])

			local var8_22 = var3_22.x + (iter1_22 - 1) * var2_22.x

			var6_22.anchoredPosition = Vector2(var8_22, var5_22)
		end
	end
end

function var0_0.GetDisplayStatisticsData(arg0_23)
	local var0_23 = arg0_23.player
	local var1_23 = string.format("%0.1f", var0_23.winCount / math.max(var0_23.attackCount, 1) * 100) .. "%"
	local var2_23 = string.format("%0.1f", var0_23.pvp_win_count / math.max(var0_23.pvp_attack_count, 1) * 100) .. "%"

	return {
		{
			"friend_resume_ship_count",
			var0_23.shipCount
		},
		{
			"friend_event_count",
			var0_23.collect_attack_count
		},
		{
			"friend_resume_attack_count",
			var0_23.attackCount
		},
		{
			"friend_resume_manoeuvre_count",
			var0_23.pvp_attack_count
		},
		{
			"friend_resume_attack_win_rate",
			var1_23
		},
		{
			"friend_resume_manoeuvre_win_rate",
			var2_23
		}
	}
end

function var0_0.OnDestroy(arg0_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.animPanels) do
		if LeanTween.isTweening(iter1_24.gameObject) then
			LeanTween.cancel(iter1_24.gameObject)
		end
	end

	eachChild(arg0_24.medalTpl.parent, function(arg0_25, arg1_25)
		if arg0_25:Find("now/medal").childCount > 0 then
			returnLoveLetterMedal(arg0_25:Find("now/medal"):GetChild(0))
		end
	end)

	arg0_24.exited = true
end

return var0_0
