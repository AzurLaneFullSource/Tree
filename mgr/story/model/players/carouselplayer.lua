local var0 = class("CarouselPlayer", import(".StoryPlayer"))

function var0.OnReset(arg0, arg1, arg2, arg3)
	setActive(arg0.actorPanel, false)
	arg3()
end

function var0.OnEnter(arg0, arg1, arg2, arg3)
	arg0:StartAnimtion(arg1, arg3)
end

function var0.StartAnimtion(arg0, arg1, arg2)
	local var0 = arg1:GetBgs()

	assert(var0)
	setActive(arg0.bgPanel, true)

	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		local var2 = iter1[1]
		local var3 = iter1[2]

		table.insert(var1, function(arg0)
			arg0:ReplaceBg(var2, var3, arg0)
		end)
	end

	seriesAsync(var1, arg2)
end

function var0.RegisetEvent(arg0, arg1)
	var0.super.RegisetEvent(arg0, arg1)
	triggerButton(arg0._go)
end

function var0.ReplaceBg(arg0, arg1, arg2, arg3)
	arg0.bgImage.sprite = arg0:GetBg(arg1)

	arg0:DelayCall(arg2, arg3)
end

return var0
