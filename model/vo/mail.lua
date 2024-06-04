local var0 = class("Mail", import(".BaseMail"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.readFlag = arg1.read_flag == 2
	arg0.attachFlag = arg1.attach_flag == 0 or arg1.attach_flag == 2
	arg0.importantFlag = arg1.imp_flag == 1
end

function var0.setReadFlag(arg0, arg1)
	arg0.readFlag = arg1
end

function var0.setImportantFlag(arg0, arg1)
	arg0.importantFlag = arg1
end

function var0.setAttachFlag(arg0, arg1)
	arg0.attachFlag = arg1
end

return var0
