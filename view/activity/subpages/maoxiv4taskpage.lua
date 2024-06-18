local var0_0 = class("MaoxiV4TaskPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	arg0_1.nday = arg0_1.activity.data3

	local var0_1 = arg0_1.activity:getConfig("config_client").firstStory

	if var0_1 then
		playStory(var0_1)
	end

	arg0_1:PlayStory()

	if arg0_1.dayTF then
		setText(arg0_1.dayTF, tostring(arg0_1.nday))
	end

	arg0_1.uilist:align(#arg0_1.taskGroup[arg0_1.nday])
end

function var0_0.PlayStory(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_client").story
	local var1_2 = arg0_2.nday - 1

	if arg0_2.nday == 7 then
		local var2_2 = arg0_2.taskGroup[arg0_2.nday][1]
		local var3_2 = arg0_2.taskGroup[arg0_2.nday][2]
		local var4_2 = arg0_2.taskProxy:getTaskById(var2_2) or arg0_2.taskProxy:getFinishTaskById(var2_2)
		local var5_2 = arg0_2.taskProxy:getTaskById(var3_2) or arg0_2.taskProxy:getFinishTaskById(var3_2)

		if var4_2:getTaskStatus() == 2 and var5_2:getTaskStatus() == 2 then
			var1_2 = var1_2 + 1
		end
	end

	if checkExist(var0_2, {
		var1_2
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0_2[var1_2][1])
	end
end

return var0_0
