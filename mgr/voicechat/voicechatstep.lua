local var0_0 = class("VoiceChatStep")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.say = arg1_1.say or ""
	arg0_1.voice = arg1_1.voice
	arg0_1.options = arg1_1.options
	arg0_1.waitForClick = arg1_1.wait or 0
	arg0_1.optionFlag = arg1_1.optionFlag
	arg0_1.dispatcher = arg1_1.dispatcher
	arg0_1.shipGroup = arg2_1
end

function var0_0.IsSameBranch(arg0_2, arg1_2)
	return not arg0_2.optionFlag or arg0_2.optionFlag == arg1_2
end

function var0_0.GetSay(arg0_3)
	local var0_3 = HXSet.hxLan(arg0_3.say)
	local var1_3 = getProxy(ApartmentProxy):getApartment(arg0_3.shipGroup)
	local var2_3 = var1_3 and var1_3:GetCallName() or arg0_3.shipGroup

	return (string.gsub(var0_3, "{dorm3d}", var2_3))
end

function var0_0.GetVoice(arg0_4)
	return arg0_4.voice
end

function var0_0.ExistOption(arg0_5)
	return arg0_5.options ~= nil and #arg0_5.options > 0
end

function var0_0.GetOptions(arg0_6)
	return _.map(arg0_6.options or {}, function(arg0_7)
		local var0_7 = arg0_7.content
		local var1_7 = HXSet.hxLan(var0_7)

		return {
			var1_7,
			arg0_7.flag
		}
	end)
end

function var0_0.ExistDispatcher(arg0_8)
	return arg0_8.dispatcher ~= nil
end

function var0_0.GetDispatcher(arg0_9)
	return arg0_9.dispatcher
end

function var0_0.IsRecallDispatcher(arg0_10)
	if not arg0_10:ExistDispatcher() then
		return false
	end

	local var0_10 = arg0_10:GetDispatcher()

	return var0_10.callbackData ~= nil and var0_10.callbackData.name ~= nil
end

function var0_0.GetDispatcherRecallName(arg0_11)
	if not arg0_11:IsRecallDispatcher() then
		return nil
	end

	return arg0_11:GetDispatcher().callbackData.name
end

function var0_0.ShouldHideUI(arg0_12)
	if not arg0_12:IsRecallDispatcher() then
		return false
	end

	return arg0_12:GetDispatcher().callbackData.hideUI == true
end

function var0_0.GetWaitForClickTime(arg0_13)
	return arg0_13.waitForClick
end

return var0_0
