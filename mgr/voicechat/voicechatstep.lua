local var0_0 = class("VoiceChatStep")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.say = arg1_1.say or ""
	arg0_1.voice = arg1_1.voice
	arg0_1.options = arg1_1.options
	arg0_1.waitForClick = arg1_1.wait or 0
	arg0_1.optionFlag = arg1_1.optionFlag
end

function var0_0.IsSameBranch(arg0_2, arg1_2)
	return not arg0_2.optionFlag or arg0_2.optionFlag == arg1_2
end

function var0_0.GetSay(arg0_3)
	return arg0_3.say
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

function var0_0.GetWaitForClickTime(arg0_8)
	return arg0_8.waitForClick
end

return var0_0
