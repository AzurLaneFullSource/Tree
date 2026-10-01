local var0_0 = class("EducateCharProfileScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateCharProfileUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/educatecharprofileui",
		"cue/story-richang-8.b"
	}

	local function var1_2()
		local var0_3 = {}

		for iter0_3, iter1_3 in ipairs(pg.secretary_special_ship.all) do
			local var1_3 = pg.secretary_special_ship[iter1_3].painting

			if var1_3 then
				table.insert(var0_3, "painting/" .. var1_3)
				table.insert(var0_3, "paintingface/" .. var1_3)
			end
		end

		return var0_3
	end

	return ResPathSupport.MergeLuaArr(var0_2, var1_2())
end

function var0_0.init(arg0_4)
	arg0_4.backBtn = arg0_4._tf:Find("adapt/top/back")
	arg0_4.homeBtn = arg0_4._tf:Find("adapt/top/home")
	arg0_4.paintingTr = arg0_4._tf:Find("main/mask/painting")
	arg0_4.chatTf = arg0_4._tf:Find("main/chat")
	arg0_4.chatTxt = arg0_4.chatTf:Find("Text"):GetComponent(typeof(Text))
	arg0_4.toggleUIItemList = UIItemList.New(arg0_4._tf:Find("main/tag"), arg0_4._tf:Find("main/tag/tpl"))
	arg0_4.wordUIItemList = UIItemList.New(arg0_4._tf:Find("main/list/content"), arg0_4._tf:Find("main/list/content/tpl"))
	arg0_4.tabItemList = UIItemList.New(arg0_4._tf:Find("tab/list"), arg0_4._tf:Find("tab/list/tpl"))
	arg0_4.cvLoader = EducateCharCvLoader.New()
	arg0_4.animation = arg0_4._tf:GetComponent(typeof(Animation))
	arg0_4.timers = {}
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.backBtn, function()
		arg0_5:emit(var0_0.ON_BACK)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.homeBtn, function()
		arg0_5:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	arg0_5:InitTabs()
	arg0_5:InitToggles()
end

function var0_0.InitTabs(arg0_8)
	arg0_8.characterList = NewEducateHelper.GetEducateCharacterList()
	arg0_8.selectedCharacterId = arg0_8.contextData.selectedCharacterId

	arg0_8.tabItemList:make(function(arg0_9, arg1_9, arg2_9)
		local var0_9 = arg1_9 + 1
		local var1_9 = arg0_8.characterList[var0_9]

		if arg0_9 == UIItemList.EventUpdate then
			setActive(arg2_9:Find("lock"), var1_9:IsLock())
			setActive(arg2_9:Find("border/selected"), var0_9 == arg0_8.selectedCharacterId)
			setActive(arg2_9:Find("border/normal"), var0_9 ~= arg0_8.selectedCharacterId)
		elseif arg0_9 == UIItemList.EventInit then
			GetImageSpriteFromAtlasAsync("qicon/" .. var1_9:GetDefaultFrame(), "", arg2_9:Find("frame"))
			onButton(arg0_8, arg2_9, function()
				if var1_9:IsLock() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_special_character_unlock"))

					return
				end

				if var0_9 ~= arg0_8.selectedCharacterId then
					arg0_8.selectedCharacterId = var0_9

					arg0_8.tabItemList:align(#arg0_8.characterList)
					arg0_8:InitToggles()
				end
			end)
		end
	end)
	arg0_8.tabItemList:align(#arg0_8.characterList)
end

function var0_0.InitToggles(arg0_11)
	local var0_11 = arg0_11.characterList[arg0_11.selectedCharacterId]:GetGroupList()

	table.sort(var0_11, function(arg0_12, arg1_12)
		return arg0_12:GetSortWeight() < arg1_12:GetSortWeight()
	end)
	arg0_11.toggleUIItemList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			arg0_11:UpdateToggle(arg2_13, var0_11[arg1_13 + 1])

			if arg1_13 == 0 then
				arg0_11.isInit = true

				triggerToggle(arg2_13, true)
			end
		end
	end)
	arg0_11.toggleUIItemList:align(#var0_11)

	arg0_11.isInit = false
end

function var0_0.UpdateToggle(arg0_14, arg1_14, arg2_14)
	setImageSprite(arg1_14:Find("sel/Text"), GetSpriteFromAtlas("ui/EducateCharProfileUI_atlas", arg2_14:GetSpriteName()), true)
	setImageSprite(arg1_14:Find("Text"), GetSpriteFromAtlas("ui/EducateCharProfileUI_atlas", arg2_14:GetSpriteName()), true)
	setActive(arg1_14:Find("lock"), arg2_14:IsLock())
	onToggle(arg0_14, arg1_14, function(arg0_15)
		if arg0_15 then
			if not arg0_14.isInit then
				arg0_14.animation:Play("anim_educate_profile_change")

				arg0_14.isInit = nil
			end

			local var0_15 = arg2_14:GetShowId()

			arg0_14:ClearCurrentWord()
			arg0_14:InitPainting(var0_15)
			arg0_14:InitWordList(var0_15)
		end
	end, SFX_PANEL)
end

function var0_0.GetWordList(arg0_16, arg1_16)
	local var0_16 = {}

	for iter0_16, iter1_16 in ipairs(pg.character_voice_special.all) do
		local var1_16 = iter1_16

		if string.find(iter1_16, ShipWordHelper.WORD_TYPE_MAIN) then
			local var2_16 = string.gsub(iter1_16, ShipWordHelper.WORD_TYPE_MAIN, "")

			var1_16 = ShipWordHelper.WORD_TYPE_MAIN .. "_" .. var2_16
		end

		if EducateCharWordHelper.ExistWord(arg1_16, var1_16) then
			table.insert(var0_16, iter1_16)
		end
	end

	return var0_16
end

function var0_0.InitWordList(arg0_17, arg1_17)
	local var0_17 = arg0_17:GetWordList(arg1_17)
	local var1_17 = pg.secretary_special_ship[arg1_17]

	arg0_17:RemoveAllTimer()
	arg0_17.wordUIItemList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			arg0_17:UpdateWordCard(arg2_18, arg1_17, var0_17[arg1_18 + 1], arg1_18)
		end
	end)
	arg0_17.wordUIItemList:align(#var0_17)
end

function var0_0.UpdateWordCard(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	local var0_19 = arg1_19:Find("bg")
	local var1_19 = pg.character_voice_special[arg3_19]

	setText(var0_19:Find("Text"), var1_19.voice_name)

	local var2_19 = -1

	onButton(arg0_19, var0_19, function()
		if arg0_19.chatting then
			return
		end

		local var0_20, var1_20, var2_20, var3_20 = EducateCharWordHelper.GetWordAndCV(arg2_19, var1_19.resource_key)

		seriesAsync({
			function(arg0_21)
				arg0_19:OnChatStart(var0_19, var2_20, arg0_21)
			end,
			function(arg0_22)
				arg0_19:UpdateExpression(arg2_19, var1_19.resource_key)
				arg0_19:PlayCV(var3_20, var0_20, function(arg0_23)
					var2_19 = arg0_23

					arg0_22()
				end)
			end,
			function(arg0_24)
				arg0_19:StartCharAnimation(var2_19, arg0_24)
			end
		}, function()
			arg0_19:OnChatEnd()
		end)
	end, SFX_PANEL)
	setActive(var0_19, false)

	arg0_19.timers[arg4_19] = Timer.New(function()
		setActive(var0_19, true)
		arg1_19:GetComponent(typeof(Animation)):Play("anim_educate_profile_tpl")
	end, math.max(1e-05, arg4_19 * 0.066), 1)

	arg0_19.timers[arg4_19]:Start()
end

function var0_0.RemoveAllTimer(arg0_27)
	for iter0_27, iter1_27 in pairs(arg0_27.timers) do
		iter1_27:Stop()

		iter1_27 = nil
	end

	arg0_27.timers = {}
end

function var0_0.OnChatStart(arg0_28, arg1_28, arg2_28, arg3_28)
	arg0_28.chatting = true
	arg0_28.chatTxt.text = arg2_28

	triggerToggle(arg1_28:Find("state"), true)

	arg0_28.selectedCard = arg1_28

	arg3_28()
end

function var0_0.UpdateExpression(arg0_29, arg1_29, arg2_29)
	local var0_29 = EducateCharWordHelper.GetExpression(arg1_29, arg2_29)

	if var0_29 and var0_29 ~= "" then
		ShipExpressionHelper.UpdateExpression(findTF(arg0_29.paintingTr, "fitter"):GetChild(0), arg0_29.paintingName, var0_29)
	else
		ShipExpressionHelper.UpdateExpression(findTF(arg0_29.paintingTr, "fitter"):GetChild(0), arg0_29.paintingName, "")
	end
end

function var0_0.OnChatEnd(arg0_30)
	arg0_30:ClearCurrentWord()
end

function var0_0.PlayCV(arg0_31, arg1_31, arg2_31, arg3_31)
	arg0_31.cvLoader:Play(arg1_31, arg2_31, 0, arg3_31)
end

function var0_0.StartCharAnimation(arg0_32, arg1_32, arg2_32)
	local var0_32 = 0.3
	local var1_32 = arg1_32 > 0 and arg1_32 or 3

	LeanTween.scale(rtf(arg0_32.chatTf.gameObject), Vector3.New(1, 1, 1), var0_32):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_32.chatTf.gameObject), Vector3.New(0, 0, 1), var0_32):setEase(LeanTweenType.easeInBack):setDelay(var0_32 + var1_32):setOnComplete(System.Action(arg2_32))
	end))
end

function var0_0.InitPainting(arg0_34, arg1_34)
	arg0_34:ReturnPainting()

	local var0_34 = pg.secretary_special_ship[arg1_34]

	setPaintingPrefabAsync(arg0_34.paintingTr, var0_34.painting, "tb3")

	arg0_34.paintingName = var0_34.painting
end

function var0_0.ReturnPainting(arg0_35)
	if arg0_35.paintingName then
		retPaintingPrefab(arg0_35.paintingTr, arg0_35.paintingName)

		arg0_35.paintingName = nil
	end
end

function var0_0.ClearCurrentWord(arg0_36)
	arg0_36.chatting = nil

	LeanTween.cancel(arg0_36.chatTf.gameObject)

	arg0_36.chatTf.localScale = Vector3.zero

	arg0_36.cvLoader:Stop()

	if not arg0_36.selectedCard then
		return
	end

	local var0_36 = arg0_36.selectedCard

	arg0_36.selectedCard = nil

	triggerToggle(var0_36:Find("state"), false)
end

function var0_0.onBackPressed(arg0_37)
	var0_0.super.onBackPressed(arg0_37)
end

function var0_0.willExit(arg0_38)
	arg0_38:ClearCurrentWord()
	arg0_38:RemoveAllTimer()
	arg0_38:ReturnPainting()

	if arg0_38.cvLoader then
		arg0_38.cvLoader:Dispose()

		arg0_38.cvLoader = nil
	end
end

return var0_0
