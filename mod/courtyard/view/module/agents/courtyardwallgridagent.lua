local var0 = class("CourtYardWallGridAgent", import(".CourtYardGridAgent"))

function var0.Reset(arg0, arg1)
	table.clear(arg0.grids)

	for iter0 = 1, #arg1 do
		if iter0 % 2 == 0 then
			local var0 = arg0:GetPool():Dequeue()

			var0.transform:SetParent(arg0.gridsTF)

			var0.transform.localScale = Vector3.one

			table.insert(arg0.grids, var0)
			arg0:UpdatePositionAndColor(var0, {
				arg1[iter0 - 1],
				arg1[iter0]
			})
		end
	end
end

function var0.Flush(arg0, arg1)
	for iter0 = 1, #arg1 do
		if iter0 % 2 == 0 then
			local var0 = arg0.grids[iter0 * 0.5]

			assert(var0)
			arg0:UpdatePositionAndColor(var0, {
				arg1[iter0 - 1],
				arg1[iter0]
			})
		end
	end
end

function var0.UpdatePositionAndColor(arg0, arg1, arg2)
	table.sort(arg2, function(arg0, arg1)
		return arg0.position.x + arg0.position.y < arg1.position.x + arg1.position.y
	end)

	local var0 = arg2[1]
	local var1 = CourtYardCalcUtil.Map2Local(var0.position)

	arg1.transform.localPosition = var1

	local var2 = _.all(arg2, function(arg0)
		return arg0.flag == 1
	end)
	local var3 = arg0:GetColor(var2 and 1 or 2)

	arg1:GetComponent(typeof(Image)).color = var3

	local var4 = var0.position.y - var0.position.x >= 1

	arg1.transform.localScale = var4 and Vector3(-1, 1, 1) or Vector3(1, 1, 1)
end

function var0.GetPool(arg0)
	return arg0:GetView().poolMgr:GetWallGridPool()
end

return var0
