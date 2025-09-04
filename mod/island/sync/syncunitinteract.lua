local var0_0 = class("SyncUnitInteract")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1
	arg0_1.type = arg2_1
	arg0_1.owners = {}
	arg0_1.status = -1
end

function var0_0.UpdateInfo(arg0_2, arg1_2)
	arg0_2:UpdateOwner(arg1_2.slots)

	arg0_2.status = arg1_2.status
end

function var0_0.SetStatus(arg0_3, arg1_3)
	arg0_3.status = arg1_3
end

function var0_0.GetStatus(arg0_4)
	return arg0_4.status
end

function var0_0.InitOwner(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg1_5) do
		arg0_5.owners[iter1_5.slot_id] = iter1_5.owner_id
	end
end

function var0_0.OwnerCount(arg0_6)
	return table.getCount(arg0_6.owners)
end

function var0_0.UpdateOwner(arg0_7, arg1_7)
	local var0_7 = #arg1_7 > arg0_7:OwnerCount()
	local var1_7

	if var0_7 then
		for iter0_7, iter1_7 in ipairs(arg1_7) do
			if not arg0_7.owners[iter1_7.slot_id] then
				arg0_7.owners[iter1_7.slot_id] = iter1_7.owner_id
				var1_7 = iter1_7.owner_id

				break
			end
		end
	else
		local var2_7 = {}

		for iter2_7, iter3_7 in ipairs(arg1_7) do
			var2_7[iter3_7.slot_id] = iter3_7.owner_id
		end

		for iter4_7, iter5_7 in pairs(arg0_7.owners) do
			if not var2_7[iter4_7] then
				var1_7 = iter5_7
				arg0_7.owners[iter4_7] = nil

				break
			end
		end
	end

	return var0_7, var1_7
end

function var0_0.RemoveOwner(arg0_8, arg1_8)
	for iter0_8, iter1_8 in pairs(arg0_8.owners) do
		if iter1_8 == arg1_8 then
			arg0_8.owners[iter0_8] = nil
		end
	end
end

return var0_0
