local var0_0 = class("CommanderCatPlayAnimation")
local var1_0 = 0.3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.expSlider = arg1_1
end

function var0_0.Action(arg0_2, arg1_2, arg2_2, arg3_2)
	if arg2_2.level - arg1_2.level > 0 then
		arg0_2:DoLevelOffsetAnimation(arg1_2, arg2_2, arg3_2)
	else
		arg0_2:DoSameLevelAnimation(arg1_2, arg2_2, arg3_2)
	end
end

function var0_0.DoLevelOffsetAnimation(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg2_3.level - arg1_3.level
	local var1_3 = {}

	table.insert(var1_3, function(arg0_4)
		local var0_4 = arg1_3:getNextLevelExp()

		TweenValue(go(arg0_3.expSlider), arg1_3.exp, var0_4, var1_0, 0, function(arg0_5)
			arg0_3.expSlider.value = arg0_5
		end, arg0_4)
	end)

	for iter0_3 = 1, var0_3 - 1 do
		table.insert(var1_3, function(arg0_6)
			TweenValue(go(arg0_3.expSlider), 0, 1, var1_0, 0, function(arg0_7)
				arg0_3.expSlider.value = arg0_7
			end, arg0_6)
		end)
	end

	table.insert(var1_3, function(arg0_8)
		local var0_8 = arg2_3:getNextLevelExp()

		TweenValue(go(arg0_3.expSlider), 0, arg2_3.exp, var1_0, 0, function(arg0_9)
			arg0_3.expSlider.value = arg0_9 / var0_8
		end, arg0_8)
	end)
	seriesAsync(var1_3, arg3_3)
end

function var0_0.DoSameLevelAnimation(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg1_10:getNextLevelExp()

	TweenValue(go(arg0_10.expSlider), arg1_10.exp, arg2_10.exp, var1_0, 0, function(arg0_11)
		arg0_10.expSlider.value = arg0_11 / var0_10
	end, arg3_10)
end

function var0_0.Dispose(arg0_12)
	if LeanTween.isTweening(arg0_12.expSlider.gameObject) then
		LeanTween.cancel(arg0_12.expSlider.gameObject)
	end
end

return var0_0
