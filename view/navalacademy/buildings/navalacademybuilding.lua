local var0_0 = class("NavalAcademyBuilding")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.parent = arg1_1
	arg0_1._tf = arg1_1:findTF("academyMap/map/" .. arg0_1:GetGameObjectName())
	arg0_1.nameTxt = findTF(arg0_1._tf, "name/Text"):GetComponent(typeof(Text))
	arg0_1.tip = findTF(arg0_1._tf, "tip")
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2._tf, function()
		arg0_2:OnClick()
	end, SFX_PANEL)

	arg0_2.nameTxt.text = arg0_2:GetTitle()

	arg0_2:RefreshTip()
	arg0_2:OnInit()
end

function var0_0.RefreshTip(arg0_4)
	setActive(arg0_4.tip, arg0_4:IsTip())
end

function var0_0.OnInit(arg0_5)
	return
end

function var0_0.OnClick(arg0_6)
	return
end

function var0_0.IsTip(arg0_7)
	return false
end

function var0_0.GetTitle(arg0_8)
	return ""
end

function var0_0.GetGameObjectName(arg0_9)
	assert(false)
end

function var0_0.emit(arg0_10, ...)
	arg0_10.parent:emit(...)
end

function var0_0.Dispose(arg0_11)
	pg.DelegateInfo.Dispose(arg0_11)
end

return var0_0
