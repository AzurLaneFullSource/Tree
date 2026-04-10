local var0_0 = class("CardPoolMgr")
local var1_0 = 5
local var2_0 = 3

function var0_0.Ctor(arg0_1)
	arg0_1.poolRoot = GameObject.New("CardPoolRoot")
	arg0_1.poolDic = {}
end

function var0_0.GetCardGameObjectById(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.poolDic[arg1_2] = arg0_2.poolDic[arg1_2] or {}

	if #arg0_2.poolDic[arg1_2] == 0 then
		local var0_2 = pg.bar_card[arg1_2].unit_res
		local var1_2 = pg.island_unit_item[var0_2].model

		if arg3_2 then
			local var2_2 = LoadAny(var1_2, nil)
			local var3_2 = Object.Instantiate(var2_2)

			arg2_2(var3_2)
		else
			LoadAnyAsync(var1_2, "", nil, function(arg0_3)
				local var0_3 = Object.Instantiate(arg0_3)

				arg2_2(var0_3)
			end)
		end
	else
		local var4_2 = arg0_2.poolDic[arg1_2][1]

		if IsNil(var4_2) then
			table.remove(arg0_2.poolDic[arg1_2], 1)
			arg0_2:GetCardGameObjectById(arg1_2, arg2_2, arg3_2)
		else
			setActive(var4_2.transform, true)
			table.remove(arg0_2.poolDic[arg1_2], 1)
			arg2_2(var4_2)
		end
	end
end

function var0_0.ReturnGameObjectById(arg0_4, arg1_4, arg2_4)
	if IsNil(arg2_4) then
		return
	end

	if (arg1_4 == 0 and var1_0 or var2_0) <= #arg0_4.poolDic[arg1_4] then
		GameObject.Destroy(arg2_4.gameObject)
	else
		table.insert(arg0_4.poolDic[arg1_4], arg2_4)
		setActive(arg2_4.transform, false)
		setParent(arg2_4.transform, arg0_4.poolRoot.transform, false)
	end
end

function var0_0.Destroy(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.poolDic) do
		for iter2_5 = #iter1_5, 1, -1 do
			local var0_5 = iter1_5[iter2_5]

			GameObject.Destroy(var0_5.gameObject)
		end
	end

	arg0_5.poolDic = {}

	if arg0_5.poolRoot then
		GameObject.Destroy(arg0_5.poolRoot)

		arg0_5.poolRoot = nil
	end
end

return var0_0
