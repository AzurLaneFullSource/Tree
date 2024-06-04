local var0 = class("ValentineQteGameResultWindow")

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0._tf = arg1
	arg0._parentTf = arg1.parent
	arg0.backBtn = arg1:Find("back")
	arg0.shareBtn = arg1:Find("share")
	arg0.scoreTxt = arg1:Find("frame/score/Text"):GetComponent(typeof(Text))
	arg0.perfectTxt = arg1:Find("frame/content/Perfect/value/Text"):GetComponent(typeof(Text))
	arg0.greatTxt = arg1:Find("frame/content/Great/value/Text"):GetComponent(typeof(Text))
	arg0.goodTxt = arg1:Find("frame/content/Good/value/Text"):GetComponent(typeof(Text))
	arg0.missTxt = arg1:Find("frame/content/Miss/value/Text"):GetComponent(typeof(Text))
	arg0.comboTxt = arg1:Find("frame/content/Combo/value/Text"):GetComponent(typeof(Text))
	arg0.chatTxt = arg1:Find("chat/Text"):GetComponent(typeof(Text))
	arg0.nameTxt = arg1:Find("frame/Text"):GetComponent(typeof(Text))

	arg0:Init()
	setText(arg1:Find("frame/score/label"), i18n("2023Valentine_minigame_label1"))

	arg0.nameTxt.text = getProxy(PlayerProxy):getRawData():GetName()

	setActive(arg0.nameTxt.gameObject, false)
end

function var0.Init(arg0)
	onButton(arg0, arg0.backBtn, function()
		if arg0.callback then
			arg0.callback()
		end

		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.shareBtn, function()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeValentineQte, nil, {
			weight = LayerWeightConst.TOP_LAYER + 1
		})
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1, arg2)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	arg0.statistics = arg1
	arg0.callback = arg2

	setActive(arg0._tf, true)
	arg0:Flush()
end

function var0.Flush(arg0)
	arg0.scoreTxt.text = arg0.statistics.Score
	arg0.perfectTxt.text = arg0.statistics.Perfect
	arg0.greatTxt.text = arg0.statistics.Great
	arg0.goodTxt.text = arg0.statistics.Good
	arg0.missTxt.text = arg0.statistics.Miss
	arg0.comboTxt.text = arg0.statistics.Combo
	arg0.chatTxt.text = arg0:GetChatTxt(arg0.statistics.Score)
end

function var0.GetChatTxt(arg0, arg1)
	local var0

	for iter0, iter1 in ipairs(ValentineQteGameConst.CHAT_CONTENT) do
		local var1 = iter1[1]
		local var2 = iter1[2]
		local var3 = iter1[3]

		if var1 <= arg1 and arg1 <= var2 then
			var0 = var3

			break
		end
	end

	if var0 then
		return i18n("2023Valentine_minigame_" .. var0)
	else
		return ""
	end
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)

	arg0.callback = nil

	setActive(arg0._tf, false)
end

function var0.Destroy(arg0)
	arg0:Hide()
	pg.DelegateInfo.Dispose(arg0)
end

return var0
