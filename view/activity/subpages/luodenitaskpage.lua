local var0_0 = class("LuodeniTaskPage", import(".TemplatePage.SkinTemplatePage"))

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
	setText(arg0_1.dayTF, setColorStr(arg0_1.nday, "#F2F5FF") .. setColorStr("/" .. #arg0_1.taskGroup, "#F2F5FF"))
end

function var0_0.PlayStory(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_client").story
	local var1_2 = false

	if arg0_2.nday == 1 then
		local var2_2 = arg0_2.taskGroup[1][1]
		local var3_2 = arg0_2.taskGroup[1][2]
		local var4_2 = arg0_2.taskProxy:getTaskById(var2_2) or arg0_2.taskProxy:getFinishTaskById(var2_2)
		local var5_2 = arg0_2.taskProxy:getTaskById(var3_2) or arg0_2.taskProxy:getFinishTaskById(var3_2)

		if var4_2:getTaskStatus() == 2 and var5_2:getTaskStatus() == 2 and checkExist(var0_2, {
			1
		}, {
			1
		}) then
			var1_2 = true
		end
	end

	if arg0_2.nday == 2 then
		var1_2 = true
	end

	if arg0_2.nday == 1 and var1_2 or arg0_2.nday == 2 then
		pg.NewStoryMgr.GetInstance():Play(var0_2[1][1])
	end

	if arg0_2.nday == 5 then
		local var6_2 = arg0_2.nday
		local var7_2 = arg0_2.taskGroup[arg0_2.nday][1]
		local var8_2 = arg0_2.taskGroup[arg0_2.nday][2]
		local var9_2 = arg0_2.taskProxy:getTaskById(var7_2) or arg0_2.taskProxy:getFinishTaskById(var7_2)
		local var10_2 = arg0_2.taskProxy:getTaskById(var8_2) or arg0_2.taskProxy:getFinishTaskById(var8_2)

		if var9_2:getTaskStatus() == 2 and var10_2:getTaskStatus() == 2 then
			var6_2 = var6_2 + 1
		end

		if checkExist(var0_2, {
			var6_2
		}, {
			1
		}) then
			pg.NewStoryMgr.GetInstance():Play(var0_2[var6_2][1])
		end
	elseif arg0_2.nday ~= 1 and checkExist(var0_2, {
		arg0_2.nday
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0_2[arg0_2.nday][1])
	end
end

function var0_0.GetProgressColor(arg0_3)
	return "#98A7D1", "#98A7D1"
end

return var0_0
