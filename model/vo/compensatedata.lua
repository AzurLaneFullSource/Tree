local var0_0 = class("CompensateData", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.date = arg1_1.send_time
	arg0_1.timestamp = arg1_1.timestamp
	arg0_1.title, arg0_1.sender = unpack(string.split(HXSet.hxLan(arg1_1.title), "||"))
	arg0_1.sender = arg0_1.sender or i18n("mail_sender_default")
	arg0_1.text = string.gsub(HXSet.hxLan(arg1_1.text), "\\n", "\n")
	arg0_1.attachments = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.attachment_list) do
		table.insert(arg0_1.attachments, Drop.New({
			type = iter1_1.type,
			id = iter1_1.id,
			count = iter1_1.number
		}))
	end

	arg0_1.attachFlag = arg1_1.attach_flag ~= 0
end

function var0_0.setAttachFlag(arg0_2, arg1_2)
	arg0_2.attachFlag = arg1_2
end

function var0_0.isEnd(arg0_3)
	return arg0_3.timestamp > 0 and pg.TimeMgr.GetInstance():GetServerTime() >= arg0_3.timestamp
end

return var0_0
