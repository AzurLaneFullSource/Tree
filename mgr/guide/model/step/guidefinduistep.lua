local var0 = class("GuideFindUIStep", import(".GuideStep"))

var0.TRIGGER_TYPE_BUTTON = 1
var0.TRIGGER_TYPE_TOGGLE = 2
var0.EVENT_TYPE_CLICK = 3
var0.EVENT_TYPE_STICK = 4
var0.SHOW_UI = 5
var0.TRIGGER_TYPE_BUTTONEX = 6
var0.SNAP_PAGE = 7
var0.EVENT_TYPE_EVT_CLICK = 8

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.eventUI = arg0:GenEventSearchData(arg1.ui)
end

function var0.GenEventSearchData(arg0, arg1)
	if not arg1 then
		return nil
	end

	local var0 = arg0:GenSearchData(arg1)
	local var1 = arg1.scale ~= nil
	local var2 = arg1.scale or 1

	if arg1.dynamicPath then
		local var3, var4 = arg1.dynamicPath()

		if var3 then
			var0.path = var3
		end

		if var4 then
			var1 = true
			var2 = var4
		end
	end

	var0.settings = {
		pos = arg1.pos,
		scale = var2,
		eulerAngles = arg1.eulerAngles,
		isLevelPoint = arg1.isLevelPoint,
		image = arg1.image,
		customPosition = arg1.pos or var1 or arg1.eulerAngles or arg1.isLevelPoint,
		clearChildEvent = arg1.eventPath ~= nil,
		keepScrollTxt = arg1.keepScrollTxt
	}

	local var5
	local var6

	if arg1.onClick then
		var5 = var0.TRIGGER_TYPE_BUTTONEX
		var6 = arg1.onClick
	else
		var5 = arg1.triggerType and arg1.triggerType[1] or var0.TRIGGER_TYPE_BUTTON
		var6 = arg1.triggerType and arg1.triggerType[2]
	end

	local var7 = arg1.eventPath

	if arg1.dynamicEventPath then
		var7 = arg1.dynamicEventPath()
	end

	var0.triggerData = {
		type = var5,
		arg = var6
	}
	var0.childIndex = arg1.eventIndex
	var0.eventPath = var7
	var0.fingerPos = arg1.fingerPos
	var0.slipAnim = var5 == var0.SNAP_PAGE

	return var0
end

function var0.GetType(arg0)
	return GuideStep.TYPE_FINDUI
end

function var0.GetEventUI(arg0)
	return arg0.eventUI
end

return var0
