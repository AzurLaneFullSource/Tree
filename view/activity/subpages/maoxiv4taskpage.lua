local var0 = class("MaoxiV4TaskPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	arg0.nday = arg0.activity.data3

	local var0 = arg0.activity:getConfig("config_client").firstStory

	if var0 then
		playStory(var0)
	end

	arg0:PlayStory()

	if arg0.dayTF then
		setText(arg0.dayTF, tostring(arg0.nday))
	end

	arg0.uilist:align(#arg0.taskGroup[arg0.nday])
end

function var0.PlayStory(arg0)
	local var0 = arg0.activity:getConfig("config_client").story
	local var1 = arg0.nday - 1

	if arg0.nday == 7 then
		local var2 = arg0.taskGroup[arg0.nday][1]
		local var3 = arg0.taskGroup[arg0.nday][2]
		local var4 = arg0.taskProxy:getTaskById(var2) or arg0.taskProxy:getFinishTaskById(var2)
		local var5 = arg0.taskProxy:getTaskById(var3) or arg0.taskProxy:getFinishTaskById(var3)

		if var4:getTaskStatus() == 2 and var5:getTaskStatus() == 2 then
			var1 = var1 + 1
		end
	end

	if checkExist(var0, {
		var1
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0[var1][1])
	end
end

return var0
