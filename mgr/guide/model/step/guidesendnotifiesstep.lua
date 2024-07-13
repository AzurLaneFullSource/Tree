local var0_0 = class("GuideSendNotifiesStep", import(".GuideStep"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.notifies = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.notifies) do
		table.insert(arg0_1.notifies, {
			notify = iter1_1.notify,
			body = iter1_1.body
		})
	end
end

function var0_0.GetType(arg0_2)
	return GuideStep.TYPE_SENDNOTIFIES
end

function var0_0.GetNotifies(arg0_3)
	return arg0_3.notifies
end

function var0_0.ExistTrigger(arg0_4)
	return true
end

return var0_0
