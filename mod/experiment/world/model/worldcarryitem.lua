local var0 = class("WorldCarryItem", import("...BaseEntity"))

var0.Fields = {
	config = "table",
	id = "number",
	offsetRow = "number",
	offsetColumn = "number"
}
var0.EventUpdateOffset = "WorldCarryItem.EventUpdateOffset"

function var0.Setup(arg0, arg1)
	arg0.id = arg1
	arg0.config = pg.world_carry_item[arg0.id]

	assert(arg0.config, "world_carry_item not exist: " .. arg0.id)

	arg0.offsetRow = 0
	arg0.offsetColumn = 0
end

function var0.UpdateOffset(arg0, arg1, arg2)
	if arg0.offsetRow ~= arg1 or arg0.offsetColumn ~= arg2 then
		arg0.offsetRow = arg1
		arg0.offsetColumn = arg2

		arg0:DispatchEvent(var0.EventUpdateOffset)
	end
end

function var0.GetScale(arg0)
	return Vector3(arg0.config.scale / 100, arg0.config.scale / 100, 1)
end

function var0.IsAvatar(arg0)
	return arg0.config.enemyicon == 1
end

return var0
