local var0 = class("SettingsBasePanel")
local var1 = 0
local var2 = 1
local var3 = 2

function var0.Ctor(arg0, arg1)
	arg0.parentTF = arg1

	pg.DelegateInfo.New(arg0)

	arg0.state = var1
end

function var0.Init(arg0, arg1)
	if arg0.state == var1 then
		arg0:Load(arg1)
	else
		arg1()
	end
end

function var0.IsLoaded(arg0)
	return arg0.state == var3
end

function var0.Load(arg0, arg1)
	arg0.state = var2

	PoolMgr.GetInstance():GetUI(arg0:GetUIName(), true, function(arg0)
		arg0.state = var3
		arg0._go = arg0
		arg0._tf = arg0.transform

		setParent(arg0._tf, arg0.parentTF)
		arg0:InitTitle()
		arg0:OnInit()
		arg0:OnUpdate()
		setActive(arg0._tf, true)
		arg1()
	end)
end

function var0.InitTitle(arg0)
	setText(arg0._tf:Find("title"), arg0:GetTitle())
	setText(arg0._tf:Find("title/title_text"), arg0:GetTitleEn())
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)

	if arg0.state >= var3 then
		PoolMgr.GetInstance():ReturnUI(arg0:GetUIName(), arg0._go)
	end
end

function var0.GetUIName(arg0)
	assert(false, "overwrite me !!!")
end

function var0.GetTitle(arg0)
	assert(false, "overwrite me !!!")
end

function var0.GetTitleEn(arg0)
	assert(false, "overwrite me !!!")
end

function var0.OnInit(arg0)
	return
end

function var0.OnUpdate(arg0)
	return
end

return var0
