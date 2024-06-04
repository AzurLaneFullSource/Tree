local var0 = class("WakabaChrisSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	arg0.nday = arg0.activity.data3

	local var0 = {}
	local var1 = arg0.activity:getConfig("config_client").story
	local var2 = pg.NewStoryMgr.GetInstance()

	for iter0 = 1, arg0.nday do
		if checkExist(var1, {
			iter0
		}, {
			1
		}) and not var2:IsPlayed(var1[iter0][1]) then
			table.insert(var0, function(arg0)
				var2:Play(var1[iter0][1], arg0)
			end)
		end
	end

	seriesAsync(var0, function()
		print("story play number", #var0)
	end)
	setText(arg0.dayTF, arg0.nday .. "/" .. #arg0.taskGroup)
	arg0.uilist:align(#arg0.taskGroup[arg0.nday])
end

return var0
