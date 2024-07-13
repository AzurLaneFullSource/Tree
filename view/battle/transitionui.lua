local var0_0 = class("Transition", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	local var0_1 = arg0_1.UIName

	if not var0_1 then
		var0_1 = arg0_1.contextData.loadUI
		arg0_1.UIName = var0_1
	end

	return var0_1
end

function var0_0.init(arg0_2)
	return
end

function var0_0.didEnter(arg0_3)
	return
end

function var0_0.onBackPressed(arg0_4)
	return
end

return var0_0
