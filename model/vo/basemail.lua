local var0 = class("BaseMail", import(".BaseVO"))

var0.ATTACHMENT_UNTAKEN = 1
var0.ATTACHMENT_TAKEN = 2

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.date = arg1.date
	arg0.title, arg0.sender = unpack(string.split(HXSet.hxLan(arg1.title), "||"))
	arg0.sender = arg0.sender or i18n("mail_sender_default")
	arg0.content = string.gsub(HXSet.hxLan(arg1.content), "\\n", "\n")
	arg0.attachments = {}

	for iter0, iter1 in ipairs(arg1.attachment_list) do
		table.insert(arg0.attachments, Drop.New({
			type = iter1.type,
			id = iter1.id,
			count = iter1.number
		}))
	end
end

local var1

function var0.IsRare(arg0)
	if not var1 then
		var1 = {}

		for iter0, iter1 in ipairs({
			PlayerConst.ResGold,
			PlayerConst.ResOil,
			PlayerConst.ResExploit
		}) do
			table.insert(var1, Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = iter1
			}))
		end

		table.insert(var1, Drop.New({
			type = DROP_TYPE_ITEM,
			id = ITEM_ID_CUBE
		}))
	end

	return #arg0.attachments > 0 and underscore.any(arg0.attachments, function(arg0)
		for iter0, iter1 in ipairs(var1) do
			if arg0.type == iter1.type and arg0.id == iter1.id then
				return false
			end
		end

		return true
	end)
end

function var0.IsMatchKey(arg0, arg1)
	if not arg1 or arg1 == "" then
		return true
	end

	arg1 = string.lower(string.gsub(arg1, "%.", "%%."))
	arg1 = string.lower(string.gsub(arg1, "%-", "%%-"))

	return underscore.any({
		arg0.title,
		arg0.sender,
		arg0.content
	}, function(arg0)
		return string.find(string.lower(arg0), arg1)
	end)
end

return var0
