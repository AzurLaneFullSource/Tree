local var0_0 = class("SettingsBasePanel")
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.parentTF = arg1_1

	pg.DelegateInfo.New(arg0_1)

	arg0_1.state = var1_0
end

function var0_0.Init(arg0_2, arg1_2)
	if arg0_2.state == var1_0 then
		arg0_2:Load(arg1_2)
	else
		arg1_2()
	end
end

function var0_0.IsLoaded(arg0_3)
	return arg0_3.state == var3_0
end

function var0_0.Load(arg0_4, arg1_4)
	arg0_4.state = var2_0

	PoolMgr.GetInstance():GetUI(arg0_4:GetUIName(), true, function(arg0_5)
		arg0_4.state = var3_0
		arg0_4._go = arg0_5
		arg0_4._tf = arg0_5.transform

		setParent(arg0_4._tf, arg0_4.parentTF)
		arg0_4:InitTitle()
		arg0_4:OnInit()
		arg0_4:OnUpdate()
		setActive(arg0_4._tf, true)
		arg1_4()
	end)
end

function var0_0.InitTitle(arg0_6)
	setText(arg0_6._tf:Find("title"), arg0_6:GetTitle())
	setText(arg0_6._tf:Find("title/title_text"), arg0_6:GetTitleEn())
end

function var0_0.Dispose(arg0_7)
	pg.DelegateInfo.Dispose(arg0_7)

	if arg0_7.state >= var3_0 then
		PoolMgr.GetInstance():ReturnUI(arg0_7:GetUIName(), arg0_7._go)
	end
end

function var0_0.GetUIName(arg0_8)
	assert(false, "overwrite me !!!")
end

function var0_0.GetTitle(arg0_9)
	assert(false, "overwrite me !!!")
end

function var0_0.GetTitleEn(arg0_10)
	assert(false, "overwrite me !!!")
end

function var0_0.OnInit(arg0_11)
	return
end

function var0_0.OnUpdate(arg0_12)
	return
end

return var0_0
