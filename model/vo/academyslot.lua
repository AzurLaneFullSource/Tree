local var0_0 = class("AcademySlot", import(".BaseVO"))

var0_0.STATE_IDLE = "STATE_IDLE"
var0_0.STATE_IN_CLASS = "STATE_IN_CLASS"
var0_0.STATE_CLASS_OVER = "STATE_CLASS_OVER"

function var0_0.Ctor(arg0_1)
	return
end

function var0_0.SetSlotData(arg0_2, arg1_2)
	arg0_2._shipVO = arg1_2.ship
	arg0_2._attrList = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.attr_list) do
		arg0_2._attrList[iter1_2.attr] = iter1_2.num
	end

	arg0_2._timeStamp = arg1_2.time
end

function var0_0.GetShip(arg0_3)
	return arg0_3._shipVO
end

function var0_0.GetAttrList(arg0_4)
	return arg0_4._attrList
end

function var0_0.GetDuration(arg0_5)
	if arg0_5._timeStamp then
		return arg0_5._timeStamp - pg.TimeMgr.GetInstance():GetServerTime()
	else
		return nil
	end
end

return var0_0
