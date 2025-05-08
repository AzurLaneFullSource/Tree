local var0_0 = class("SyncUnitStatic", import(".SyncUnit"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.owners = {}

	arg0_1:UpdateOwner(arg1_1.slots)
end

function var0_0.UpdateOwner(arg0_2, arg1_2)
	local var0_2 = #arg1_2 > table.getCount(arg0_2.owners)
	local var1_2

	if var0_2 then
		for iter0_2, iter1_2 in ipairs(arg1_2) do
			if not arg0_2.owners[iter1_2.slot_id] then
				arg0_2.owners[iter1_2.slot_id] = iter1_2.owner_id
				var1_2 = iter1_2.owner_id

				break
			end
		end
	else
		local var2_2 = {}

		for iter2_2, iter3_2 in ipairs(arg1_2) do
			var2_2[iter3_2.slot_id] = iter3_2.owner_id
		end

		for iter4_2, iter5_2 in pairs(arg0_2.owners) do
			if not var2_2[iter4_2] then
				var1_2 = iter5_2
				arg0_2.owners[iter4_2] = nil

				break
			end
		end
	end

	return var0_2, var1_2
end

return var0_0
