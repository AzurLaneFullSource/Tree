local var0 = class("MailRedDotNode", import(".RedDotNode"))
local var1 = 99

function var0.Ctor(arg0, arg1)
	arg0._mailMsg = findTF(arg1, "unread")
	arg0._mailEmpty = findTF(arg1, "read")
	arg0._attachmentHint = findTF(arg1, "attachmentLabel")
	arg0._attachmentCountText = findTF(arg0._attachmentHint, "attachmentCountText"):GetComponent(typeof(Text))

	var0.super.Ctor(arg0, arg1, {
		pg.RedDotMgr.TYPES.MAIL
	})
end

function var0.GetName(arg0)
	return arg0.gameObject.name
end

function var0.Init(arg0)
	var0.super.Init(arg0)

	local var0 = getProxy(MailProxy)

	if var0.total == math.clamp(var0.total, MAIL_COUNT_LIMIT * 0.9, MAIL_COUNT_LIMIT) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("warning_mail_max_1", var0.total, MAIL_COUNT_LIMIT))
	end
end

function var0.SetData(arg0, arg1)
	local var0 = arg1

	if var0 > 0 then
		SetActive(arg0._attachmentHint, true)
		SetActive(arg0._mailEmpty, false)
		SetActive(arg0._mailMsg, true)

		arg0.gameObject:GetComponent(typeof(Button)).targetGraphic = arg0._mailMsg:GetComponent(typeof(Image))

		if var0 > var1 then
			arg0._attachmentCountText.text = var1 .. "+"
		else
			arg0._attachmentCountText.text = var0
		end
	else
		SetActive(arg0._mailEmpty, true)
		SetActive(arg0._mailMsg, false)
		SetActive(arg0._attachmentHint, false)

		arg0.gameObject:GetComponent(typeof(Button)).targetGraphic = arg0._mailEmpty:GetComponent(typeof(Image))
	end
end

return var0
