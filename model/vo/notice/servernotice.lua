﻿local var0_0 = class("ServerNotice", import(".Notice"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.version = arg1_1.version
	arg0_1.btnTitle = arg1_1.btn_title
	arg0_1.titleImage = arg1_1.title_image
	arg0_1.timeDes = arg1_1.time_desc
	arg0_1.type = arg1_1.tag_type
	arg0_1.icon = arg1_1.icon
	arg0_1.track = arg1_1.track

	local var0_1 = string.split(arg0_1.title, "&")

	if #var0_1 > 1 then
		arg0_1.title = var0_1[1]
		arg0_1.pageTitle = var0_1[2]
	else
		arg0_1.title = var0_1[1]
		arg0_1.pageTitle = var0_1[1]
	end

	local var1_1 = string.match(arg0_1.titleImage, "<config.*/>")

	arg0_1.link = var1_1 and string.match(var1_1, "link%s*=%s*([^%s]+)") or nil
	arg0_1.paramType = var1_1 and tonumber(string.match(var1_1, "type%s*=%s*(%d+)")) or nil

	if arg0_1.paramType then
		if arg0_1.paramType == 1 then
			arg0_1.param = string.match(var1_1, "param%s*=%s*'(.*)'")
		elseif arg0_1.paramType == 2 then
			arg0_1.param = string.match(var1_1, "param%s*=%s*'(.*)'")
		elseif arg0_1.paramType == 3 then
			arg0_1.param = string.match(var1_1, "param%s*=%s*(%d+)")
			arg0_1.param = arg0_1.param and tonumber(arg0_1.param) or arg0_1.param
		elseif arg0_1.paramType == 4 then
			arg0_1.param = string.match(var1_1, "param%s*=%s*(%d+)")
			arg0_1.param = arg0_1.param and tonumber(arg0_1.param) or arg0_1.param
		end
	end

	arg0_1.titleImage = var1_1 and string.gsub(arg0_1.titleImage, var1_1, "") or arg0_1.titleImage
	arg0_1.code = arg0_1:prefKey()
end

function var0_0.prefKey(arg0_2)
	return "ServerNotice" .. arg0_2.id
end

return var0_0