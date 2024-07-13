local var0_0 = class("BaseMail", import(".BaseVO"))

var0_0.ATTACHMENT_UNTAKEN = 1
var0_0.ATTACHMENT_TAKEN = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.date = arg1_1.date
	arg0_1.title, arg0_1.sender = unpack(string.split(HXSet.hxLan(arg1_1.title), "||"))
	arg0_1.sender = arg0_1.sender or i18n("mail_sender_default")
	arg0_1.content = string.gsub(HXSet.hxLan(arg1_1.content), "\\n", "\n")
	arg0_1.attachments = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.attachment_list) do
		table.insert(arg0_1.attachments, Drop.New({
			type = iter1_1.type,
			id = iter1_1.id,
			count = iter1_1.number
		}))
	end
end

local var1_0

function var0_0.IsRare(arg0_2)
	if not var1_0 then
		var1_0 = {}

		for iter0_2, iter1_2 in ipairs({
			PlayerConst.ResGold,
			PlayerConst.ResOil,
			PlayerConst.ResExploit
		}) do
			table.insert(var1_0, Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = iter1_2
			}))
		end

		table.insert(var1_0, Drop.New({
			type = DROP_TYPE_ITEM,
			id = ITEM_ID_CUBE
		}))
	end

	return #arg0_2.attachments > 0 and underscore.any(arg0_2.attachments, function(arg0_3)
		for iter0_3, iter1_3 in ipairs(var1_0) do
			if arg0_3.type == iter1_3.type and arg0_3.id == iter1_3.id then
				return false
			end
		end

		return true
	end)
end

function var0_0.IsMatchKey(arg0_4, arg1_4)
	if not arg1_4 or arg1_4 == "" then
		return true
	end

	arg1_4 = string.lower(string.gsub(arg1_4, "%.", "%%."))
	arg1_4 = string.lower(string.gsub(arg1_4, "%-", "%%-"))

	return underscore.any({
		arg0_4.title,
		arg0_4.sender,
		arg0_4.content
	}, function(arg0_5)
		return string.find(string.lower(arg0_5), arg1_4)
	end)
end

return var0_0
