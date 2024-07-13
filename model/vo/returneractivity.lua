local var0_0 = class("ReturnerActivity", import(".Activity"))

var0_0.TYPE_INVITER = 1
var0_0.TYPE_RETURNER = 2

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.roleType = arg0_1.data1
end

function var0_0.IsPush(arg0_2)
	return arg0_2.data2_list[1] == 1
end

function var0_0.IsInviter(arg0_3)
	return arg0_3.roleType == var0_0.TYPE_INVITER
end

function var0_0.IsReturner(arg0_4)
	return arg0_4.roleType == var0_0.TYPE_RETURNER
end

function var0_0.ShouldAcceptTasks(arg0_5)
	if arg0_5:IsInviter() then
		return arg0_5:ShouldAcceptTasksIfInviter()
	elseif arg0_5:IsReturner() then
		return arg0_5:ShouldAcceptTasksIfReturner()
	end
end

function var0_0.ShouldAcceptTasksIfInviter(arg0_6)
	if arg0_6:IsPush() then
		local var0_6 = arg0_6:getDataConfigTable("tasklist")
		local var1_6 = arg0_6:getDayIndex()
		local var2_6 = getProxy(TaskProxy)
		local var3_6 = 0

		for iter0_6 = #var0_6, 1, -1 do
			if arg0_6:GetTask(var0_6[iter0_6]) then
				var3_6 = iter0_6

				break
			end
		end

		local var4_6 = arg0_6:GetTask(var0_6[var3_6])

		if (not var4_6 or var4_6:isReceive()) and var3_6 < var1_6 and (var3_6 ~= #var0_6 or not var4_6 or not var4_6:isReceive()) then
			return true
		end
	end

	return false
end

function var0_0.GetTask(arg0_7, arg1_7)
	local var0_7 = getProxy(TaskProxy)

	return var0_7:getTaskById(arg1_7) or var0_7:getFinishTaskById(arg1_7)
end

function var0_0.ShouldAcceptTasksIfReturner(arg0_8)
	local var0_8 = arg0_8.data4

	if arg0_8.data2 == 0 then
		return false
	end

	if var0_8 == 0 then
		return true
	end

	local var1_8 = arg0_8:getDataConfigTable("task_list")
	local var2_8 = getProxy(TaskProxy)
	local var3_8 = _.all(var1_8[var0_8], function(arg0_9)
		return var2_8:getFinishTaskById(arg0_9) ~= nil
	end)
	local var4_8 = _.all(var1_8[var0_8], function(arg0_10)
		return var2_8:getTaskById(arg0_10) == nil and var2_8:getFinishTaskById(arg0_10) == nil
	end)
	local var5_8 = var0_8 == #var1_8

	local function var6_8()
		local var0_11 = pg.TimeMgr.GetInstance():GetServerTime()

		return pg.TimeMgr.GetInstance():DiffDay(arg0_8:getStartTime(), var0_11) + 1 > var0_8
	end

	return var4_8 or var3_8 and not var5_8 and var6_8()
end

function var0_0.getDataConfigTable(arg0_12, arg1_12)
	if arg0_12:IsInviter() then
		return pg.activity_template_headhunting[arg0_12.id][arg1_12]
	elseif arg0_12:IsReturner() then
		return pg.activity_template_returnner[arg0_12.id][arg1_12]
	end
end

return var0_0
