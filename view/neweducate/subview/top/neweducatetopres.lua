local var0_0 = class("NewEducateTopRes")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.event = arg2_1
	arg0_1.bgImage = arg0_1._tf:GetComponent(typeof(Image))
	arg0_1.resUIList = UIItemList.New(arg0_1._tf, arg0_1._tf:Find("tpl"))

	arg0_1.resUIList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventInit then
			arg0_1:OnInitItem(arg1_2, arg2_2)
		elseif arg0_2 == UIItemList.EventUpdate then
			arg0_1:OnUpdateItem(arg1_2, arg2_2)
		end
	end)
end

function var0_0.SetBgEnable(arg0_3, arg1_3)
	arg0_3.bgImage.enabled = arg1_3
end

function var0_0.OnInitItem(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4.resIds[arg1_4 + 1]

	setActive(arg2_4:Find("line"), arg1_4 + 1 ~= #arg0_4.resIds)

	local var1_4 = pg.child2_resource[var0_4]

	LoadImageSpriteAsync("neweducateicon/" .. var1_4.icon, arg2_4:Find("icon"))
	onButton(arg0_4.event, arg2_4, function()
		arg0_4.event:emit(NewEducateBaseUI.ON_ITEM, {
			drop = {
				number = 1,
				type = NewEducateConst.DROP_TYPE.RES,
				id = var0_4
			}
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = pg.child2_resource[arg0_6.resIds[arg1_6 + 1]]
	local var1_6 = var0_6.type == NewEducateChar.RES_TYPE.MOOD and "/" .. var0_6.max_value or ""
	local var2_6 = arg0_6.char:GetRes(var0_6.id)

	if var0_6.type == NewEducateChar.RES_TYPE.MOOD then
		setText(arg2_6:Find("value"), setColorStr(var2_6, arg0_6:GetMoodColor(var2_6)) .. var1_6)
	elseif var0_6.type == NewEducateChar.RES_TYPE.ACTION then
		setText(arg2_6:Find("value"), var2_6 == 0 and setColorStr(var2_6, "#ee4a4a") or var2_6)
	else
		setText(arg2_6:Find("value"), var2_6 .. var1_6)
	end
end

function var0_0.Update(arg0_7, arg1_7)
	arg0_7.char = arg1_7
	arg0_7.resIds = arg0_7.resIds or {
		arg0_7.char:GetResIdByType(NewEducateChar.RES_TYPE.MONEY),
		arg0_7.char:GetResIdByType(NewEducateChar.RES_TYPE.MOOD),
		arg0_7.char:GetResIdByType(NewEducateChar.RES_TYPE.ACTION)
	}

	arg0_7.resUIList:align(#arg0_7.resIds)
end

function var0_0.GetMoodColor(arg0_8, arg1_8)
	if arg1_8 < 20 then
		return "#ee4a4a"
	elseif arg1_8 < 40 then
		return "#ab4734"
	elseif arg1_8 < 60 then
		return "#393A3C"
	else
		return "#00c79b"
	end
end

function var0_0.Dispose(arg0_9)
	return
end

return var0_0
