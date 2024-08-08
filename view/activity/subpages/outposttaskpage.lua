local var0_0 = class("OutPostTaskPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	setText(arg0_1.dayTF, arg0_1.nday)
end

function var0_0.PlayStory(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_client").story
	local var1_2 = arg0_2.taskGroup[arg0_2.nday][1]
	local var2_2 = arg0_2.taskGroup[arg0_2.nday][2]
	local var3_2 = arg0_2.taskProxy:getTaskById(var1_2) or arg0_2.taskProxy:getFinishTaskById(var1_2)
	local var4_2 = arg0_2.taskProxy:getTaskById(var2_2) or arg0_2.taskProxy:getFinishTaskById(var2_2)
	local var5_2 = 1

	if var3_2:getTaskStatus() == 2 and var4_2:getTaskStatus() == 2 then
		var5_2 = 0
	end

	local var6_2 = arg0_2.nday - var5_2

	if checkExist(var0_2, {
		var6_2
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0_2[var6_2][1])
	end
end

return var0_0
