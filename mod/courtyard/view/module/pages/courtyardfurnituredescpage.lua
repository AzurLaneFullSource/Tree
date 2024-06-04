local var0 = class("CourtYardFurnitureDescPage", import(".CourtYardBaseSubPage"))

function var0.getUIName(arg0)
	return "CourtYardFurnitureDescUI"
end

function var0.OnLoaded(arg0)
	arg0.descPanel = arg0._tf:Find("desc")
	arg0.okBtn = arg0.descPanel:Find("ok_btn")
	arg0.iconImg = findTF(arg0._tf, "desc/iconframe/icon"):GetComponent(typeof(Image))
	arg0.nameTxt = findTF(arg0._tf, "desc/Text"):GetComponent(typeof(Text))
	arg0.typeTxt = findTF(arg0._tf, "desc/container/frame/type"):GetComponent(typeof(Text))
	arg0.contentTxt = findTF(arg0._tf, "desc/container/frame/content"):GetComponent(typeof(Text))
	arg0.comtableTxt = findTF(arg0._tf, "desc/container/frame/comfortable_container/Text"):GetComponent(typeof(Text))
	arg0.approachTxt = findTF(arg0._tf, "desc/container/frame/approach_container/Text"):GetComponent(typeof(Text))
	arg0.dateTxt = findTF(arg0._tf, "desc/container/frame/date_container/Text"):GetComponent(typeof(Text))
	arg0.voiceBtn = findTF(arg0._tf, "desc/container/frame/music_btn/voice")
	arg0.bgVoiceBtn = findTF(arg0._tf, "desc/container/frame/music_btn/bg_voice")
	arg0.bgVoiceMark = findTF(arg0._tf, "desc/container/frame/music_btn/bg_voice/mark")
	arg0.musicalInstrumentsBtn = findTF(arg0._tf, "desc/container/frame/music_btn/play")

	setText(findTF(arg0._tf, "desc/container/frame/comfortable_container/label"), i18n("word_comfort_level"))
	setText(findTF(arg0._tf, "desc/container/frame/approach_container/label"), i18n("word_get_way"))
	setText(findTF(arg0._tf, "desc/container/frame/date_container/label"), i18n("word_get_date"))
	setText(findTF(arg0._tf, "desc/ok_btn/text"), i18n("word_ok"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Close()
	end, SFX_PANEL)
	onButton(arg0, arg0.okBtn, function()
		arg0:Close()
	end, SFX_PANEL)
	onButton(arg0, arg0.voiceBtn, function()
		arg0:Emit("PlayFurnitureVoice", arg0.furniture.id)
	end, SFX_PANEL)
	onButton(arg0, arg0.bgVoiceBtn, function()
		arg0:Emit("PlayFurnitureBg", arg0.furniture.id)
		setActive(arg0.bgVoiceMark, arg0.furniture:GetMusicData())
	end, SFX_PANEL)
	onButton(arg0, arg0.musicalInstrumentsBtn, function()
		if arg0.furniture:IsMusicalInstruments() then
			arg0:Emit("PlayMusicalInstruments", arg0.furniture.id)
		end
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	setActive(arg0._tf, true)

	arg0.furniture = arg1

	local var0, var1 = arg1:ExistVoice()

	setActive(arg0.voiceBtn, var0 and (var1 == 1 or var1 == 3))
	setActive(arg0.bgVoiceBtn, var0 and (var1 == 2 or var1 == 3))
	setAnchoredPosition(arg0.voiceBtn, {
		y = var1 == 3 and -72 or -22
	})
	setActive(arg0.musicalInstrumentsBtn, arg1:IsMusicalInstruments())
	setActive(arg0.bgVoiceMark, arg0.furniture:GetMusicData())
	LoadSpriteAsync("FurnitureIcon/" .. arg1:GetIcon(), function(arg0)
		if not arg0.exited then
			arg0.iconImg.sprite = arg0
		end
	end)

	arg0.nameTxt.text = shortenString(arg1:GetName(), 6)

	local var2 = getProxy(DormProxy):getRawData():GetFurniture(arg1.configId)

	arg0.dateTxt.text = var2 and var2:getDate() or arg1:GetAddDate()
	arg0.comtableTxt.text = "+" .. arg1:GetComfortable()
	arg0.contentTxt.text = arg1:GetDescription()
	arg0.approachTxt.text = arg1:GetAddMode()
	arg0.typeTxt.text = arg1:GetGametipType()

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	local var3 = arg1:IsType(Furniture.TYPE_LUTE)

	setActive(arg0.approachTxt.gameObject.transform.parent, not var3)
	setActive(arg0.dateTxt.gameObject.transform.parent, not var3)
end

function var0.Close(arg0)
	setActive(arg0._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	arg0.exited = true

	arg0:Close()
end

return var0
