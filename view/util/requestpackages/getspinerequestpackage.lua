local var0_0 = class("GetSpineRequestPackage", import(".RequestPackage"))

function var0_0.__call(arg0_1)
	if arg0_1.stopped then
		return
	end

	local var0_1 = arg0_1.name

	arg0_1.spineChar = SpineAnimChar.New()

	arg0_1.spineChar:SetPaint(var0_1)
	arg0_1.spineChar:Load(true, function(arg0_2)
		if arg0_1.stopped then
			arg0_2:Dispose()

			return
		end

		if arg0_1.onLoaded then
			arg0_1.onLoaded(arg0_2)
		end
	end)

	return arg0_1
end

function var0_0.Ctor(arg0_3, arg1_3, arg2_3)
	arg0_3.name = arg1_3
	arg0_3.path = "Spine"
	arg0_3.onLoaded = arg2_3
end

return var0_0
