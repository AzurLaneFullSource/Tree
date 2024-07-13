local var0_0 = class("CourtYardFurnitureDescPage", import(".CourtYardBaseSubPage"))

function var0_0.getUIName(arg0_1)
	return "CourtYardFurnitureDescUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.descPanel = arg0_2._tf:Find("desc")
	arg0_2.okBtn = arg0_2.descPanel:Find("ok_btn")
	arg0_2.iconImg = findTF(arg0_2._tf, "desc/iconframe/icon"):GetComponent(typeof(Image))
	arg0_2.nameTxt = findTF(arg0_2._tf, "desc/Text"):GetComponent(typeof(Text))
	arg0_2.typeTxt = findTF(arg0_2._tf, "desc/container/frame/type"):GetComponent(typeof(Text))
	arg0_2.contentTxt = findTF(arg0_2._tf, "desc/container/frame/content"):GetComponent(typeof(Text))
	arg0_2.comtableTxt = findTF(arg0_2._tf, "desc/container/frame/comfortable_container/Text"):GetComponent(typeof(Text))
	arg0_2.approachTxt = findTF(arg0_2._tf, "desc/container/frame/approach_container/Text"):GetComponent(typeof(Text))
	arg0_2.dateTxt = findTF(arg0_2._tf, "desc/container/frame/date_container/Text"):GetComponent(typeof(Text))
	arg0_2.voiceBtn = findTF(arg0_2._tf, "desc/container/frame/music_btn/voice")
	arg0_2.bgVoiceBtn = findTF(arg0_2._tf, "desc/container/frame/music_btn/bg_voice")
	arg0_2.bgVoiceMark = findTF(arg0_2._tf, "desc/container/frame/music_btn/bg_voice/mark")
	arg0_2.musicalInstrumentsBtn = findTF(arg0_2._tf, "desc/container/frame/music_btn/play")

	setText(findTF(arg0_2._tf, "desc/container/frame/comfortable_container/label"), i18n("word_comfort_level"))
	setText(findTF(arg0_2._tf, "desc/container/frame/approach_container/label"), i18n("word_get_way"))
	setText(findTF(arg0_2._tf, "desc/container/frame/date_container/label"), i18n("word_get_date"))
	setText(findTF(arg0_2._tf, "desc/ok_btn/text"), i18n("word_ok"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Close()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.okBtn, function()
		arg0_3:Close()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.voiceBtn, function()
		arg0_3:Emit("PlayFurnitureVoice", arg0_3.furniture.id)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.bgVoiceBtn, function()
		arg0_3:Emit("PlayFurnitureBg", arg0_3.furniture.id)
		setActive(arg0_3.bgVoiceMark, arg0_3.furniture:GetMusicData())
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.musicalInstrumentsBtn, function()
		if arg0_3.furniture:IsMusicalInstruments() then
			arg0_3:Emit("PlayMusicalInstruments", arg0_3.furniture.id)
		end
	end, SFX_PANEL)
end

function var0_0.Show(arg0_9, arg1_9)
	setActive(arg0_9._tf, true)

	arg0_9.furniture = arg1_9

	local var0_9, var1_9 = arg1_9:ExistVoice()

	setActive(arg0_9.voiceBtn, var0_9 and (var1_9 == 1 or var1_9 == 3))
	setActive(arg0_9.bgVoiceBtn, var0_9 and (var1_9 == 2 or var1_9 == 3))
	setAnchoredPosition(arg0_9.voiceBtn, {
		y = var1_9 == 3 and -72 or -22
	})
	setActive(arg0_9.musicalInstrumentsBtn, arg1_9:IsMusicalInstruments())
	setActive(arg0_9.bgVoiceMark, arg0_9.furniture:GetMusicData())
	LoadSpriteAsync("FurnitureIcon/" .. arg1_9:GetIcon(), function(arg0_10)
		if not arg0_9.exited then
			arg0_9.iconImg.sprite = arg0_10
		end
	end)

	arg0_9.nameTxt.text = shortenString(arg1_9:GetName(), 6)

	local var2_9 = getProxy(DormProxy):getRawData():GetFurniture(arg1_9.configId)

	arg0_9.dateTxt.text = var2_9 and var2_9:getDate() or arg1_9:GetAddDate()
	arg0_9.comtableTxt.text = "+" .. arg1_9:GetComfortable()
	arg0_9.contentTxt.text = arg1_9:GetDescription()
	arg0_9.approachTxt.text = arg1_9:GetAddMode()
	arg0_9.typeTxt.text = arg1_9:GetGametipType()

	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf)

	local var3_9 = arg1_9:IsType(Furniture.TYPE_LUTE)

	setActive(arg0_9.approachTxt.gameObject.transform.parent, not var3_9)
	setActive(arg0_9.dateTxt.gameObject.transform.parent, not var3_9)
end

function var0_0.Close(arg0_11)
	setActive(arg0_11._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf, arg0_11._parentTf)
end

function var0_0.OnDestroy(arg0_12)
	arg0_12.exited = true

	arg0_12:Close()
end

return var0_0
