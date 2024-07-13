local var0_0 = class("CourtYardWallGridAgent", import(".CourtYardGridAgent"))

function var0_0.Reset(arg0_1, arg1_1)
	table.clear(arg0_1.grids)

	for iter0_1 = 1, #arg1_1 do
		if iter0_1 % 2 == 0 then
			local var0_1 = arg0_1:GetPool():Dequeue()

			var0_1.transform:SetParent(arg0_1.gridsTF)

			var0_1.transform.localScale = Vector3.one

			table.insert(arg0_1.grids, var0_1)
			arg0_1:UpdatePositionAndColor(var0_1, {
				arg1_1[iter0_1 - 1],
				arg1_1[iter0_1]
			})
		end
	end
end

function var0_0.Flush(arg0_2, arg1_2)
	for iter0_2 = 1, #arg1_2 do
		if iter0_2 % 2 == 0 then
			local var0_2 = arg0_2.grids[iter0_2 * 0.5]

			assert(var0_2)
			arg0_2:UpdatePositionAndColor(var0_2, {
				arg1_2[iter0_2 - 1],
				arg1_2[iter0_2]
			})
		end
	end
end

function var0_0.UpdatePositionAndColor(arg0_3, arg1_3, arg2_3)
	table.sort(arg2_3, function(arg0_4, arg1_4)
		return arg0_4.position.x + arg0_4.position.y < arg1_4.position.x + arg1_4.position.y
	end)

	local var0_3 = arg2_3[1]
	local var1_3 = CourtYardCalcUtil.Map2Local(var0_3.position)

	arg1_3.transform.localPosition = var1_3

	local var2_3 = _.all(arg2_3, function(arg0_5)
		return arg0_5.flag == 1
	end)
	local var3_3 = arg0_3:GetColor(var2_3 and 1 or 2)

	arg1_3:GetComponent(typeof(Image)).color = var3_3

	local var4_3 = var0_3.position.y - var0_3.position.x >= 1

	arg1_3.transform.localScale = var4_3 and Vector3(-1, 1, 1) or Vector3(1, 1, 1)
end

function var0_0.GetPool(arg0_6)
	return arg0_6:GetView().poolMgr:GetWallGridPool()
end

return var0_0
