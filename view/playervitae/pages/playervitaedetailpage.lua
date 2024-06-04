local var0 = class("PlayerVitaeDetailPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "PlayerVitaeDetailPage"
end

function var0.OnPlayerNameChange(arg0, arg1)
	arg0.player = arg1
	arg0.nameTxt.text = arg1.name
end

function var0.OnLoaded(arg0)
	arg0.medalTpl = arg0:findTF("medalList/tpl")
	arg0.emblemIcon = arg0:findTF("power/medal"):GetComponent(typeof(Image))
	arg0.emblemTxt = arg0:findTF("power/medal_text"):GetComponent(typeof(Image))
	arg0.highestEmblem = arg0:findTF("power/rank"):GetComponent(typeof(Text))
	arg0.powerTxt = arg0:findTF("power/power"):GetComponent(typeof(Text))
	arg0.collectionTxt = arg0:findTF("power/collection"):GetComponent(typeof(Text))
	arg0.modityNameBtn = arg0:findTF("info/name")
	arg0.nameTxt = arg0:findTF("info/name/Text"):GetComponent(typeof(Text))
	arg0.idTxt = arg0:findTF("info/uid"):GetComponent(typeof(Text))
	arg0.levelTxt = arg0:findTF("info/level"):GetComponent(typeof(Text))
	arg0.expTxt = arg0:findTF("info/exp"):GetComponent(typeof(Text))
	arg0.statisticTpl = arg0:findTF("statistics/tpl")
	arg0.shareBtn = arg0:findTF("btn_share")
	arg0.attireBtn = arg0:findTF("btn_attire")
	arg0.attireBtnTip = arg0.attireBtn:Find("tip")
	arg0.inputField = arg0:findTF("greet/InputField")
	arg0.writeBtn = arg0:findTF("greet/write_btn")
	arg0.animPanels = {
		arg0:findTF("info"),
		arg0:findTF("power"),
		arg0:findTF("statistics"),
		arg0:findTF("greet")
	}

	setText(arg0:findTF("power/collection_label"), i18n("friend_resume_collection_rate"))
	setText(arg0:findTF("power/power_label"), i18n("friend_resume_fleet_gs"))
	setText(arg0:findTF("info/title_name"), i18n("friend_resume_title"))
	setText(arg0:findTF("statistics/title_name"), i18n("friend_resume_data_title"))
	setText(arg0:findTF("greet/InputField/Placeholder"), i18n("player_manifesto_placeholder"))
	arg0:MatchResolution()
end

function var0.PreCalcAspect(arg0, arg1)
	return arg0.rect.height / arg1
end

function var0.MatchResolution(arg0)
	local var0 = var0.PreCalcAspect(arg0._parentTf, arg0._tf.rect.height)

	arg0._tf.localScale = Vector3(var0, var0, 1)
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.modityNameBtn, function()
		local var0, var1 = arg0.player:canModifyName()

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(var1)

			return
		end

		arg0.contextData.renamePage:ExecuteAction("Show", arg0.player)
	end, SFX_PANEL)
	onButton(arg0, arg0.writeBtn, function()
		activateInputField(arg0.inputField)
	end, SFX_PANEL)
	onButton(arg0, arg0.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeAdmira)
	end, SFX_PANEL)
	onButton(arg0, arg0.attireBtn, function()
		arg0:emit(PlayerVitaeMediator.ON_ATTIRE)
	end, SFX_PANEL)
	setActive(arg0.attireBtnTip, _.any(getProxy(AttireProxy):needTip(), function(arg0)
		return arg0 == true
	end))
	onInputEndEdit(arg0, arg0.inputField, function(arg0)
		if wordVer(arg0) > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("playerinfo_mask_word"))
			activateInputField(arg0.inputField)

			return
		end

		if not arg0 or arg0.manifesto == arg0 then
			return
		end

		arg0.manifesto = arg0

		arg0:emit(PlayerVitaeMediator.CHANGE_MANIFESTO, arg0)
	end)
	arg0._tf:SetAsFirstSibling()
end

function var0.Show(arg0, arg1, arg2)
	var0.super.Show(arg0)

	arg0.player = arg1

	arg0:UpdateMedals()
	arg0:UpdatePower()
	arg0:UpdateInfo()
	arg0:UpdateStatistics()

	if arg2 then
		arg0:DoEnterAnimation()
	end
end

function var0.DoEnterAnimation(arg0)
	for iter0, iter1 in ipairs(arg0.animPanels) do
		local var0 = iter1.localPosition.x
		local var1 = iter0 * 0.05
		local var2 = 0.2 + (iter0 - 1) * 0.05

		iter1.localPosition = Vector3(var0 + 800, iter1.localPosition.y, 0)

		LeanTween.moveLocalX(iter1.gameObject, var0, var2):setDelay(var1):setEase(LeanTweenType.easeInOutSine)
	end
end

function var0.UpdateMedals(arg0)
	local var0 = arg0.player.displayTrophyList
	local var1 = math.min(5, #var0)
	local var2 = 353
	local var3 = 30

	for iter0 = 1, var1 do
		local var4 = iter0 == 1 and arg0.medalTpl or cloneTplTo(arg0.medalTpl, arg0.medalTpl.parent)
		local var5 = pg.medal_template[var0[var1 - iter0 + 1]]

		LoadSpriteAsync("medal/s_" .. var5.icon, function(arg0)
			if arg0.exited then
				return
			end

			local var0 = var4:Find("icon"):GetComponent(typeof(Image))

			var0.sprite = arg0

			var0:SetNativeSize()
		end)

		local var6 = var2 - (iter0 - 1) * (var3 + var4.sizeDelta.x)

		var4.anchoredPosition = Vector2(var6, var4.anchoredPosition.y)
	end

	setActive(arg0.medalTpl, var1 ~= 0)
end

function var0.UpdatePower(arg0)
	local var0 = getProxy(MilitaryExerciseProxy):RawGetSeasonInfo()
	local var1 = SeasonInfo.getEmblem(var0.score, var0.rank)

	LoadSpriteAsync("emblem/" .. var1, function(arg0)
		arg0.emblemIcon.sprite = arg0

		arg0.emblemIcon:SetNativeSize()
	end)
	LoadSpriteAsync("emblem/n_" .. var1, function(arg0)
		if arg0.exited then
			return
		end

		arg0.emblemTxt.sprite = arg0

		arg0.emblemTxt:SetNativeSize()
	end)

	local var2 = math.max(arg0.player.maxRank, 1)
	local var3 = pg.arena_data_rank[math.min(var2, 14)]

	arg0.highestEmblem.text = i18n("friend_resume_title_metal") .. var3.name

	getProxy(BayProxy):GetBayPowerRootedAsyn(function(arg0)
		if arg0.exited then
			return
		end

		arg0.powerTxt.text = math.floor(arg0)
	end)

	arg0.collectionTxt.text = getProxy(CollectionProxy):getCollectionRate() * 100 .. "%"
end

function var0.UpdateInfo(arg0)
	arg0.nameTxt.text = arg0.player.name
	arg0.idTxt.text = arg0.player.id
	arg0.levelTxt.text = "LV." .. arg0.player.level

	local var0 = getConfigFromLevel1(pg.user_level, arg0.player.level).exp

	arg0.expTxt.text = arg0.player.exp .. "/" .. var0

	local var1 = arg0.player:GetManifesto()

	setInputText(arg0.inputField, var1)
end

function var0.UpdateStatistics(arg0)
	local var0 = arg0:GetDisplayStatisticsData()
	local var1 = 2
	local var2 = Vector2(355, 25)
	local var3 = arg0.statisticTpl.anchoredPosition
	local var4 = arg0.statisticTpl.sizeDelta.x

	for iter0 = 1, #var0, var1 do
		local var5 = var3.y - (iter0 - 1) * var2.y

		for iter1 = 1, var1 do
			local var6 = iter1 == 1 and iter0 == 1 and arg0.statisticTpl or cloneTplTo(arg0.statisticTpl, arg0.statisticTpl.parent)
			local var7 = var0[iter0 + (iter1 - 1)]

			setText(var6, i18n(var7[1]))
			setText(var6:Find("value"), var7[2])

			local var8 = var3.x + (iter1 - 1) * var2.x

			var6.anchoredPosition = Vector2(var8, var5)
		end
	end
end

function var0.GetDisplayStatisticsData(arg0)
	local var0 = arg0.player
	local var1 = string.format("%0.1f", var0.winCount / math.max(var0.attackCount, 1) * 100) .. "%"
	local var2 = string.format("%0.1f", var0.pvp_win_count / math.max(var0.pvp_attack_count, 1) * 100) .. "%"

	return {
		{
			"friend_resume_ship_count",
			var0.shipCount
		},
		{
			"friend_event_count",
			var0.collect_attack_count
		},
		{
			"friend_resume_attack_count",
			var0.attackCount
		},
		{
			"friend_resume_manoeuvre_count",
			var0.pvp_attack_count
		},
		{
			"friend_resume_attack_win_rate",
			var1
		},
		{
			"friend_resume_manoeuvre_win_rate",
			var2
		}
	}
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in ipairs(arg0.animPanels) do
		if LeanTween.isTweening(iter1.gameObject) then
			LeanTween.cancel(iter1.gameObject)
		end
	end

	arg0.exited = true
end

return var0
