local var0_0 = class("GuideHideUIPlayer", import(".GuidePlayer"))

function var0_0.OnExecution(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg1_1:GetHideNodes()
	local var1_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		table.insert(var1_1, function(arg0_2)
			arg0_1:SearchWithoutDelay(iter1_1, function(arg0_3)
				if not arg0_3 then
					pg.NewGuideMgr.GetInstance():Stop()

					return
				end

				setActive(arg0_3, not iter1_1.hideFlag)
				arg0_2()
			end)
		end)
	end

	parallelAsync(var1_1, arg2_1)
end

function var0_0.RegisterEvent(arg0_4, arg1_4, arg2_4)
	arg2_4()
end

return var0_0
