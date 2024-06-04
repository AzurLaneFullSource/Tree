local var0 = class("AcademySlot", import(".BaseVO"))

var0.STATE_IDLE = "STATE_IDLE"
var0.STATE_IN_CLASS = "STATE_IN_CLASS"
var0.STATE_CLASS_OVER = "STATE_CLASS_OVER"

function var0.Ctor(arg0)
	return
end

function var0.SetSlotData(arg0, arg1)
	arg0._shipVO = arg1.ship
	arg0._attrList = {}

	for iter0, iter1 in ipairs(arg1.attr_list) do
		arg0._attrList[iter1.attr] = iter1.num
	end

	arg0._timeStamp = arg1.time
end

function var0.GetShip(arg0)
	return arg0._shipVO
end

function var0.GetAttrList(arg0)
	return arg0._attrList
end

function var0.GetDuration(arg0)
	if arg0._timeStamp then
		return arg0._timeStamp - pg.TimeMgr.GetInstance():GetServerTime()
	else
		return nil
	end
end

return var0
