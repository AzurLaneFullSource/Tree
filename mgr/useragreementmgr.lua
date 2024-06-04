pg = pg or {}
pg.UserAgreementMgr = singletonClass("UserAgreementMgr")

local var0 = pg.UserAgreementMgr
local var1 = "UserAgreementUI"
local var2 = 0
local var3 = 1
local var4 = 2

function var0.Init(arg0, arg1)
	arg0.state = var2

	if arg1 then
		arg1()
	end
end

function var0.Show(arg0, arg1)
	arg0.onClose = arg1.onClose
	arg0.content = arg1.content
	arg0.forceRead = arg1.forceRead
	arg0.title = arg1.title

	if arg0.state == var2 then
		arg0:LoadUI()
	elseif arg0.state == var4 then
		arg0:Flush()
	elseif arg0.state == var3 then
		-- block empty
	end
end

function var0.LoadUI(arg0)
	arg0.state = var3

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetUI(var1, true, function(arg0)
		arg0.state = var4

		pg.UIMgr.GetInstance():LoadingOff()

		arg0._go = arg0

		arg0:OnLoaded()
		arg0:Flush()
		setActive(arg0._go, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0._go.transform, false, {
			weight = LayerWeightConst.THIRD_LAYER
		})
	end)
end

function var0.OnLoaded(arg0)
	arg0.contentTxt = arg0._go.transform:Find("window/container/scrollrect/content/Text"):GetComponent(typeof(Text))
	arg0.acceptBtn = arg0._go.transform:Find("window/accept_btn")
	arg0.acceptBtnTxt = arg0.acceptBtn:Find("Text"):GetComponent(typeof(Text))
	arg0.scrollrect = arg0._go.transform:Find("window/container/scrollrect"):GetComponent(typeof(ScrollRect))
	arg0.titleTxt = arg0._go.transform:Find("window/title"):GetComponent(typeof(Text))
	arg0.msgboxTitleTxt = arg0._go.transform:Find("window/title1/Text"):GetComponent(typeof(Text))
end

function var0.Flush(arg0)
	arg0.msgboxTitleTxt.text = i18n("title_info")
	arg0.contentTxt.text = arg0.content
	arg0.acceptBtnTxt.text = i18n("word_back")
	arg0.titleTxt.text = arg0.title

	local var0 = not arg0.forceRead

	onButton(nil, arg0.acceptBtn, function()
		if var0 then
			arg0:Hide()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("read_the_user_agreement"))
		end
	end)
	onScroll(nil, arg0.scrollrect.gameObject, function(arg0)
		if arg0.y <= 0.01 and not var0 then
			var0 = true

			setButtonEnabled(arg0.acceptBtn, var0)
		end
	end)
	setButtonEnabled(arg0.acceptBtn, var0)
	scrollTo(arg0.scrollrect.gameObject, 0, 1)
end

function var0.Hide(arg0)
	if arg0.onClose then
		arg0.onClose()
	end

	if arg0.acceptBtn then
		removeOnButton(arg0.acceptBtn)
	end

	if arg0.scrollrect then
		arg0.scrollrect.onValueChanged:RemoveAllListeners()
	end

	arg0.onClose = nil
	arg0.content = nil
	arg0.forceRead = nil
	arg0.title = nil

	if arg0._go then
		pg.UIMgr.GetInstance():UnblurPanel(arg0._go.transform, pg.UIMgr.GetInstance().UIMain)
		PoolMgr.GetInstance():ReturnUI(var1, arg0._go)

		arg0._go = nil
	end

	arg0.state = var2
end

function var0.ShowForBiliPrivate(arg0)
	local var0 = require("GameCfg.useragreems.BiliPrivate")

	arg0:Show({
		content = var0.content,
		title = var0.title
	})
end

function var0.ShowForBiliLicence(arg0)
	local var0 = require("GameCfg.useragreems.BiliLicence")

	arg0:Show({
		content = var0.content,
		title = var0.title
	})
end

function var0.ShowChtPrivate(arg0)
	local var0 = require("GameCfg.useragreems.ChtPrivate")

	arg0:Show({
		content = var0.content,
		title = var0.title
	})
end

function var0.ShowChtLicence(arg0)
	local var0 = require("GameCfg.useragreems.ChtLicence")

	arg0:Show({
		content = var0.content,
		title = var0.title
	})
end
