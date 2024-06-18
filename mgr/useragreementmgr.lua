pg = pg or {}
pg.UserAgreementMgr = singletonClass("UserAgreementMgr")

local var0_0 = pg.UserAgreementMgr
local var1_0 = "UserAgreementUI"
local var2_0 = 0
local var3_0 = 1
local var4_0 = 2

function var0_0.Init(arg0_1, arg1_1)
	arg0_1.state = var2_0

	if arg1_1 then
		arg1_1()
	end
end

function var0_0.Show(arg0_2, arg1_2)
	arg0_2.onClose = arg1_2.onClose
	arg0_2.content = arg1_2.content
	arg0_2.forceRead = arg1_2.forceRead
	arg0_2.title = arg1_2.title

	if arg0_2.state == var2_0 then
		arg0_2:LoadUI()
	elseif arg0_2.state == var4_0 then
		arg0_2:Flush()
	elseif arg0_2.state == var3_0 then
		-- block empty
	end
end

function var0_0.LoadUI(arg0_3)
	arg0_3.state = var3_0

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetUI(var1_0, true, function(arg0_4)
		arg0_3.state = var4_0

		pg.UIMgr.GetInstance():LoadingOff()

		arg0_3._go = arg0_4

		arg0_3:OnLoaded()
		arg0_3:Flush()
		setActive(arg0_3._go, true)
		pg.UIMgr.GetInstance():BlurPanel(arg0_3._go.transform, false, {
			weight = LayerWeightConst.THIRD_LAYER
		})
	end)
end

function var0_0.OnLoaded(arg0_5)
	arg0_5.contentTxt = arg0_5._go.transform:Find("window/container/scrollrect/content/Text"):GetComponent(typeof(Text))
	arg0_5.acceptBtn = arg0_5._go.transform:Find("window/accept_btn")
	arg0_5.acceptBtnTxt = arg0_5.acceptBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_5.scrollrect = arg0_5._go.transform:Find("window/container/scrollrect"):GetComponent(typeof(ScrollRect))
	arg0_5.titleTxt = arg0_5._go.transform:Find("window/title"):GetComponent(typeof(Text))
	arg0_5.msgboxTitleTxt = arg0_5._go.transform:Find("window/title1/Text"):GetComponent(typeof(Text))
end

function var0_0.Flush(arg0_6)
	arg0_6.msgboxTitleTxt.text = i18n("title_info")
	arg0_6.contentTxt.text = arg0_6.content
	arg0_6.acceptBtnTxt.text = i18n("word_back")
	arg0_6.titleTxt.text = arg0_6.title

	local var0_6 = not arg0_6.forceRead

	onButton(nil, arg0_6.acceptBtn, function()
		if var0_6 then
			arg0_6:Hide()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("read_the_user_agreement"))
		end
	end)
	onScroll(nil, arg0_6.scrollrect.gameObject, function(arg0_8)
		if arg0_8.y <= 0.01 and not var0_6 then
			var0_6 = true

			setButtonEnabled(arg0_6.acceptBtn, var0_6)
		end
	end)
	setButtonEnabled(arg0_6.acceptBtn, var0_6)
	scrollTo(arg0_6.scrollrect.gameObject, 0, 1)
end

function var0_0.Hide(arg0_9)
	if arg0_9.onClose then
		arg0_9.onClose()
	end

	if arg0_9.acceptBtn then
		removeOnButton(arg0_9.acceptBtn)
	end

	if arg0_9.scrollrect then
		arg0_9.scrollrect.onValueChanged:RemoveAllListeners()
	end

	arg0_9.onClose = nil
	arg0_9.content = nil
	arg0_9.forceRead = nil
	arg0_9.title = nil

	if arg0_9._go then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_9._go.transform, pg.UIMgr.GetInstance().UIMain)
		PoolMgr.GetInstance():ReturnUI(var1_0, arg0_9._go)

		arg0_9._go = nil
	end

	arg0_9.state = var2_0
end

function var0_0.ShowForBiliPrivate(arg0_10)
	local var0_10 = require("GameCfg.useragreems.BiliPrivate")

	arg0_10:Show({
		content = var0_10.content,
		title = var0_10.title
	})
end

function var0_0.ShowForBiliLicence(arg0_11)
	local var0_11 = require("GameCfg.useragreems.BiliLicence")

	arg0_11:Show({
		content = var0_11.content,
		title = var0_11.title
	})
end

function var0_0.ShowChtPrivate(arg0_12)
	local var0_12 = require("GameCfg.useragreems.ChtPrivate")

	arg0_12:Show({
		content = var0_12.content,
		title = var0_12.title
	})
end

function var0_0.ShowChtLicence(arg0_13)
	local var0_13 = require("GameCfg.useragreems.ChtLicence")

	arg0_13:Show({
		content = var0_13.content,
		title = var0_13.title
	})
end
