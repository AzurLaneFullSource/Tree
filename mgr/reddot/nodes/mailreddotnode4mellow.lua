local var0_0 = class("MailRedDotNode4Mellow", import(".RedDotNode"))
local var1_0 = 99

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._attachmentHint = findTF(arg1_1, "tip")
	arg0_1._attachmentCountText = findTF(arg1_1, "Text"):GetComponent(typeof(Text))

	var0_0.super.Ctor(arg0_1, arg1_1, {
		pg.RedDotMgr.TYPES.MAIL
	})
end

function var0_0.GetName(arg0_2)
	return arg0_2.gameObject.name
end

function var0_0.Init(arg0_3)
	var0_0.super.Init(arg0_3)

	local var0_3 = getProxy(MailProxy)

	if var0_3.total >= MAIL_COUNT_LIMIT then
		pg.TipsMgr.GetInstance():ShowTips(i18n("warning_mail_max_2"))
	elseif var0_3.total > MAIL_COUNT_LIMIT * 0.9 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("warning_mail_max_1", var0_3.total, MAIL_COUNT_LIMIT))
	end
end

function var0_0.SetData(arg0_4, arg1_4)
	local var0_4 = arg1_4

	if var0_4 > 0 then
		SetActive(arg0_4._attachmentHint, true)

		if var0_4 > var1_0 then
			arg0_4._attachmentCountText.text = var1_0 .. "+"
		else
			arg0_4._attachmentCountText.text = var0_4
		end
	else
		SetActive(arg0_4._attachmentHint, false)

		arg0_4._attachmentCountText.text = ""
	end
end

return var0_0
