local var0_0 = class("GuideFindUIStep", import(".GuideStep"))

var0_0.TRIGGER_TYPE_BUTTON = 1
var0_0.TRIGGER_TYPE_TOGGLE = 2
var0_0.EVENT_TYPE_CLICK = 3
var0_0.EVENT_TYPE_STICK = 4
var0_0.SHOW_UI = 5
var0_0.TRIGGER_TYPE_BUTTONEX = 6
var0_0.SNAP_PAGE = 7
var0_0.EVENT_TYPE_EVT_CLICK = 8

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.eventUI = arg0_1:GenEventSearchData(arg1_1.ui)
end

function var0_0.GenEventSearchData(arg0_2, arg1_2)
	if not arg1_2 then
		return nil
	end

	local var0_2 = arg0_2:GenSearchData(arg1_2)
	local var1_2 = arg1_2.scale ~= nil
	local var2_2 = arg1_2.scale or 1

	if arg1_2.dynamicPath then
		local var3_2, var4_2 = arg1_2.dynamicPath()

		if var3_2 then
			var0_2.path = var3_2
		end

		if var4_2 then
			var1_2 = true
			var2_2 = var4_2
		end
	end

	var0_2.settings = {
		pos = arg1_2.pos,
		scale = var2_2,
		eulerAngles = arg1_2.eulerAngles,
		isLevelPoint = arg1_2.isLevelPoint,
		image = arg1_2.image,
		customPosition = arg1_2.pos or var1_2 or arg1_2.eulerAngles or arg1_2.isLevelPoint,
		clearChildEvent = arg1_2.eventPath ~= nil,
		keepScrollTxt = arg1_2.keepScrollTxt
	}

	local var5_2
	local var6_2

	if arg1_2.onClick then
		var5_2 = var0_0.TRIGGER_TYPE_BUTTONEX
		var6_2 = arg1_2.onClick
	else
		var5_2 = arg1_2.triggerType and arg1_2.triggerType[1] or var0_0.TRIGGER_TYPE_BUTTON
		var6_2 = arg1_2.triggerType and arg1_2.triggerType[2]
	end

	local var7_2 = arg1_2.eventPath

	if arg1_2.dynamicEventPath then
		var7_2 = arg1_2.dynamicEventPath()
	end

	var0_2.triggerData = {
		type = var5_2,
		arg = var6_2
	}
	var0_2.childIndex = arg1_2.eventIndex
	var0_2.eventPath = var7_2
	var0_2.fingerPos = arg1_2.fingerPos
	var0_2.slipAnim = var5_2 == var0_0.SNAP_PAGE

	return var0_2
end

function var0_0.GetType(arg0_3)
	return GuideStep.TYPE_FINDUI
end

function var0_0.GetEventUI(arg0_4)
	return arg0_4.eventUI
end

return var0_0
