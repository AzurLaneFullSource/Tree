local var0 = class("LuodeniTaskPage", import(".TemplatePage.SkinTemplatePage"))

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
	setText(arg0.dayTF, setColorStr(arg0.nday, "#F2F5FF") .. setColorStr("/" .. #arg0.taskGroup, "#F2F5FF"))
end

function var0.PlayStory(arg0)
	local var0 = arg0.activity:getConfig("config_client").story
	local var1 = false

	if arg0.nday == 1 then
		local var2 = arg0.taskGroup[1][1]
		local var3 = arg0.taskGroup[1][2]
		local var4 = arg0.taskProxy:getTaskById(var2) or arg0.taskProxy:getFinishTaskById(var2)
		local var5 = arg0.taskProxy:getTaskById(var3) or arg0.taskProxy:getFinishTaskById(var3)

		if var4:getTaskStatus() == 2 and var5:getTaskStatus() == 2 and checkExist(var0, {
			1
		}, {
			1
		}) then
			var1 = true
		end
	end

	if arg0.nday == 2 then
		var1 = true
	end

	if arg0.nday == 1 and var1 or arg0.nday == 2 then
		pg.NewStoryMgr.GetInstance():Play(var0[1][1])
	end

	if arg0.nday == 5 then
		local var6 = arg0.nday
		local var7 = arg0.taskGroup[arg0.nday][1]
		local var8 = arg0.taskGroup[arg0.nday][2]
		local var9 = arg0.taskProxy:getTaskById(var7) or arg0.taskProxy:getFinishTaskById(var7)
		local var10 = arg0.taskProxy:getTaskById(var8) or arg0.taskProxy:getFinishTaskById(var8)

		if var9:getTaskStatus() == 2 and var10:getTaskStatus() == 2 then
			var6 = var6 + 1
		end

		if checkExist(var0, {
			var6
		}, {
			1
		}) then
			pg.NewStoryMgr.GetInstance():Play(var0[var6][1])
		end
	elseif arg0.nday ~= 1 and checkExist(var0, {
		arg0.nday
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var0[arg0.nday][1])
	end
end

function var0.GetProgressColor(arg0)
	return "#98A7D1", "#98A7D1"
end

return var0
