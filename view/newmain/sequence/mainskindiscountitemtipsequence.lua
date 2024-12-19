local var0_0 = class("MainSkinDiscountItemTipSequence", import(".MainOverDueSkinDiscountItemSequence"))

function var0_0.Execute(arg0_1, arg1_1)
	if not arg0_1:ShouldTip() then
		arg1_1()

		return
	end

	local var0_1, var1_1 = arg0_1:CollectExpiredItems()

	if #var0_1 <= 0 and #var1_1 <= 0 then
		arg1_1()

		return
	end

	var0_0.TipFlag = true

	local var2_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		table.insert(var2_1, iter1_1)
	end

	for iter2_1, iter3_1 in ipairs(var1_1) do
		table.insert(var2_1, iter3_1)
	end

	arg0_1:DisplayResults(var2_1, arg1_1)
end

function var0_0.ShouldTip(arg0_2)
	local var0_2 = getProxy(PlayerProxy):getRawData().id
	local var1_2 = PlayerPrefs.GetString("SkinDiscountItemTip" .. var0_2, "")

	if var1_2 == "" then
		return not var0_0.TipFlag
	end

	if pg.TimeMgr.GetInstance():GetServerTime() < tonumber(var1_2) then
		return false
	else
		return not var0_0.TipFlag
	end
end

function var0_0.DisplayResults(arg0_3, arg1_3, arg2_3)
	arg0_3:Display(MainSkinDiscountItemTipDisplayPage, arg1_3, arg2_3)
end

function var0_0.InTime(arg0_4, arg1_4)
	if type(arg1_4) == "table" then
		local var0_4 = arg1_4[2]
		local var1_4 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_4)
		local var2_4 = var1_4 - 86400
		local var3_4 = pg.TimeMgr.GetInstance():GetServerTime()

		return var2_4 <= var3_4 and var3_4 < var1_4
	end

	return false
end

return var0_0
