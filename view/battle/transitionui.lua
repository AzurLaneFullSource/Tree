local var0 = class("Transition", import("..base.BaseUI"))

function var0.getUIName(arg0)
	local var0 = arg0.UIName

	if not var0 then
		var0 = arg0.contextData.loadUI
		arg0.UIName = var0
	end

	return var0
end

function var0.init(arg0)
	return
end

function var0.didEnter(arg0)
	return
end

function var0.onBackPressed(arg0)
	return
end

return var0
