local var0_0 = class("IslandVisitorLogCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.mainTr = arg1_1.transform:Find("main")
	arg0_1.emptyTr = arg1_1.transform:Find("empty")
	arg0_1.timeTxt = arg1_1.transform:Find("main/time"):GetComponent(typeof(Text))
	arg0_1.nameTxt = arg1_1.transform:Find("main/name"):GetComponent(typeof(Text))
	arg0_1.opTxt = arg1_1.transform:Find("main/op"):GetComponent(typeof(Text))
	arg0_1.emptyTimeTxt = arg1_1.transform:Find("empty/time"):GetComponent(typeof(Text))
end

function var0_0.Update(arg0_2, arg1_2)
	local var0_2 = arg1_2.id == -1

	if var0_2 then
		arg0_2:UpdateEmpty(arg1_2)
	else
		arg0_2:UpdateMain(arg1_2)
	end

	setActive(arg0_2.mainTr, not var0_2)
	setActive(arg0_2.emptyTr, var0_2)
end

function var0_0.UpdateEmpty(arg0_3, arg1_3)
	arg0_3.emptyTimeTxt.text = arg1_3:GetTimeWithoutHAndM()
end

function var0_0.UpdateMain(arg0_4, arg1_4)
	arg0_4.timeTxt.text = arg1_4:GetTime()
	arg0_4.nameTxt.text = arg1_4:GetName()
	arg0_4.opTxt.text = arg1_4:GetOpDesc()
end

function var0_0.Dispose(arg0_5)
	return
end

return var0_0
