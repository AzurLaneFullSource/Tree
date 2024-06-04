local var0 = class("MailProxy", import(".NetProxy"))

var0.MAIL_TOTAL = "mail total"
var0.MAIL_OPENNED = "mail openned"
var0.MAIL_ATTACHMENT_TAKEN = "mail attachment taken"
var0.UPDATE_ATTACHMENT_COUNT = "UPDATE_ATTACHMENT_COUNT"
var0.DEAL_CMD_LIST = {
	"read",
	"important",
	"unimportant",
	"delete",
	"attachment",
	"overflow",
	"move"
}
var0.MailMessageBoxType = {
	ReceiveAward = 1,
	ShowTips = 2,
	OverflowConfirm = 3
}

function var0.register(arg0)
	arg0.data = {}
	arg0.total = 0
	arg0.totalExist = 0
	arg0.totalExistMailId = nil
	arg0.ids = {}
	arg0.importantIds = nil
	arg0.rareIds = nil
	arg0.collectionData = {}
	arg0.collectionIds = nil

	arg0:on(30001, function(arg0)
		arg0:unpdateUnreadCount(arg0.unread_number)
		arg0:updateTotal(arg0.total_number)
	end)
end

function var0.getMail(arg0, arg1)
	if arg0.data[arg1] ~= nil then
		return arg0.data[arg1]:clone()
	end
end

function var0.updateMail(arg0, arg1)
	assert(isa(arg1, Mail), "should be an instance of Mail")

	arg0.data[arg1.id] = arg1:clone()
end

function var0.removeMail(arg0, arg1)
	arg0.total = arg0.total - 1

	if arg0.totalExist > 0 and arg1 <= arg0.totalExistMailId then
		arg0.totalExist = arg0.totalExist - 1

		table.removebyvalue(arg0.ids, arg1)
	end

	if arg0.data[arg1] then
		if arg0.importantIds and arg0.data[arg1].importantFlag then
			table.removebyvalue(arg0.importantIds, arg1)
		end

		if arg0.rareIds and arg0.data[arg1]:IsRare() then
			table.removebyvalue(arg0.rareIds, arg1)
		end
	end

	arg0.data[arg1] = nil
end

function var0.getCollecitonMail(arg0, arg1)
	if arg0.collectionData[arg1] then
		return arg0.collectionData[arg1]:clone()
	end
end

function var0.updateCollectionMail(arg0, arg1)
	assert(isa(arg1, BaseMail), "should be an instance of BaseMail")

	arg0.collectionData[arg1.id] = arg1:clone()
end

function var0.removeCollectionMail(arg0, arg1)
	assert(arg0.collectionData[arg1] ~= nil, "mail should exist")

	arg0.collectionData[arg1] = nil

	table.removebyvalue(arg0.collectionIds, arg1)
end

function var0.DealMailOperation(arg0, arg1, arg2)
	switch(arg2, {
		read = function()
			arg0._existUnreadCount = arg0._existUnreadCount - 1

			if arg0.data[arg1] then
				arg0.data[arg1]:setReadFlag(true)
			end
		end,
		important = function()
			if arg0.data[arg1] then
				arg0.data[arg1]:setImportantFlag(true)

				if arg0.importantIds then
					table.dichotomyInsert(arg0.importantIds, arg1)
				end
			end
		end,
		unimportant = function()
			if arg0.data[arg1] then
				arg0.data[arg1]:setImportantFlag(false)

				if arg0.importantIds then
					table.removebyvalue(arg0.importantIds, arg1)
				end
			end
		end,
		delete = function()
			arg0:removeMail(arg1)
		end,
		attachment = function()
			if arg0.data[arg1] then
				arg0.data[arg1]:setAttachFlag(true)
				arg0.data[arg1]:setReadFlag(true)
			end
		end,
		overflow = function()
			return
		end,
		move = function()
			if arg0.data[arg1] then
				local var0 = arg0.data[arg1]

				arg0:removeMail(arg1)
				arg0:updateCollectionMail(var0)

				if arg0.collectionIds then
					table.dichotomyInsert(arg0.collectionIds, arg1)
				end
			end
		end
	})
end

function var0.IsDirty(arg0)
	return arg0.totalExist < arg0.total
end

function var0.GetNewIndex(arg0)
	local var0 = math.min(arg0.total - arg0.totalExist, SINGLE_MAIL_REQUIRE_SIZE)

	return arg0.total - var0 + 1, arg0.total
end

function var0.GetNextIndex(arg0)
	local var0 = math.min(arg0.totalExist - #arg0.ids, SINGLE_MAIL_REQUIRE_SIZE)
	local var1 = arg0.totalExist - #arg0.ids

	return var1 - var0 + 1, var1
end

function var0.AddNewMails(arg0, arg1)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg1) do
		arg0:updateMail(iter1)

		if iter1.importantFlag then
			table.insert(var0, iter1.id)
		end

		if iter1:IsRare() then
			table.insert(var1, iter1.id)
		end
	end

	arg0.ids = table.mergeArray(arg0.ids, underscore.map(arg1, function(arg0)
		return arg0.id
	end))

	if #var0 > 0 and arg0.importantIds then
		arg0.importantIds = table.mergeArray(arg0.importantIds, var0)
	end

	if #var1 > 0 and arg0.rareIds then
		arg0.rareIds = table.mergeArray(arg0.rareIds, var1)
	end

	arg0.totalExist = arg0.total

	if arg0.totalExist > 0 then
		arg0.totalExistMailId = arg0.ids[#arg0.ids]
	end
end

function var0.AddNextMails(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		arg0:updateMail(iter1)
	end

	arg0.ids = table.mergeArray(underscore.map(arg1, function(arg0)
		return arg0.id
	end), arg0.ids)
end

function var0.SetImportantMails(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		arg0:updateMail(iter1)
	end

	arg0.importantIds = underscore.map(arg1, function(arg0)
		return arg0.id
	end)
end

function var0.SetRareMails(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		arg0:updateMail(iter1)
	end

	arg0.rareIds = underscore.map(arg1, function(arg0)
		return arg0.id
	end)
end

function var0.AddCollectionMails(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		arg0:updateCollectionMail(iter1)
	end

	arg0.collectionIds = table.mergeArray(arg0.collectionIds, underscore.map(arg1, function(arg0)
		return arg0.id
	end))
end

function var0.GetMails(arg0, arg1)
	return underscore.map(arg1, function(arg0)
		return arg0.data[arg0]
	end)
end

function var0.GetCollectionMails(arg0, arg1)
	return underscore.map(arg1, function(arg0)
		return arg0.collectionData[arg0]
	end)
end

function var0.GetMailsAttachments(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		local var1 = arg0.data[iter1]

		if not var1.attachFlag then
			for iter2, iter3 in ipairs(var1.attachments) do
				table.insert(var0, Clone(iter3))
			end
		end
	end

	return PlayerConst.MergeSameDrops(var0)
end

function var0.GetUnreadCount(arg0)
	return arg0._existUnreadCount
end

function var0.unpdateUnreadCount(arg0, arg1)
	arg0._existUnreadCount = arg1

	arg0:sendNotification(var0.UPDATE_ATTACHMENT_COUNT)
end

function var0.updateTotal(arg0, arg1)
	arg0.total = arg1

	arg0:sendNotification(var0.MAIL_TOTAL, arg0.total)
end

return var0
