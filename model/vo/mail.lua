local var0_0 = class("Mail", import(".BaseMail"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.readFlag = arg1_1.read_flag == 2
	arg0_1.attachFlag = arg1_1.attach_flag == 0 or arg1_1.attach_flag == 2
	arg0_1.importantFlag = arg1_1.imp_flag == 1
end

function var0_0.setReadFlag(arg0_2, arg1_2)
	arg0_2.readFlag = arg1_2
end

function var0_0.setImportantFlag(arg0_3, arg1_3)
	arg0_3.importantFlag = arg1_3
end

function var0_0.setAttachFlag(arg0_4, arg1_4)
	arg0_4.attachFlag = arg1_4
end

return var0_0
