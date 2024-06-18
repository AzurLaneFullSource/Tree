local var0_0 = class("WorldCarryItem", import("...BaseEntity"))

var0_0.Fields = {
	config = "table",
	id = "number",
	offsetRow = "number",
	offsetColumn = "number"
}
var0_0.EventUpdateOffset = "WorldCarryItem.EventUpdateOffset"

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.config = pg.world_carry_item[arg0_1.id]

	assert(arg0_1.config, "world_carry_item not exist: " .. arg0_1.id)

	arg0_1.offsetRow = 0
	arg0_1.offsetColumn = 0
end

function var0_0.UpdateOffset(arg0_2, arg1_2, arg2_2)
	if arg0_2.offsetRow ~= arg1_2 or arg0_2.offsetColumn ~= arg2_2 then
		arg0_2.offsetRow = arg1_2
		arg0_2.offsetColumn = arg2_2

		arg0_2:DispatchEvent(var0_0.EventUpdateOffset)
	end
end

function var0_0.GetScale(arg0_3)
	return Vector3(arg0_3.config.scale / 100, arg0_3.config.scale / 100, 1)
end

function var0_0.IsAvatar(arg0_4)
	return arg0_4.config.enemyicon == 1
end

return var0_0
