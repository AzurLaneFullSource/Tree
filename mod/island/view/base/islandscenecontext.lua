local var0_0 = class("IslandSceneContext")

function var0_0.Ctor(arg0_1, arg1_1, ...)
	arg0_1.class = arg1_1
	arg0_1.args = packEx(...)
	arg0_1.subpages = {}
	arg0_1.__visible = true
	arg0_1.__openPrevWhenClose = true
	arg0_1.__delRecordWhenClose = true
end

function var0_0.DisabelOpenPrevWhenClose(arg0_2)
	arg0_2.__openPrevWhenClose = false
end

function var0_0.DisabelDelRecordWhenClose(arg0_3)
	arg0_3.__delRecordWhenClose = false
end

function var0_0.GetDelRecordWhenClose(arg0_4)
	local var0_4 = arg0_4.__delRecordWhenClose

	arg0_4.__delRecordWhenClose = true

	return var0_4
end

function var0_0.GetOpenPrevWhenClose(arg0_5)
	local var0_5 = arg0_5.__openPrevWhenClose

	arg0_5.__openPrevWhenClose = true

	return var0_5
end

function var0_0.AddSubPage(arg0_6, arg1_6, ...)
	local var0_6 = _.detect(arg0_6.subpages, function(arg0_7)
		return arg1_6.__cname == arg0_7.class.__cname
	end)

	if var0_6 then
		var0_6.__visible = true

		return
	end

	local var1_6 = IslandSceneContext.New(arg1_6, ...)

	table.insert(arg0_6.subpages, var1_6)
end

function var0_0.GetSubPages(arg0_8)
	return arg0_8.subpages
end

function var0_0.GetData(arg0_9)
	return arg0_9.args
end

return var0_0
