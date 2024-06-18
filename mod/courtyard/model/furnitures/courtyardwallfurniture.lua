local var0_0 = class("CourtYardWallFurniture", import(".CourtYardFurniture"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.furniture_data_template[arg2_1.configId or arg2_1.id].size[2] = 1

	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var0_0.Init(arg0_2, arg1_2)
	arg0_2:UpdatePosition(arg1_2)
end

function var0_0.UpdatePosition(arg0_3, arg1_3)
	arg0_3:SetPosition(arg1_3)
	arg0_3:SetDir(arg0_3:GetDirection())
end

function var0_0.GetInitSize(arg0_4)
	if arg0_4:RightDirectionLimited() then
		return {
			{
				arg0_4.sizeY,
				arg0_4.sizeX
			}
		}
	elseif arg0_4:LeftDirectionLimited() then
		return {
			{
				arg0_4.sizeX,
				arg0_4.sizeY
			}
		}
	else
		return {
			{
				arg0_4.sizeX,
				arg0_4.sizeY
			},
			{
				arg0_4.sizeY,
				arg0_4.sizeX
			}
		}
	end
end

function var0_0._GetDirection(arg0_5, arg1_5)
	if arg0_5:RightDirectionLimited() then
		return 2
	elseif arg0_5:LeftDirectionLimited() then
		return 1
	elseif arg1_5.y - arg1_5.x >= 1 then
		return 1
	else
		return 2
	end
end

function var0_0.GetWidth(arg0_6)
	return arg0_6.config.size[1]
end

function var0_0.GetDirection(arg0_7)
	local var0_7 = arg0_7:GetPosition()

	return arg0_7:_GetDirection(var0_7)
end

function var0_0.Rotate(arg0_8)
	return
end

function var0_0.InActivityRange(arg0_9, arg1_9)
	local var0_9 = arg0_9:GetHost():GetStorey():GetRange()

	return (arg1_9.x == var0_9.x or arg1_9.y == var0_9.y) and arg1_9.x ~= arg1_9.y
end

function var0_0.LeftDirectionLimited(arg0_10)
	return arg0_10.config.belong == 3
end

function var0_0.RightDirectionLimited(arg0_11)
	return arg0_11.config.belong == 4
end

function var0_0.NormalizePosition(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12:GetHost():GetStorey():GetRange().x
	local var1_12 = arg0_12:_GetDirection(arg1_12) == 1
	local var2_12 = (var1_12 and Vector2(arg1_12.x, arg1_12.y) or Vector2(arg1_12.y, arg1_12.x)).x
	local var3_12 = arg0_12:GetWidth()
	local var4_12 = math.min(var2_12, var0_12 - var3_12)
	local var5_12 = math.max(arg2_12, var4_12)
	local var6_12 = var1_12 and Vector2(var5_12, var0_12) or Vector2(var0_12, var5_12)

	arg0_12:SetDir(arg0_12:_GetDirection(var6_12))

	return var6_12
end

function var0_0.SetDir(arg0_13, arg1_13)
	var0_0.super.SetDir(arg0_13, arg1_13)
	arg0_13:DispatchEvent(CourtYardEvent.ROTATE_FURNITURE, arg0_13.dir)
end

function var0_0.CanPutChild(arg0_14)
	return false
end

return var0_0
