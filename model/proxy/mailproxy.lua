local var0_0 = class("MailProxy", import(".NetProxy"))

var0_0.MAIL_TOTAL = "mail total"
var0_0.MAIL_OPENNED = "mail openned"
var0_0.MAIL_ATTACHMENT_TAKEN = "mail attachment taken"
var0_0.UPDATE_ATTACHMENT_COUNT = "UPDATE_ATTACHMENT_COUNT"
var0_0.DEAL_CMD_LIST = {
	"read",
	"important",
	"unimportant",
	"delete",
	"attachment",
	"overflow",
	"move"
}
var0_0.MailMessageBoxType = {
	ReceiveAward = 1,
	ShowTips = 2,
	OverflowConfirm = 3
}

function var0_0.register(arg0_1)
	arg0_1.data = {}
	arg0_1.total = 0
	arg0_1.totalExist = 0
	arg0_1.totalExistMailId = nil
	arg0_1.ids = {}
	arg0_1.importantIds = nil
	arg0_1.rareIds = nil
	arg0_1.collectionData = {}
	arg0_1.collectionIds = nil

	arg0_1:on(30001, function(arg0_2)
		arg0_1:unpdateUnreadCount(arg0_2.unread_number)
		arg0_1:updateTotal(arg0_2.total_number)
	end)
end

function var0_0.getMail(arg0_3, arg1_3)
	if arg0_3.data[arg1_3] ~= nil then
		return arg0_3.data[arg1_3]:clone()
	end
end

function var0_0.updateMail(arg0_4, arg1_4)
	assert(isa(arg1_4, Mail), "should be an instance of Mail")

	arg0_4.data[arg1_4.id] = arg1_4:clone()
end

function var0_0.removeMail(arg0_5, arg1_5)
	arg0_5.total = arg0_5.total - 1

	if arg0_5.totalExist > 0 and arg1_5 <= arg0_5.totalExistMailId then
		arg0_5.totalExist = arg0_5.totalExist - 1

		table.removebyvalue(arg0_5.ids, arg1_5)
	end

	if arg0_5.data[arg1_5] then
		if arg0_5.importantIds and arg0_5.data[arg1_5].importantFlag then
			table.removebyvalue(arg0_5.importantIds, arg1_5)
		end

		if arg0_5.rareIds and arg0_5.data[arg1_5]:IsRare() then
			table.removebyvalue(arg0_5.rareIds, arg1_5)
		end
	end

	arg0_5.data[arg1_5] = nil
end

function var0_0.getCollecitonMail(arg0_6, arg1_6)
	if arg0_6.collectionData[arg1_6] then
		return arg0_6.collectionData[arg1_6]:clone()
	end
end

function var0_0.updateCollectionMail(arg0_7, arg1_7)
	assert(isa(arg1_7, BaseMail), "should be an instance of BaseMail")

	arg0_7.collectionData[arg1_7.id] = arg1_7:clone()
end

function var0_0.removeCollectionMail(arg0_8, arg1_8)
	assert(arg0_8.collectionData[arg1_8] ~= nil, "mail should exist")

	arg0_8.collectionData[arg1_8] = nil

	table.removebyvalue(arg0_8.collectionIds, arg1_8)
end

function var0_0.DealMailOperation(arg0_9, arg1_9, arg2_9)
	switch(arg2_9, {
		read = function()
			arg0_9._existUnreadCount = arg0_9._existUnreadCount - 1

			if arg0_9.data[arg1_9] then
				arg0_9.data[arg1_9]:setReadFlag(true)
			end
		end,
		important = function()
			if arg0_9.data[arg1_9] then
				arg0_9.data[arg1_9]:setImportantFlag(true)

				if arg0_9.importantIds then
					table.dichotomyInsert(arg0_9.importantIds, arg1_9)
				end
			end
		end,
		unimportant = function()
			if arg0_9.data[arg1_9] then
				arg0_9.data[arg1_9]:setImportantFlag(false)

				if arg0_9.importantIds then
					table.removebyvalue(arg0_9.importantIds, arg1_9)
				end
			end
		end,
		delete = function()
			arg0_9:removeMail(arg1_9)
		end,
		attachment = function()
			if arg0_9.data[arg1_9] then
				arg0_9.data[arg1_9]:setAttachFlag(true)
				arg0_9.data[arg1_9]:setReadFlag(true)
			end
		end,
		overflow = function()
			return
		end,
		move = function()
			if arg0_9.data[arg1_9] then
				local var0_16 = arg0_9.data[arg1_9]

				arg0_9:removeMail(arg1_9)
				arg0_9:updateCollectionMail(var0_16)

				if arg0_9.collectionIds then
					table.dichotomyInsert(arg0_9.collectionIds, arg1_9)
				end
			end
		end
	})
end

function var0_0.IsDirty(arg0_17)
	return arg0_17.totalExist < arg0_17.total
end

function var0_0.GetNewIndex(arg0_18)
	local var0_18 = math.min(arg0_18.total - arg0_18.totalExist, SINGLE_MAIL_REQUIRE_SIZE)

	return arg0_18.total - var0_18 + 1, arg0_18.total
end

function var0_0.GetNextIndex(arg0_19)
	local var0_19 = math.min(arg0_19.totalExist - #arg0_19.ids, SINGLE_MAIL_REQUIRE_SIZE)
	local var1_19 = arg0_19.totalExist - #arg0_19.ids

	return var1_19 - var0_19 + 1, var1_19
end

function var0_0.AddNewMails(arg0_20, arg1_20)
	local var0_20 = {}
	local var1_20 = {}

	for iter0_20, iter1_20 in ipairs(arg1_20) do
		arg0_20:updateMail(iter1_20)

		if iter1_20.importantFlag then
			table.insert(var0_20, iter1_20.id)
		end

		if iter1_20:IsRare() then
			table.insert(var1_20, iter1_20.id)
		end
	end

	arg0_20.ids = table.mergeArray(arg0_20.ids, underscore.map(arg1_20, function(arg0_21)
		return arg0_21.id
	end))

	if #var0_20 > 0 and arg0_20.importantIds then
		arg0_20.importantIds = table.mergeArray(arg0_20.importantIds, var0_20)
	end

	if #var1_20 > 0 and arg0_20.rareIds then
		arg0_20.rareIds = table.mergeArray(arg0_20.rareIds, var1_20)
	end

	arg0_20.totalExist = arg0_20.total

	if arg0_20.totalExist > 0 then
		arg0_20.totalExistMailId = arg0_20.ids[#arg0_20.ids]
	end
end

function var0_0.AddNextMails(arg0_22, arg1_22)
	for iter0_22, iter1_22 in ipairs(arg1_22) do
		arg0_22:updateMail(iter1_22)
	end

	arg0_22.ids = table.mergeArray(underscore.map(arg1_22, function(arg0_23)
		return arg0_23.id
	end), arg0_22.ids)
end

function var0_0.SetImportantMails(arg0_24, arg1_24)
	for iter0_24, iter1_24 in ipairs(arg1_24) do
		arg0_24:updateMail(iter1_24)
	end

	arg0_24.importantIds = underscore.map(arg1_24, function(arg0_25)
		return arg0_25.id
	end)
end

function var0_0.SetRareMails(arg0_26, arg1_26)
	for iter0_26, iter1_26 in ipairs(arg1_26) do
		arg0_26:updateMail(iter1_26)
	end

	arg0_26.rareIds = underscore.map(arg1_26, function(arg0_27)
		return arg0_27.id
	end)
end

function var0_0.AddCollectionMails(arg0_28, arg1_28)
	for iter0_28, iter1_28 in ipairs(arg1_28) do
		arg0_28:updateCollectionMail(iter1_28)
	end

	arg0_28.collectionIds = table.mergeArray(arg0_28.collectionIds, underscore.map(arg1_28, function(arg0_29)
		return arg0_29.id
	end))
end

function var0_0.GetMails(arg0_30, arg1_30)
	return underscore.map(arg1_30, function(arg0_31)
		return arg0_30.data[arg0_31]
	end)
end

function var0_0.GetCollectionMails(arg0_32, arg1_32)
	return underscore.map(arg1_32, function(arg0_33)
		return arg0_32.collectionData[arg0_33]
	end)
end

function var0_0.GetMailsAttachments(arg0_34, arg1_34)
	local var0_34 = {}

	for iter0_34, iter1_34 in ipairs(arg1_34) do
		local var1_34 = arg0_34.data[iter1_34]

		if not var1_34.attachFlag then
			for iter2_34, iter3_34 in ipairs(var1_34.attachments) do
				table.insert(var0_34, Clone(iter3_34))
			end
		end
	end

	return PlayerConst.MergeSameDrops(var0_34)
end

function var0_0.GetUnreadCount(arg0_35)
	return arg0_35._existUnreadCount
end

function var0_0.unpdateUnreadCount(arg0_36, arg1_36)
	arg0_36._existUnreadCount = arg1_36

	arg0_36:sendNotification(var0_0.UPDATE_ATTACHMENT_COUNT)
end

function var0_0.updateTotal(arg0_37, arg1_37)
	arg0_37.total = arg1_37

	arg0_37:sendNotification(var0_0.MAIL_TOTAL, arg0_37.total)
end

return var0_0
