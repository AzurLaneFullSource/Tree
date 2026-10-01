local var0_0 = class("CrusingActivity", import("model.vo.Activity"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.previousPeriodAct = arg0_1:CreatePreviousPeriodAct()

	print("========================&", arg0_1.id, arg0_1.data3, arg0_1.data4)
end

function var0_0.GetCrusingUnreceiveAward(arg0_2)
	assert(arg0_2:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING, "type error")

	local var0_2 = pg.battlepass_event_pt[arg0_2.id]
	local var1_2 = {}
	local var2_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.data1_list) do
		var2_2[iter1_2] = true
	end

	for iter2_2, iter3_2 in ipairs(var0_2.target) do
		if iter3_2 > arg0_2.data1 then
			break
		elseif not var2_2[iter3_2] then
			table.insert(var1_2, Drop.Create(pg.battlepass_event_award[var0_2.award[iter2_2]].drop_client))
		end
	end

	if arg0_2.data2 ~= 1 then
		return PlayerConst.MergePassItemDrop(var1_2)
	end

	local var3_2 = {}

	for iter4_2, iter5_2 in ipairs(arg0_2.data2_list) do
		var3_2[iter5_2] = true
	end

	for iter6_2, iter7_2 in ipairs(var0_2.target) do
		if iter7_2 > arg0_2.data1 then
			break
		elseif not var3_2[iter7_2] then
			table.insert(var1_2, Drop.Create(pg.battlepass_event_award[var0_2.award_pay[iter6_2]].drop_client))
		end
	end

	return PlayerConst.MergePassItemDrop(var1_2)
end

function var0_0.GetCrusingInfo(arg0_3)
	assert(arg0_3:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_CRUSING, "type error")

	local var0_3 = pg.battlepass_event_pt[arg0_3.id]
	local var1_3 = var0_3.pt
	local var2_3 = {}
	local var3_3 = {}

	for iter0_3, iter1_3 in ipairs(var0_3.key_point_display) do
		var3_3[iter1_3] = true
	end

	for iter2_3, iter3_3 in ipairs(var0_3.target) do
		table.insert(var2_3, {
			id = iter2_3,
			pt = iter3_3,
			award = pg.battlepass_event_award[var0_3.award[iter2_3]].drop_client,
			award_pay = pg.battlepass_event_award[var0_3.award_pay[iter2_3]].drop_client,
			isImportent = var3_3[iter2_3]
		})
	end

	local var4_3 = arg0_3.data1
	local var5_3 = arg0_3.data2 == 1
	local var6_3 = {}

	for iter4_3, iter5_3 in ipairs(arg0_3.data1_list) do
		var6_3[iter5_3] = true
	end

	local var7_3 = {}

	for iter6_3, iter7_3 in ipairs(arg0_3.data2_list) do
		var7_3[iter7_3] = true
	end

	local var8_3 = 0

	for iter8_3, iter9_3 in ipairs(var2_3) do
		if var4_3 < iter9_3.pt then
			break
		else
			var8_3 = iter8_3
		end
	end

	return {
		ptId = var1_3,
		awardList = var2_3,
		pt = var4_3,
		isPay = var5_3,
		awardDic = var6_3,
		awardPayDic = var7_3,
		phase = var8_3
	}
end

function var0_0.GetUpdateToastData(arg0_4, arg1_4)
	local var0_4 = pg.battlepass_event_pt[arg0_4.id]
	local var1_4 = var0_4.target

	if arg1_4 and arg1_4.data1 < var1_4[#var1_4] and arg0_4.data1 - arg1_4.data1 > 0 then
		return {
			ptId = var0_4.pt,
			ptCount = arg0_4.data1 - arg1_4.data1
		}
	end
end

function var0_0.SyncAwardRecords(arg0_5, arg1_5)
	arg0_5.data1_list = {}
	arg1_5 = arg1_5 or pg.battlepass_event_pt[arg0_5.id]

	for iter0_5, iter1_5 in ipairs(arg1_5.target) do
		if iter1_5 <= arg0_5.data1 then
			table.insert(arg0_5.data1_list, iter1_5)
		else
			break
		end
	end

	if arg0_5.data2 == 1 then
		arg0_5.data2_list = underscore.rest(arg0_5.data1_list, 1)
	else
		arg0_5.data2_list = {}
	end
end

function var0_0.AddAwardRecord(arg0_6, arg1_6)
	if not table.contains(arg0_6.data1_list, arg1_6) then
		table.insert(arg0_6.data1_list, arg1_6)
	end
end

function var0_0.AddPayAwardRecord(arg0_7, arg1_7)
	if not table.contains(arg0_7.data2_list, arg1_7) then
		table.insert(arg0_7.data2_list, arg1_7)
	end
end

function var0_0.CreatePreviousPeriodAct(arg0_8)
	local var0_8 = pg.battlepass_event_pt[arg0_8.id]

	if arg0_8.data3 > 0 and var0_8.related_activity and var0_8.related_activity ~= 0 then
		return PrevPeriodCrusingActivity.New(var0_8.related_activity, arg0_8)
	end

	return nil
end

function var0_0.GetPreviousPeriodAct(arg0_9)
	return arg0_9.previousPeriodAct
end

function var0_0.UpdatePreviousPeriodAct(arg0_10)
	if not arg0_10.previousPeriodAct then
		return
	end

	arg0_10.previousPeriodAct:RevertSynCrusingActivity(arg0_10)

	arg0_10.previousPeriodAct = arg0_10:CreatePreviousPeriodAct()
end

return var0_0
