local var0_0 = class("EducateCharProfileScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateCharProfileUI"
end

function var0_0.init(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("adapt/top/back")
	arg0_2.homeBtn = arg0_2:findTF("adapt/top/home")
	arg0_2.paintingTr = arg0_2:findTF("main/mask/painting")
	arg0_2.chatTf = arg0_2:findTF("main/chat")
	arg0_2.chatTxt = arg0_2.chatTf:Find("Text"):GetComponent(typeof(Text))
	arg0_2.toggleUIItemList = UIItemList.New(arg0_2:findTF("main/tag"), arg0_2:findTF("main/tag/tpl"))
	arg0_2.wordUIItemList = UIItemList.New(arg0_2:findTF("main/list/content"), arg0_2:findTF("main/list/content/tpl"))
	arg0_2.tabItemList = UIItemList.New(arg0_2:findTF("tab/list"), arg0_2:findTF("tab/list/tpl"))
	arg0_2.cvLoader = EducateCharCvLoader.New()
	arg0_2.animation = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.timers = {}
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.homeBtn, function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	arg0_3:InitTabs()
	arg0_3:InitToggles()
end

function var0_0.InitTabs(arg0_6)
	arg0_6.characterList = NewEducateHelper.GetEducateCharacterList()
	arg0_6.selectedCharacterId = arg0_6.contextData.selectedCharacterId

	arg0_6.tabItemList:make(function(arg0_7, arg1_7, arg2_7)
		local var0_7 = arg1_7 + 1
		local var1_7 = arg0_6.characterList[var0_7]

		if arg0_7 == UIItemList.EventUpdate then
			setActive(arg2_7:Find("lock"), var1_7:IsLock())
			setActive(arg2_7:Find("border/selected"), var0_7 == arg0_6.selectedCharacterId)
			setActive(arg2_7:Find("border/normal"), var0_7 ~= arg0_6.selectedCharacterId)
		elseif arg0_7 == UIItemList.EventInit then
			GetImageSpriteFromAtlasAsync("qicon/" .. var1_7:GetDefaultFrame(), "", arg2_7:Find("frame"))
			onButton(arg0_6, arg2_7, function()
				if var1_7:IsLock() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_special_character_unlock"))

					return
				end

				if var0_7 ~= arg0_6.selectedCharacterId then
					arg0_6.selectedCharacterId = var0_7

					arg0_6.tabItemList:align(#arg0_6.characterList)
					arg0_6:InitToggles()
				end
			end)
		end
	end)
	arg0_6.tabItemList:align(#arg0_6.characterList)
end

function var0_0.InitToggles(arg0_9)
	local var0_9 = arg0_9.characterList[arg0_9.selectedCharacterId]:GetGroupList()

	table.sort(var0_9, function(arg0_10, arg1_10)
		return arg0_10:GetSortWeight() < arg1_10:GetSortWeight()
	end)
	arg0_9.toggleUIItemList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_9:UpdateToggle(arg2_11, var0_9[arg1_11 + 1])

			if arg1_11 == 0 then
				arg0_9.isInit = true

				triggerToggle(arg2_11, true)
			end
		end
	end)
	arg0_9.toggleUIItemList:align(#var0_9)

	arg0_9.isInit = false
end

function var0_0.UpdateToggle(arg0_12, arg1_12, arg2_12)
	setImageSprite(arg1_12:Find("sel/Text"), GetSpriteFromAtlas("ui/EducateCharProfileUI_atlas", arg2_12:GetSpriteName()), true)
	setImageSprite(arg1_12:Find("Text"), GetSpriteFromAtlas("ui/EducateCharProfileUI_atlas", arg2_12:GetSpriteName()), true)
	setActive(arg1_12:Find("lock"), arg2_12:IsLock())
	onToggle(arg0_12, arg1_12, function(arg0_13)
		if arg0_13 then
			if not arg0_12.isInit then
				arg0_12.animation:Play("anim_educate_profile_change")

				arg0_12.isInit = nil
			end

			local var0_13 = arg2_12:GetShowId()

			arg0_12:ClearCurrentWord()
			arg0_12:InitPainting(var0_13)
			arg0_12:InitWordList(var0_13)
		end
	end, SFX_PANEL)
end

function var0_0.GetWordList(arg0_14, arg1_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in pairs(pg.character_voice_special.all) do
		local var1_14 = iter1_14

		if string.find(iter1_14, ShipWordHelper.WORD_TYPE_MAIN) then
			local var2_14 = string.gsub(iter1_14, ShipWordHelper.WORD_TYPE_MAIN, "")

			var1_14 = ShipWordHelper.WORD_TYPE_MAIN .. "_" .. var2_14
		end

		if EducateCharWordHelper.ExistWord(arg1_14, var1_14) then
			table.insert(var0_14, iter1_14)
		end
	end

	return var0_14
end

function var0_0.InitWordList(arg0_15, arg1_15)
	local var0_15 = arg0_15:GetWordList(arg1_15)
	local var1_15 = pg.secretary_special_ship[arg1_15]

	arg0_15:RemoveAllTimer()
	arg0_15.wordUIItemList:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			arg0_15:UpdateWordCard(arg2_16, arg1_15, var0_15[arg1_16 + 1], arg1_16)
		end
	end)
	arg0_15.wordUIItemList:align(#var0_15)
end

function var0_0.UpdateWordCard(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	local var0_17 = arg1_17:Find("bg")
	local var1_17 = pg.character_voice_special[arg3_17]

	setText(var0_17:Find("Text"), var1_17.voice_name)

	local var2_17 = -1

	onButton(arg0_17, var0_17, function()
		if arg0_17.chatting then
			return
		end

		local var0_18, var1_18, var2_18, var3_18 = EducateCharWordHelper.GetWordAndCV(arg2_17, var1_17.resource_key)

		seriesAsync({
			function(arg0_19)
				arg0_17:OnChatStart(var0_17, var2_18, arg0_19)
			end,
			function(arg0_20)
				arg0_17:UpdateExpression(arg2_17, var1_17.resource_key)
				arg0_17:PlayCV(var3_18, var0_18, function(arg0_21)
					var2_17 = arg0_21

					arg0_20()
				end)
			end,
			function(arg0_22)
				arg0_17:StartCharAnimation(var2_17, arg0_22)
			end
		}, function()
			arg0_17:OnChatEnd()
		end)
	end, SFX_PANEL)
	setActive(var0_17, false)

	arg0_17.timers[arg4_17] = Timer.New(function()
		setActive(var0_17, true)
		arg1_17:GetComponent(typeof(Animation)):Play("anim_educate_profile_tpl")
	end, math.max(1e-05, arg4_17 * 0.066), 1)

	arg0_17.timers[arg4_17]:Start()
end

function var0_0.RemoveAllTimer(arg0_25)
	for iter0_25, iter1_25 in pairs(arg0_25.timers) do
		iter1_25:Stop()

		iter1_25 = nil
	end

	arg0_25.timers = {}
end

function var0_0.OnChatStart(arg0_26, arg1_26, arg2_26, arg3_26)
	arg0_26.chatting = true
	arg0_26.chatTxt.text = arg2_26

	triggerToggle(arg1_26:Find("state"), true)

	arg0_26.selectedCard = arg1_26

	arg3_26()
end

function var0_0.UpdateExpression(arg0_27, arg1_27, arg2_27)
	local var0_27 = EducateCharWordHelper.GetExpression(arg1_27, arg2_27)

	if var0_27 and var0_27 ~= "" then
		ShipExpressionHelper.UpdateExpression(findTF(arg0_27.paintingTr, "fitter"):GetChild(0), arg0_27.paintingName, var0_27)
	else
		ShipExpressionHelper.UpdateExpression(findTF(arg0_27.paintingTr, "fitter"):GetChild(0), arg0_27.paintingName, "")
	end
end

function var0_0.OnChatEnd(arg0_28)
	arg0_28:ClearCurrentWord()
end

function var0_0.PlayCV(arg0_29, arg1_29, arg2_29, arg3_29)
	arg0_29.cvLoader:Play(arg1_29, arg2_29, 0, arg3_29)
end

function var0_0.StartCharAnimation(arg0_30, arg1_30, arg2_30)
	local var0_30 = 0.3
	local var1_30 = arg1_30 > 0 and arg1_30 or 3

	LeanTween.scale(rtf(arg0_30.chatTf.gameObject), Vector3.New(1, 1, 1), var0_30):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_30.chatTf.gameObject), Vector3.New(0, 0, 1), var0_30):setEase(LeanTweenType.easeInBack):setDelay(var0_30 + var1_30):setOnComplete(System.Action(arg2_30))
	end))
end

function var0_0.InitPainting(arg0_32, arg1_32)
	arg0_32:ReturnPainting()

	local var0_32 = pg.secretary_special_ship[arg1_32]

	setPaintingPrefabAsync(arg0_32.paintingTr, var0_32.painting, "tb3")

	arg0_32.paintingName = var0_32.painting
end

function var0_0.ReturnPainting(arg0_33)
	if arg0_33.paintingName then
		retPaintingPrefab(arg0_33.paintingTr, arg0_33.paintingName)

		arg0_33.paintingName = nil
	end
end

function var0_0.ClearCurrentWord(arg0_34)
	arg0_34.chatting = nil

	LeanTween.cancel(arg0_34.chatTf.gameObject)

	arg0_34.chatTf.localScale = Vector3.zero

	arg0_34.cvLoader:Stop()

	if not arg0_34.selectedCard then
		return
	end

	local var0_34 = arg0_34.selectedCard

	arg0_34.selectedCard = nil

	triggerToggle(var0_34:Find("state"), false)
end

function var0_0.onBackPressed(arg0_35)
	var0_0.super.onBackPressed(arg0_35)
end

function var0_0.willExit(arg0_36)
	arg0_36:ClearCurrentWord()
	arg0_36:RemoveAllTimer()
	arg0_36:ReturnPainting()

	if arg0_36.cvLoader then
		arg0_36.cvLoader:Dispose()

		arg0_36.cvLoader = nil
	end
end

return var0_0
