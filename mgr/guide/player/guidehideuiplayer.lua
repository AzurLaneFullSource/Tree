local var0_0 = class("GuideHideUIPlayer", import(".GuidePlayer"))
local var1_0 = 1
local var2_0 = 2

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

				arg0_1:SetActive(arg0_3, not iter1_1.hideFlag, defaultValue(iter1_1.type, var1_0))
				arg0_2()
			end)
		end)
	end

	parallelAsync(var1_1, arg2_1)
end

function var0_0.SetActive(arg0_4, arg1_4, arg2_4, arg3_4)
	if arg3_4 == var1_0 then
		setActive(arg1_4, arg2_4)
	elseif arg3_4 == var2_0 then
		local var0_4 = GetOrAddComponent(arg1_4, typeof(CanvasGroup))

		var0_4.alpha = arg2_4 and 1 or 0
		var0_4.blocksRaycasts = arg2_4
	end
end

function var0_0.RegisterEvent(arg0_5, arg1_5, arg2_5)
	arg2_5()
end

return var0_0
