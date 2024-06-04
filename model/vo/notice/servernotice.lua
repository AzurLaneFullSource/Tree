local var0 = class("ServerNotice", import(".Notice"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.version = arg1.version
	arg0.btnTitle = arg1.btn_title
	arg0.titleImage = arg1.title_image
	arg0.timeDes = arg1.time_desc
	arg0.type = arg1.tag_type
	arg0.icon = arg1.icon
	arg0.track = arg1.track

	local var0 = string.split(arg0.title, "&")

	if #var0 > 1 then
		arg0.title = var0[1]
		arg0.pageTitle = var0[2]
	else
		arg0.title = var0[1]
		arg0.pageTitle = var0[1]
	end
end

function var0.prefKey(arg0)
	return "ServerNotice" .. arg0.id
end

return var0
