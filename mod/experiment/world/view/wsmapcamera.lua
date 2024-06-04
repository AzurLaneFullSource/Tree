local var0 = class("WSMapCamera", import("...BaseEntity"))

var0.Fields = {
	map = "table",
	camera = "userdata",
	gid = "number"
}

function var0.Setup(arg0)
	arg0:Init()
end

function var0.Dispose(arg0)
	arg0.camera.enabled = false

	arg0:Clear()
end

function var0.UpdateMap(arg0, arg1)
	if arg0.map ~= arg1 or arg0.gid ~= arg1.gid then
		arg0.map = arg1
		arg0.gid = arg1.gid
		arg0.camera.fieldOfView = arg1.theme.fov
	end
end

function var0.Init(arg0)
	arg0.camera.enabled = true
end

return var0
