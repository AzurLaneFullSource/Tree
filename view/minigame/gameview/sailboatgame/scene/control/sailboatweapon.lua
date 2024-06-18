local var0_0 = class("SailBoatWeapon")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1)
	var1_0 = SailBoatGameVo
	arg0_1._data = arg1_1
	arg0_1._fireTime = nil
end

function var0_0.start(arg0_2)
	arg0_2._fireTime = arg0_2:getConfig("cd")
end

function var0_0.step(arg0_3, arg1_3)
	if arg0_3._fireTime and arg0_3._fireTime > 0 then
		arg0_3._fireTime = arg0_3._fireTime - arg1_3

		if arg0_3._fireTime < 0 then
			arg0_3._fireTime = 0
		end
	else
		arg0_3._fireTime = 0
	end
end

function var0_0.skillStep(arg0_4, arg1_4)
	arg0_4._fireTime = arg0_4._fireTime - arg1_4
end

function var0_0.getFireAble(arg0_5)
	if arg0_5._fireTime and arg0_5._fireTime > 0 then
		return false
	end

	return true
end

function var0_0.fire(arg0_6)
	if not arg0_6:getFireAble() then
		return nil
	end

	arg0_6._fireTime = arg0_6:getConfig("cd")

	return arg0_6:getFireData()
end

function var0_0.getFireTime(arg0_7)
	return arg0_7._fireTime or 0
end

function var0_0.getFireData(arg0_8)
	return Clone(arg0_8._data)
end

function var0_0.getAngel(arg0_9)
	return arg0_9:getConfig("angel")
end

function var0_0.getDistance(arg0_10)
	return arg0_10:getConfig("distance")
end

function var0_0.getDamage(arg0_11)
	return arg0_11:getConfig("damage")
end

function var0_0.getFireFlag(arg0_12)
	return arg0_12._fireTime == 0
end

function var0_0.getConfig(arg0_13, arg1_13)
	return arg0_13._data[arg1_13]
end

function var0_0.clear(arg0_14)
	arg0_14._data = nil
end

return var0_0
