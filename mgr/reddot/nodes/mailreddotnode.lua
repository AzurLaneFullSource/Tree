local var0_0 = class("MailRedDotNode", import(".RedDotNode"))
local var1_0 = 99

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._mailMsg = findTF(arg1_1, "unread")
	arg0_1._mailEmpty = findTF(arg1_1, "read")
	arg0_1._attachmentHint = findTF(arg1_1, "attachmentLabel")
	arg0_1._attachmentCountText = findTF(arg0_1._attachmentHint, "attachmentCountText"):GetComponent(typeof(Text))

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

	if var0_3.total == math.clamp(var0_3.total, MAIL_COUNT_LIMIT * 0.9, MAIL_COUNT_LIMIT) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("warning_mail_max_1", var0_3.total, MAIL_COUNT_LIMIT))
	end
end

function var0_0.SetData(arg0_4, arg1_4)
	local var0_4 = arg1_4

	if var0_4 > 0 then
		SetActive(arg0_4._attachmentHint, true)
		SetActive(arg0_4._mailEmpty, false)
		SetActive(arg0_4._mailMsg, true)

		arg0_4.gameObject:GetComponent(typeof(Button)).targetGraphic = arg0_4._mailMsg:GetComponent(typeof(Image))

		if var0_4 > var1_0 then
			arg0_4._attachmentCountText.text = var1_0 .. "+"
		else
			arg0_4._attachmentCountText.text = var0_4
		end
	else
		SetActive(arg0_4._mailEmpty, true)
		SetActive(arg0_4._mailMsg, false)
		SetActive(arg0_4._attachmentHint, false)

		arg0_4.gameObject:GetComponent(typeof(Button)).targetGraphic = arg0_4._mailEmpty:GetComponent(typeof(Image))
	end
end

return var0_0
