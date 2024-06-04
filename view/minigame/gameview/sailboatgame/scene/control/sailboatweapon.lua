local var0 = class("SailBoatWeapon")
local var1

function var0.Ctor(arg0, arg1)
	var1 = SailBoatGameVo
	arg0._data = arg1
	arg0._fireTime = nil
end

function var0.start(arg0)
	arg0._fireTime = arg0:getConfig("cd")
end

function var0.step(arg0, arg1)
	if arg0._fireTime and arg0._fireTime > 0 then
		arg0._fireTime = arg0._fireTime - arg1

		if arg0._fireTime < 0 then
			arg0._fireTime = 0
		end
	else
		arg0._fireTime = 0
	end
end

function var0.skillStep(arg0, arg1)
	arg0._fireTime = arg0._fireTime - arg1
end

function var0.getFireAble(arg0)
	if arg0._fireTime and arg0._fireTime > 0 then
		return false
	end

	return true
end

function var0.fire(arg0)
	if not arg0:getFireAble() then
		return nil
	end

	arg0._fireTime = arg0:getConfig("cd")

	return arg0:getFireData()
end

function var0.getFireTime(arg0)
	return arg0._fireTime or 0
end

function var0.getFireData(arg0)
	return Clone(arg0._data)
end

function var0.getAngel(arg0)
	return arg0:getConfig("angel")
end

function var0.getDistance(arg0)
	return arg0:getConfig("distance")
end

function var0.getDamage(arg0)
	return arg0:getConfig("damage")
end

function var0.getFireFlag(arg0)
	return arg0._fireTime == 0
end

function var0.getConfig(arg0, arg1)
	return arg0._data[arg1]
end

function var0.clear(arg0)
	arg0._data = nil
end

return var0
