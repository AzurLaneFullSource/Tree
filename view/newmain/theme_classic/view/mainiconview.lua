local var0_0 = class("MainIconView", import("...base.MainBaseView"))
local var1_0 = 1
local var2_0 = 2

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1, nil)

	arg0_1._tf = arg1_1
	arg0_1._go = arg1_1.gameObject
	arg0_1.iconList = {
		[var1_0] = MainSpineIcon.New(arg1_1),
		[var2_0] = MainEducateCharIcon.New(arg1_1)
	}
end

function var0_0.GetIconType(arg0_2, arg1_2)
	if isa(arg1_2, VirtualEducateCharShip) then
		return var2_0
	else
		return var1_0
	end
end

function var0_0.Init(arg0_3, arg1_3)
	arg0_3.ship = arg1_3

	local var0_3 = arg0_3:GetIconType(arg1_3)

	if arg0_3.iconInstance then
		arg0_3.iconInstance:Unload()

		arg0_3.iconInstance = nil
	end

	arg0_3.iconInstance = arg0_3.iconList[var0_3]

	arg0_3.iconInstance:Load(arg1_3:getPrefab())
end

function var0_0.Refresh(arg0_4, arg1_4)
	local var0_4 = arg1_4:getPrefab()
	local var1_4 = arg0_4:GetIconType(arg1_4)

	if arg0_4.iconList[var1_4] ~= arg0_4.iconInstance or arg0_4.name ~= var0_4 then
		arg0_4:Init(arg1_4)
	elseif arg0_4.iconInstance then
		arg0_4.iconInstance:Resume()
	end

	arg0_4.ship = arg1_4
end

function var0_0.Disable(arg0_5)
	if arg0_5.iconInstance then
		arg0_5.iconInstance:Pause()
	end
end

function var0_0.IsLoading(arg0_6)
	if arg0_6.iconInstance then
		return arg0_6.iconInstance:IsLoading()
	end

	return false
end

function var0_0.GetDirection(arg0_7)
	return Vector2(0, 1)
end

function var0_0.Dispose(arg0_8)
	var0_0.super.Dispose(arg0_8)

	for iter0_8, iter1_8 in ipairs(arg0_8.iconList) do
		iter1_8:Dispose()
	end

	arg0_8.iconList = nil
	arg0_8.iconInstance = nil
end

return var0_0
