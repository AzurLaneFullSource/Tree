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

	seriesAsync({
		function(arg0_5)
			local var0_5 = arg0_4:getResource()

			SplitPackConst.DownloadByLuaArr(var0_5, arg0_5)
		end,
		function(arg0_6)
			PoolMgr.GetInstance():GetUI(arg0_4:GetUIName(), true, function(arg0_7)
				if arg0_4.exited then
					PoolMgr.GetInstance():ReturnUI(arg0_4:GetUIName(), arg0_7)

					return
				end

				arg0_4.state = var3_0
				arg0_4._go = arg0_7
				arg0_4._tf = arg0_7.transform

				setParent(arg0_4._tf, arg0_4.parentTF)
				arg0_4:InitTitle()
				arg0_4:OnInit()
				arg0_4:OnUpdate()
				setActive(arg0_4._tf, true)
				arg0_6()
			end)
		end
	}, arg1_4)
end

function var0_0.InitTitle(arg0_8)
	setText(arg0_8._tf:Find("title"), arg0_8:GetTitle())
	setText(arg0_8._tf:Find("title/title_text"), arg0_8:GetTitleEn())
end

function var0_0.Dispose(arg0_9)
	arg0_9.exited = true

	pg.DelegateInfo.Dispose(arg0_9)

	if arg0_9.state >= var3_0 then
		PoolMgr.GetInstance():ReturnUI(arg0_9:GetUIName(), arg0_9._go)
	end
end

function var0_0.GetUIName(arg0_10)
	assert(false, "overwrite me !!!")
end

function var0_0.getResource(arg0_11)
	return {
		"ui/" .. arg0_11:GetUIName()
	}
end

function var0_0.GetTitle(arg0_12)
	assert(false, "overwrite me !!!")
end

function var0_0.GetTitleEn(arg0_13)
	assert(false, "overwrite me !!!")
end

function var0_0.OnInit(arg0_14)
	return
end

function var0_0.OnUpdate(arg0_15)
	return
end

return var0_0
