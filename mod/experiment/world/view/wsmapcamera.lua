local var0_0 = class("WSMapCamera", import("...BaseEntity"))

var0_0.Fields = {
	map = "table",
	camera = "userdata",
	gid = "number"
}

function var0_0.Setup(arg0_1)
	arg0_1:Init()
end

function var0_0.Dispose(arg0_2)
	arg0_2.camera.enabled = false

	arg0_2:Clear()
end

function var0_0.UpdateMap(arg0_3, arg1_3)
	if arg0_3.map ~= arg1_3 or arg0_3.gid ~= arg1_3.gid then
		arg0_3.map = arg1_3
		arg0_3.gid = arg1_3.gid
		arg0_3.camera.fieldOfView = arg1_3.theme.fov
	end
end

function var0_0.Init(arg0_4)
	arg0_4.camera.enabled = true
end

return var0_0
