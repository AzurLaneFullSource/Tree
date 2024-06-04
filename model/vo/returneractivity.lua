local var0 = class("ReturnerActivity", import(".Activity"))

var0.TYPE_INVITER = 1
var0.TYPE_RETURNER = 2

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.roleType = arg0.data1
end

function var0.IsPush(arg0)
	return arg0.data2_list[1] == 1
end

function var0.IsInviter(arg0)
	return arg0.roleType == var0.TYPE_INVITER
end

function var0.IsReturner(arg0)
	return arg0.roleType == var0.TYPE_RETURNER
end

function var0.ShouldAcceptTasks(arg0)
	if arg0:IsInviter() then
		return arg0:ShouldAcceptTasksIfInviter()
	elseif arg0:IsReturner() then
		return arg0:ShouldAcceptTasksIfReturner()
	end
end

function var0.ShouldAcceptTasksIfInviter(arg0)
	if arg0:IsPush() then
		local var0 = arg0:getDataConfigTable("tasklist")
		local var1 = arg0:getDayIndex()
		local var2 = getProxy(TaskProxy)
		local var3 = 0

		for iter0 = #var0, 1, -1 do
			if arg0:GetTask(var0[iter0]) then
				var3 = iter0

				break
			end
		end

		local var4 = arg0:GetTask(var0[var3])

		if (not var4 or var4:isReceive()) and var3 < var1 and (var3 ~= #var0 or not var4 or not var4:isReceive()) then
			return true
		end
	end

	return false
end

function var0.GetTask(arg0, arg1)
	local var0 = getProxy(TaskProxy)

	return var0:getTaskById(arg1) or var0:getFinishTaskById(arg1)
end

function var0.ShouldAcceptTasksIfReturner(arg0)
	local var0 = arg0.data4

	if arg0.data2 == 0 then
		return false
	end

	if var0 == 0 then
		return true
	end

	local var1 = arg0:getDataConfigTable("task_list")
	local var2 = getProxy(TaskProxy)
	local var3 = _.all(var1[var0], function(arg0)
		return var2:getFinishTaskById(arg0) ~= nil
	end)
	local var4 = _.all(var1[var0], function(arg0)
		return var2:getTaskById(arg0) == nil and var2:getFinishTaskById(arg0) == nil
	end)
	local var5 = var0 == #var1

	local function var6()
		local var0 = pg.TimeMgr.GetInstance():GetServerTime()

		return pg.TimeMgr.GetInstance():DiffDay(arg0:getStartTime(), var0) + 1 > var0
	end

	return var4 or var3 and not var5 and var6()
end

function var0.getDataConfigTable(arg0, arg1)
	if arg0:IsInviter() then
		return pg.activity_template_headhunting[arg0.id][arg1]
	elseif arg0:IsReturner() then
		return pg.activity_template_returnner[arg0.id][arg1]
	end
end

return var0
