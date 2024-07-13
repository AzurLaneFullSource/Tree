local var0_0 = class("ResourceFieldPercentAttr", import(".ResourceFieldProductAttr"))

function var0_0.GetProgressDesc(arg0_1)
	return arg0_1.value .. "%" .. "/" .. arg0_1.maxValue .. "%"
end

function var0_0.GetAdditionDesc(arg0_2)
	return arg0_2.addition .. "%"
end

return var0_0
