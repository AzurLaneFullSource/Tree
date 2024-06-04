local var0 = class("CourtYardWallFurniture", import(".CourtYardFurniture"))

function var0.Ctor(arg0, arg1, arg2)
	pg.furniture_data_template[arg2.configId or arg2.id].size[2] = 1

	var0.super.Ctor(arg0, arg1, arg2)
end

function var0.Init(arg0, arg1)
	arg0:UpdatePosition(arg1)
end

function var0.UpdatePosition(arg0, arg1)
	arg0:SetPosition(arg1)
	arg0:SetDir(arg0:GetDirection())
end

function var0.GetInitSize(arg0)
	if arg0:RightDirectionLimited() then
		return {
			{
				arg0.sizeY,
				arg0.sizeX
			}
		}
	elseif arg0:LeftDirectionLimited() then
		return {
			{
				arg0.sizeX,
				arg0.sizeY
			}
		}
	else
		return {
			{
				arg0.sizeX,
				arg0.sizeY
			},
			{
				arg0.sizeY,
				arg0.sizeX
			}
		}
	end
end

function var0._GetDirection(arg0, arg1)
	if arg0:RightDirectionLimited() then
		return 2
	elseif arg0:LeftDirectionLimited() then
		return 1
	elseif arg1.y - arg1.x >= 1 then
		return 1
	else
		return 2
	end
end

function var0.GetWidth(arg0)
	return arg0.config.size[1]
end

function var0.GetDirection(arg0)
	local var0 = arg0:GetPosition()

	return arg0:_GetDirection(var0)
end

function var0.Rotate(arg0)
	return
end

function var0.InActivityRange(arg0, arg1)
	local var0 = arg0:GetHost():GetStorey():GetRange()

	return (arg1.x == var0.x or arg1.y == var0.y) and arg1.x ~= arg1.y
end

function var0.LeftDirectionLimited(arg0)
	return arg0.config.belong == 3
end

function var0.RightDirectionLimited(arg0)
	return arg0.config.belong == 4
end

function var0.NormalizePosition(arg0, arg1, arg2)
	local var0 = arg0:GetHost():GetStorey():GetRange().x
	local var1 = arg0:_GetDirection(arg1) == 1
	local var2 = (var1 and Vector2(arg1.x, arg1.y) or Vector2(arg1.y, arg1.x)).x
	local var3 = arg0:GetWidth()
	local var4 = math.min(var2, var0 - var3)
	local var5 = math.max(arg2, var4)
	local var6 = var1 and Vector2(var5, var0) or Vector2(var0, var5)

	arg0:SetDir(arg0:_GetDirection(var6))

	return var6
end

function var0.SetDir(arg0, arg1)
	var0.super.SetDir(arg0, arg1)
	arg0:DispatchEvent(CourtYardEvent.ROTATE_FURNITURE, arg0.dir)
end

function var0.CanPutChild(arg0)
	return false
end

return var0
