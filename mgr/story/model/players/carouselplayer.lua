local var0_0 = class("CarouselPlayer", import(".StoryPlayer"))

function var0_0.OnReset(arg0_1, arg1_1, arg2_1, arg3_1)
	setActive(arg0_1.actorPanel, false)
	arg3_1()
end

function var0_0.OnEnter(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2:StartAnimtion(arg1_2, arg3_2)
end

function var0_0.StartAnimtion(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg1_3:GetBgs()

	assert(var0_3)
	setActive(arg0_3.bgPanel, true)

	local var1_3 = {}

	for iter0_3, iter1_3 in ipairs(var0_3) do
		local var2_3 = iter1_3[1]
		local var3_3 = iter1_3[2]

		table.insert(var1_3, function(arg0_4)
			arg0_3:ReplaceBg(var2_3, var3_3, arg0_4)
		end)
	end

	seriesAsync(var1_3, arg2_3)
end

function var0_0.RegisetEvent(arg0_5, arg1_5)
	var0_0.super.RegisetEvent(arg0_5, arg1_5)
	triggerButton(arg0_5._go)
end

function var0_0.ReplaceBg(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6.bgImage.sprite = arg0_6:GetBg(arg1_6)

	arg0_6:DelayCall(arg2_6, arg3_6)
end

return var0_0
