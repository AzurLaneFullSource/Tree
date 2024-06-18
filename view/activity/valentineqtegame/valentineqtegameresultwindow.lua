local var0_0 = class("ValentineQteGameResultWindow")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._tf = arg1_1
	arg0_1._parentTf = arg1_1.parent
	arg0_1.backBtn = arg1_1:Find("back")
	arg0_1.shareBtn = arg1_1:Find("share")
	arg0_1.scoreTxt = arg1_1:Find("frame/score/Text"):GetComponent(typeof(Text))
	arg0_1.perfectTxt = arg1_1:Find("frame/content/Perfect/value/Text"):GetComponent(typeof(Text))
	arg0_1.greatTxt = arg1_1:Find("frame/content/Great/value/Text"):GetComponent(typeof(Text))
	arg0_1.goodTxt = arg1_1:Find("frame/content/Good/value/Text"):GetComponent(typeof(Text))
	arg0_1.missTxt = arg1_1:Find("frame/content/Miss/value/Text"):GetComponent(typeof(Text))
	arg0_1.comboTxt = arg1_1:Find("frame/content/Combo/value/Text"):GetComponent(typeof(Text))
	arg0_1.chatTxt = arg1_1:Find("chat/Text"):GetComponent(typeof(Text))
	arg0_1.nameTxt = arg1_1:Find("frame/Text"):GetComponent(typeof(Text))

	arg0_1:Init()
	setText(arg1_1:Find("frame/score/label"), i18n("2023Valentine_minigame_label1"))

	arg0_1.nameTxt.text = getProxy(PlayerProxy):getRawData():GetName()

	setActive(arg0_1.nameTxt.gameObject, false)
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.backBtn, function()
		if arg0_2.callback then
			arg0_2.callback()
		end

		arg0_2:Hide()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeValentineQte, nil, {
			weight = LayerWeightConst.TOP_LAYER + 1
		})
	end, SFX_PANEL)
end

function var0_0.Show(arg0_5, arg1_5, arg2_5)
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf)

	arg0_5.statistics = arg1_5
	arg0_5.callback = arg2_5

	setActive(arg0_5._tf, true)
	arg0_5:Flush()
end

function var0_0.Flush(arg0_6)
	arg0_6.scoreTxt.text = arg0_6.statistics.Score
	arg0_6.perfectTxt.text = arg0_6.statistics.Perfect
	arg0_6.greatTxt.text = arg0_6.statistics.Great
	arg0_6.goodTxt.text = arg0_6.statistics.Good
	arg0_6.missTxt.text = arg0_6.statistics.Miss
	arg0_6.comboTxt.text = arg0_6.statistics.Combo
	arg0_6.chatTxt.text = arg0_6:GetChatTxt(arg0_6.statistics.Score)
end

function var0_0.GetChatTxt(arg0_7, arg1_7)
	local var0_7

	for iter0_7, iter1_7 in ipairs(ValentineQteGameConst.CHAT_CONTENT) do
		local var1_7 = iter1_7[1]
		local var2_7 = iter1_7[2]
		local var3_7 = iter1_7[3]

		if var1_7 <= arg1_7 and arg1_7 <= var2_7 then
			var0_7 = var3_7

			break
		end
	end

	if var0_7 then
		return i18n("2023Valentine_minigame_" .. var0_7)
	else
		return ""
	end
end

function var0_0.Hide(arg0_8)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_8._tf, arg0_8._parentTf)

	arg0_8.callback = nil

	setActive(arg0_8._tf, false)
end

function var0_0.Destroy(arg0_9)
	arg0_9:Hide()
	pg.DelegateInfo.Dispose(arg0_9)
end

return var0_0
