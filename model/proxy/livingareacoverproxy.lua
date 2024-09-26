local var0_0 = class("LivingAreaCoverProxy", import(".NetProxy"))

var0_0.ON_UPDATE = "LivingAreaCoverProxy:ON_UPDATE"

function var0_0.register(arg0_1)
	arg0_1.data = {}
	arg0_1.coverId = 0

	for iter0_1, iter1_1 in ipairs(pg.livingarea_cover.all) do
		arg0_1.data[iter1_1] = LivingAreaCover.New({
			id = iter1_1,
			unlock = iter1_1 == 0
		})
	end

	arg0_1:on(11003, function(arg0_2)
		arg0_1.coverId = arg0_2.cover.id

		for iter0_2, iter1_2 in ipairs(arg0_2.cover.covers or {}) do
			arg0_1.data[iter1_2]:SetUnlock(true)
		end
	end)
end

function var0_0.GetCoverId(arg0_3)
	return arg0_3.coverId
end

function var0_0.GetCurCover(arg0_4)
	return arg0_4:GetCover(arg0_4:GetCoverId())
end

function var0_0.UpdateCoverId(arg0_5, arg1_5)
	arg0_5.coverId = arg1_5
end

function var0_0.GetCover(arg0_6, arg1_6)
	return arg0_6.data[arg1_6]
end

function var0_0.GetCover(arg0_7, arg1_7)
	return arg0_7.data[arg1_7]
end

function var0_0.GetUnlockList(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.data) do
		if iter1_8:IsUnlock() then
			table.insert(var0_8, iter1_8)
		end
	end

	return var0_8
end

function var0_0.GetLockList(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.data) do
		if not iter1_9:IsUnlock() then
			table.insert(var0_9, iter1_9)
		end
	end

	return var0_9
end

function var0_0.UpdateCover(arg0_10, arg1_10)
	arg0_10.data[arg1_10.id] = arg1_10

	arg0_10:sendNotification(var0_0.ON_UPDATE)
end

function var0_0.IsTip(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.data) do
		if iter1_11:IsNew() then
			return true
		end
	end

	return false
end

function var0_0.remove(arg0_12)
	return
end

return var0_0
