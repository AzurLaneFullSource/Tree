local var0_0 = class("SyncUnitData")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.pos = Vector3(arg1_1.pos.x, arg1_1.pos.y, arg1_1.pos.z)
	arg0_1.dir = Quaternion(arg1_1.dir.x, arg1_1.dir.y, arg1_1.dir.z, arg1_1.dir.w)
	arg0_1.status = arg1_1.status
end

function var0_0.Pack(arg0_2)
	return {
		id = arg0_2.id,
		pos = {
			x = arg0_2.pos.x,
			y = arg0_2.pos.y,
			z = arg0_2.pos.z
		},
		dir = {
			x = arg0_2.dir.x,
			y = arg0_2.dir.y,
			z = arg0_2.dir.z,
			w = arg0_2.dir.w
		},
		status = arg0_2.status
	}
end

function var0_0.toString(arg0_3)
	return string.format("id=%d,pos=[%s,%s,%s],dir=[%s,%s,%s,%s],status=%s", arg0_3.id, string.format("%.5f", arg0_3.pos.x), string.format("%.5f", arg0_3.pos.y), string.format("%.5f", arg0_3.pos.z), string.format("%.5f", arg0_3.dir.x), string.format("%.5f", arg0_3.dir.y), string.format("%.5f", arg0_3.dir.z), string.format("%.5f", arg0_3.dir.w), PrintTable(arg0_3.status))
end

return var0_0
