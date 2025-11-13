local var0_0 = class("ShipProfileInformationPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ShipProfileInformationPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.voiceActor = arg0_2._tf:Find("bg/author_panel/cvPanel/label/mask/Text"):GetComponent("ScrollText")
	arg0_2.illustrator = arg0_2._tf:Find("bg/author_panel/illustPanel/illustrator/label/mask/Text"):GetComponent("ScrollText")
	arg0_2.cvContainer = arg0_2._tf:Find("bg/lines_panel/lines_list/Grid")
	arg0_2.cvTpl = arg0_2:getTpl("bg/lines_panel/lines_list/Grid/lines_tpl")
	arg0_2.weddingReview = arg0_2._tf:Find("bg/wedding")
	arg0_2.voiceBtn = arg0_2._tf:Find("bg/language_change")
	arg0_2.voiceBtnSel = arg0_2.voiceBtn:Find("sel")
	arg0_2.voiceBtnUnsel = arg0_2.voiceBtn:Find("unsel")
	arg0_2.voiceBtnPositions = {
		arg0_2.voiceBtnSel.localPosition,
		arg0_2.voiceBtnUnsel.localPosition
	}
	arg0_2.voiceBtnTxt = arg0_2.voiceBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_2.voiceBtnTxt1 = arg0_2.voiceBtn:Find("Text1"):GetComponent(typeof(Text))
	arg0_2.profilePlayBtn = arg0_2._tf:Find("bg/prototype_panel/title/playButton")
	arg0_2.profileTxt = arg0_2._tf:Find("bg/prototype_panel/desc/scroll/Text"):GetComponent(typeof(Text))
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
	local var2_20 = pg.ship_skin_words[arg0_20.skin.id]
	local var3_20 = setmetatable({}, {
		__index = function(arg0_21, arg1_21)
			if arg1_21 == "voice_key_2" and pg.ship_skin_words[arg0_20.skin.id][arg1_21] == 0 then
				rawset(arg0_21, arg1_21, pg.ship_skin_words[var1_20.id][arg1_21])
			else
				rawset(arg0_21, arg1_21, pg.ship_skin_words[arg0_20.skin.id][arg1_21])
			end

			return arg0_21[arg1_21]
		end
	})
	local var4_20 = ShipWordHelper.GetLanguageSetting(arg0_20.skin.id)
	local var5_20 = var3_20.voice_key_2 >= 0 or var3_20.voice_key_2 == -2

	if var3_20.voice_key_2 >= 0 and var4_20 == 0 then
		var4_20 = pg.gameset.language_default.key_value

		PlayerPrefs.SetInt(CV_LANGUAGE_KEY .. var0_20, var4_20)
	end

	arg0_20:OnCvBtn(var4_20 == 2)

	if var3_20.voice_key_2 >= 0 or var3_20.voice_key_2 == -2 then
		local var6_20 = var3_20.voice_key_2 % 10

		if var6_20 == 2 then
			arg0_20.voiceBtnTxt.text = i18n("word_chinese")
			arg0_20.voiceBtnTxt1.text = i18n("word_japanese")
		elseif var6_20 == 3 then
			arg0_20.voiceBtnTxt.text = i18n("word_japanese_2")
			arg0_20.voiceBtnTxt1.text = i18n("word_japanese_3")
		end
	end

	setActive(arg0_20.voiceBtn, var5_20)
end

function var0_0.SetAuthorInfo(arg0_22)
	local var0_22 = arg0_22.skin
	local var1_22 = ShipWordHelper.GetCVAuthor(var0_22.id)

	print(var1_22 .. "  ----")
	arg0_22.voiceActor:SetText(var1_22)
end

function var0_0.SetIllustrator(arg0_23)
	local var0_23 = arg0_23.shipGroup:GetNationTxt()

	print(var0_23)
	arg0_23.illustrator:SetText(var0_23)
end

function var0_0.GetCvList(arg0_24, arg1_24)
	local var0_24 = {}

	if arg1_24 then
		if pg.ship_skin_template[arg0_24.skin.id].spine_use_live2d == 1 then
			var0_24 = pg.AssistantInfo.GetCVListForProfile(true, arg0_24.skin.id)
		else
			var0_24 = pg.AssistantInfo.GetCVListForProfile(false, arg0_24.skin.id)
		end
	else
		var0_24 = ShipWordHelper.GetCVList()
	end

	return var0_24
end

function var0_0.UpdateCvList(arg0_25, arg1_25)
	arg0_25:DestroyCvBtns()

	arg0_25.cvBtns = {}
	arg0_25.dispalys = arg0_25:GetCvList(arg1_25)

	table.sort(arg0_25.dispalys, function(arg0_26, arg1_26)
		return arg0_26.profile_index < arg1_26.profile_index
	end)

	for iter0_25, iter1_25 in ipairs(arg0_25.dispalys) do
		arg0_25:AddCvBtn(iter1_25)
		arg0_25:AddExCvBtn(iter1_25)
	end

	local var0_25 = (pg.character_voice.touch.profile_index - 1) * 2
	local var1_25 = arg0_25.cvBtns[var0_25]

	var0_25 = var1_25 and var1_25._tf:GetSiblingIndex() or var0_25

	local var2_25 = ShipWordHelper.GetMainSceneWordCnt(arg0_25.skin.id, -1)
	local var3_25 = arg0_25.shipGroup:GetMaxIntimacy()
	local var4_25 = ShipWordHelper.GetMainSceneWordCnt(arg0_25.skin.id, var3_25)

	if var2_25 < var4_25 then
		for iter2_25 = var2_25 + 1, var4_25 do
			arg0_25:AddMainExBtn(iter2_25, var0_25)

			var0_25 = var0_25 + 1
		end
	end
end

function var0_0.AddMainExBtn(arg0_27, arg1_27, arg2_27)
	local var0_27 = ShipProfileMainExCvBtn.New(cloneTplTo(arg0_27.cvTpl, arg0_27.cvContainer))

	onButton(arg0_27, var0_27._tf, function()
		if arg0_27.callback then
			arg0_27.callback(var0_27)
		end
	end, SFX_PANEL)
	var0_27:Init(arg0_27.shipGroup, arg0_27.skin, arg0_27.isLive2d, arg1_27)
	var0_27:Update()
	var0_27._tf:SetSiblingIndex(arg2_27)
	table.insert(arg0_27.cvBtns, var0_27)
end

function var0_0.AddCvBtn(arg0_29, arg1_29)
	local var0_29 = ShipProfileCvBtn.New(cloneTplTo(arg0_29.cvTpl, arg0_29.cvContainer))

	onButton(arg0_29, var0_29._tf, function()
		if arg0_29.callback then
			arg0_29.callback(var0_29)
		end
	end, SFX_PANEL)
	var0_29:Init(arg0_29.shipGroup, arg0_29.skin, arg0_29.isLive2d, arg1_29)
	var0_29:Update()
	table.insert(arg0_29.cvBtns, var0_29)
end

function var0_0.AddExCvBtn(arg0_31, arg1_31)
	local var0_31 = ShipProfileExCvBtn.New(cloneTplTo(arg0_31.cvTpl, arg0_31.cvContainer))

	onButton(arg0_31, var0_31._tf, function()
		if arg0_31.callback then
			arg0_31.callback(var0_31)
		end
	end, SFX_PANEL)

	local var1_31 = arg0_31.shipGroup:GetMaxIntimacy()

	var0_31:Init(arg0_31.shipGroup, arg0_31.skin, arg0_31.isLive2d, arg1_31, var1_31)
	var0_31:Update()
	table.insert(arg0_31.cvBtns, var0_31)
end

function var0_0.DestroyCvBtns(arg0_33)
	if not arg0_33.cvBtns then
		return
	end

	for iter0_33, iter1_33 in ipairs(arg0_33.cvBtns) do
		iter1_33:Destroy()
	end
end

function var0_0.OnDestroy(arg0_34)
	arg0_34:DestroyCvBtns()

	arg0_34.cvLoader = nil
	arg0_34.callback = nil
end

return var0_0
