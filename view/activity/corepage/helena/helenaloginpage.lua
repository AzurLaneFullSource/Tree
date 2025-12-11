local var0_0 = class("HelenaLoginPage", import("view.activity.CorePage.CoreLoginTemplatePage"))

function var0_0.OnDataSetting(arg0_1)
	arg0_1.nday = 0
	arg0_1.taskProxy = getProxy(TaskProxy)
	arg0_1.taskGroup = arg0_1.activity:getConfig("config_data")
	arg0_1.preStory = arg0_1.activity:getConfig("config_client").firstStory

	if arg0_1.preStory ~= nil then
		pg.NewStoryMgr.GetInstance():Play(arg0_1.preStory)
	end

	return updateActivityTaskStatus(arg0_1.activity)
end

function var0_0.OnUpdateFlush(arg0_2)
	arg0_2.nday = arg0_2.activity.data3

	arg0_2:PlayStory()

	if arg0_2.dayTF then
		setText(arg0_2.dayTF, arg0_2.nday .. "/" .. #arg0_2.taskGroup)
	end

	arg0_2.uilist:align(#arg0_2.taskGroup[arg0_2.nday])
end

function var0_0.PlayStory(arg0_3)
	local var0_3 = arg0_3.activity:getConfig("config_client").story
	local var1_3 = arg0_3.nday - 1

	if arg0_3.nday < 8 then
		local var2_3 = arg0_3.taskGroup[arg0_3.nday][1]
		local var3_3 = arg0_3.taskGroup[arg0_3.nday][2]
		local var4_3 = arg0_3.taskProxy:getTaskById(var2_3) or arg0_3.taskProxy:getFinishTaskById(var2_3)
		local var5_3 = arg0_3.taskProxy:getTaskById(var3_3) or arg0_3.taskProxy:getFinishTaskById(var3_3)

		if var4_3:getTaskStatus() == 2 and var5_3:getTaskStatus() == 2 then
			var1_3 = var1_3 + 1
		end
	end

	if checkExist(var0_3, {
		var1_3
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0_3[var1_3][1])
	end
end

function var0_0.GetProgressColor(arg0_4)
	return "#466cd4", "#737373"
end

return var0_0
