local var0 = class("ResourceFieldPercentAttr", import(".ResourceFieldProductAttr"))

function var0.GetProgressDesc(arg0)
	return arg0.value .. "%" .. "/" .. arg0.maxValue .. "%"
end

function var0.GetAdditionDesc(arg0)
	return arg0.addition .. "%"
end

return var0
