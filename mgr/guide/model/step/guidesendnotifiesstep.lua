local var0 = class("GuideSendNotifiesStep", import(".GuideStep"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.notifies = {}

	for iter0, iter1 in ipairs(arg1.notifies) do
		table.insert(arg0.notifies, {
			notify = iter1.notify,
			body = iter1.body
		})
	end
end

function var0.GetType(arg0)
	return GuideStep.TYPE_SENDNOTIFIES
end

function var0.GetNotifies(arg0)
	return arg0.notifies
end

function var0.ExistTrigger(arg0)
	return true
end

return var0
