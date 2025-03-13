local var0_0 = class("BaseMail", import(".BaseVO"))

var0_0.ATTACHMENT_UNTAKEN = 1
var0_0.ATTACHMENT_TAKEN = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.date = arg1_1.date
	arg0_1.title, arg0_1.sender = unpack(string.split(HXSet.hxLan(arg1_1.title), "||"))
	arg0_1.sender = arg0_1.sender and string.gsub(arg0_1.sender or "", "{ship_statistics:(%d+).-}", function(arg0_2)
		return pg.ship_data_statistics[tonumber(arg0_2)].name
	end) or i18n("mail_sender_default")
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

function var0_0.IsRare(arg0_3)
	if not var1_0 then
		var1_0 = {}

		for iter0_3, iter1_3 in ipairs({
			PlayerConst.ResGold,
			PlayerConst.ResOil,
			PlayerConst.ResExploit
		}) do
			table.insert(var1_0, Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = iter1_3
			}))
		end

		table.insert(var1_0, Drop.New({
			type = DROP_TYPE_ITEM,
			id = ITEM_ID_CUBE
		}))
	end

	return #arg0_3.attachments > 0 and underscore.any(arg0_3.attachments, function(arg0_4)
		for iter0_4, iter1_4 in ipairs(var1_0) do
			if arg0_4.type == iter1_4.type and arg0_4.id == iter1_4.id then
				return false
			end
		end

		return true
	end)
end

function var0_0.IsMatchKey(arg0_5, arg1_5)
	if not arg1_5 or arg1_5 == "" then
		return true
	end

	arg1_5 = string.lower(string.gsub(arg1_5, "%.", "%%."))
	arg1_5 = string.lower(string.gsub(arg1_5, "%-", "%%-"))

	return underscore.any({
		arg0_5.title,
		arg0_5.sender,
		arg0_5.content
	}, function(arg0_6)
		return string.find(string.lower(arg0_6), arg1_5)
	end)
end

return var0_0
