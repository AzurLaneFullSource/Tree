local var0 = class("ShipProfileInformationPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ShipProfileInformationPage"
end

function var0.OnLoaded(arg0)
	arg0.voiceActor = arg0:findTF("bg/author_panel/cvPanel/label/mask/Text"):GetComponent("ScrollText")
	arg0.illustrator = arg0:findTF("bg/author_panel/illustPanel/illustrator/label/mask/Text"):GetComponent("ScrollText")
	arg0.cvContainer = arg0:findTF("bg/lines_panel/lines_list/Grid")
	arg0.cvTpl = arg0:getTpl("bg/lines_panel/lines_list/Grid/lines_tpl")
	arg0.weddingReview = arg0:findTF("bg/wedding")
	arg0.voiceBtn = arg0:findTF("bg/language_change")
	arg0.voiceBtnSel = arg0.voiceBtn:Find("sel")
	arg0.voiceBtnUnsel = arg0.voiceBtn:Find("unsel")
	arg0.voiceBtnPositions = {
		arg0.voiceBtnSel.localPosition,
		arg0.voiceBtnUnsel.localPosition
	}
	arg0.voiceBtnTxt = arg0.voiceBtn:Find("Text"):GetComponent(typeof(Text))
	arg0.voiceBtnTxt1 = arg0.voiceBtn:Find("Text1"):GetComponent(typeof(Text))
	arg0.profilePlayBtn = arg0:findTF("bg/prototype_panel/title/playButton")
	arg0.profileTxt = arg0:findTF("bg/prototype_panel/desc/scroll/Text"):GetComponent(typeof(Text))
end

function var0.UpdateCvBtn(arg0, arg1)
	local var0 = arg0.voiceBtnPositions[arg1 and 2 or 1]
	local var1 = arg0.voiceBtnPositions[arg1 and 1 or 2]

	arg0.voiceBtnSel.localPosition = var0
	arg0.voiceBtnUnsel.localPosition = var1

	local var2 = Color.New(1, 1, 1, 1)
	local var3 = Color.New(0.5, 0.5, 0.5, 1)

	arg0.voiceBtnTxt.color = arg1 and var2 or var3
	arg0.voiceBtnTxt1.color = arg1 and var3 or var2
end

function var0.UpdateLang2(arg0)
	local var0 = arg0.skin.ship_group
	local var1 = ShipGroup.getDefaultSkin(var0)
	local var2 = pg.ship_skin_words[var1.id]

	PlayerPrefs.SetInt(CV_LANGUAGE_KEY .. var0, 2)
	arg0.cvLoader:Load(arg0.skin.id)
	arg0:SetAuthorInfo()
	arg0:UpdateCvList(arg0.isLive2d)
	arg0:UpdateProfileInfo()
end

function var0.UpdateLang1(arg0)
	local var0 = arg0.skin.ship_group
	local var1 = ShipGroup.getDefaultSkin(var0)
	local var2 = pg.ship_skin_words[var1.id]

	PlayerPrefs.SetInt(CV_LANGUAGE_KEY .. var0, 1)
	arg0.cvLoader:Load(arg0.skin.id)
	arg0:SetAuthorInfo()
	arg0:UpdateCvList(arg0.isLive2d)
	arg0:UpdateProfileInfo()
end

function var0.OnCvBtn(arg0, arg1)
	local var0 = arg1

	onButton(arg0, arg0.voiceBtn, function()
		var0 = not var0

		arg0:UpdateCvBtn(var0)

		if var0 then
			arg0:UpdateLang2()
		else
			arg0:UpdateLang1()
		end
	end, SFX_PANEL)
	arg0:UpdateCvBtn(var0)
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.weddingReview, function()
		arg0:emit(ShipProfileScene.WEDDING_REVIEW, {
			group = arg0.shipGroup,
			skinID = arg0.skin.id
		})
	end, SFX_PANEL)
end

function var0.EnterAnim(arg0, arg1, arg2)
	LeanTween.moveX(rtf(arg0._tf), 0, arg1):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg2))
end

function var0.ExistAnim(arg0, arg1, arg2)
	LeanTween.moveX(rtf(arg0._tf), 1000, arg1):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function()
		if arg2 then
			arg2()
		end

		arg0:Hide()
	end))
end

function var0.Update(arg0, arg1, arg2, arg3)
	arg0:Show()

	arg0.shipGroup = arg1
	arg0.showTrans = arg2

	setActive(arg0.weddingReview, arg1.married == 1)

	if isActive(arg0.weddingReview) then
		local var0 = arg1:getProposeType()

		eachChild(arg0.weddingReview, function(arg0)
			setActive(arg0, arg0.name == var0)
		end)
	end

	if arg3 then
		arg3()
	end
end

function var0.Flush(arg0, arg1, arg2)
	if arg0.skin and arg0.skin.id == arg1.id and arg0.isLive2d == arg2 then
		return
	end

	arg0.skin = arg1
	arg0.isLive2d = arg2

	arg0:SetAuthorInfo()
	arg0:SetIllustrator()
	arg0:UpdateLanguage()
	arg0:UpdateProfileInfo()
	arg0:UpdateCvList(arg2)
	arg0.cvLoader:Load(arg0.skin.id)
end

function var0.UpdateProfileInfo(arg0)
	local var0, var1, var2 = ShipWordHelper.GetWordAndCV(arg0.skin.id, ShipWordHelper.WORD_TYPE_PROFILE)

	arg0.profileTxt.text = SwitchSpecialChar(var2, true)

	local var3 = pg.ship_skin_words[arg0.skin.id]
	local var4 = var3 and (var3.voice_key >= 0 or var3.voice_key == -2) or var3.voice_key_2 > 0 and var3.voice_key < 0

	if var4 then
		onButton(arg0, arg0.profilePlayBtn, function()
			arg0.cvLoader:PlaySound(var1)
		end, SFX_PANEL)
	end

	setActive(arg0.profilePlayBtn, var4)
end

function var0.SetCvLoader(arg0, arg1)
	arg0.cvLoader = arg1
end

function var0.SetCallback(arg0, arg1)
	arg0.callback = arg1
end

function var0.UpdateLanguage(arg0)
	local var0 = arg0.skin.ship_group
	local var1 = ShipGroup.getDefaultSkin(var0)
	local var2 = pg.ship_skin_words[var1.id]
	local var3 = ShipWordHelper.GetLanguageSetting(var1.id)
	local var4 = var2.voice_key_2 >= 0 or var2.voice_key_2 == -2

	if var2.voice_key_2 >= 0 and var3 == 0 then
		var3 = pg.gameset.language_default.key_value

		PlayerPrefs.SetInt(CV_LANGUAGE_KEY .. var0, var3)
	end

	arg0:OnCvBtn(var3 == 2)

	if var2.voice_key_2 >= 0 or var2.voice_key_2 == -2 then
		local var5 = var2.voice_key_2 % 10
		local var6 = ""

		if var5 == 2 then
			var6 = i18n("word_chinese")
		elseif var5 == 3 then
			var6 = i18n("word_japanese_2")
		end

		arg0.voiceBtnTxt.text = var6
		arg0.voiceBtnTxt1.text = i18n("word_japanese")
	end

	setActive(arg0.voiceBtn, var4)
end

function var0.SetAuthorInfo(arg0)
	local var0 = arg0.skin
	local var1 = ShipWordHelper.GetCVAuthor(var0.id)

	print(var1 .. "  ----")
	arg0.voiceActor:SetText(var1)
end

function var0.SetIllustrator(arg0)
	local var0 = arg0.shipGroup:GetNationTxt()

	print(var0)
	arg0.illustrator:SetText(var0)
end

function var0.GetCvList(arg0, arg1)
	local var0 = {}

	if arg1 then
		if pg.ship_skin_template[arg0.skin.id].spine_use_live2d == 1 then
			var0 = pg.AssistantInfo.GetCVListForProfile(true)
		else
			var0 = pg.AssistantInfo.GetCVListForProfile()
		end
	else
		var0 = ShipWordHelper.GetCVList()
	end

	return var0
end

function var0.UpdateCvList(arg0, arg1)
	arg0:DestroyCvBtns()

	arg0.cvBtns = {}
	arg0.dispalys = arg0:GetCvList(arg1)

	table.sort(arg0.dispalys, function(arg0, arg1)
		return arg0.profile_index < arg1.profile_index
	end)

	for iter0, iter1 in ipairs(arg0.dispalys) do
		arg0:AddCvBtn(iter1)
		arg0:AddExCvBtn(iter1)
	end

	local var0 = (pg.character_voice.touch.profile_index - 1) * 2
	local var1 = arg0.cvBtns[var0]

	var0 = var1 and var1._tf:GetSiblingIndex() or var0

	local var2 = ShipWordHelper.GetMainSceneWordCnt(arg0.skin.id, -1)
	local var3 = arg0.shipGroup:GetMaxIntimacy()
	local var4 = ShipWordHelper.GetMainSceneWordCnt(arg0.skin.id, var3)

	if var2 < var4 then
		for iter2 = var2 + 1, var4 do
			arg0:AddMainExBtn(iter2, var0)

			var0 = var0 + 1
		end
	end
end

function var0.AddMainExBtn(arg0, arg1, arg2)
	local var0 = ShipProfileMainExCvBtn.New(cloneTplTo(arg0.cvTpl, arg0.cvContainer))

	onButton(arg0, var0._tf, function()
		if arg0.callback then
			arg0.callback(var0)
		end
	end, SFX_PANEL)
	var0:Init(arg0.shipGroup, arg0.skin, arg0.isLive2d, arg1)
	var0:Update()
	var0._tf:SetSiblingIndex(arg2)
	table.insert(arg0.cvBtns, var0)
end

function var0.AddCvBtn(arg0, arg1)
	local var0 = ShipProfileCvBtn.New(cloneTplTo(arg0.cvTpl, arg0.cvContainer))

	onButton(arg0, var0._tf, function()
		if arg0.callback then
			arg0.callback(var0)
		end
	end, SFX_PANEL)
	var0:Init(arg0.shipGroup, arg0.skin, arg0.isLive2d, arg1)
	var0:Update()
	table.insert(arg0.cvBtns, var0)
end

function var0.AddExCvBtn(arg0, arg1)
	local var0 = ShipProfileExCvBtn.New(cloneTplTo(arg0.cvTpl, arg0.cvContainer))

	onButton(arg0, var0._tf, function()
		if arg0.callback then
			arg0.callback(var0)
		end
	end, SFX_PANEL)

	local var1 = arg0.shipGroup:GetMaxIntimacy()

	var0:Init(arg0.shipGroup, arg0.skin, arg0.isLive2d, arg1, var1)
	var0:Update()
	table.insert(arg0.cvBtns, var0)
end

function var0.DestroyCvBtns(arg0)
	if not arg0.cvBtns then
		return
	end

	for iter0, iter1 in ipairs(arg0.cvBtns) do
		iter1:Destroy()
	end
end

function var0.OnDestroy(arg0)
	arg0:DestroyCvBtns()

	arg0.cvLoader = nil
	arg0.callback = nil
end

return var0
