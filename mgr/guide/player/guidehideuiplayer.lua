local var0 = class("GuideHideUIPlayer", import(".GuidePlayer"))

function var0.OnExecution(arg0, arg1, arg2)
	local var0 = arg1:GetHideNodes()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var1, function(arg0)
			arg0:SearchWithoutDelay(iter1, function(arg0)
				if not arg0 then
					pg.NewGuideMgr.GetInstance():Stop()

					return
				end

				setActive(arg0, not iter1.hideFlag)
				arg0()
			end)
		end)
	end

	parallelAsync(var1, arg2)
end

function var0.RegisterEvent(arg0, arg1, arg2)
	arg2()
end

return var0
