local var0_0 = class("ShipProfileInformationPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ShipProfileInformationPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.voiceActor = arg0_2:findTF("bg/author_panel/cvPanel/label/mask/Text"):GetComponent("ScrollText")
	arg0_2.illustrator = arg0_2:findTF("bg/author_panel/illustPanel/illustrator/label/mask/Text"):GetComponent("ScrollText")
	arg0_2.cvContainer = arg0_2:findTF("bg/lines_panel/lines_list/Grid")
	arg0_2.cvTpl = arg0_2:getTpl("bg/lines_panel/lines_list/Grid/lines_tpl")
	arg0_2.weddingReview = arg0_2:findTF("bg/wedding")
	arg0_2.voiceBtn = arg0_2:findTF("bg/language_change")
	arg0_2.voiceBtnSel = arg0_2.voiceBtn:Find("sel")
	arg0_2.voiceBtnUnsel = arg0_2.voiceBtn:Find("unsel")
	arg0_2.voiceBtnPositions = {
		arg0_2.voiceBtnSel.localPosition,
		arg0_2.voiceBtnUnsel.localPosition
	}
	arg0_2.voiceBtnTxt = arg0_2.voiceBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_2.voiceBtnTxt1 = arg0_2.voiceBtn:Find("Text1"):GetComponent(typeof(Text))
	arg0_2.profilePlayBtn = arg0_2:findTF("bg/prototype_panel/title/playButton")
	arg0_2.profileTxt = arg0_2:findTF("bg/prototype_panel/desc/scroll/Text"):GetComponent(typeof(Text))
end

function var0_0.UpdateCvBtn(arg0_3, arg1_3)
	local var0_3 = arg0_3.voiceBtnPositions[arg1_3 and 2 or 1]
	local var1_3 = arg0_3.voiceBtnPositions[arg1_3 and 1 or 2]

	arg0_3.voiceBtnSel.localPosition = var0_3
	arg0_3.voiceBtnUnsel.localPosition = var1_3

	local var2_3 = Color.New(1, 1, 1, 1)
	local var3_3 = Color.New(0.5, 0.5, 0.5, 1)

	arg0_3.voiceBtnTxt.color = arg1_3 and var2_3 or var3_3
	arg0_3.voiceBtnTxt1.color = arg1_3 and var3_3 or var2_3
end

function var0_0.UpdateLang2(arg0_4)
	local var0_4 = arg0_4.skin.ship_group
	local var1_4 = ShipGroup.getDefaultSkin(var0_4)
	local var2_4 = pg.ship_skin_words[var1_4.id]

	PlayerPrefs.SetInt(CV_LANGUAGE_KEY .. var0_4, 2)
	arg0_4.cvLoader:Load(arg0_4.skin.id)
	arg0_4:SetAuthorInfo()
	arg0_4:UpdateCvList(arg0_4.isLive2d)
	arg0_4:UpdateProfileInfo()
end

function var0_0.UpdateLang1(arg0_5)
	local var0_5 = arg0_5.skin.ship_group
	local var1_5 = ShipGroup.getDefaultSkin(var0_5)
	local var2_5 = pg.ship_skin_words[var1_5.id]

	PlayerPrefs.SetInt(CV_LANGUAGE_KEY .. var0_5, 1)
	arg0_5.cvLoader:Load(arg0_5.skin.id)
	arg0_5:SetAuthorInfo()
	arg0_5:UpdateCvList(arg0_5.isLive2d)
	arg0_5:UpdateProfileInfo()
end

function var0_0.OnCvBtn(arg0_6, arg1_6)
	local var0_6 = arg1_6

	onButton(arg0_6, arg0_6.voiceBtn, function()
		var0_6 = not var0_6

		arg0_6:UpdateCvBtn(var0_6)

		if var0_6 then
			arg0_6:UpdateLang2()
		else
			arg0_6:UpdateLang1()
		end
	end, SFX_PANEL)
	arg0_6:UpdateCvBtn(var0_6)
end

function var0_0.OnInit(arg0_8)
	onButton(arg0_8, arg0_8.weddingReview, function()
		arg0_8:emit(ShipProfileScene.WEDDING_REVIEW, {
			group = arg0_8.shipGroup,
			skinID = arg0_8.skin.id
		})
	end, SFX_PANEL)
end

function var0_0.EnterAnim(arg0_10, arg1_10, arg2_10)
	LeanTween.moveX(rtf(arg0_10._tf), 0, arg1_10):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg2_10))
end

function var0_0.ExistAnim(arg0_11, arg1_11, arg2_11)
	LeanTween.moveX(rtf(arg0_11._tf), 1000, arg1_11):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		if arg2_11 then
			arg2_11()
		end

		arg0_11:Hide()
	end))
end

function var0_0.Update(arg0_13, arg1_13, arg2_13, arg3_13)
	arg0_13:Show()

	arg0_13.shipGroup = arg1_13
	arg0_13.showTrans = arg2_13

	setActive(arg0_13.weddingReview, arg1_13.married == 1)

	if isActive(arg0_13.weddingReview) then
		local var0_13 = arg1_13:getProposeType()

		eachChild(arg0_13.weddingReview, function(arg0_14)
			setActive(arg0_14, arg0_14.name == var0_13)
		end)
	end

	if arg3_13 then
		arg3_13()
	end
end

function var0_0.Flush(arg0_15, arg1_15, arg2_15)
	if arg0_15.skin and arg0_15.skin.id == arg1_15.id and arg0_15.isLive2d == arg2_15 then
		return
	end

	arg0_15.skin = arg1_15
	arg0_15.isLive2d = arg2_15

	arg0_15:SetAuthorInfo()
	arg0_15:SetIllustrator()
	arg0_15:UpdateLanguage()
	arg0_15:UpdateProfileInfo()
	arg0_15:UpdateCvList(arg2_15)
	arg0_15.cvLoader:Load(arg0_15.skin.id)
end

function var0_0.UpdateProfileInfo(arg0_16)
	local var0_16, var1_16, var2_16 = ShipWordHelper.GetWordAndCV(arg0_16.skin.id, ShipWordHelper.WORD_TYPE_PROFILE)

	arg0_16.profileTxt.text = SwitchSpecialChar(var2_16, true)

	local var3_16 = pg.ship_skin_words[arg0_16.skin.id]
	local var4_16 = var3_16 and (var3_16.voice_key >= 0 or var3_16.voice_key == -2) or var3_16.voice_key_2 > 0 and var3_16.voice_key < 0

	if var4_16 then
		onButton(arg0_16, arg0_16.profilePlayBtn, function()
			arg0_16.cvLoader:PlaySound(var1_16)
		end, SFX_PANEL)
	end

	setActive(arg0_16.profilePlayBtn, var4_16)
end

function var0_0.SetCvLoader(arg0_18, arg1_18)
	arg0_18.cvLoader = arg1_18
end

function var0_0.SetCallback(arg0_19, arg1_19)
	arg0_19.callback = arg1_19
end

function var0_0.UpdateLanguage(arg0_20)
	local var0_20 = arg0_20.skin.ship_group
	local var1_20 = ShipGroup.getDefaultSkin(var0_20)
	local var2_20 = pg.ship_skin_words[var1_20.id]
	local var3_20 = ShipWordHelper.GetLanguageSetting(var1_20.id)
	local var4_20 = var2_20.voice_key_2 >= 0 or var2_20.voice_key_2 == -2

	if var2_20.voice_key_2 >= 0 and var3_20 == 0 then
		var3_20 = pg.gameset.language_default.key_value

		PlayerPrefs.SetInt(CV_LANGUAGE_KEY .. var0_20, var3_20)
	end

	arg0_20:OnCvBtn(var3_20 == 2)

	if var2_20.voice_key_2 >= 0 or var2_20.voice_key_2 == -2 then
		local var5_20 = var2_20.voice_key_2 % 10
		local var6_20 = ""

		if var5_20 == 2 then
			var6_20 = i18n("word_chinese")
		elseif var5_20 == 3 then
			var6_20 = i18n("word_japanese_2")
		end

		arg0_20.voiceBtnTxt.text = var6_20
		arg0_20.voiceBtnTxt1.text = i18n("word_japanese")
	end

	setActive(arg0_20.voiceBtn, var4_20)
end

function var0_0.SetAuthorInfo(arg0_21)
	local var0_21 = arg0_21.skin
	local var1_21 = ShipWordHelper.GetCVAuthor(var0_21.id)

	print(var1_21 .. "  ----")
	arg0_21.voiceActor:SetText(var1_21)
end

function var0_0.SetIllustrator(arg0_22)
	local var0_22 = arg0_22.shipGroup:GetNationTxt()

	print(var0_22)
	arg0_22.illustrator:SetText(var0_22)
end

function var0_0.GetCvList(arg0_23, arg1_23)
	local var0_23 = {}

	if arg1_23 then
		if pg.ship_skin_template[arg0_23.skin.id].spine_use_live2d == 1 then
			var0_23 = pg.AssistantInfo.GetCVListForProfile(true)
		else
			var0_23 = pg.AssistantInfo.GetCVListForProfile()
		end
	else
		var0_23 = ShipWordHelper.GetCVList()
	end

	return var0_23
end

function var0_0.UpdateCvList(arg0_24, arg1_24)
	arg0_24:DestroyCvBtns()

	arg0_24.cvBtns = {}
	arg0_24.dispalys = arg0_24:GetCvList(arg1_24)

	table.sort(arg0_24.dispalys, function(arg0_25, arg1_25)
		return arg0_25.profile_index < arg1_25.profile_index
	end)

	for iter0_24, iter1_24 in ipairs(arg0_24.dispalys) do
		arg0_24:AddCvBtn(iter1_24)
		arg0_24:AddExCvBtn(iter1_24)
	end

	local var0_24 = (pg.character_voice.touch.profile_index - 1) * 2
	local var1_24 = arg0_24.cvBtns[var0_24]

	var0_24 = var1_24 and var1_24._tf:GetSiblingIndex() or var0_24

	local var2_24 = ShipWordHelper.GetMainSceneWordCnt(arg0_24.skin.id, -1)
	local var3_24 = arg0_24.shipGroup:GetMaxIntimacy()
	local var4_24 = ShipWordHelper.GetMainSceneWordCnt(arg0_24.skin.id, var3_24)

	if var2_24 < var4_24 then
		for iter2_24 = var2_24 + 1, var4_24 do
			arg0_24:AddMainExBtn(iter2_24, var0_24)

			var0_24 = var0_24 + 1
		end
	end
end

function var0_0.AddMainExBtn(arg0_26, arg1_26, arg2_26)
	local var0_26 = ShipProfileMainExCvBtn.New(cloneTplTo(arg0_26.cvTpl, arg0_26.cvContainer))

	onButton(arg0_26, var0_26._tf, function()
		if arg0_26.callback then
			arg0_26.callback(var0_26)
		end
	end, SFX_PANEL)
	var0_26:Init(arg0_26.shipGroup, arg0_26.skin, arg0_26.isLive2d, arg1_26)
	var0_26:Update()
	var0_26._tf:SetSiblingIndex(arg2_26)
	table.insert(arg0_26.cvBtns, var0_26)
end

function var0_0.AddCvBtn(arg0_28, arg1_28)
	local var0_28 = ShipProfileCvBtn.New(cloneTplTo(arg0_28.cvTpl, arg0_28.cvContainer))

	onButton(arg0_28, var0_28._tf, function()
		if arg0_28.callback then
			arg0_28.callback(var0_28)
		end
	end, SFX_PANEL)
	var0_28:Init(arg0_28.shipGroup, arg0_28.skin, arg0_28.isLive2d, arg1_28)
	var0_28:Update()
	table.insert(arg0_28.cvBtns, var0_28)
end

function var0_0.AddExCvBtn(arg0_30, arg1_30)
	local var0_30 = ShipProfileExCvBtn.New(cloneTplTo(arg0_30.cvTpl, arg0_30.cvContainer))

	onButton(arg0_30, var0_30._tf, function()
		if arg0_30.callback then
			arg0_30.callback(var0_30)
		end
	end, SFX_PANEL)

	local var1_30 = arg0_30.shipGroup:GetMaxIntimacy()

	var0_30:Init(arg0_30.shipGroup, arg0_30.skin, arg0_30.isLive2d, arg1_30, var1_30)
	var0_30:Update()
	table.insert(arg0_30.cvBtns, var0_30)
end

function var0_0.DestroyCvBtns(arg0_32)
	if not arg0_32.cvBtns then
		return
	end

	for iter0_32, iter1_32 in ipairs(arg0_32.cvBtns) do
		iter1_32:Destroy()
	end
end

function var0_0.OnDestroy(arg0_33)
	arg0_33:DestroyCvBtns()

	arg0_33.cvLoader = nil
	arg0_33.callback = nil
end

return var0_0
